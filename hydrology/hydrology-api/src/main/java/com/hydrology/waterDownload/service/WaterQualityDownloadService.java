package com.hydrology.waterDownload.service;

import cn.hutool.core.convert.Convert;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.constant.WaterDownloadConstants;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.db.GetDbUtils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Slf4j
@Service
public class WaterQualityDownloadService {
    @Autowired
    RedisCache redisCache;


    Pattern pattern = Pattern.compile(">([^<]+)<");

    // 异步下载状态：同一时刻只允许一个任务；进度以新快照发布供状态查询
    private final AtomicBoolean running = new AtomicBoolean(false);
    private volatile JSONObject progress = new JSONObject().set("status", "idle");

    // 区域抓取台账：落库记录每日每区域成败，供更新重启后补偿补抓
    private static final String FETCH_LOG_TABLE = "hy_download_water_quality_fetch_log";
    private volatile boolean fetchLogReady = false;

    public JSONObject getDownloadStatus() {
        return this.progress;
    }

    /**
     * 异步提交入口：全量下载耗时几十分钟，同步 HTTP 会占线程且被网关掐断。
     * 同步 download() 保留供定时任务/手动调用。
     */
    public boolean startDownload() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return false;
        if (this.running.get()) return false;
        this.progress = new JSONObject().set("status", "running").set("started_at", DateUtil.now());
        Thread worker = new Thread(() -> {
            try {
                this.download();
            } catch (Exception e) {
                log.error("水质下载任务异常", e);
                this.progress = new JSONObject().set("status", "failed")
                        .set("error", e.getMessage()).set("finished_at", DateUtil.now());
            }
        }, "water-quality-download");
        worker.setDaemon(true);
        worker.start();
        return true;
    }

    /**
     * 全量下载入口（定时任务/手动）：保守限速（只降速不提速）+ 连续失败熔断
     * + 失败台账与一轮补抓。站点访问频率过大会封禁 IP，请求间隔只允许调大不允许调小。
     */
    public void download() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        this.doDownload(this.validAreas());
    }

    /**
     * 重启补偿：今日台账已有记录但未全部成功时，只补抓缺失/失败区域。
     * 今日无任何台账记录说明本轮尚未开始，交给定时任务，不额外增加请求次数。
     */
    public void resumeInterrupted() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        try {
            this.ensureFetchLogTable();
            Db db = GetDbUtils.getDb();
            List<Entity> logs = db.query("select area_id, status from " + FETCH_LOG_TABLE + " where fetch_date = ?", DateUtil.today());
            if (logs.isEmpty()) return;
            Set<String> doneIds = logs.stream()
                    .filter(e -> "success".equals(e.getStr("status")))
                    .map(e -> e.getStr("area_id")).collect(Collectors.toSet());
            Map<String, Entity> areaMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL));
            List<String> pending = this.validAreas().stream()
                    .filter(name -> !doneIds.contains(areaMap.get(name).getStr("id")))
                    .collect(Collectors.toList());
            if (pending.isEmpty()) return;
            log.info("水质下载重启补偿：今日未完成区域 {} 个，开始补抓", pending.size());
            this.doDownload(pending);
        } catch (Exception e) {
            log.error("水质下载重启补偿检查失败", e);
        }
    }

    /** 有效区域列表：过滤无效区域，被跳过的区域不再白等限速间隔 */
    private List<String> validAreas() {
        Map<String, Entity> areaMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL));
        return areaMap.keySet().stream()
                .filter(name -> !areaMap.get(name).getStr("id").contains("0000"))
                .collect(Collectors.toList());
    }

    private void doDownload(List<String> areaNames) {
        if (!this.running.compareAndSet(false, true)) {
            log.warn("已有水质下载任务进行中，本次跳过");
            return;
        }
        try {
            String url = "https://szzdjc.cnemc.cn:8070/GJZ/Ajax/Publish.ashx";

            Map<String, Entity> areaMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL));
            Map<String, Entity> riverMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_RIVER_LABEL));
            int size = areaNames.size();
            Set<String> ids = new HashSet<>();
            List<String> failedAreas = new ArrayList<>();
            int consecutiveFailures = 0;
            boolean circuitBroken = false;
            int processed = 0;

            for (String areaName : areaNames) {
                this.rateLimitSleep(consecutiveFailures);
                processed++;
                log.info("水质数据下载，正在处理 {}/{} {}", processed, size, areaName);
                boolean ok = this.fetchArea(url, areaName, areaMap, riverMap, ids);
                if (ok) {
                    consecutiveFailures = 0;
                } else {
                    failedAreas.add(areaName);
                    consecutiveFailures++;
                    if (consecutiveFailures >= SystemConfig.getWaterQualityCircuitBreakFailures()) {
                        circuitBroken = true;
                        log.error("水质下载连续失败达到 {} 次，熔断中止本轮，避免 IP 进黑名单", consecutiveFailures);
                        break;
                    }
                }
                this.publishProgress("running", size, processed, failedAreas, false);
            }

            // 失败区域一轮补抓（熔断时跳过），仍保持保守限速
            if (!circuitBroken && !failedAreas.isEmpty()) {
                List<String> retryAreas = new ArrayList<>(failedAreas);
                failedAreas.clear();
                log.info("水质下载开始补抓 {} 个失败区域", retryAreas.size());
                for (String areaName : retryAreas) {
                    this.rateLimitSleep(0);
                    if (!this.fetchArea(url, areaName, areaMap, riverMap, ids)) {
                        failedAreas.add(areaName);
                    }
                }
            }
            String status = circuitBroken ? "circuit_broken" : "done";
            this.publishProgress(status, size, processed, failedAreas, circuitBroken);
            log.info("水质下载结束 status={} 处理={}/{} 失败={}", status, processed, size, failedAreas);
        } finally {
            this.running.set(false);
        }
    }

    /** 台账表自建：重启补偿依赖，免手工迁移 */
    @SneakyThrows
    private void ensureFetchLogTable() {
        if (this.fetchLogReady) return;
        Db db = GetDbUtils.getDb();
        db.execute("CREATE TABLE IF NOT EXISTS `" + FETCH_LOG_TABLE + "` (" +
                "`fetch_date` varchar(10) NOT NULL COMMENT '抓取日期'," +
                "`area_id` varchar(32) NOT NULL COMMENT '区域ID'," +
                "`area_name` varchar(64) DEFAULT NULL COMMENT '区域名称'," +
                "`status` varchar(16) NOT NULL COMMENT 'success/failed'," +
                "`message` varchar(500) DEFAULT NULL COMMENT '失败原因'," +
                "`update_time` datetime DEFAULT NULL COMMENT '更新时间'," +
                "PRIMARY KEY (`fetch_date`,`area_id`)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='水质下载区域抓取台账（重启补偿用）'");
        this.fetchLogReady = true;
    }

    /** 记录区域抓取结果；台账写入失败不影响数据入库主流程 */
    private void recordFetch(String areaId, String areaName, String status, String message) {
        try {
            this.ensureFetchLogTable();
            Db db = GetDbUtils.getDb();
            db.execute("insert into " + FETCH_LOG_TABLE + " (fetch_date, area_id, area_name, status, message, update_time) " +
                            "values (?,?,?,?,?,now()) on duplicate key update status=values(status), message=values(message), update_time=now()",
                    DateUtil.today(), areaId, areaName, status, StrUtil.maxLength(message, 500));
        } catch (Exception e) {
            log.error("水质抓取台账写入失败 area={}", areaName, e);
        }
    }

    private void publishProgress(String status, int total, int processed, List<String> failedAreas, boolean circuitBroken) {
        this.progress = new JSONObject()
                .set("status", status)
                .set("total", total)
                .set("processed", processed)
                .set("failed", new ArrayList<>(failedAreas))
                .set("circuit_broken", circuitBroken)
                .set("updated_at", DateUtil.now());
    }

    /**
     * 保守限速：配置间隔内随机抖动；失败时按连续失败次数指数退避（封顶 10 分钟）。
     * 只降速不提速：成功后回到基线间隔，任何情况下不低于配置下限，避免触发站点黑名单。
     */
    @SneakyThrows
    private void rateLimitSleep(int consecutiveFailures) {
        int min = Math.max(1, SystemConfig.getWaterQualityIntervalMin());
        int max = Math.max(min, SystemConfig.getWaterQualityIntervalMax());
        long base = (min + new Random().nextInt(max - min + 1)) * 1000L;
        long factor = 1L << Math.min(consecutiveFailures, 4);
        long delay = Math.min(base * factor, 10 * 60 * 1000L);
        if (consecutiveFailures > 0) {
            log.warn("水质下载失败退避，连续失败={} 等待={}s", consecutiveFailures, delay / 1000);
        }
        Thread.sleep(delay);
    }

    /**
     * 单区域拉取入库：行级容错，单行异常不丢弃同区域其余行；
     * HTTP 状态与响应体校验，非 JSON（限流/错误页）视为失败。
     */
    private boolean fetchArea(String url, String areaName, Map<String, Entity> areaMap,
                              Map<String, Entity> riverMap, Set<String> ids) {
        String areaId = areaMap.get(areaName).getStr("id");
        Map<String, Object> params = new HashMap<String, Object>() {{
            put("AreaID", areaId);
            put("RiverID", "");
            put("MNName", "");
            put("PageIndex", -1);
            put("PageSize", 120);
            put("action", "getRealDatas");
        }};

        HttpRequest httpRequest = HttpUtil.createPost(url).form(params).timeout(30000);
        try (HttpResponse httpResponse = httpRequest.execute(false)) {
            if (!httpResponse.isOk()) {
                log.error("水质下载 HTTP 异常 area={} status={}", areaName, httpResponse.getStatus());
                this.recordFetch(areaId, areaName, "failed", "HTTP " + httpResponse.getStatus());
                return false;
            }
            String body = httpResponse.body();
            if (StrUtil.isBlank(body) || !JSONUtil.isTypeJSON(body)) {
                log.error("水质下载响应非 JSON（可能被限流/错误页） area={}", areaName);
                this.recordFetch(areaId, areaName, "failed", "响应非JSON");
                return false;
            }
            JSONObject entries = JSONUtil.parseObj(body);
            JSONArray thead = entries.getJSONArray("thead");
            JSONArray tbody = entries.getJSONArray("tbody");
            // 无数据属正常响应，不计失败
            if (tbody == null || tbody.isEmpty()) {
                this.recordFetch(areaId, areaName, "success", null);
                return true;
            }
            Entity fieldEntity = this.disposeFieldName(thead);
            List<Entity> saveParams = new ArrayList<>();
            for (int i = 0; i < tbody.size(); i++) {
                try {
                    JSONArray data = tbody.getJSONArray(i);
                    Entity entity = Entity.create();
                    for (String key : fieldEntity.keySet()) {
                        String value = this.disposeValue(data.getStr(Integer.parseInt(key)));
                        entity.set(fieldEntity.getStr(key), value);
                    }

                    String wqProvince = entity.getStr("wq_province");
                    if (StrUtil.isNotBlank(wqProvince)) {
                        Entity province = areaMap.get(wqProvince);
                        // 字典缺失降级保留原值，避免 NPE 丢弃整批
                        entity.set("wq_province", province != null ? province.getStr("id") : wqProvince);
                    }
                    entity.set("wq_city", areaId);

                    String wqMonitorTimeOrigin = entity.getStr("wq_monitor_time_origin");
                    if (StrUtil.isBlank(wqMonitorTimeOrigin)) continue;
                    String time = this.inferYear(wqMonitorTimeOrigin) + "-" + wqMonitorTimeOrigin;
                    entity.set("wq_monitor_time", time);
                    String id = SecureUtil.md5(time + entity.getStr("wq_section_name"));
                    if (!ids.add(id)) continue;
                    entity.set("wq_id", id);

                    String wqBasin = entity.getStr("wq_basin");
                    if (StrUtil.isNotBlank(wqBasin)) {
                        Entity river = riverMap.get(wqBasin);
                        entity.set("wq_basin", river != null ? river.getStr("id") : wqBasin);
                    }
                    saveParams.add(entity);
                } catch (Exception e) {
                    log.error("水质数据行处理失败 area={} row={}", areaName, i, e);
                }
            }
            if (!saveParams.isEmpty()) {
                GetDbUtils.insertOrUpdate("hy_download_water_quality", saveParams);
            }
            this.recordFetch(areaId, areaName, "success", null);
            return true;
        } catch (Exception e) {
            log.error("水质数据下载失败 area={}", areaName, e);
            this.recordFetch(areaId, areaName, "failed", e.getMessage());
            return false;
        }
    }

    /**
     * 推断监测时间年份：站点只返回 MM-dd HH:mm，元旦前后抓取上年末数据
     * 直接拼当前年会错；数据月份大于当前月份时视为上一年数据。
     */
    private int inferYear(String monitorTimeOrigin) {
        DateTime now = DateUtil.date();
        try {
            // hutool month() 从 0 起，+1 转为自然月
            int dataMonth = DateUtil.parse(monitorTimeOrigin, "MM-dd HH:mm").month() + 1;
            if (dataMonth > now.month() + 1) {
                return now.year() - 1;
            }
        } catch (Exception e) {
            log.warn("监测时间解析失败，按当前年份处理: {}", monitorTimeOrigin);
        }
        return now.year();
    }

    private String disposeValue(Object object) {
        if (object == null) return null;
        String value = object.toString();
        value = value.trim().replace("\"", "").replace("*", "");
        if (value.contains("--")) return null;
        if (value.contains("<span")) {
            Matcher matcher = pattern.matcher(value);
            if (matcher.find()) {
                value = matcher.group(1);
            }
        }
        if (StrUtil.isBlank(value)) return null;
        return value;
    }


    private Entity disposeFieldName(JSONArray tbody) {
        Entity entity = Entity.create();
        for (int i = 0; i < tbody.size(); i++) {
            String fieldName = tbody.getStr(i);


            if (fieldName.contains("省份")) entity.set(String.valueOf(i), "wq_province");
            if (fieldName.contains("流域")) entity.set(String.valueOf(i), "wq_basin");
            if (fieldName.contains("断面名称")) entity.set(String.valueOf(i), "wq_section_name");
            if (fieldName.contains("监测时间")) entity.set(String.valueOf(i), "wq_monitor_time_origin");
            if (fieldName.contains("水质类别")) entity.set(String.valueOf(i), "wq_type");
            if (fieldName.contains("水温")) entity.set(String.valueOf(i), "wq_temperature");
            if (fieldName.contains("pH")) entity.set(String.valueOf(i), "wq_ph");
            if (fieldName.contains("溶解氧")) entity.set(String.valueOf(i), "wq_do");
            if (fieldName.contains("电导率")) entity.set(String.valueOf(i), "wq_ec");
            if (fieldName.contains("浊度")) entity.set(String.valueOf(i), "wq_ntu");
            if (fieldName.contains("高锰酸盐指数")) entity.set(String.valueOf(i), "wq_permanganate");
            if (fieldName.contains("氨氮")) entity.set(String.valueOf(i), "wq_ammonia");
            if (fieldName.contains("总磷")) entity.set(String.valueOf(i), "wq_tp");
            if (fieldName.contains("总氮")) entity.set(String.valueOf(i), "wq_tn");
            if (fieldName.contains("叶绿素")) entity.set(String.valueOf(i), "wq_chla");
            if (fieldName.contains("藻密度")) entity.set(String.valueOf(i), "wq_algal");
        }
        return entity;
    }

    @SneakyThrows
    public void importData() {

        Entity set = Entity.create()
                .set("Ⅰ", "1")
                .set("Ⅱ", "2")
                .set("Ⅲ", "3")
                .set("Ⅳ", "4")
                .set("Ⅴ", "5")
                .set("劣Ⅴ", "6")
                .set("未监测", "7");
        String path = "C:\\Users\\vhaix\\Desktop\\222.xlsx";
        ExcelReader reader = ExcelUtil.getReader(path);
        List<Map<String, Object>> maps = reader.readAll();
        ArrayList<Object[]> entities = new ArrayList<>();
        HashSet<String> strings = new HashSet<>();
        Db r = GetDbUtils.getDb();
        String insertSql = "insert into hy_download_water_quality (wq_id,wq_province,wq_basin,wq_section_name,wq_monitor_time_origin,wq_type,wq_temperature,wq_ph,wq_do,wq_ec,wq_ntu,wq_permanganate,wq_ammonia,wq_tp,wq_tn,wq_chla,wq_algal,wq_city) " +
                "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

        int index = 0;
        Map<String, Entity> areaMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL));
        Map<String, Entity> riverMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_RIVER_LABEL));

        for (Map<String, Object> map : maps) {
            try {
                ArrayList<Object> objects = new ArrayList<>();


                String dateTime = this.disposeValue(map.get("监测时间"));
                String sectionName = this.disposeValue(map.get("断面名称"));
                if (dateTime == null) continue;
                String id = SecureUtil.md5(dateTime + sectionName);
                if (strings.contains(id)) continue;

                try {
                    DateUtil.parse(dateTime);
                } catch (Exception e) {
                    continue;
                }
                strings.add(id);
                objects.add(id);
                objects.add(areaMap.get(this.disposeValue(map.get("省份"))).getStr("id"));
                objects.add(riverMap.get(this.disposeValue(map.get("流域"))).getStr("id"));
                objects.add(sectionName);
                objects.add(DateUtil.parse(dateTime).toTimestamp());
                objects.add(set.getStr(this.disposeValue(map.get("水质类别"))));
                objects.add(this.disposeValue(map.get("水温")));
                objects.add(this.disposeValue(map.get("PH")));
                objects.add(this.disposeValue(map.get("溶解氧")));
                objects.add(this.disposeValue(map.get("电导率")));
                objects.add(this.disposeValue(map.get("浊度")));
                objects.add(this.disposeValue(map.get("高锰酸盐")));
                objects.add(this.disposeValue(map.get("氨氮")));
                objects.add(this.disposeValue(map.get("总磷")));
                objects.add(this.disposeValue(map.get("总氮")));
                objects.add(this.disposeValue(map.get("叶绿素")));
                objects.add(this.disposeValue(map.get("藻密度")));
                objects.add(areaMap.get(this.disposeValue(map.get("市区"))).getStr("id"));

                entities.add(objects.toArray());
                index++;
                if (index % 10000 == 0) {
                    log.info("已处理数据 {}", index);
                }

            } catch (Exception e) {
                System.out.println(this.disposeValue(map.get("市区")));
                log.error(e.getMessage(), e);
            }
        }
        log.info("开始插入数据");
        //  r.executeBatch(insertSql, entities);

        // 假设 entities 是你需要插入的总数据集合，insertSql 是插入的SQL语句
        int batchSize = 1000; // 每一批次的插入数量
        int total = entities.size();

        for (int i = 0; i < total; i += batchSize) {
            // 计算当前批次的结束下标，防止最后一批数据越界
            int end = Math.min(i + batchSize, total);
            // 截取当前需要插入的子列表
            log.info("水质数据导入，正在处理 {}/{}", i, total);
            List<Object[]> subList = entities.subList(i, end);
            // 执行批量插入
            r.executeBatch(insertSql, subList);
        }
        log.info("结束插入数据");

    }


    public Object getWaterQualityDic(String dicName) {

        Map<String, Object> areaMap = redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_ID);
        List<Object> areaList = redisCache.getCacheList(WaterDownloadConstants.QUALITY_AREA_LIST);
        Map<String, Object> riverMap = redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_RIVER_ID);

        switch (dicName) {
            case "tree":
                return areaList;
            case "treeMap":
                return areaMap;
            case "river":
                return riverMap;
            case "dataType":
                return Entity.create()
                        .set("1", Entity.create().set("id", "1").set("label", "Ⅰ").set("color", "#CCFFFF"))
                        .set("2", Entity.create().set("id", "2").set("label", "Ⅱ").set("color", "#00CCFF"))
                        .set("3", Entity.create().set("id", "3").set("label", "Ⅲ").set("color", "#00FF00"))
                        .set("4", Entity.create().set("id", "4").set("label", "Ⅳ").set("color", "#FFFF00"))
                        .set("5", Entity.create().set("id", "5").set("label", "Ⅴ").set("color", "#FF9B00"))
                        .set("6", Entity.create().set("id", "6").set("label", "劣Ⅴ").set("color", "#FF0000"))
                        .set("7", Entity.create().set("id", "7").set("label", "未监测").set("color", "#2b2b2b"))
                        ;
        }
        return null;
    }

    @SneakyThrows
    public List<Entity> getData(Entity paramMap) {
        Db db = GetDbUtils.getDb();
        // 排序方向白名单，防 SQL 注入
        String dataOrder = "asc".equalsIgnoreCase(paramMap.getStr("dataOrder")) ? "asc" : "desc";

        List<String> dates = Convert.toList(String.class, paramMap.getStr("dates"));
        Timestamp startDate = DateUtil.parse(dates.get(0)).toTimestamp();
        Timestamp endDate = DateUtil.parse(dates.get(1)).toTimestamp();
        Set<String> checkList = Convert.toMap(String.class, Boolean.class, paramMap.get("treeCheckList")).keySet();
        List<Object> params = new ArrayList<>();
        params.add(startDate);
        params.add(endDate);
        String checkWhereSql = "";
        String limitSql = "";
        if (!checkList.isEmpty()) {
            // 勾选城市参数化，防 SQL 注入
            checkWhereSql = " and wq_city in (" + String.join(",", Collections.nCopies(checkList.size(), "?")) + ") ";
            params.addAll(checkList);
        } else {
            limitSql = " limit 1650";
        }
        String orderSql = StrUtil.format("order by  wq_monitor_time {},wq_city,wq_section_name ", dataOrder);

        String querySql = StrUtil.format("select * from hy_download_water_quality where wq_monitor_time > ? and wq_monitor_time <= ? ") + checkWhereSql + orderSql + limitSql;
        List<Entity> query = db.query(querySql, params.toArray());
        return query;
    }
}
