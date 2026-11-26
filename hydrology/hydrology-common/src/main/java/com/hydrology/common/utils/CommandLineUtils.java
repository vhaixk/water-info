package com.hydrology.common.utils;


import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.io.resource.ResourceUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.constant.WaterDownloadConstants;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.db.GetDbUtils;
import com.spire.license.LicenseProvider;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@Slf4j
public class CommandLineUtils implements CommandLineRunner {

    @Autowired
    JdbcTemplate jdbcTemplate;
    @Autowired
    RedisCache redisCache;

    @Override
    public void run(String... args) {
        this.setDb();
        this.initWaterDownload();
        this.initWaterQuality();
        this.initWaterQuality();
        this.initTokenMapping();
        this.setPermitPathHeaderValues();
        this.getLicense();
    }

    @SneakyThrows
    private void initTokenMapping() {
        Db db = GetDbUtils.getDb();
        List<Entity> query = db.query("select * from hy_upload_token_mapping");
        Map<String, Entity> groupData = CollectionUtils.getGroupDataOne(query, "token_id");
        this.redisCache.setCacheMap(RedisConstants.STATION_PREFIX + RedisConstants.TOKEN_MAPPING, groupData, true);
    }


    @SneakyThrows
    private void setPermitPathHeaderValues() {
        Db db = GetDbUtils.getDb();
        List<Entity> query = db.query("select token_id from hy_upload_token_mapping");
        List<Long> tokenId = query.stream().map(entity -> entity.getLong("token_id")).collect(Collectors.toList());
        SystemConfig.setPermitPathHeaderValues(tokenId);
    }


    /**
     * 设置数据源
     */
    private void setDb() {
        GetDbUtils.setDb(new Db(jdbcTemplate.getDataSource()));
    }


    private void initWaterQuality() {

        if (redisCache.hasKey(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL) &&
                redisCache.hasKey(WaterDownloadConstants.QUALITY_AREA_RIVER_LABEL) &&
                redisCache.hasKey(WaterDownloadConstants.QUALITY_AREA_MAP_ID) &&
                redisCache.hasKey(WaterDownloadConstants.QUALITY_AREA_RIVER_ID) &&
                redisCache.hasKey(WaterDownloadConstants.QUALITY_AREA_LIST)
        ) {
            return;
        }

        String folderPath = "/profile/water-download/water-quality";
        String areaPath = SystemConfig.getRealPath(folderPath) + "/hy_download_water_quality_area.json";
        String riverPath = SystemConfig.getRealPath(folderPath) + "/hy_download_water_quality_river.json";
        JSONArray riverArray = JSONUtil.parseArray(FileUtil.readUtf8String(riverPath));
        JSONArray areaArray = JSONUtil.parseArray(FileUtil.readUtf8String(areaPath));
        Entity areaLabelEntity = Entity.create();
        Entity areaIdEntity = Entity.create();
        for (int i = 0; i < areaArray.size(); i++) {
            JSONObject jsonObject = areaArray.getJSONObject(i);
            Entity set = Entity.create().set("id", jsonObject.getStr("id")).set("label", jsonObject.getStr("label"));
            areaLabelEntity.set(jsonObject.getStr("label"), set);
            areaIdEntity.set(jsonObject.getStr("id"), set);
            JSONArray jsonArray = jsonObject.getJSONArray("children");
            if (jsonArray != null && !jsonArray.isEmpty()) {
                for (int i1 = 0; i1 < jsonArray.size(); i1++) {
                    JSONObject jsonObject1 = jsonArray.getJSONObject(i1);
                    areaLabelEntity.set(jsonObject1.getStr("label"), jsonObject1);
                    areaIdEntity.set(jsonObject1.getStr("id"), jsonObject1);
                }
            }
        }

        Entity riverLabelEntity = Entity.create();
        Entity riverIdEntity = Entity.create();
        for (int i = 0; i < riverArray.size(); i++) {
            JSONObject jsonObject = riverArray.getJSONObject(i);
            riverLabelEntity.set(jsonObject.getStr("label"), jsonObject);
            riverIdEntity.set(jsonObject.getStr("id"), jsonObject);
        }
        redisCache.setCacheList(WaterDownloadConstants.QUALITY_AREA_LIST, areaArray, true);
        redisCache.setCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_LABEL, areaLabelEntity, true);
        redisCache.setCacheMap(WaterDownloadConstants.QUALITY_AREA_RIVER_LABEL, riverLabelEntity, true);

        redisCache.setCacheMap(WaterDownloadConstants.QUALITY_AREA_MAP_ID, areaIdEntity, true);
        redisCache.setCacheMap(WaterDownloadConstants.QUALITY_AREA_RIVER_ID, riverIdEntity, true);
    }


    @SneakyThrows
    private void initWaterDownload() {
        for (String table : WaterDownloadConstants.TABLES) {
            String allName = table + WaterDownloadConstants.RINSE_DATA;
            String treeName = table + WaterDownloadConstants.TREE;
            if (redisCache.hasKey(treeName) && redisCache.hasKey(allName)) {
                continue;
            }
            WaterDownloadCacheUtils.refreshMappingCache(table);
        }
    }

    public void getLicense() {
        InputStream is = ResourceUtil.getStream("license.elic.xml");
        try {
            LicenseProvider.setLicenseFile(is);
            log.info("doc授权成功");
        } catch (Exception e) {
            throw new RuntimeException("doc授权文件错误!");
        }
        IoUtil.close(is);
    }
}
