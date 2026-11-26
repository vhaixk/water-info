package com.hydrology.common.utils;

import cn.hutool.core.convert.Convert;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.extra.spring.SpringUtil;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.core.domain.entity.SysDictData;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.utils.db.GetDbUtils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
public class CacheUtils {


    public static Entity getTableInfo(String tableName) {
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        return Convert.convert(Entity.class, redisCache.getCacheMap(RedisConstants.TABLE_PREFIX + tableName));
    }

    public static Map<String, Entity> getColumnInfo(String tableName) {
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        return Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName));
    }

    public static Entity getColumnInfoOne(String tableName, String columnName) {
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        return Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName)).get(columnName);
    }

    public static Map<String, Entity> getColumnPkInfo(String tableName, String columnName) {
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        return Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(RedisConstants.COLUMN_PK + tableName));
    }

    public static Entity getColumnInfoPkOne(String tableName, String columnName) {
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        return Convert.toMap(String.class, Entity.class, redisCache.getCacheMap(RedisConstants.COLUMN_PK + tableName)).get(columnName);
    }

    public static List<SysDictData> getDicCache(String typeName) {

        return DictUtils.getDictCache(typeName);
    }

    public static String getDicValue(String typeName, String label) {

        return DictUtils.getDictValue(typeName, label);
    }

    public static String getDicLabel(String typeName, String value) {

        return DictUtils.getDictLabel(typeName, value);
    }

    @SneakyThrows
    public static void initEntityDicCache(String typeName) {
        RedisCache redisBean = SpringUtil.getBean(RedisCache.class);
        Db db = GetDbUtils.getDb();
        String queryDictSql = "select * from sys_dict_type where dict_category = 'entity_dic' and length(dict_entity_json) > 0 is not null";
        if (StrUtil.isNotBlank(typeName)) {
            queryDictSql += " and dict_type = '" + typeName + "'";
        }
        List<Entity> queryDictType = db.query(queryDictSql);
        for (Entity entity : queryDictType) {
            String dictEntityJson = entity.getStr("dict_entity_json");
            JSONObject entries = JSONUtil.parseObj(dictEntityJson);
            if (entries.isEmpty()) continue;
            String tableName = entries.getStr("tableName");
            String dictType = entries.getStr("dictType", entries.getStr("tableName"));
            String dictCode = entries.getStr("dictCode", entries.getStr("dictValue"));
            String dictLabel = entries.getStr("dictLabel");
            String dictValue = entries.getStr("dictValue");
            String dictRemark = entries.getStr("dictRemark");
            String dictSort = entries.getStr("dictSort");
            String whereSql = entries.getStr("whereSql");
            String orderSql = entries.getStr("orderSql");
            String querySql = StrUtil.format("select {} as dict_code,{} as dict_label,{} as dict_value,{} as dict_sort,{} as dictRemark" +
                            " from {} {} {}",
                    dictCode, dictLabel, dictValue, dictSort, dictRemark, tableName,
                    StrUtil.blankToDefault(whereSql, ""), StrUtil.blankToDefault(orderSql, "order by " + dictValue));
            try {
                List<Entity> resultData = db.query(querySql);
                List<Map<String, Object>> dicListData = resultData.stream().map(result -> {
                    Map<String, Object> returnMap = new LinkedHashMap<>();
                    for (String key : result.keySet()) {
                        returnMap.put(StrUtil.toCamelCase(key), result.get(key));
                    }
                    return returnMap;
                }).collect(Collectors.toList());
                redisBean.deleteObject(DictUtils.getCacheKey(dictType));
                redisBean.setCacheObject(DictUtils.getCacheKey(dictType), dicListData);
            } catch (SQLException e) {
                log.error(StrUtil.format("字典sql异常 {}", querySql), e);
            }
        }
    }
}
