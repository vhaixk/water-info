package com.hydrology.common.utils.db;


import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.comparator.CompareUtil;
import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.*;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.extra.spring.SpringUtil;
import com.hydrology.common.constant.HttpStatus;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.core.entity.QueryEntity;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.exception.ServiceException;
import com.hydrology.common.utils.CacheUtils;
import com.hydrology.common.utils.SecurityUtils;
import com.hydrology.common.utils.WaterDownloadCacheUtils;
import lombok.Getter;
import lombok.Setter;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.sql.SQLException;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
public class GetDbUtils {

    @Getter
    @Setter
    private static Db db;


    public static String[] INVALID_CHARACTERS = new String[]{"select", "update", "delete", "insert"};

    /** 单次查询/导出行数上限 */
    public static final long MAX_PAGE_SIZE = 200_000L;

    /** 表名/列名等 SQL 标识符合法性校验 */
    private static final Pattern IDENTIFIER_PATTERN = Pattern.compile("^[a-zA-Z0-9_]+$");

    private static void checkTableName(String tableName) {
        if (StrUtil.isBlank(tableName) || !IDENTIFIER_PATTERN.matcher(tableName).matches()) {
            throw new ServiceException("非法表名：" + tableName, HttpStatus.FORBIDDEN);
        }
    }

    public static ResultEntity queryDataByEntity(QueryEntity queryEntity) {
        if (queryEntity == null) queryEntity = new QueryEntity();

        // 获取分页参数，并设置默认值与上限，防止空值 NPE 或任意 pageSize 拉取全表
        long page = queryEntity.getPage() == null || queryEntity.getPage() < 1 ? 1L : queryEntity.getPage();
        long pageSize = queryEntity.getPageSize() == null || queryEntity.getPageSize() < 1 ? 20L
                : Math.min(queryEntity.getPageSize(), MAX_PAGE_SIZE);
        queryEntity.setPage(page).setPageSize(pageSize);
        String tableName = queryEntity.getTableName();
        checkTableName(tableName);
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Map<String, Entity> columnConfigList = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);

        checkPower(queryEntity);
        // 1. 构建 where 条件（排除分页参数和可能的排序参数）
        List<Object> paramsList = new ArrayList<>();
        List<String> whereFields = new ArrayList<>();

        getWhereConditions(ListUtil.toList(queryEntity.getColumns().values()), columnConfigList, whereFields, paramsList);
        String orderBy = getOrderBy(ListUtil.toList(queryEntity.getOrders().values()), columnConfigList);
        String whereClause = StrUtil.join(" AND ", whereFields);

        String querySql = StrUtil.format(
                "select * from {} where {} {}",
                tableName,
                whereClause,
                orderBy == null ? "" : " order by " + orderBy
        );

