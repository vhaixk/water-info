package com.hydrology.common.core.service;

import cn.hutool.core.comparator.CompareUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Entity;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.constant.HttpStatus;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.core.domain.entity.SysDictData;
import com.hydrology.common.core.entity.QueryEntity;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.exception.ServiceException;
import com.hydrology.common.utils.DictUtils;
import com.hydrology.common.utils.SecurityUtils;
import com.hydrology.common.utils.db.GetDbUtils;
import com.hydrology.common.utils.db.ResultEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Slf4j
@Service
public class CurdService {

    /** 单次导出行数上限 */
    public static final long EXPORT_MAX_ROWS = 200_000L;

    /** 导出文件保留天数 */
    private static final long EXPORT_RETAIN_DAYS = 7;

    @Autowired
    private RedisCache redisCache;

    private static final Set<String> RESTRICTED_TABLES = new HashSet<String>() {{
        add("sys_");
        add("qrtz_");
        add("gen_");
    }};

    /**
     * 检查表访问权限：表名必须合法且已在列配置缓存中注册（白名单），受限表仅 admin 可操作
     */
    private void checkTablePermission(String tableName) {
        if (StrUtil.isBlank(tableName) || !tableName.matches("[a-zA-Z0-9_]+")) {
            throw new ServiceException("非法表名", HttpStatus.FORBIDDEN);
        }
        Map<String, Entity> columnConfig = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);
        if (columnConfig == null || columnConfig.isEmpty()) {
            throw new ServiceException("该表未注册，禁止访问", HttpStatus.FORBIDDEN);
        }
        for (String restricted : RESTRICTED_TABLES) {
            if (tableName.startsWith(restricted) && !SecurityUtils.isAdmin()) {
                throw new ServiceException("您无权操作该表数据", HttpStatus.FORBIDDEN);
            }
        }
    }

    public Map<String, Entity> getColumnData(String tableName) {
        checkTablePermission(tableName);
        return this.redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);
    }

    public ResultEntity getTableData(QueryEntity queryEntity) {
        checkTablePermission(queryEntity.getTableName());

        return GetDbUtils.queryDataByEntity(queryEntity);
    }

    public Entity getTableDataOne(QueryEntity queryEntity) {
        checkTablePermission(queryEntity.getTableName());

        return GetDbUtils.queryOneDataByEntity(queryEntity);
    }

    public long insertOrUpdate(Entity queryOne) {
        String tableName = queryOne.getStr("tableName");
        checkTablePermission(tableName);
        checkRowWritePermission(tableName, queryOne);
        return GetDbUtils.insertOrUpdate(queryOne);
    }

    public int delete(String tableName, Entity entity) {
        checkTablePermission(tableName);
        entity.remove("tableName");
        // 行级数据权限：将允许访问的站点范围注入删除条件，防止越权删除他人站点数据
        Map<String, List<String>> rowScope = getRowScope(tableName);
        if (rowScope != null) {
            for (Map.Entry<String, List<String>> entry : rowScope.entrySet()) {
                List<String> allowed = entry.getValue();
                if (allowed.isEmpty()) {
                    return 0;
                }
                Object value = entity.get(entry.getKey());
                if (value == null || StrUtil.isBlank(value.toString())) {
                    entity.set(entry.getKey(), allowed);
                } else {
                    List<String> requested = toStringList(value);
                    List<String> intersection = requested.stream().filter(allowed::contains).collect(Collectors.toList());
                    if (intersection.isEmpty()) {
                        return 0;
                    }
                    entity.set(entry.getKey(), intersection);
                }
            }
        }
        return GetDbUtils.removeData(tableName, entity);
    }

    public String export(String tableName, String exportName, QueryEntity queryEntity) {
        checkTablePermission(tableName);
        if (queryEntity == null) {
            queryEntity = new QueryEntity();
        }
        // 以路径表名为准，分页由服务端控制，防止前端传入任意 pageSize 拉取全表
        queryEntity.setTableName(tableName);
        queryEntity.setPage(1L).setPageSize(1L);
        long total = GetDbUtils.queryDataByEntity(queryEntity).getTotal();
        if (total > EXPORT_MAX_ROWS) {
            throw new ServiceException(StrUtil.format("导出数据量 {} 超过 {} 行上限，请缩小查询范围后重试", total, EXPORT_MAX_ROWS));
        }

        Map<String, Entity> columnData = redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);
        Map<String, Map<String, String>> dictMap = new HashMap<>();

        List<String> sortKeys = columnData.keySet()
                .stream()
                .filter(columnName -> {
                    Entity columnEntity = columnData.get(columnName);
                    String isList = columnEntity.getStr("is_list");
                    String dictType = columnEntity.getStr("dict_type");
                    if (StrUtil.isNotBlank(dictType)) {
                        List<SysDictData> dictList = DictUtils.getDictCache(dictType);
                        Map<String, String> dictDataMap = dictList
                                .stream()
                                .collect(Collectors.toMap(SysDictData::getDictValue, SysDictData::getDictLabel));
                        dictMap.put(columnName, dictDataMap);
                    }
                    return StrUtil.isNotBlank(isList) && "1".equals(isList);
                })
                .sorted((c1, c2) -> CompareUtil.compare(columnData.get(c1).getInt("sort"), columnData.get(c2).getInt("sort")))
                .collect(Collectors.toList());

        queryEntity.setPageSize(Math.max(total, 1L));
        ResultEntity resultEntity = GetDbUtils.queryDataByEntity(queryEntity);
        List<Entity> dataList = resultEntity.getDataList();

        String filePath = StrUtil.format(
                "/profile/export/hydrology/{}/{}_{}.xlsx",
                DateUtil.today().replace("-", "/"),
                sanitizeExportName(exportName),
                IdUtil.fastSimpleUUID()
        );
        String realPath = SystemConfig.getRealPath(filePath);

        // 字典翻译：字典项缺失时保留原值，避免导出出现空列
        for (Map.Entry<String, Map<String, String>> entry : dictMap.entrySet()) {
            String columnName = entry.getKey();
            Map<String, String> dicMapData = entry.getValue();
            for (Entity entity : dataList) {
                String rawValue = entity.getStr(columnName);
                entity.set(columnName, dicMapData.getOrDefault(rawValue, rawValue));
            }
        }

        // 流式写出，避免大数据量导出 OOM
        try (ExcelWriter writer = ExcelUtil.getBigWriter(realPath)) {
            writer.setOnlyAlias(true);
            for (int i = 0; i < sortKeys.size(); i++) {
                String sortKey = sortKeys.get(i);
                writer.addHeaderAlias(sortKey, columnData.get(sortKey).getStr("column_comment"));
                writer.setColumnWidth(i, 22);
            }
            writer.write(dataList);
        }
        cleanExpiredExportFiles();
        return filePath;
    }

    /**
     * 获取当前用户在指定表上的行级数据权限范围；无权限上下文（管理员/内部任务）返回 null 表示不限制
     */
    private Map<String, List<String>> getRowScope(String tableName) {
        if (!StrUtil.containsIgnoreCase(tableName, "hy_")) {
            return null;
        }
        String powerIds = SecurityUtils.getPowerIds();
        if (StrUtil.isBlank(powerIds)) {
            return null;
        }
        String systemId = SecurityUtils.getSystemId();
        if (StrUtil.isBlank(systemId)) {
            return null;
        }
        Map<String, List<String>> scope = new LinkedHashMap<>();
        scope.put("station_f_id", new ArrayList<>(SecurityUtils.getFStations().keySet()));
        scope.put("power_station_id", Arrays.asList(powerIds.split(",")));
        return scope;
    }

    /**
     * 写操作行级权限校验：站点字段必须在授权范围内；按主键更新时目标行必须对当前用户可见
     */
    private void checkRowWritePermission(String tableName, Entity entity) {
        Map<String, List<String>> rowScope = getRowScope(tableName);
        if (rowScope == null) {
            return;
        }
        for (Map.Entry<String, List<String>> entry : rowScope.entrySet()) {
            Object value = entity.get(entry.getKey());
            if (value == null || StrUtil.isBlank(value.toString())) {
                continue;
            }
            List<String> requested = toStringList(value);
            if (!entry.getValue().containsAll(requested)) {
                throw new ServiceException("您无权操作该站点数据", HttpStatus.FORBIDDEN);
            }
        }
        // 按主键更新时，校验目标行在数据权限范围内可见，防止凭主键越权修改他人站点数据
        Map<String, Entity> pkCacheMap = redisCache.getCacheMap(RedisConstants.COLUMN_PK + tableName, Entity.class);
        if (pkCacheMap.isEmpty()) {
            return;
        }
        List<String> pkNames = pkCacheMap.values().stream()
                .map(pk -> pk.getStr("column_name"))
                .collect(Collectors.toList());
        boolean hasAllPk = pkNames.stream().allMatch(pk -> StrUtil.isNotBlank(entity.getStr(pk)));
        if (!hasAllPk) {
            return;
        }
        QueryEntity queryEntity = new QueryEntity().setTableName(tableName).setPage(1L).setPageSize(1L);
        for (String pk : pkNames) {
            queryEntity.getColumns().put(pk, QueryEntity.Column.getOne()
                    .setColumnName(pk)
                    .setWhereType("EQ")
                    .setGroupId(pk)
                    .setColumnValue(entity.get(pk)));
        }
        if (GetDbUtils.queryDataByEntity(queryEntity).getTotal() == 0) {
            throw new ServiceException("您无权操作该数据", HttpStatus.FORBIDDEN);
        }
    }

    private static List<String> toStringList(Object value) {
        if (value instanceof List) {
            return ((List<?>) value).stream().map(String::valueOf).collect(Collectors.toList());
        }
        return Collections.singletonList(String.valueOf(value));
    }

    /**
     * 消毒导出文件名：去除路径分隔符、通配符与点号，防止路径穿越
     */
    private static String sanitizeExportName(String exportName) {
        String name = StrUtil.blankToDefault(exportName, "export");
        name = name.replaceAll("[\\\\/:*?\"<>|.\\s]", "");
        if (name.length() > 100) {
            name = name.substring(0, 100);
        }
        return StrUtil.blankToDefault(name, "export");
    }

    /**
     * 异步清理过期的导出文件，避免导出目录无限增长
     */
    private void cleanExpiredExportFiles() {
        CompletableFuture.runAsync(() -> {
            try {
                File exportRoot = new File(SystemConfig.getProfile(), "export/hydrology");
                if (!exportRoot.exists()) {
                    return;
                }
                long expireBefore = System.currentTimeMillis() - EXPORT_RETAIN_DAYS * 24 * 3600 * 1000L;
                for (File file : FileUtil.loopFiles(exportRoot)) {
                    if (file.lastModified() < expireBefore) {
                        FileUtil.del(file);
                    }
                }
            } catch (Exception e) {
                log.warn("清理过期导出文件失败", e);
            }
        });
    }
}