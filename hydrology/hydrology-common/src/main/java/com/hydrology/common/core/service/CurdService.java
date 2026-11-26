package com.hydrology.common.core.service;

import cn.hutool.core.comparator.CompareUtil;
import cn.hutool.core.date.DateUtil;
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
import org.apache.poi.ss.usermodel.Sheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CurdService {


    @Autowired
    private RedisCache redisCache;

    private static final Set<String> RESTRICTED_TABLES = new HashSet<String>() {{
        add("sys_");
        add("qrtz_");
        add("gen_");
    }};

    /**
     * 检查表访问权限：受限表仅 admin 可查
     */
    private void checkTablePermission(String tableName) {
        if (StrUtil.isBlank(tableName)) {
            return;
        }
        for (String restricted : RESTRICTED_TABLES) {
            if (tableName.startsWith(restricted)) {
                if (!SecurityUtils.isAdmin()) {
                    throw new ServiceException("您无权查看该表数据", HttpStatus.FORBIDDEN);
                }
                return;
            }
        }
    }

    public Map<String, Entity> getColumnData(String tableName) {
        Map<String, Entity> columnList = this.redisCache.getCacheMap(RedisConstants.COLUMN_PREFIX + tableName, Entity.class);
        return columnList;
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
        return GetDbUtils.insertOrUpdate(queryOne);
    }

    public int delete(String tableName, Entity entity) {
        return GetDbUtils.removeData(tableName, entity);

    }

    public String export(String tableName, String exportName, QueryEntity queryEntity) {
        checkTablePermission(tableName);
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
//        queryEntity.setPage(null).setPageSize(null);
        ResultEntity resultEntity = GetDbUtils.queryDataByEntity(queryEntity);
        List<Entity> dataList = resultEntity.getDataList();
        String filePath = StrUtil.format(
                "/profile/export/hydrology/{}/{}.xlsx",
                DateUtil.today().replace("-", "/"),
                StrUtil.blankToDefault(exportName, String.valueOf(System.currentTimeMillis()))
        );
        String realPath = SystemConfig.getRealPath(filePath);
        ExcelWriter writer = ExcelUtil.getWriter(realPath).setOnlyAlias(true);

        for (String columnName : dictMap.keySet()) {
            Map<String, String> dicMapData = dictMap.get(columnName);
            for (Entity entity : dataList) {
                entity.set(columnName, dicMapData.get(entity.getStr(columnName)));
            }
        }

        for (int i = 0; i < sortKeys.size(); i++) {
            String sortKey = sortKeys.get(i);
            writer.addHeaderAlias(sortKey, columnData.get(sortKey).getStr("column_comment"));
            Sheet sheet = writer.getSheet();
            sheet.autoSizeColumn(i);
            int currentWidth = sheet.getColumnWidth(i);
            sheet.setColumnWidth(i, currentWidth + 512);
        }
        writer.write(dataList);

        writer.close();
        return filePath;
    }
}