        log.info("queryDataByEntity:{}", querySql);
        try {
            long total = getTotalCount(db, tableName, whereClause, paramsList.toArray());
            List<Entity> dataList;
            if (pageSize > 1000) {
                int batchSize = 1000;
                dataList = new ArrayList<>(5000);
                long currentOffset = 0;
                while (currentOffset < pageSize) {
                    log.info("监测数据量过大，采用分批查询合并策略 total:{} currentOffset:{}", pageSize, currentOffset);
                    List<Object> batchParams = new ArrayList<>(paramsList);
                    batchParams.add(batchSize);
                    batchParams.add(currentOffset);

                    String batchSql = querySql + " limit ? offset ?";
                    List<Entity> batchData = db.query(batchSql, batchParams.toArray());
                    if (batchData == null || batchData.isEmpty()) {
                        break;
                    }
                    dataList.addAll(batchData);
                    currentOffset += batchSize;
                }
            } else {
                long offset = (page - 1) * pageSize;
                paramsList.add(pageSize);
                paramsList.add(offset);
                querySql += " limit ? offset ?";
                dataList = db.query(querySql, paramsList.toArray());
            }
            return ResultEntity.getInstance()
                    .setDataList(dataList)
                    .setPage(page)
                    .setPageSize(pageSize)
                    .setTotal(total)
                    .setTotalPage((total + pageSize - 1) / pageSize);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @SneakyThrows
    private static void checkPower(QueryEntity queryEntity) {

        String powerIds = SecurityUtils.getPowerIds();
        if (StrUtil.isBlank(powerIds)) return;
        String systemId = SecurityUtils.getSystemId();
        if (StrUtil.isBlank(systemId)) return;
        String tableName = queryEntity.getTableName();

        if (StrUtil.containsIgnoreCase(tableName, "hy_")) {
            // 用户传入的站点条件必须与授权范围求交集，防止自选站点绕过行级数据权限
            applyPowerColumn(queryEntity, "station_f_id", new ArrayList<>(SecurityUtils.getFStations().keySet()));
            applyPowerColumn(queryEntity, "power_station_id", Arrays.asList(powerIds.split(",")));
        }
    }

    private static void applyPowerColumn(QueryEntity queryEntity, String columnName, List<String> allowed) {
        if (allowed.isEmpty()) {
            throw new ServiceException("您无权访问该站点数据", HttpStatus.FORBIDDEN);
        }
        QueryEntity.Column column = queryEntity.getColumns().get(columnName);
        List<String> finalValues = allowed;
        if (column != null && ObjectUtil.isNotEmpty(column.getColumnValue())) {
            Object value = column.getColumnValue();
            List<String> requested = value instanceof List
                    ? ((List<?>) value).stream().map(String::valueOf).collect(Collectors.toList())
                    : Collections.singletonList(String.valueOf(value));
            finalValues = requested.stream().filter(allowed::contains).distinct().collect(Collectors.toList());
            if (finalValues.isEmpty()) {
                throw new ServiceException("您无权访问该站点数据", HttpStatus.FORBIDDEN);
            }
        }
        queryEntity.getColumns()
                .put(columnName,
                        QueryEntity.Column.getOne()
                                .setWhereType("IN")
                                .setColumnName(columnName)
                                .setGroupId(columnName)
                                .setColumnValue(finalValues)
                );
    }

    public static Entity queryOneDataByEntity(QueryEntity queryEntity) {
        List<Entity> entities = queryDataByEntity(queryEntity).getDataList();
        if (entities == null || entities.isEmpty()) {
            return Entity.create();
        }
        return entities.get(0);
    }

    @SneakyThrows
    public static List<Entity> queryNewDataByGroup(Entity entity) {
        checkValue(entity);
        checkTableName(entity.getStr("tableName"));
        checkTableName(entity.getStr("partitionField"));
        checkTableName(entity.getStr("orderField"));
        String sql = "SELECT\n" +
                "  *\n" + "FROM\n" +
                "  (SELECT *, ROW_NUMBER() OVER (PARTITION BY {partitionField} ORDER BY {orderField} DESC) AS rn FROM {tableName} where monitor_station_time > ?) t\n" +
                "WHERE\n" + "  t.rn = 1";
        String finalSql = StrUtil.format(sql, entity);
        return db.query(finalSql, DateUtil.date().offset(DateField.HOUR, -3).toTimestamp());
    }

    /**
     * 构建 where 条件
     */
    private static void getWhereConditions(
            List<QueryEntity.Column> columns,
            Map<String, Entity> columnConfigList,
            List<String> whereFields,
            List<Object> params
    ) {
        columns = columns.stream().filter(column -> columnConfigList.containsKey(column.getColumnName())).collect(Collectors.toList());
        // 分组
        Map<String, List<QueryEntity.Column>> whereEntityGroup =
                columns.stream()
                        .collect(Collectors.groupingBy(item -> StrUtil.blankToDefault(item.getGroupId(), "default")));

        whereFields.add(" 1 = 1 ");
        for (String key : whereEntityGroup.keySet()) {
            // 每个组为 or 链接
            List<QueryEntity.Column> whereColumns = whereEntityGroup.get(key);
            List<String> tempWhere = new ArrayList<>();
            for (QueryEntity.Column item : whereColumns) {
                Object columnValue = item.getColumnValue();
                String whereType = StrUtil.blankToDefault(item.getWhereType(), "EQ").toUpperCase();

                if ((columnValue == null || StrUtil.isBlank(columnValue.toString())) && !whereType.contains("NULL"))
                    continue;
                checkValue(columnValue);
                String itemKey = item.getColumnName();
                boolean isListValue = columnValue instanceof List;
                if (isListValue && ((List<?>) columnValue).isEmpty()) continue;
                Entity columnConfig = columnConfigList.get(itemKey);
                String javaType = columnConfig.getStr("java_type");

                switch (whereType) {
                    case "GT":
                        tempWhere.add(itemKey + " > ? ");
                        break;
                    case "LT":
                        tempWhere.add(itemKey + " < ? ");
                        break;
                    case "GTE":
                        tempWhere.add(itemKey + " >= ? ");
                        break;
                    case "LTE":
                        tempWhere.add(itemKey + " <= ? ");
                        break;
                    case "LIKE":
                        tempWhere.add(itemKey + " like concat(concat('%', ?), '%') ");
                        break;
                    case "LLIKE":
                        tempWhere.add(itemKey + " like concat('%', ?) ");
                        break;
                    case "RLIKE":
                        tempWhere.add(itemKey + " like concat(?, '%') ");
                        break;
                    case "NE":
                        tempWhere.add(itemKey + " != ? ");
                        break;
                    case "BETWEEN":
                        tempWhere.add(itemKey + " >= ? and " + itemKey + " <= ? ");
                        break;
                    case "ISNULL":
                        tempWhere.add(itemKey + " IS  NULL ");
                        break;
                    case "NOTNULL":
                        tempWhere.add(itemKey + " IS NOT NULL ");
                        break;
                    case "IN":
                        List<String> collect = isListValue ?
                                ((List<?>) columnValue)
                                        .stream()
                                        .map(tt -> "?")
                                        .collect(Collectors.toList())
                                : Stream.of(columnValue.toString())
                                .map(tt -> "?")
                                .collect(Collectors.toList());
                        tempWhere.add(itemKey + " in ( " + StrUtil.join(",", collect) + " ) ");
                        break;
                    case "EQ":
                    default:
                        tempWhere.add(itemKey + " = ? ");
                }
                if (!whereType.equals("ISNULL") && !whereType.equals("NOTNULL")) {
                    List<Object> finalValue = getQueryValue(javaType, columnValue);
                    params.addAll(finalValue);
                }
            }
            if (!tempWhere.isEmpty()) {
                whereFields.add(" (" + String.join(" or ", tempWhere) + ") ");
            }
        }


    }

    private static List<Object> getQueryValue(String javaType, Object value) {
        boolean isListValue = value instanceof List;
        try {
            switch (javaType) {
                case "String":
                    return isListValue ?
                            ((List<?>) value)
                                    .stream()
                                    .map(String::valueOf)
                                    .collect(Collectors.toList())
                            : Collections.singletonList(value.toString());
                case "Long":
                    return isListValue ?
                            ((List<?>) value)
                                    .stream()
                                    .map(item -> Long.valueOf(String.valueOf(item)))
                                    .collect(Collectors.toList())
                            : Collections.singletonList(Long.valueOf(String.valueOf(value)));
                case "Date":
                    return isListValue ?
                            ((List<?>) value)
                                    .stream()
                                    .map(item -> DateUtil.parse(String.valueOf(item)).toTimestamp())
                                    .collect(Collectors.toList())
                            : Collections.singletonList(DateUtil.parse(String.valueOf(value)).toTimestamp());
                default:
                    throw new RuntimeException(StrUtil.format("查询失败，位置字段类型，类型 = {}，值 = {}", javaType, value));
            }
        } catch (RuntimeException e) {
            throw new RuntimeException(StrUtil.format("数据类型和数据值不匹配 {} === {}", javaType, value), e);
        }

    }

    private static void checkValue(Object value) {
        if (value instanceof List) {
            ((List<?>) value).forEach(item -> {
                if (item != null && ArrayUtil.contains(INVALID_CHARACTERS, item.toString())) {
                    throw new RuntimeException("含有违规值！" + item);
                }
            });
        } else {
            if (ArrayUtil.contains(INVALID_CHARACTERS, value.toString())) {
                throw new RuntimeException("含有违规值！" + value);
            }
        }

    }

    private static void checkValue(Entity entity) {
        for (String key : entity.keySet()) {
            String value = entity.getStr(key);
            if (ArrayUtil.contains(INVALID_CHARACTERS, value)) {
                throw new RuntimeException("含有违规值！" + value);
            }
        }
    }

    /**
     * 获取排序字段
     */
    private static String getOrderBy(List<QueryEntity.Order> columns, Map<String, Entity> columnConfigList) {

        columns = columns.stream().filter(column -> columnConfigList.containsKey(column.getColumnName())).collect(Collectors.toList());
        if (columns.isEmpty()) {
            return null;
        }
        for (int i = 0; i < columns.size(); i++) {
            QueryEntity.Order order = columns.get(i);
            order.setSort(order.getSort() == null ? i : order.getSort());
            if (order.getSortType() != null && !order.getSortType().equals("asc") && !order.getSortType().equals("desc")) {
                throw new RuntimeException(StrUtil.format("非法排序 {} === {}", order.getColumnName(), order.getSortType()));
            }
        }
        return columns.stream()
                .sorted((item1, item2) -> CompareUtil.compare(item1.getSort(), item2.getSort()))
                .map(item -> item.getColumnName() + " " + StrUtil.blankToDefault(item.getSortType(), "asc"))
                .collect(Collectors.joining(","));
    }

    /**
     * 获取总记录数
     */
    private static long getTotalCount(Db db, String tableName, String whereClause, Object[] params) throws SQLException {
        String countSql = StrUtil.format("SELECT COUNT(1) FROM {} WHERE {}", tableName, whereClause);
        return db.queryNumber(countSql, params).longValue();
    }

    @SneakyThrows
    public static int removeData(String tableName, Entity entity) {

        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Map<String, Entity> columnList = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);
        List<String> keys = entity.keySet().stream().filter(columnList::containsKey).collect(Collectors.toList());
        if (keys.isEmpty()) return 0;
        String sql = "delete from {} where {}";
        List<String> whereStr = new ArrayList<>();
        List<Object> deleteValues = new ArrayList<>();

        checkTableName(tableName);
        for (String key : keys) {
            Object value = entity.get(key);
            String javaType = columnList.get(key).getStr("java_type");
            checkValue(value);
            List<Object> queryValue = getQueryValue(javaType, value);
            String collect = queryValue.stream().map(valueStr -> "?").collect(Collectors.joining(","));
            whereStr.add(key + " in (" + collect + ")");
            deleteValues.addAll(queryValue);
        }
        String deleteSql = StrUtil.format(sql, tableName, String.join(" and ", whereStr));
        log.debug("delete sql: {}", deleteSql);
        int removed = db.execute(deleteSql, deleteValues.toArray());
        // 映射表删除后即时重建树/字典缓存
        if (removed > 0 && tableName.startsWith("hy_download_water_mapping_")) {
            new Thread(() -> WaterDownloadCacheUtils.refreshMappingCache(tableName)).start();
        }
        return removed;
    }

