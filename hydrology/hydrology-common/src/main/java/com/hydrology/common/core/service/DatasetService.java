package com.hydrology.common.core.service;

import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.hydrology.common.constant.HttpStatus;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.core.entity.QueryEntity;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.exception.ServiceException;
import com.hydrology.common.utils.db.GetDbUtils;
import com.hydrology.common.utils.db.ResultEntity;
import com.hydrology.common.utils.poi.ExcelExportUtils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * 关联数据集：声明式多表 join 的只读查询/导出，标识符全部白名单校验
 */
@Slf4j
@Service
public class DatasetService {

    public static final String DS_PREFIX = "ds_";
    private static final Pattern IDENTIFIER = Pattern.compile("^[a-zA-Z0-9_]+$");
    private static final Set<String> JOIN_TYPES = new HashSet<>(Arrays.asList("LEFT", "INNER"));
    private static final String[] POWER_COLUMNS = {"station_f_id", "power_station_id"};

    @Autowired
    private RedisCache redisCache;

    public boolean isDataset(String name) {
        return StrUtil.isNotBlank(name) && name.startsWith(DS_PREFIX);
    }

    public Entity getConfig(String name) {
        if (!isDataset(name) || !IDENTIFIER.matcher(name).matches()) {
            throw new ServiceException("非法数据集名", HttpStatus.FORBIDDEN);
        }
        // Redis 序列化为 fastjson2，直存 Entity 会反序列化成 JSONObject，故存 JSON 字符串再解析
        Object cached = redisCache.getCacheObject(RedisConstants.DATASET_PREFIX + name);
        if (cached == null) {
            throw new ServiceException("该数据集未注册，禁止访问", HttpStatus.FORBIDDEN);
        }
        Entity config = Entity.create();
        config.putAll(JSONUtil.parseObj(cached.toString()));
        return config;
    }

    public List<Entity> getColumns(Entity config) {
        List<Entity> cols = new ArrayList<>();
        for (Object o : JSONUtil.parseArray(config.getStr("columns_json"))) {
            Entity e = Entity.create();
            e.putAll((JSONObject) o);
            cols.add(e);
        }
        return cols;
    }

