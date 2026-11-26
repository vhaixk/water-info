package com.hydrology.common.utils;

import cn.hutool.core.convert.Convert;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class CollectionUtils {


    /**
     * 按指定字段分组，返回 LinkedHashMap 保持插入顺序
     */
    public static <T> LinkedHashMap<String, List<T>> getGroupData(List<T> dataByGroup, String fieldName) {
        if (dataByGroup == null) return new LinkedHashMap<>();

        return dataByGroup.stream()
                .collect(Collectors.groupingBy(
                        entity -> {
                            Map<?, ?> finalEntity;
                            if (!(entity instanceof Map)) {
                                finalEntity = Convert.toMap(String.class, Object.class, entity);
                            } else {
                                finalEntity = (Map<?, ?>) entity;
                            }
                            Object value = finalEntity.get(fieldName);
                            return value == null ? "null" : value.toString();
                        },
                        LinkedHashMap::new, // 指定使用 LinkedHashMap
                        Collectors.toList()
                ));
    }

    /**
     * 按指定字段分组，每组取第一个元素，返回 LinkedHashMap
     */
    public static <T> LinkedHashMap<String, T> getGroupDataOne(List<T> dataByGroup, String fieldName) {
        if (dataByGroup == null) return null;

        LinkedHashMap<String, List<T>> groupData = getGroupData(dataByGroup, fieldName);
        return groupData.entrySet()
                .stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue().get(0),
                        (v1, v2) -> v1, // 处理可能的键冲突
                        LinkedHashMap::new // 指定使用 LinkedHashMap
                ));
    }

    /**
     * 提取两个字段生成 Map，返回 LinkedHashMap
     */
    @SuppressWarnings("unchecked")
    public static <T> LinkedHashMap<String, String> getGroupDataString(List<T> dataByGroup, String fieldKey, String fieldValue) {
        if (dataByGroup == null) return new LinkedHashMap<>();

        return dataByGroup.stream()
                .collect(Collectors.toMap(
                        t -> {
                            Map<String, Object> objectMap = (Map<String, Object>) t;
                            Object key = objectMap.get(fieldKey);
                            return key == null ? "null" : key.toString();
                        },
                        t -> {
                            Map<String, Object> objectMap = (Map<String, Object>) t;
                            Object val = objectMap.get(fieldValue);
                            return val == null ? "null" : val.toString();
                        },
                        (v1, v2) -> v1, // 处理可能的键冲突
                        LinkedHashMap::new // 指定使用 LinkedHashMap
                ));
    }

    /**
     * 将 List 转换为以指定字段为 Key 的 LinkedHashMap
     */
    public static <T> LinkedHashMap<String, T> toMap(List<T> genTable, String fieldName) {
        if (genTable == null) return new LinkedHashMap<>();

        return genTable.stream()
                .collect(Collectors.toMap(
                        entity -> {
                            Map<?, ?> finalEntity;
                            if (!(entity instanceof Map)) {
                                finalEntity = Convert.toMap(String.class, Object.class, entity);
                            } else {
                                finalEntity = (Map<?, ?>) entity;
                            }
                            Object value = finalEntity.get(fieldName);
                            return value == null ? "null" : value.toString();
                        },
                        entity -> entity,
                        (v1, v2) -> v1, // 处理可能的键冲突
                        LinkedHashMap::new // 指定使用 LinkedHashMap
                ));
    }
}
