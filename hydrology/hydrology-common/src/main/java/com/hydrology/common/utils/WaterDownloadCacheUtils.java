package com.hydrology.common.utils;

import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import com.hydrology.common.constant.WaterDownloadConstants;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.db.GetDbUtils;
import cn.hutool.extra.spring.SpringUtil;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 水雨情映射缓存构建：映射表 -> 流域/河流/测站树 + 测站名映射字典
 * 启动初始化与映射表增删改后共用，保证字典映射即时生效。
 * 匹配键统一走 {@link StationNameUtils#normalizeKey}（繁简/全角归一）；
 * 流域白名单之外的脏值隔离到“待审核”节点，避免污染树。
 */
@Slf4j
public class WaterDownloadCacheUtils {

    public static final String QUARANTINE_BASIN = "待审核";

    @SneakyThrows
    public static void refreshMappingCache(String tableName) {
        Db db = GetDbUtils.getDb();
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);

        Set<String> basinWhitelist = loadBasinWhitelist(db);

        String formatSql = "select * from {} order by basin_name,province_name,river_name ";
        List<Entity> data = db.query(StrUtil.format(formatSql, tableName));
        List<Entity> treeData = new ArrayList<>();
        String allName = tableName + WaterDownloadConstants.RINSE_DATA;
        String treeName = tableName + WaterDownloadConstants.TREE;

        Map<String, List<Entity>> basinGroup = data.stream()
                .collect(Collectors.groupingBy(entity -> basinLabel(entity.getStr("basin_name"), basinWhitelist)));
        for (String basinName : basinGroup.keySet()) {
            Map<String, List<Entity>> riverGroup = basinGroup.get(basinName)
                    .stream()
                    .filter(entity -> entity.getStr("river_name") != null)
                    .collect(Collectors.groupingBy(entity -> entity.getStr("river_name")));
            ArrayList<Entity> children = new ArrayList<>();

            Entity resultEntity = Entity.create()
                    .set("id", basinName)
                    .set("label", basinName);
            treeData.add(resultEntity);
            for (String river : riverGroup.keySet()) {
                Entity set = Entity.create().set("id", river).set("label", river);
                children.add(set);
                List<Entity> collect = riverGroup.get(river)
                        .stream()
                        .map(entity -> {
                            String stationName = entity.getStr("station_name");
                            return Entity.create().set("id", stationName).set("label", stationName);
                        })
                        .collect(Collectors.toList());
                if (!collect.isEmpty()) set.set("children", collect);
            }
            if (!children.isEmpty()) resultEntity.set("children", children);
        }

        Map<String, List<Entity>> groupData = data.stream()
                .collect(Collectors.groupingBy(entity -> {
                            String stationName = entity.getStr("station_name");
                            String stationNameAlias = entity.getStr("station_name_alias");
                            return StationNameUtils.normalizeKey(StrUtil.blankToDefault(stationNameAlias, stationName));
                        })
                );

        redisCache.setCacheMap(allName, groupData, true);
        redisCache.setCacheList(treeName, treeData, true);
    }

    /**
     * 流域白名单（规范化键集合），来自 hy_download_water_basin_whitelist 表
     */
    @SneakyThrows
    public static Set<String> loadBasinWhitelist(Db db) {
        Set<String> set = new HashSet<>();
        List<Entity> rows = db.query("select basin_name from hy_download_water_basin_whitelist");
        for (Entity row : rows) {
            set.add(StationNameUtils.normalizeKey(row.getStr("basin_name")));
        }
        return set;
    }

    /**
     * 白名单内返回原流域名，否则隔离到“待审核”
     */
    private static String basinLabel(String basinName, Set<String> whitelist) {
        if (StrUtil.isBlank(basinName)) {
            return QUARANTINE_BASIN;
        }
        return whitelist.contains(StationNameUtils.normalizeKey(basinName)) ? basinName : QUARANTINE_BASIN;
    }
}