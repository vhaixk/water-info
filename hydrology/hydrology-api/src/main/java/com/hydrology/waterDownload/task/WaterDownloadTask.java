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


    public void runCrawl() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        String waterDownloadUrl = SystemConfig.getWaterDownloadUrl();
        String token = SystemConfig.getWaterDownloadToken();

        // /crawl/water 为异步接口：提交任务后轮询 /crawl/status 直至 done
        String taskId;
        HttpRequest submit = HttpUtil.createPost(waterDownloadUrl + "/crawl/water")
                .timeout(30000).body(JSONUtil.toJsonStr(Entity.create().set("token", token)));
        try (HttpResponse response = submit.execute()) {
            taskId = JSONUtil.parseObj(response.body()).getStr("task_id");
        } catch (Exception e) {
            log.error("提交爬取任务失败", e);
            return;
        }
        if (StrUtil.isBlank(taskId)) {
            log.error("爬取任务提交未返回 task_id");
            return;
        }

        JSONObject results = null;
        long deadline = System.currentTimeMillis() + 15 * 60 * 1000L;
        while (System.currentTimeMillis() < deadline) {
            try {
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
            HttpRequest statusReq = HttpUtil.createPost(waterDownloadUrl + "/crawl/status")
                    .timeout(30000).body(JSONUtil.toJsonStr(Entity.create().set("token", token).set("task_id", taskId)));
            try (HttpResponse response = statusReq.execute()) {
                JSONObject task = JSONUtil.parseObj(response.body());
                if ("done".equals(task.getStr("status"))) {
                    results = task.getJSONObject("results");
                    break;
                }
                log.info("爬取任务进行中 task={} status={}", taskId, task.getStr("status"));
            } catch (Exception e) {
                log.error("查询爬取状态失败", e);
            }
        }
        if (results == null) {
            log.error("爬取任务超时或失败 task={}", taskId);
            return;
        }

        // 大江大河 / 大型水库 / 雨水情，单站失败不影响其余
        JSONObject djObject = results.getJSONObject("dj");
        JSONObject xsqObject = results.getJSONObject("xsq");
        JSONObject ysqObject = results.getJSONObject("ysq");
        if (djObject != null) {
            this.downloadAndSave("hy_download_water_dj", djObject.getStr("excel"), djObject.getStr("image"));
        }
        if (xsqObject != null) {
            this.downloadAndSave("hy_download_water_sk", xsqObject.getStr("excel"), xsqObject.getStr("image"));
        }
        if (ysqObject != null) {
            this.downloadAndSave("hy_download_water_yq", ysqObject.getStr("excel"), ysqObject.getStr("image"));
        }
    }

    public void downloadAndSave(String tableName, String excelPath, String imagePath) {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        String waterDownloadUrl = SystemConfig.getWaterDownloadUrl();
        String crawlUrl = StrUtil.format("{}/download", waterDownloadUrl);
        Entity params = Entity.create().set("path", excelPath).set("token", SystemConfig.getWaterDownloadToken());
        HttpRequest httpRequest = HttpUtil.createPost(crawlUrl).timeout(-1).body(JSONUtil.toJsonStr(params));

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

        try (HttpResponse response = httpRequest.execute(false)) {
            InputStream inputStream = response.bodyStream();
            ExcelReader reader = ExcelUtil.getReader(inputStream);
            List<List<Object>> readList = reader.read();
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
            GetDbUtils.insertOrUpdate(tableName, values);
            // 以当日 Excel 为权威，自动补全映射字典与流域白名单
            this.upsertMappingFromExcel(tableName, readList);
            inputStream.close();
            reader.close();
        } catch (Exception e) {
            log.error(e.getMessage(), e);
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
