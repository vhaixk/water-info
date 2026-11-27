package com.hydrology.waterDownload.task;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.NumberUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.utils.StationNameUtils;
import com.hydrology.common.utils.db.GetDbUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Component("waterDownloadTask")
public class WaterDownloadTask {

    // 站点键 -> 数据表：单站独立分发，失败可单独重发
    private static final String[][] CRAWL_SITES = {
            {"dj", "hy_download_water_dj"},
            {"xsq", "hy_download_water_sk"},
            {"ysq", "hy_download_water_yq"},
    };
    // Java 侧额外分发轮次（Python 服务内部每轮已自带重试）
    private static final int MAX_ROUNDS = 2;

    public void runCrawl() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        for (String[] site : CRAWL_SITES) {
            this.crawlSite(site[0], site[1]);
        }
    }

    /**
     * 只爬指定数据表对应的站点（启动补偿用），避免重复抓当日已成功的站点
     */
    public void runCrawlTables(List<String> tables) {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        for (String[] site : CRAWL_SITES) {
            if (tables.contains(site[1])) {
                this.crawlSite(site[0], site[1]);
            }
        }
    }

    /**
     * 单站爬取 + 入库：校验结果后按失败原因决定重发还是放弃。
     * 可重试（空表/超时/网络/入库失败）退避后再发一轮；不可重试直接放弃。
     */
    private void crawlSite(String site, String tableName) {
        for (int round = 1; round <= MAX_ROUNDS; round++) {
            JSONObject task = this.submitAndWait(site);
            if (task == null) {
                // 提交/轮询失败多为服务或网络瞬时问题，允许再发一轮
                log.error("站点 {} 爬取任务提交/轮询失败，第 {} 轮", site, round);
            } else if ("done".equals(task.getStr("status"))) {
                JSONObject result = task.getJSONObject("results").getJSONObject(site);
                if (result != null && result.getInt("rows", 0) > 0
                        && this.downloadAndSave(tableName, result.getStr("excel"), result.getStr("image"))) {
                    return;
                }
                log.error("站点 {} 结果校验或入库失败，第 {} 轮", site, round);
            } else {
                JSONObject error = task.getJSONObject("error");
                boolean retryable = error != null && error.getBool("retryable", false);
                log.error("站点 {} 爬取失败 code={} retryable={}",
                        site, error == null ? null : error.getStr("code"), retryable);
                if (!retryable) return;
            }
            if (round < MAX_ROUNDS) {
                try {
                    Thread.sleep(60 * 1000L);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
        log.error("站点 {} 经 {} 轮仍失败，放弃", site, MAX_ROUNDS);
    }

    /**
     * 提交单站异步任务并轮询至 done/failed；提交失败或超时返回 null。
     */
    private JSONObject submitAndWait(String site) {
        String waterDownloadUrl = SystemConfig.getWaterDownloadUrl();
        String token = SystemConfig.getWaterDownloadToken();

        String taskId;
        HttpRequest submit = HttpUtil.createPost(waterDownloadUrl + "/crawl/site")
                .timeout(30000).body(JSONUtil.toJsonStr(Entity.create().set("token", token).set("site", site)));
        try (HttpResponse response = submit.execute()) {
            taskId = JSONUtil.parseObj(response.body()).getStr("task_id");
        } catch (Exception e) {
            log.error("提交站点 {} 爬取任务失败", site, e);
            return null;
        }
        if (StrUtil.isBlank(taskId)) {
            log.error("站点 {} 爬取任务提交未返回 task_id", site);
            return null;
        }

        // 生产服务器响应/OCR 可能较慢：单轮最坏 3 次尝试×(加载+稳定等待+截图)+退避，放宽到 30 分钟
        long deadline = System.currentTimeMillis() + 30 * 60 * 1000L;
        while (System.currentTimeMillis() < deadline) {
            try {
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return null;
            }
            HttpRequest statusReq = HttpUtil.createPost(waterDownloadUrl + "/crawl/status")
                    .timeout(30000).body(JSONUtil.toJsonStr(Entity.create().set("token", token).set("task_id", taskId)));
            try (HttpResponse response = statusReq.execute()) {
                // Python 服务重启会丢失内存任务：404 时立即结束本轮，交由上层重新分发，不空等超时
                if (response.getStatus() == 404) {
                    log.error("爬取任务已丢失（下载服务可能重启） task={}", taskId);
                    return null;
                }
                JSONObject task = JSONUtil.parseObj(response.body());
                if (StrUtil.isNotBlank(task.getStr("error"))) {
                    log.error("爬取状态查询返回错误 task={} error={}", taskId, task.getStr("error"));
                    return null;
                }
                String status = task.getStr("status");
                if ("done".equals(status) || "failed".equals(status)) {
                    return task;
                }
                log.info("站点 {} 爬取进行中 task={} status={} attempts={}",
                        site, taskId, status, task.getStr("attempts"));
            } catch (Exception e) {
                log.error("查询爬取状态失败", e);
            }
        }
        log.error("站点 {} 爬取任务超时 task={}", site, taskId);
        return null;
    }

    public boolean downloadAndSave(String tableName, String excelPath, String imagePath) {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return false;
        String waterDownloadUrl = SystemConfig.getWaterDownloadUrl();
        String crawlUrl = StrUtil.format("{}/download", waterDownloadUrl);
        Entity params = Entity.create().set("path", excelPath).set("token", SystemConfig.getWaterDownloadToken());
        HttpRequest httpRequest = HttpUtil.createPost(crawlUrl).timeout(-1).body(JSONUtil.toJsonStr(params));

        try (HttpResponse response = httpRequest.execute(false)) {
            if (!response.isOk()) {
                log.error("下载 Excel 失败 http={} path={}", response.getStatus(), excelPath);
                return false;
            }
            InputStream inputStream = response.bodyStream();
            ExcelReader reader = ExcelUtil.getReader(inputStream);
            List<List<Object>> readList = reader.read();
            if (readList == null || readList.isEmpty()) {
                log.error("Excel 无数据行，放弃入库 path={}", excelPath);
                return false;
            }
            List<Entity> saveValues = new ArrayList<>();
            switch (tableName) {
                case "hy_download_water_dj":
                    saveValues = this.disposeDj(readList);
                    break;
                case "hy_download_water_sk":
                    saveValues = this.disposeSk(readList);
                    break;
                case "hy_download_water_yq":
                    saveValues = this.disposeYq(readList);
                    break;
            }
            Map<String, Entity> entityMap = saveValues
                    .stream()
                    .collect(
                            Collectors.toMap(
                                    key -> key.getStr("monitor_id"),
                                    value -> value,
                                    (e1, e2) -> {
                                        Double value1 = e1.getDouble("monitor_value");
                                        Double value2 = e2.getDouble("monitor_value");
                                        if (value1 != null && value1 != 0) {
                                            return e1;
                                        }
                                        if (value2 != null && value2 != 0) {
                                            return e2;
                                        }
                                        return e1;
                                    }
                            )
                    );
            List<Entity> values = entityMap.keySet().stream().map(entityMap::get).collect(Collectors.toList());
            if (values.isEmpty()) {
                log.error("解析后无有效数据行，放弃入库 table={} path={}", tableName, excelPath);
                return false;
            }
            GetDbUtils.insertOrUpdate(tableName, values);
            // 以当日 Excel 为权威，自动补全映射字典与流域白名单
            this.upsertMappingFromExcel(tableName, readList);
            // 入库成功后才登记日期映射，避免失败时前端拿到无效文件路径
            GetDbUtils.insertOrUpdate(
                    Entity.create()
                            .set("tableName", "hy_download_water_date_mapping")
                            .set("data_date", DateUtil.today())
                            .set("data_type", tableName)
                            .set("data_excel_path", excelPath)
                            .set("data_png_path", imagePath)
                            .set("create_time", null)
                            .set("update_time", null)
            );
            inputStream.close();
            reader.close();
            return true;
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return false;
        }

    }

    /**
     * 以当日 OCR Excel 为权威补全映射字典：
     * 列 0流域 1省份 2河流 3站名。站名繁简归一为显示名，原名作别名；
     * 同时把 Excel 出现的流域名加入白名单（Excel 为可信来源）。
     */
    private void upsertMappingFromExcel(String tableName, List<List<Object>> readList) {
        String mappingTable = tableName.replace("hy_download_water_", "hy_download_water_mapping_");
        Map<String, Entity> mappingMap = new LinkedHashMap<>();
        Set<String> basins = new HashSet<>();
        for (List<Object> row : readList) {
            if (row.size() < 4) continue;
            String station = this.disposeValue(row.get(3));
            if (StrUtil.isBlank(station)) continue;
            String basin = StationNameUtils.toSimplified(this.disposeValue(row.get(0)));
            String province = this.disposeValue(row.get(1));
            String river = StationNameUtils.toSimplified(this.disposeValue(row.get(2)));
            String key = StationNameUtils.normalizeKey(station);
            if (mappingMap.containsKey(key)) continue;
            String display = StationNameUtils.toSimplified(station);
            Entity entity = Entity.create()
                    .set("station_name", display)
                    .set("basin_name", basin)
                    .set("river_name", river)
                    .set("province_name", province);
            if (!StationNameUtils.normalizeKey(display).equals(key)) {
                entity.set("station_name_alias", station);
            }
            mappingMap.put(key, entity);
            if (StrUtil.isNotBlank(basin)) basins.add(basin);
        }
        if (!mappingMap.isEmpty()) {
            GetDbUtils.insertOrUpdate(mappingTable, new ArrayList<>(mappingMap.values()));
        }
        Db db = GetDbUtils.getDb();
        for (String basin : basins) {
            try {
                db.execute("insert ignore into hy_download_water_basin_whitelist(basin_name) values(?)", basin);
            } catch (Exception e) {
                log.error("流域白名单写入失败 {}", basin, e);
            }
        }
    }

    private List<Entity> disposeYq(List<List<Object>> readList) {
        List<Entity> entities = new ArrayList<>();
        for (List<Object> objects : readList) {
            try {
                String stationValue = this.disposeValue(objects.get(3));
                String timeValue = this.disposeValue(objects.get(4));
                String monitorValue = this.disposeValue(objects.get(5));
                String imagePath = this.disposeValue(objects.get(5));
                if (StrUtil.isBlank(imagePath) || !imagePath.contains("save_images")) {
                    imagePath = this.disposeValue(objects.get(6));
                }
                if (stationValue == null || timeValue == null) continue;
                String disposeTime = this.disposeTime(timeValue);
                if (disposeTime == null) continue;
                Double monitorDouble = this.disposeDouble(monitorValue);
                entities.add(new Entity()
                        .set("monitor_id", SecureUtil.md5(stationValue + timeValue))
                        .set("station_name", stationValue)
                        .set("monitor_time", disposeTime)
                        .set("origin_monitor_time", timeValue)
                        .set("monitor_value", monitorDouble)
                        .set("create_time", null)
                        .set("update_time", null)
                        .set("monitor_png_path", imagePath)
                );
            } catch (Exception e) {
                log.error(e.getMessage(), e);
            }
        }
        return entities;
    }


    private List<Entity> disposeSk(List<List<Object>> readList) {
        List<Entity> entities = new ArrayList<>();
        for (List<Object> objects : readList) {
            try {
                String stationValue = this.disposeValue(objects.get(3));
                String timeValue = this.disposeValue(objects.get(4));
                String monitorValue = this.disposeValue(objects.get(5));
                String monitorValueWarn = this.disposeValue(objects.get(6));
                String imagePath = this.disposeValue(objects.get(6));

                if (StrUtil.isBlank(imagePath) || !imagePath.contains("save_images")) {
                    imagePath = this.disposeValue(objects.get(7));
                }
                if (stationValue == null || timeValue == null) continue;
                String disposeTime = this.disposeTime(timeValue);
                if (disposeTime == null) continue;
                Double monitorDouble = this.disposeDouble(monitorValue);
                Double monitorValueDiff = this.disposeDouble2(monitorValue, monitorValueWarn);
                entities.add(new Entity()
                        .set("monitor_id", SecureUtil.md5(stationValue + timeValue))
                        .set("station_name", stationValue)
                        .set("monitor_time", disposeTime)
                        .set("origin_monitor_time", timeValue)
                        .set("monitor_value", monitorDouble)
                        .set("monitor_value_diff", monitorValueDiff)
                        .set("create_time", null)
                        .set("update_time", null)
                        .set("monitor_png_path", imagePath)
                );
            } catch (Exception e) {
                log.error(e.getMessage(), e);
            }
        }
        return entities;
    }

    private List<Entity> disposeDj(List<List<Object>> readList) {
        List<Entity> entities = new ArrayList<>();
        for (List<Object> objects : readList) {
            try {
                String stationValue = this.disposeValue(objects.get(3));
                String timeValue = this.disposeValue(objects.get(4));
                String monitorValue = this.disposeValue(objects.get(5));
                String monitorValueWarn = this.disposeValue(objects.get(6));
                String imagePath = this.disposeValue(objects.get(6));

                if (StrUtil.isBlank(imagePath) || !imagePath.contains("save_images")) {
                    imagePath = this.disposeValue(objects.get(7));
                }
                if (stationValue == null || timeValue == null) continue;
                String disposeTime = this.disposeTime(timeValue);
                if (disposeTime == null) continue;
                Double monitorDouble = this.disposeDouble(monitorValue);
                Double monitorWarnDouble = this.disposeDouble2(monitorValue, monitorValueWarn);

                entities.add(new Entity()
                        .set("monitor_id", SecureUtil.md5(stationValue + timeValue))
                        .set("station_name", stationValue)
                        .set("monitor_time", disposeTime)
                        .set("origin_monitor_time", timeValue)
                        .set("monitor_value", monitorDouble)
                        .set("monitor_value_warn", monitorWarnDouble)
                        .set("create_time", null)
                        .set("update_time", null)
                        .set("monitor_png_path", imagePath)
                );
            } catch (Exception e) {
                log.error(e.getMessage(), e);
            }
        }
        return entities;
    }

    private Double disposeDouble2(String monitorValue, String monitorValueWarn) {

        try {
            if (monitorValueWarn == null || monitorValueWarn.equals("-")) {
                return null;
            }
            if (monitorValue.contains(" ")) {
                String trim = monitorValue.split(" ")[1].trim();
                if (StrUtil.isBlank(trim)) return null;
                return NumberUtil.isNumber(trim) ? Double.valueOf(trim) : null;
            }

            return NumberUtil.isNumber(monitorValueWarn) ? Double.valueOf(monitorValueWarn) : null;
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return null;
        }
    }

    private Double disposeDouble(String monitorValue) {
        try {
            if (monitorValue == null) return null;
            if (monitorValue.contains(" ")) {
                String[] split = monitorValue.split(" ");
                String trim = split[0].trim();
                return NumberUtil.isNumber(trim) ? Double.valueOf(trim) : null;
            }
            return NumberUtil.isNumber(monitorValue) ? Double.valueOf(monitorValue) : null;
        } catch (Exception e) {
            log.error("非法浮点数，跳过 {}", monitorValue);
            return null;
        }
    }

    private String disposeTime(String timeValue) {
        try {
            DateUtil.parse(timeValue, "MM-dd HH:mm");
            if (timeValue.contains("08:00 ")) return this.disposeTime(timeValue.split(" ")[1]);
            return DateUtil.date().year() + "-" + timeValue;
        } catch (Exception e) {
            log.error("非法日期，跳过 {}", timeValue);
            return null;
        }
    }


    private String disposeValue(Object value) {
        if (value == null) return null;
        String stringValue = value.toString().replace("--", "");
        if (StrUtil.isBlank(stringValue)) return null;
        return stringValue.trim();
    }


}