    public static long insertOrUpdate(Entity entity) {
        String tableName = entity.getStr("tableName");
        return insertOrUpdate(tableName, ListUtil.toList(entity));
    }

    public static long insertOrUpdate(String tableName, List<Entity> entities) {
        return insertOrUpdate(tableName, entities, false);
    }

    public static long insertOrUpdate(String tableName, List<Entity> entities, boolean checkDic) {
        if (entities == null || entities.isEmpty()) {
            log.error("数据集里面没有数据！");
            return 0;
        }
        checkTableName(tableName);
        if (entities.size() > 1000) {
            final int BATCH_SIZE = 1000;
            long totalAffectedRows = 0;
            for (int i = 0; i < entities.size(); i += BATCH_SIZE) {
                log.info("监测数据量过大，采用分批插入策略 total:{} currentOffset:{}", entities.size(), totalAffectedRows);
                int end = Math.min(i + BATCH_SIZE, entities.size());
                List<Entity> batchEntities = entities.subList(i, end);
                totalAffectedRows += insertOrUpdate(tableName, batchEntities, checkDic);
            }
            return totalAffectedRows;
        }

        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Map<String, Entity> columnList = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);
        Set<String> columns = entities.get(0).keySet();
        List<String> keys = columns.stream().filter(columnList::containsKey).collect(Collectors.toList());

