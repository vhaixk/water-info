package com.hydrology.common.utils.gis;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.hydrology.common.utils.gis.entity.GeometryEntity;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.geotools.geojson.geom.GeometryJSON;
import org.geotools.geometry.jts.JTS;
import org.geotools.referencing.CRS;
import org.locationtech.jts.algorithm.ConvexHull;
import org.locationtech.jts.geom.*;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKTReader;
import org.locationtech.jts.io.WKTWriter;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CRSAuthorityFactory;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


@Slf4j
public class GeometryUtils {
    private static final GeometryFactory GF = new GeometryFactory();
    private static final String LINE_STRING = "linestring";
    private static final String POINT = "point";
    private static final String POLYGON = "polygon";

    public static Geometry getGeometryValue(Object value) {
        if (value instanceof String) {
            if (((String) value).contains("(")) {
                return wkt2Geometry((String) value);
            }
            if (((String) value).contains("[")) {
                return geojson2Geometry((String) value);
            }
        }
        if (value instanceof Geometry) {
            return (Geometry) value;
        }
        throw new RuntimeException("没有匹配的geometry类型");
    }

    public static Geometry geojson2Geometry(String geojson) {
        GeometryJSON geometryJson = new GeometryJSON(20);
        JSONObject geometry = JSONUtil.parseObj(geojson, false);
        try {
            String geometryType = geometry.getStr("type");
            if ("MultiPolygon".equalsIgnoreCase(geometryType)) {
                return geometryJson.readMultiPolygon(new StringReader(geojson));
            } else if ("Polygon".equalsIgnoreCase(geometryType)) {
                return geometryJson.readPolygon(new StringReader(geojson));
            } else if ("MultiLineString".equalsIgnoreCase(geometryType)) {
                return geometryJson.readMultiLine(new StringReader(geojson));
            } else if ("LineString".equalsIgnoreCase(geometryType)) {
                return geometryJson.readLine(new StringReader(geojson));
            } else if ("MultiPoint".equalsIgnoreCase(geometryType)) {
                return geometryJson.readMultiPoint(new StringReader(geojson));
            } else if ("Point".equalsIgnoreCase(geometryType)) {
                return geometryJson.readPoint(new StringReader(geojson));
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        throw new RuntimeException("没有匹配的geometry类型");
    }

    public static String geometry2GeoJson(Geometry geometry) {
        JSONObject set = new JSONObject()
                .set("type", geometry.getGeometryType())
                .set("coordinates",
                        Arrays.stream(geometry.getCoordinates())
                                .map(item -> new Double[]{item.getX(), item.getY(), Double.isNaN(item.getZ()) ? 0D : item.getZ()})
                                .collect(Collectors.toList())
                );
        return JSONUtil.toJsonStr(set);
    }

    public static String geometry2Wkt(Geometry mpolygon) {
        String WKT = null;
        StringWriter writer = new StringWriter();
        try {
            WKTWriter g = new WKTWriter();
            g.write(mpolygon, writer);
            WKT = writer.toString();
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return null;
        }
        return WKT;
    }

    public static Geometry wkt2Geometry(String value) {
        WKTReader wktreader = new WKTReader();
        Geometry read = null;
        try {
            read = wktreader.read(value);
        } catch (ParseException e) {
            log.error(e.getMessage(), e);
        }
        return read;
    }


    public static String getGeometryType(Object geometry) {
        if (geometry instanceof String) {
            String type = (String) geometry;
            String lowerCase = type.toLowerCase();
            if (lowerCase.contains("multilinestring") || lowerCase.contains("linestring") || lowerCase.contains("line")) {
                return LINE_STRING;
            }
            if (lowerCase.contains("multipoint") || lowerCase.contains("point")) {
                return POINT;
            }
            if (lowerCase.contains("multipolygon") || lowerCase.contains("polygon")) {
                return POLYGON;
            }

        }
        if (geometry instanceof Polygon) {
            return POLYGON;
        }
        if (geometry instanceof LineString) {
            return LINE_STRING;
        }
        if (geometry instanceof Point) {
            return POINT;
        }
        if (geometry instanceof Geometry) {
            Geometry geometryValue = getGeometryValue(geometry);
            return getGeometryType(geometryValue.getGeometryType());
        }

        return geometry.toString();
    }

    public static Class<?> getGeometryClass(String type) {
        switch (type) {
            case LINE_STRING:
                return MultiLineString.class;
            case POINT:
                return MultiPoint.class;
            case POLYGON:
                return MultiPolygon.class;
            default:
                throw new RuntimeException("空间对象类型不能为空！");
        }
    }

    @SneakyThrows
    public static void toWgs84(List<Coordinate> coordinates, String crsFrom, String crsTo) {
        MathTransform mathTransform = getMathTransform(crsFrom, crsTo);
        WKTReader wktReader = new WKTReader();

        for (Coordinate coordinate : coordinates) {
            Double c_x = coordinate.getX();
            Double c_y = coordinate.getY();
            String oldWKT = StrUtil.format("POINT ({} {})", c_x, c_y);
            Geometry oldGeometry = wktReader.read(oldWKT);
            Geometry transform = JTS.transform(oldGeometry, mathTransform);
            coordinate.setX(transform.getCentroid().getX());
            coordinate.setY(transform.getCentroid().getY());
        }
    }

    public static MathTransform getMathTransform(String crsFrom, String crsTo) throws FactoryException {

        CRSAuthorityFactory crsAuthorityFactory = CRS.getAuthorityFactory(true);
        CoordinateReferenceSystem fromFactory = crsAuthorityFactory.createCoordinateReferenceSystem("EPSG:" + crsFrom);
        CoordinateReferenceSystem toFactory = crsAuthorityFactory.createCoordinateReferenceSystem("EPSG:" + crsTo);
        return CRS.findMathTransform(fromFactory, toFactory, true);
    }


    /**
     * 计算包围所有点的 Polygon GeoJSON geometry
     *
     * @param useConvexHull true → 凸包（最边缘点），false → 轴对齐包围盒（矩形）
     * @return JSONObject { "type": "Polygon", "coordinates": [...] }，若点不足返回 null
     */
    public static Geometry createBoundingPolygon(List<Coordinate> coordinates, boolean useConvexHull) {
        if (coordinates == null || coordinates.isEmpty()) {
            return null;
        }

        Coordinate[] coordsArray = coordinates.toArray(new Coordinate[0]);
        printCoordinatesStats(coordinates);
        Polygon polygon;
        if (useConvexHull) {
            polygon = createConvexHullPolygon(coordsArray);
        } else {
            polygon = createEnvelopePolygon(coordsArray, coordinates);
        }

        if (polygon == null || polygon.isEmpty()) {
            return null;
        }

        // 2. 转成 GeoJSON coordinates
        JSONArray geoJsonCoords = polygonToGeoJsonCoordinates(polygon);

        JSONObject geometry = new JSONObject();
        geometry.set("type", "Polygon");
        geometry.set("coordinates", geoJsonCoords);
        String jsonStr = JSONUtil.toJsonStr(geometry);
        Geometry finalGeometry = GeometryUtils.geojson2Geometry(jsonStr);

        return finalGeometry;
    }

    // 凸包
    private static Polygon createConvexHullPolygon(Coordinate[] coords) {
        ConvexHull ch = new ConvexHull(coords, GF);
        Geometry geom = ch.getConvexHull();
        if (geom instanceof Polygon) {
            return (Polygon) geom;
        }
        if (geom instanceof LineString) {
            LineString ls = (LineString) geom;
            if (ls.getNumPoints() >= 3) {
                // 极少数情况下返回 LineString（所有点共线），强制闭合
                Coordinate[] closed = new Coordinate[ls.getNumPoints() + 1];
                System.arraycopy(ls.getCoordinates(), 0, closed, 0, ls.getNumPoints());
                closed[ls.getNumPoints()] = closed[0];
                return GF.createPolygon(closed);
            }
        }
        return null;
    }

    public static void printCoordinatesStats(List<Coordinate> coordinates) {
        if (coordinates.isEmpty()) {
            System.out.println("无坐标点");
            return;
        }

        double[] xs = coordinates.stream().mapToDouble(Coordinate::getX).toArray();
        double[] ys = coordinates.stream().mapToDouble(Coordinate::getY).toArray();
        double[] zs = coordinates.stream().mapToDouble(Coordinate::getZ).toArray();

        System.out.println("点数量: " + coordinates.size());
        System.out.printf("X: min=%.6f, max=%.6f, 范围=%.6f%n",
                Arrays.stream(xs).min().getAsDouble(),
                Arrays.stream(xs).max().getAsDouble(),
                Arrays.stream(xs).max().getAsDouble() - Arrays.stream(xs).min().getAsDouble());
        System.out.printf("Y: min=%.6f, max=%.6f, 范围=%.6f%n",
                Arrays.stream(ys).min().getAsDouble(),
                Arrays.stream(ys).max().getAsDouble(),
                Arrays.stream(ys).max().getAsDouble() - Arrays.stream(ys).min().getAsDouble());
        System.out.printf("Z: min=%.2f, max=%.2f%n",
                Arrays.stream(zs).min().getAsDouble(),
                Arrays.stream(zs).max().getAsDouble());
    }

    // 轴对齐包围盒（矩形）
    private static Polygon createEnvelopePolygon(Coordinate[] coords, List<Coordinate> coordList) {
        Envelope env = new Envelope();
        for (Coordinate c : coords) {
            env.expandToInclude(c.getX(), c.getY());
        }

        // 使用所有点的平均 Z 作为多边形的高度（也可改成 minZ / maxZ）
        double avgZ = coordList.stream()
                .mapToDouble(Coordinate::getZ)
                .average()
                .orElse(0.0);

        Coordinate[] ring = {
                new Coordinate(env.getMinX(), env.getMinY(), avgZ),
                new Coordinate(env.getMaxX(), env.getMinY(), avgZ),
                new Coordinate(env.getMaxX(), env.getMaxY(), avgZ),
                new Coordinate(env.getMinX(), env.getMaxY(), avgZ),
                new Coordinate(env.getMinX(), env.getMinY(), avgZ) // 闭合
        };
        return GF.createPolygon(ring);
    }

    // JTS Polygon → GeoJSON coordinates
    private static JSONArray polygonToGeoJsonCoordinates(Polygon polygon) {
        JSONArray coordinates = new JSONArray();
        JSONArray ring = new JSONArray();

        for (Coordinate c : polygon.getExteriorRing().getCoordinates()) {
            JSONArray point = new JSONArray();
            if (Double.isNaN(c.getZ())) continue;
            point.put(c.getX());
            point.put(c.getY());
            point.put(c.getZ());
            ring.put(point);
        }
        coordinates.put(ring);
        return coordinates;
    }

    public static List<Coordinate> removeOutliers(List<Coordinate> coords, double percentile) {
        double[] xs = coords.stream().mapToDouble(Coordinate::getX).sorted().toArray();
        double[] ys = coords.stream().mapToDouble(Coordinate::getY).sorted().toArray();

        int lowerIdx = (int) (coords.size() * (percentile / 100));
        int upperIdx = (int) (coords.size() * (1 - percentile / 100));

        double minX = xs[Math.max(0, lowerIdx)];
        double maxX = xs[Math.min(xs.length - 1, upperIdx)];
        double minY = ys[Math.max(0, lowerIdx)];
        double maxY = ys[Math.min(ys.length - 1, upperIdx)];

        return coords.stream()
                .filter(c -> c.getX() >= minX && c.getX() <= maxX && c.getY() >= minY && c.getY() <= maxY)
                .collect(Collectors.toList());
    }


    // ====================== 常用快捷调用 ======================

    /**
     * 推荐：返回最紧致的凸包多边形
     */
    public static Geometry createConvexHullGeometry(List<Coordinate> layerDataList) {
        return createBoundingPolygon(layerDataList, true);
    }

    /**
     * 返回轴对齐矩形包围盒
     */
    public static Geometry createEnvelopeGeometry(List<Coordinate> layerDataList) {
        return createBoundingPolygon(layerDataList, false);
    }


    public static GeometryEntity getGeometryInfo(Geometry geometry) {
        if (geometry == null) {
            throw new RuntimeException("不能传null");
        }
        Envelope en = geometry.getEnvelope().getEnvelopeInternal();
        return GeometryEntity.getKjdxEntity()
                .setC_x(geometry.getCentroid().getX())
                .setC_y(geometry.getCentroid().getY())
                .setXmax(en.getMaxX())
                .setXmin(en.getMinX())
                .setYmax(en.getMaxY())
                .setYmin(en.getMinY());
    }

    public static GeometryEntity getGeometryInfoByGeoJson(String geojson) {
        return getGeometryInfo(GeometryUtils.geojson2Geometry(geojson));
    }

    public static GeometryEntity getGeometryInfoByWkt(String wkt) {
        return getGeometryInfo(GeometryUtils.wkt2Geometry(wkt));
    }
}