    /**
     * 输出列元数据：复制源列完整配置（保留 is_query/html_type 等前端字段），覆盖为别名视角
     */
    public Map<String, Entity> getColumnData(String name) {
        Entity config = getConfig(name);
        Map<String, Entity> map = new LinkedHashMap<>();
        for (Entity c : getColumns(config)) {
            Map<String, Entity> srcCols = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + c.getStr("source_table"), Entity.class);
            Entity src = srcCols == null ? null : srcCols.get(c.getStr("source_column"));
            if (src == null) {
                throw new ServiceException("数据集列配置失效：" + c.getStr("source_table") + "." + c.getStr("source_column"), HttpStatus.FORBIDDEN);
            }
            Entity v = Entity.create();
            v.putAll(src);
            v.set("column_name", c.getStr("alias"));
            v.set("column_comment", StrUtil.blankToDefault(c.getStr("column_comment"), src.getStr("column_comment")));
            v.set("dict_type", c.getStr("dict_type"));
            v.set("is_list", c.getStr("is_list"));
            v.set("is_show", c.getStr("is_show"));
            v.set("sort", c.getInt("sort"));
            map.put(c.getStr("alias"), v);
        }
        return map;
    }

    /**
     * 组装内层 join SQL；所有标识符在此再次校验（保存时已校验，双保险）
     */
    public String buildInnerSql(Entity config) {
        String mainTable = config.getStr("main_table");
        checkIdentifier(mainTable);
        Map<String, String> aliasMap = new LinkedHashMap<>();
        aliasMap.put(mainTable, "t0");
        List<JSONObject> joins = new ArrayList<>();
        for (Object o : JSONUtil.parseArray(StrUtil.blankToDefault(config.getStr("join_config"), "[]"))) {
            joins.add((JSONObject) o);
        }
        joins.sort(Comparator.comparingInt(j -> j.getInt("sort", 0)));
        StringBuilder from = new StringBuilder(mainTable).append(" t0");
        for (int i = 0; i < joins.size(); i++) {
            JSONObject j = joins.get(i);
            String table = j.getStr("table");
            String joinType = j.getStr("joinType", "LEFT").toUpperCase();
            checkIdentifier(table);
            if (!JOIN_TYPES.contains(joinType)) {
                throw new ServiceException("非法关联类型：" + joinType, HttpStatus.FORBIDDEN);
            }
            String alias = "t" + (i + 1);
            JSONArray on = j.getJSONArray("on");
            if (on == null || on.isEmpty()) {
                throw new ServiceException("关联条件不能为空：" + table, HttpStatus.FORBIDDEN);
            }
            List<String> onParts = new ArrayList<>();
            for (Object oo : on) {
                JSONObject cond = (JSONObject) oo;
                String leftTable = cond.getStr("leftTable");
                String leftCol = cond.getStr("leftCol");
                String rightCol = cond.getStr("rightCol");
                checkIdentifier(leftCol);
                checkIdentifier(rightCol);
                String leftAlias = aliasMap.get(leftTable);
                if (leftAlias == null) {
                    throw new ServiceException("关联左侧表必须为主表或前序关联表：" + leftTable, HttpStatus.FORBIDDEN);
                }
                onParts.add(leftAlias + "." + leftCol + " = " + alias + "." + rightCol);
            }
            from.append(" ").append(joinType).append(" join ").append(table).append(" ").append(alias)
                    .append(" on ").append(String.join(" and ", onParts));
            aliasMap.put(table, alias);
        }
        List<Entity> cols = getColumns(config);
        if (cols.isEmpty()) {
            throw new ServiceException("数据集输出列不能为空", HttpStatus.FORBIDDEN);
        }
        List<String> selectParts = new ArrayList<>();
        for (Entity c : cols) {
            String tAlias = aliasMap.get(c.getStr("source_table"));
            String col = c.getStr("source_column");
            String outAlias = c.getStr("alias");
            checkIdentifier(col);
            checkIdentifier(outAlias);
            if (tAlias == null) {
                throw new ServiceException("输出列来源表不在数据集中：" + c.getStr("source_table"), HttpStatus.FORBIDDEN);
            }
            selectParts.add(tAlias + "." + col + " as " + outAlias);
        }
        return "select " + String.join(", ", selectParts) + " from " + from;
    }

    private static void checkIdentifier(String s) {
        if (StrUtil.isBlank(s) || !IDENTIFIER.matcher(s).matches()) {
            throw new ServiceException("非法标识符：" + s, HttpStatus.FORBIDDEN);
        }
    }

    /**
     * 派生表包装：输出别名成为真实列，where/排序/分页全部复用单表逻辑
     */
    @SneakyThrows
    public ResultEntity query(QueryEntity q) {
        Entity config = getConfig(q.getTableName());
        GetDbUtils.checkPower(q, config.getStr("main_table"));
        Map<String, Entity> virtualCols = getColumnData(q.getTableName());
        long page = q.getPage() == null || q.getPage() < 1 ? 1L : q.getPage();
        long pageSize = q.getPageSize() == null || q.getPageSize() < 1 ? 20L : Math.min(q.getPageSize(), GetDbUtils.MAX_PAGE_SIZE);
        q.setPage(page).setPageSize(pageSize);

        List<Object> params = new ArrayList<>();
        List<String> whereFields = new ArrayList<>();
        GetDbUtils.getWhereConditions(ListUtil.toList(q.getColumns().values()), virtualCols, whereFields, params);
        String orderBy = GetDbUtils.getOrderBy(ListUtil.toList(q.getOrders().values()), virtualCols);
        String whereClause = String.join(" AND ", whereFields);
        String innerSql = buildInnerSql(config);
        Db db = GetDbUtils.getDb();
        long total = db.queryNumber("select count(1) from (" + innerSql + ") ds where " + whereClause, params.toArray()).longValue();
        String querySql = "select * from (" + innerSql + ") ds where " + whereClause
                + (orderBy == null ? "" : " order by " + orderBy) + " limit ? offset ?";
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        log.info("datasetQuery:{}", querySql);
        List<Entity> rows = db.query(querySql, params.toArray());
        return ResultEntity.getInstance().setDataList(rows).setPage(page).setPageSize(pageSize)
                .setTotal(total).setTotalPage((total + pageSize - 1) / pageSize);
    }

    public String export(String name, String exportName, QueryEntity q) {
        getConfig(name);
        if (q == null) {
            q = new QueryEntity();
        }
        q.setTableName(name);
        q.setPage(1L).setPageSize(1L);
        long total = query(q).getTotal();
        if (total > CurdService.EXPORT_MAX_ROWS) {
            throw new ServiceException(StrUtil.format("导出数据量 {} 超过 {} 行上限，请缩小查询范围后重试", total, CurdService.EXPORT_MAX_ROWS));
        }
        q.setPageSize(Math.max(total, 1L));
        List<Entity> rows = query(q).getDataList();
        return ExcelExportUtils.writeExcel(rows, getColumnData(name), exportName);
    }

    @SneakyThrows
    public List<Entity> listDataset(String datasetName, String datasetComment) {
        StringBuilder sql = new StringBuilder("select * from gen_dataset where 1=1");
        List<Object> params = new ArrayList<>();
        if (StrUtil.isNotBlank(datasetName)) {
            sql.append(" and dataset_name like concat('%',?,'%')");
            params.add(datasetName);
        }
        if (StrUtil.isNotBlank(datasetComment)) {
            sql.append(" and dataset_comment like concat('%',?,'%')");
            params.add(datasetComment);
        }
        sql.append(" order by dataset_id desc");
        return GetDbUtils.getDb().query(sql.toString(), params.toArray());
    }

    @SneakyThrows
    public Entity getDataset(Long id) {
        return GetDbUtils.getDb().queryOne("select * from gen_dataset where dataset_id = ?", id);
    }

    @SneakyThrows
    public List<Entity> getDatasetColumns(Long id) {
        return GetDbUtils.getDb().query("select * from gen_dataset_column where dataset_id = ? order by sort", id);
    }

    /**
     * 保存前全量白名单校验；hy_ 主表强制纳入隐藏权限列
     */
    public void validate(Entity ds, List<Entity> cols) {
        String name = ds.getStr("dataset_name");
        if (StrUtil.isBlank(name) || !name.matches("^ds_[a-zA-Z0-9_]+$")) {
            throw new ServiceException("数据集名须为 ds_ 前缀 + 字母数字下划线");
        }
        String mainTable = ds.getStr("main_table");
        Map<String, Entity> mainCols = requireRegistered(mainTable);
        Map<String, Map<String, Entity>> tableCols = new LinkedHashMap<>();
        tableCols.put(mainTable, mainCols);
        for (Object o : JSONUtil.parseArray(StrUtil.blankToDefault(ds.getStr("join_config"), "[]"))) {
            JSONObject j = (JSONObject) o;
            String table = j.getStr("table");
            if (tableCols.containsKey(table)) {
                throw new ServiceException("关联表重复：" + table);
            }
            tableCols.put(table, requireRegistered(table));
            // 关联条件两侧列必须存在于对应表的白名单列缓存
            JSONArray on = j.getJSONArray("on");
            if (on != null) {
                for (Object oo : on) {
                    JSONObject cond = (JSONObject) oo;
                    Map<String, Entity> leftCols = tableCols.get(cond.getStr("leftTable"));
                    if (leftCols == null || !leftCols.containsKey(cond.getStr("leftCol"))) {
                        throw new ServiceException("关联左侧列不存在：" + cond.getStr("leftTable") + "." + cond.getStr("leftCol"));
                    }
                    if (!tableCols.get(table).containsKey(cond.getStr("rightCol"))) {
                        throw new ServiceException("关联右侧列不存在：" + table + "." + cond.getStr("rightCol"));
                    }
                }
            }
        }
        // 触发一次完整组装校验（标识符/joinType/on 左侧表顺序）
        Entity tmp = Entity.create().set("main_table", mainTable)
                .set("join_config", ds.getStr("join_config"))
                .set("columns_json", JSONUtil.toJsonStr(cols));
        buildInnerSql(tmp);
        Set<String> aliases = new HashSet<>();
        for (Entity c : cols) {
            Map<String, Entity> src = tableCols.get(c.getStr("source_table"));
            if (src == null || !src.containsKey(c.getStr("source_column"))) {
                throw new ServiceException("输出列不存在：" + c.getStr("source_table") + "." + c.getStr("source_column"));
            }
            if (!aliases.add(c.getStr("alias"))) {
                throw new ServiceException("输出列别名重复：" + c.getStr("alias"));
            }
        }
        if (StrUtil.containsIgnoreCase(mainTable, "hy_")) {
            for (String pc : POWER_COLUMNS) {
                // 与单表语义一致：仅纳入主表实际存在的权限列，checkPower 注入的多余条件会被列白名单过滤
                if (!mainCols.containsKey(pc)) {
                    continue;
                }
                boolean exists = cols.stream().anyMatch(c -> pc.equals(c.getStr("alias")));
                if (!exists) {
                    cols.add(Entity.create().set("source_table", mainTable).set("source_column", pc)
                            .set("alias", pc).set("column_comment", pc).set("dict_type", "")
                            .set("is_show", "0").set("is_list", "0").set("sort", 999));
                }
            }
        }
    }

    private Map<String, Entity> requireRegistered(String table) {
        if (StrUtil.isBlank(table) || isDataset(table)) {
            throw new ServiceException("非法主表/关联表：" + table);
        }
        Map<String, Entity> cols = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + table, Entity.class);
        if (cols == null || cols.isEmpty()) {
            throw new ServiceException("表未注册：" + table);
        }
        return cols;
    }

    /**
     * 新增或按 dataset_id 更新；事务内重写输出列，成功后刷缓存
     */
    @SneakyThrows
    public void saveDataset(Entity ds, List<Entity> cols) {
        validate(ds, cols);
        Db db = GetDbUtils.getDb();
        Long id = ds.getLong("dataset_id");
        Entity exist = db.queryOne("select dataset_id from gen_dataset where dataset_name = ?", ds.getStr("dataset_name"));
        if (exist != null && !exist.getLong("dataset_id").equals(id)) {
            throw new ServiceException("数据集名已存在：" + ds.getStr("dataset_name"));
        }
        db.tx(txDb -> {
            if (id == null) {
                txDb.insert(Entity.create("gen_dataset")
                        .set("dataset_name", ds.getStr("dataset_name"))
                        .set("dataset_comment", ds.getStr("dataset_comment"))
                        .set("main_table", ds.getStr("main_table"))
                        .set("join_config", ds.getStr("join_config"))
                        .set("create_time", new Date()));
                Entity saved = txDb.queryOne("select dataset_id from gen_dataset where dataset_name = ?", ds.getStr("dataset_name"));
                ds.set("dataset_id", saved.getLong("dataset_id"));
            } else {
                txDb.update(Entity.create("gen_dataset")
                                .set("dataset_comment", ds.getStr("dataset_comment"))
                                .set("main_table", ds.getStr("main_table"))
                                .set("join_config", ds.getStr("join_config"))
                                .set("update_time", new Date()),
                        Entity.create("gen_dataset").set("dataset_id", id));
                txDb.del(Entity.create("gen_dataset_column").set("dataset_id", id));
            }
            for (Entity c : cols) {
                Integer sort = c.getInt("sort");
                txDb.insert(Entity.create("gen_dataset_column")
                        .set("dataset_id", ds.getLong("dataset_id"))
                        .set("source_table", c.getStr("source_table"))
                        .set("source_column", c.getStr("source_column"))
                        .set("alias", c.getStr("alias"))
                        .set("column_comment", c.getStr("column_comment"))
                        .set("dict_type", StrUtil.blankToDefault(c.getStr("dict_type"), ""))
                        .set("is_show", StrUtil.blankToDefault(c.getStr("is_show"), "1"))
                        .set("is_list", StrUtil.blankToDefault(c.getStr("is_list"), "1"))
                        .set("sort", sort == null ? 0 : sort));
            }
        });
        reloadCache(ds.getStr("dataset_name"));
    }

    @SneakyThrows
    public void deleteDataset(Long[] ids) {
        Db db = GetDbUtils.getDb();
        List<String> names = new ArrayList<>();
        for (Long id : ids) {
            Entity ds = getDataset(id);
            if (ds != null) {
                names.add(ds.getStr("dataset_name"));
            }
            db.del(Entity.create("gen_dataset_column").set("dataset_id", id));
            db.del(Entity.create("gen_dataset").set("dataset_id", id));
        }
        names.forEach(this::removeCache);
    }

    /**
     * 刷新单个数据集缓存（common 侧实现，generator 的 GenTableCacheService 委托本方法）
     */
    @SneakyThrows
    public void reloadCache(String name) {
        Db db = GetDbUtils.getDb();
        Entity ds = db.queryOne("select * from gen_dataset where dataset_name = ?", name);
        if (ds == null) {
            removeCache(name);
            return;
        }
        List<Entity> cols = db.query("select * from gen_dataset_column where dataset_id = ? order by sort", ds.getLong("dataset_id"));
        ds.set("columns_json", JSONUtil.toJsonStr(cols));
        redisCache.setCacheObject(RedisConstants.DATASET_PREFIX + name, JSONUtil.toJsonStr(ds));
    }

    public void removeCache(String name) {
        redisCache.deleteObject(RedisConstants.DATASET_PREFIX + name);
    }
}