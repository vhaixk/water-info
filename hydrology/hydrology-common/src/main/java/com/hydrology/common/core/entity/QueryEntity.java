package com.hydrology.common.core.entity;

import lombok.Data;
import lombok.experimental.Accessors;

import java.util.LinkedHashMap;
import java.util.Map;

@Data
@Accessors(chain = true)
public class QueryEntity {

    private String tableName;
    private Map<String, Column> columns = new LinkedHashMap<>();
    private Map<String, Order> orders = new LinkedHashMap<>();
    private Long page = 1L;
    private Long pageSize = 20L;
    private Long total;


    public static QueryEntity getOne() {
        return new QueryEntity();
    }

    @Data
    @Accessors(chain = true)
    public static class Column {
        private String columnName;
        private Object columnValue = null;
        private String whereType;
        private String groupId;

        public Column setColumnName(String columnName) {
            this.columnName = columnName.toLowerCase();
            return this;
        }

        public Column setWhereType(String whereType) {
            this.whereType = whereType.toUpperCase();
            return this;
        }

        public static Column getOne() {
            return new Column();
        }

    }

    @Data
    @Accessors(chain = true)
    public static class Order {
        private String columnName;
        private String sortType;
        private Integer sort;

        public Order setSortType(String sortType) {
            this.sortType = sortType == null ? null : sortType.toLowerCase();
            return this;
        }

        public Order setColumnName(String columnName) {
            this.columnName = columnName == null ? null : columnName.toLowerCase();
            return this;

        }

        public static Order getOne() {
            return new Order();
        }
    }


}