        Map<String, Entity> pkCacheMap = redisCache.getCacheMap(RedisConstants.COLUMN_PK + tableName, Entity.class);
        List<Entity> pkCacheList = new ArrayList<>(pkCacheMap.values());
        List<String> pkStringList = pkCacheList.stream().map(entity -> entity.getStr("column_name")).collect(Collectors.toList());
        List<String> hasPkValue = getHasPkValue(tableName, pkStringList, entities, pkCacheMap);
        List<Entity> insertEntities = new ArrayList<>();
        List<Entity> updateEntities = new ArrayList<>();

        for (Entity entity : entities) {
            List<String> pkList = new ArrayList<>();
            for (String s : pkStringList) {
                pkList.add(entity.getStr(s));
            }
            String indexString = String.join("-", pkList);
            if (hasPkValue.contains(indexString)) {
                updateEntities.add(entity);
            } else {
                insertEntities.add(entity);
            }
        }

        List<Object[]> insertObjects = getObjectValues(tableName, keys, columnList, insertEntities, pkCacheList, false);
        List<Object[]> updateObjects = getObjectValues(tableName, keys, columnList, updateEntities, pkCacheList, true);
        String insertSql = StrUtil.format("insert into {}({}) values ({})",
                tableName,
                String.join(",", keys),
                keys.stream().map(s -> "?").collect(Collectors.joining(","))
        );
        String updateSql = StrUtil.format("update {} set {} = ? where {} = ? ",
                tableName,
                String.join("= ? ,", keys),
                String.join("= ? and ", pkStringList)
        );
        int[] finalSize = {0};
        try {
            // 插入与更新在同一事务内，避免部分成功部分失败
            db.tx(txDb -> {
                if (!insertObjects.isEmpty()) {
                    log.info("batch insert sql: {}", insertSql);
                    log.info("batch insert size ===> {}", insertObjects.size());
                    txDb.executeBatch(insertSql, insertObjects);
                    finalSize[0] += insertObjects.size();
                }
                if (!updateObjects.isEmpty()) {
                    log.info("batch update sql ===> {}", updateSql);
                    log.info("batch update size ===> {}", updateObjects.size());
                    txDb.executeBatch(updateSql, updateObjects);
                    finalSize[0] += updateObjects.size();
                }
            });
            String refreshCache = redisCache.getCacheMapValue(RedisConstants.TABLE_PREFIX + tableName, "refresh_cache");
            if ((checkDic || "1".equals(refreshCache)) && finalSize[0] > 0) {
                String powerIds = SecurityUtils.getPowerIds();
                new Thread(() -> {
                    try {
                        checkDic(tableName);

                        // 只有水温监测系统会用到 暂时这么处理
                        if (tableName.contains("_base_f_station")) {
                            SecurityUtils.refreshFStation(tableName, powerIds);
                        }
                        if (tableName.contains("_base_station")) {
                            SecurityUtils.refreshStation(tableName, powerIds);
                        }
                        if (tableName.contains("_base_power_station")) {
                            SecurityUtils.refreshStation(tableName, powerIds);
                        }
                    } catch (Exception e) {
                        log.error("刷新表 {} 相关缓存失败", tableName, e);
                    }
                }).start();
            }
            // 映射表增改后即时重建树/字典缓存，不依赖 refresh_cache 配置
            if (finalSize[0] > 0 && tableName.startsWith("hy_download_water_mapping_")) {
                new Thread(() -> WaterDownloadCacheUtils.refreshMappingCache(tableName)).start();
            }
            return finalSize[0];
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    private static void checkDic(String tableName) {
        String formatStr = "监测到字典新增数据，刷新字典类型 {} {}";
        try {
            List<Entity> query = db.query("select dict_type from sys_dict_type where dict_entity_json like ?", StrUtil.format("%{}%", tableName));
            if (query == null || query.isEmpty()) {
                return;
            }
            for (Entity entity : query) {
                String dictType = entity.getStr("dict_type");
                CacheUtils.initEntityDicCache(dictType);
            }
            log.info(StrUtil.format(formatStr, tableName, "成功"));
        } catch (SQLException e) {
            log.error(StrUtil.format(formatStr, tableName, "失败"), e);
            throw new RuntimeException(e);
        }
    }

    @SneakyThrows
    private static List<String> getHasPkValue(String tableName, List<String> pkStringList, List<Entity> entities, Map<String, Entity> pkCacheMap) {

        String queryPkSql = "select {} from {} where 1=1 {}";
        Map<String, List<String>> keyMap = new LinkedHashMap<String, List<String>>() {{
            for (String key : pkStringList) {
                put(key, new ArrayList<>());
            }
        }};
        for (String key : pkStringList) {
            for (Entity entity : entities) {
                String value = entity.getStr(key);
                if (StrUtil.isNotBlank(value)) {
                    keyMap.get(key).add(value);
                }
            }
        }
        String pkStrings = String.join(",", pkStringList);
        StringBuilder whereBuilder = new StringBuilder();
        List<Object> pkParams = new ArrayList<>();
        for (String key : keyMap.keySet()) {
            checkTableName(key);
            String javaType = pkCacheMap.get(key).getStr("java_type");
            List<String> stringValues = keyMap.get(key);
            if (stringValues.isEmpty()) {
                continue;
            }
            // 主键值统一参数化绑定，防止拼接引入 SQL 注入
            String placeholders = stringValues.stream().map(v -> "?").collect(Collectors.joining(","));
            whereBuilder.append(" and ").append(key).append(" IN (").append(placeholders).append(") ");
            for (String stringValue : stringValues) {
                switch (javaType) {
                    case "String":
                        pkParams.add(stringValue);
                        break;
                    case "Long":
                        pkParams.add(Long.valueOf(stringValue));
                        break;
                    case "Date":
                        pkParams.add(DateUtil.parse(stringValue).toTimestamp());
                        break;
                    default:
                        throw new RuntimeException(StrUtil.format("未知主键类型，不能保存，表 = {}，字段 = {}", tableName, key));
                }
            }
        }
        if (whereBuilder.length() == 0) {
            return new ArrayList<>();
        }
        String finalQueryPkSql = StrUtil.format(queryPkSql, pkStrings, tableName, whereBuilder.toString());
        log.info("finalQueryPkSql: {}", finalQueryPkSql);
        List<Entity> query = db.query(finalQueryPkSql, pkParams.toArray());
        return query.stream()
                .map(entity -> {
                    List<String> pkList = new ArrayList<>();
                    for (String s : pkStringList) {
                        pkList.add(entity.getStr(s));
                    }
                    return String.join("-", pkList);
                })
                .collect(Collectors.toList());
    }

    private static List<Object[]> getObjectValues(String
                                                          tableName, List<String> keys, Map<String, Entity> columnList, List<Entity> entities, List<Entity> pkCacheList,
                                                  boolean update) {
        List<Object[]> listObjects = new ArrayList<>(entities.size());
        for (Entity entity : entities) {
            List<Object> objects = new ArrayList<>(keys.size());
            for (String tField : keys) {
                String field = tField.toLowerCase();
                Object value = entity.get(field);
                Entity fieldEntity = columnList.get(field);
                if (fieldEntity == null) continue;
                String javaType = fieldEntity.getStr("java_type");
                // 主键处理
                boolean isPk = fieldEntity.getStr("is_pk").equals("1");
                if (value == null && isPk) {
                    switch (javaType) {
                        case "String":
                            objects.add(IdUtil.getSnowflakeNextIdStr());
                            break;
                        case "Long":
                            objects.add(IdUtil.getSnowflakeNextId());
                            break;
                        case "Date":
                            objects.add(DateUtil.date().toTimestamp());
                            break;
                        default:
                            throw new RuntimeException(StrUtil.format("未知主键类型，不能保存，表 = {}，字段 = {}", tableName, field));
                    }
                    continue;
                }
                // 空字段处理
                if (value == null) {
                    switch (field) {
                        case "create_time":
                        case "update_time":
                            objects.add(DateUtil.date().toTimestamp());
                            continue;
                        case "create_by":
                        case "update_by":
                            objects.add(SecurityUtils.getUsername());
                            continue;
                    }
                    objects.add(value);
                    continue;
                }
                // 非空字段处理
                addValueByJavaType(objects, javaType, tableName, field, value);
            }
            if (update) {
                for (Entity pkEntity : pkCacheList) {
                    String pkColumnName = pkEntity.getStr("column_name");
                    String pkJavaType = pkEntity.getStr("java_type");
                    String pkField = pkColumnName.toLowerCase();
                    Object pkValue = entity.get(pkField);
                    addValueByJavaType(objects, pkJavaType, tableName, pkField, pkValue);
                }
            }
            listObjects.add(objects.toArray());
        }

        return listObjects;
    }

    private static void addValueByJavaType(List<Object> objects, String javaType, String tableName, String
            field, Object value) {
        String strValue = value.toString();
        switch (javaType) {
            case "String":
                if (field.equals("update_by")) {
                    objects.add(SecurityUtils.getUsername());
                    break;
                }
                objects.add(strValue);
                break;
            case "Date":
                if (field.equals("update_time")) {
                    objects.add(DateUtil.date().toTimestamp());
                    break;
                }
                try {
                    Date sqlDate = DateUtil.parse(strValue).toTimestamp();
                    objects.add(sqlDate);
                } catch (Exception e) {
                    throw new RuntimeException(StrUtil.format("非法日期类型，表 = {}，字段 = {}，值 = {}", tableName, field, strValue), e);
                }
                break;
            case "Long":
            case "Integer":
            case "Short":
                if (!NumberUtil.isNumber(strValue)) {
                    throw new RuntimeException(StrUtil.format("非法数字类型，表 = {}，字段 = {}，值 = {}", tableName, field, strValue));
                }
                objects.add(Long.parseLong(strValue));
                break;
            case "BigDecimal":
            case "Float":
                if (!NumberUtil.isNumber(strValue)) {
                    throw new RuntimeException(StrUtil.format("非法浮点类型，表 = {}，字段 = {}，值 = {}", tableName, field, strValue));
                }
                objects.add(Double.parseDouble(strValue));
                break;
            case "Boolean":
                objects.add(Boolean.parseBoolean(strValue));
                break;
            default:
                throw new RuntimeException(StrUtil.format("未知字段类型，表 = {}，字段 = {}，值 = {}", tableName, field, strValue));
        }
    }


}
