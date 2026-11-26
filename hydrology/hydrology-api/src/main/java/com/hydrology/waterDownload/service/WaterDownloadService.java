package com.hydrology.waterDownload.service;

import cn.hutool.core.convert.Convert;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.lang.TypeReference;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ZipUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONUtil;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.constant.WaterDownloadConstants;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.RegexUtils;
import com.hydrology.common.utils.StationNameUtils;
import com.hydrology.common.utils.db.GetDbUtils;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class WaterDownloadService {


    @Autowired
    private RedisCache redisCache;

    public Object getTreeData(String mappingName) {
        String treeName = mappingName + WaterDownloadConstants.TREE;
        return this.redisCache.getCacheList(treeName);

    }

    public Object getDicMapping(String mappingName) {
        String allName = mappingName + WaterDownloadConstants.RINSE_DATA;
        return this.redisCache.getCacheMap(allName);

    }

    @SneakyThrows
    public List<Entity> getData(Entity paramMap) {
        Db db = GetDbUtils.getDb();
        String metaName = paramMap.getStr("metaName");
        String mappingName = paramMap.getStr("mappingName");
        String dataOrder = paramMap.getStr("dataOrder");
        Map<String, List<Entity>> stationMapping = Convert.convert(new TypeReference<Map<String, List<Entity>>>() {
        }, redisCache.getCacheMap(mappingName + WaterDownloadConstants.RINSE_DATA));


        List<String> dates = Convert.toList(String.class, paramMap.getStr("dates"));
        Timestamp startDate = DateUtil.parse(dates.get(0)).toTimestamp();
        Timestamp endDate = DateUtil.parse(dates.get(1)).toTimestamp();
        Set<String> checkList = Convert.toMap(String.class, Boolean.class, paramMap.get("treeCheckList")).keySet();
        List<Object> params = new ArrayList<>();
        params.add(startDate);
        params.add(endDate);
        String checkWhereSql = "";
        if (!checkList.isEmpty()) {
            // 勾选节点可能是简体站名/流域/河流，而监测数据站名含繁体别名，
            // 借助映射字典展开为全部站名原始变体，保证勾选树节点能取到数据
            Set<String> normalizedCheck = checkList.stream()
                    .map(StationNameUtils::normalizeKey).collect(Collectors.toSet());
            Set<String> stationVariants = new HashSet<>(checkList);
            for (List<Entity> entities : stationMapping.values()) {
                for (Entity e : entities) {
                    String st = e.getStr("station_name");
                    String alias = e.getStr("station_name_alias");
                    boolean match = normalizedCheck.contains(StationNameUtils.normalizeKey(st))
                            || (alias != null && normalizedCheck.contains(StationNameUtils.normalizeKey(alias)))
                            || normalizedCheck.contains(StationNameUtils.normalizeKey(e.getStr("basin_name")))
                            || normalizedCheck.contains(StationNameUtils.normalizeKey(e.getStr("river_name")));
                    if (match) {
                        if (st != null) stationVariants.add(st);
                        if (alias != null) stationVariants.add(alias);
                    }
                }
            }
            checkWhereSql = StrUtil.format(" and station_name in ('{}') ", StrUtil.join("','", stationVariants));
        }
        String orderSql = "order by monitor_time " + dataOrder;
        String querySql = StrUtil.format("select * from {} where monitor_time > ? and monitor_time <= ?", metaName) + checkWhereSql + orderSql;
        List<Entity> query = db.query(querySql, params.toArray());
        for (Entity entity : query) {
            String stationName = entity.getStr("station_name");
            String cleanString = StationNameUtils.normalizeKey(stationName);

            List<Entity> entities = stationMapping.get(cleanString);
            if (entities == null || entities.isEmpty()) continue;
            String basinName = entities.stream().map(entity1 -> entity1.getStr("basin_name")).collect(Collectors.joining("/"));
            String riverName = entities.stream().map(entity1 -> entity1.getStr("river_name")).collect(Collectors.joining("/"));
            String provinceName = entities.stream().map(entity1 -> entity1.getStr("province_name")).collect(Collectors.joining("/"));
            entity.set("basin_name", basinName).set("river_name", riverName).set("province_name", provinceName);
        }
        query.sort(Comparator.comparing(e -> {
                    Entity entity = (Entity) e;
                    return entity.getStr("basin_name");
                }, Comparator.nullsLast(String::compareTo)).thenComparing(e -> {
                    Entity entity = (Entity) e;
                    return entity.getStr("river_name");

                }, Comparator.nullsLast(String::compareTo))
        );
        return query;
    }


    public InputStream getProfileData(String profilePath, HttpServletResponse response) {

        HttpRequest body = HttpUtil.createPost(SystemConfig.getWaterDownloadUrl() + "/download")
                .body(
                        JSONUtil.toJsonStr(
                                Entity.create()
                                        .set("path", profilePath)
                                        .set("token", SystemConfig.getWaterDownloadToken())
                        )
                );

        try (HttpResponse httpResponse = body.execute()) {
            InputStream inputStream = httpResponse.bodyStream();
            if (response != null) responseOut(inputStream, response);
            return inputStream;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void responseOut(InputStream inputStream, HttpServletResponse response) {
        try (InputStream in = inputStream) {
            try (OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = in.read(buffer)) != -1) {
                    out.write(buffer, 0, len);
                }
                out.flush();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @SneakyThrows
    public String handleExportOrigin(Entity paramMap) {

        String metaName = paramMap.getStr("metaName");
        List<String> dates = Convert.toList(String.class, paramMap.getStr("dates"));
        DateTime startDate = DateUtil.parse(dates.get(0));
        DateTime endDate = DateUtil.parse(dates.get(1));
        String sql = "select * from hy_download_water_date_mapping where create_time >= ? and create_time <= ? and data_type = ?";
        Db db = GetDbUtils.getDb();
        List<Entity> query = db.query(sql, startDate.toTimestamp(), endDate.toTimestamp(), metaName);
        List<File> files = new ArrayList<>();
        for (Entity entity : query) {
            String dataExcelPath = entity.getStr("data_excel_path");
            String dataPngPath = entity.getStr("data_png_path");
            DateTime createTime = DateUtil.parse(entity.getStr("create_time"));
            String namePrefix = createTime.toString("yyyyMMddHHmmss");
            String excelName = namePrefix + "-" + FileUtil.getName(dataExcelPath);
            String pngName = namePrefix + "-" + FileUtil.getName(dataPngPath);

            InputStream excelStream = this.getProfileData(dataExcelPath, null);
            InputStream imageStream = this.getProfileData(dataPngPath, null);

            String saveExcelPath = "/profile/water-download" + createTime.toString("/yyyy/MM/") + excelName;
            String savePngPath = "/profile/water-download" + createTime.toString("/yyyy/MM/") + pngName;
            File excelPath = FileUtil.writeFromStream(excelStream, FileUtil.file(SystemConfig.getRealPath(saveExcelPath)), true);
            File imagePath = FileUtil.writeFromStream(imageStream, FileUtil.file(SystemConfig.getRealPath(savePngPath)), true);
            files.add(excelPath);
            files.add(imagePath);
        }

        String zipFilePath = StrUtil.format("/profile/water-download/export/origin-data-{}-{}.zip", startDate.toString("yyyyMMddHHmmss"), endDate.toString("yyyyMMddHHmmss"));
        ZipUtil.zip(FileUtil.file(SystemConfig.getRealPath(zipFilePath)), false, files.toArray(new File[0]));
        return zipFilePath;
    }
}
