package com.hydrology.common.utils.gis;

public class ShapeType {

    // 多点
    public static final String MULTI_LINE_STRING = "MultiLineString";
    //多线
    public static final String MULTI_POINT = "MultiPoint";
    //多面
    public static final String MULTI_POLYGON = "MultiPolygon";
    // 84坐标系
    public static final String CRS_84 = "crs84";
    // 压缩包内部名字
    public static final String SHAPE_NAME = "shapefile";
    // 空间对象名称
    public static final String GEOM_NAME = "the_geom";

    public static String getGeometryType(String geometryType) {
        switch (geometryType) {
            case "LineString":
                return MULTI_LINE_STRING;
            case "Point":
                return MULTI_POINT;
            case "Polygon":
                return MULTI_POLYGON;
            default:
                return geometryType;
        }
    }
}
