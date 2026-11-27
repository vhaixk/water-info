package com.hydrology.generator.service;


import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.CacheUtils;
import com.hydrology.common.utils.CollectionUtils;
import com.hydrology.common.utils.db.GetDbUtils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@Slf4j
public class GenTableCacheService implements CommandLineRunner {


    @Autowired
    RedisCache redisCache;

    @Override
    public void run(String... args) {
        this.initTableCache();
        this.initDatasetCache();
        CacheUtils.initEntityDicCache(null);
    }


    @SneakyThrows
    private void initTableCache() {
        Db db = GetDbUtils.getDb();
        List<Entity> genTable = db.query("select * from gen_table");
        List<Entity> tableColumn = db.query("select * from gen_table_column");
        Map<String, Entity> tableIdGroup = CollectionUtils.toMap(genTable, "table_id");
        Map<String, List<Entity>> columnGroup = CollectionUtils.getGroupData(tableColumn, "table_id");
        Map<String, Entity> tableNameGroup = CollectionUtils.toMap(genTable, "table_name");
        for (String tableId : columnGroup.keySet()) {
            String tableName = tableIdGroup.get(tableId).getStr("table_name").toLowerCase();
            List<Entity> entities = columnGroup.get(tableId);
            Map<String, Entity> columnGroupData = CollectionUtils.toMap(entities, "column_name");
            this.redisCache.setCacheMap(RedisConstants.COLUMN_PREFIX + tableName, columnGroupData, true);
            this.setPkField(tableName, entities);
        }
        for (String tableName : tableNameGroup.keySet()) {
            this.redisCache.setCacheMap(RedisConstants.TABLE_PREFIX + tableName, tableNameGroup.get(tableName), true);
        }
        log.info("初始化表字段缓存成功！");
    }


    @SneakyThrows
    public void refreshOneTable(Long tableId) {
        Db db = GetDbUtils.getDb();
        Entity genTable = db.queryOne("select * from gen_table where table_id = ? ", tableId);
        List<Entity> tableColumn = db.query("select * from gen_table_column where table_id = ? ", tableId);
        String tableName = genTable.getStr("table_name").toLowerCase();
        Map<String, Entity> columnGroupData = CollectionUtils.toMap(tableColumn, "column_name");
        this.redisCache.setCacheMap(RedisConstants.COLUMN_PREFIX + tableName, columnGroupData, true);
        this.redisCache.setCacheMap(RedisConstants.TABLE_PREFIX + tableName, genTable, true);
        this.setPkField(tableName, tableColumn);

        log.info("刷新表 {} 缓存成功！", tableName);

    }

    private void setPkField(String tableName, List<Entity> entities) {
        Map<String, Entity> collect = entities.stream()
                .filter(entity -> entity.getStr("is_pk").equals("1"))
                .collect(Collectors.toMap(entity -> entity.getStr("column_name"), entity -> entity));
        this.redisCache.setCacheMap(RedisConstants.COLUMN_PK + tableName, collect, true);
    }

    /** 启动时全量加载关联数据集配置缓存 */
    @SneakyThrows
    public void initDatasetCache() {
        Db db = GetDbUtils.getDb();
        List<Entity> datasets = db.query("select * from gen_dataset");
        for (Entity ds : datasets) {
            refreshDatasetCache(ds.getStr("dataset_name"));
        }
        log.info("初始化关联数据集缓存成功！共 {} 个", datasets.size());
    }

    /** 刷新单个数据集缓存（实现位于 common 侧 DatasetService，此处委托） */
    public void refreshDatasetCache(String datasetName) {
        cn.hutool.extra.spring.SpringUtil.getBean(com.hydrology.common.core.service.DatasetService.class).reloadCache(datasetName);
    }

    /** 删除数据集缓存 */
    public void removeDatasetCache(String datasetName) {
        cn.hutool.extra.spring.SpringUtil.getBean(com.hydrology.common.core.service.DatasetService.class).removeCache(datasetName);
    }
}
