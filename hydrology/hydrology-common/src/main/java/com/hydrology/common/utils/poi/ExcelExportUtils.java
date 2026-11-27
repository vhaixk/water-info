package com.hydrology.common.utils.poi;

import cn.hutool.core.comparator.CompareUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Entity;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.core.domain.entity.SysDictData;
import com.hydrology.common.utils.DictUtils;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

/**
 * 通用 Excel 导出：字典翻译 + 流式写出 + 文件名消毒 + 过期清理（单表 curd 与关联数据集共用）
 */
@Slf4j
public class ExcelExportUtils {

    /** 导出文件保留天数 */
    private static final long EXPORT_RETAIN_DAYS = 7;

    public static String writeExcel(List<Entity> dataList, Map<String, Entity> columnData, String exportName) {
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
    private static void cleanExpiredExportFiles() {
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