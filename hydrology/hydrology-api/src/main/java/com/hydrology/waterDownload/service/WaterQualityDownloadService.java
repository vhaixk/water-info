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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Service
public class WaterQualityDownloadService {
    @Autowired
    RedisCache redisCache;


    Pattern pattern = Pattern.compile(">([^<]+)<");

    @SneakyThrows
    public void download() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        String url = "https://szzdjc.cnemc.cn:8070/GJZ/Ajax/Publish.ashx";

        Set<String> ids = new HashSet<>();
        Map<String, Entity> areaMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL));
        Map<String, Entity> riverMap = Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(WaterDownloadConstants.QUALITY_AREA_RIVER_LABEL));
        int size = areaMap.size();
        int index = 0;
        for (String areaName : areaMap.keySet()) {
            List<Entity> saveParams = new ArrayList<>();
            Thread.sleep(1000 * 30 + new Random().nextInt(1000 * 45));
            log.info("水质数据下载，正在处理 {}/{}", index, size);
            index++;
            String areaId = areaMap.get(areaName).getStr("id");
            if (areaId.contains("0000")) continue;
            Map<String, Object> params = new HashMap<String, Object>() {{
                put("AreaID", areaId);
                put("RiverID", "");
                put("MNName", "");
                put("PageIndex", -1);
                put("PageSize", 120);
                put("action", "getRealDatas");
            }};

            HttpRequest httpRequest = HttpUtil.createPost(url).form(params);
            try (HttpResponse httpResponse = httpRequest.execute(false)) {
                JSONObject entries = JSONUtil.parseObj(httpResponse.body());
                JSONArray thead = entries.getJSONArray("thead");
                JSONArray tbody = entries.getJSONArray("tbody");
                if (tbody == null || tbody.isEmpty()) continue;
                Entity fieldEntity = this.disposeFieldName(thead);
                for (int i = 0; i < tbody.size(); i++) {
                    JSONArray data = tbody.getJSONArray(i);
                    Entity entity = Entity.create();
                    for (String key : fieldEntity.keySet()) {
                        String value = this.disposeValue(data.getStr(Integer.parseInt(key)));
                        entity.set(fieldEntity.getStr(key), value);
                    }

                    String wqProvince = entity.getStr("wq_province");
                    if (StrUtil.isNotBlank(wqProvince)) {
                        entity.set("wq_province", areaMap.get(wqProvince).getStr("id"));
                    }
                    entity.set("wq_city", areaId);

                    String wqMonitorTimeOrigin = entity.getStr("wq_monitor_time_origin");
                    if (StrUtil.isNotBlank(wqMonitorTimeOrigin)) {
                        DateTime date = DateUtil.date();
                        String yyyy = date.toString("yyyy");
                        String time = yyyy + "-" + wqMonitorTimeOrigin;
                        entity.set("wq_monitor_time", time);
                        String id = SecureUtil.md5(time + entity.getStr("wq_section_name"));
                        if (ids.contains(id)) continue;
                        ids.add(id);
                        entity.set("wq_id", id);
                    } else {
                        continue;
                    }

                    String wqBasin = entity.getStr("wq_basin");
                    if (StrUtil.isNotBlank(wqBasin)) {
                        entity.set("wq_basin", riverMap.get(wqBasin).getStr("id"));
                    }
                    saveParams.add(entity);
                }
                GetDbUtils.insertOrUpdate("hy_download_water_quality", saveParams);

            } catch (Exception e) {
                log.error(e.getMessage(), e);
            }
        }

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
        String dataOrder = paramMap.getStr("dataOrder");

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
            checkWhereSql = StrUtil.format(" and wq_city in ({}) ", StrUtil.join(",", checkList));
        } else {
            limitSql = " limit 1650";
        }
        String orderSql = StrUtil.format("order by  wq_monitor_time {},wq_city,wq_section_name ", dataOrder);

        String querySql = StrUtil.format("select * from hy_download_water_quality where wq_monitor_time > ? and wq_monitor_time <= ? ") + checkWhereSql + orderSql + limitSql;
        List<Entity> query = db.query(querySql, params.toArray());
        return query;
    }
}
