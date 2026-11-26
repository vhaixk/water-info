package com.hydrology.common.utils.gis;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.CharsetUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.ZipUtil;
import cn.hutool.db.Entity;
import cn.hutool.json.JSONUtil;
import com.alibaba.fastjson2.JSON;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.constant.GenConstants;
import com.hydrology.common.utils.gis.entity.ShapeEntity;
import com.hydrology.common.utils.gis.entity.ShpFile;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.geotools.data.FeatureWriter;
import org.geotools.data.Transaction;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.data.shapefile.ShapefileDataStoreFactory;
import org.geotools.data.simple.SimpleFeatureCollection;
import org.geotools.data.simple.SimpleFeatureSource;
import org.geotools.data.store.ContentFeatureSource;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.feature.simple.SimpleFeatureTypeBuilder;
import org.geotools.geometry.jts.JTS;
import org.geotools.geometry.jts.JTSFactoryFinder;
import org.geotools.referencing.CRS;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.geotools.util.factory.Hints;
import org.locationtech.jts.geom.*;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.GeometryDescriptor;
import org.opengis.feature.type.PropertyDescriptor;
import org.opengis.geometry.MismatchedDimensionException;
import org.opengis.referencing.FactoryException;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;
import org.opengis.referencing.operation.TransformException;

import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.net.MalformedURLException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;


@Slf4j
public class ShapeUtils {


    public static String exportShape(
            List<Map<String, Object>> dataList,
            String shapeField
    ) {
        return exportShape(dataList, null, shapeField, null, null, null, null);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            String shapeField
    ) {
        return exportShape(dataList, fieldTypeMap, shapeField, null, null, null, null);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            String shapeField,
            String charset
    ) {
        return exportShape(dataList, null, shapeField, null, charset, null, null);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            String shapeField,
            String charset
    ) {
        return exportShape(dataList, fieldTypeMap, shapeField, null, charset, null, null);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            String shapeField,
            String charset,
            String savePath
    ) {
        return exportShape(dataList, null, shapeField, null, charset, savePath, null);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            String shapeField,
            String charset,
            String savePath,
            String zipName
    ) {
        return exportShape(dataList, null, shapeField, null, charset, savePath, zipName);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            String shapeField,
            String charset,
            String savePath
    ) {
        return exportShape(dataList, fieldTypeMap, shapeField, null, charset, savePath, null);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            String shapeField,
            String charset,
            String savePath,
            String zipName
    ) {
        return exportShape(dataList, fieldTypeMap, shapeField, null, charset, savePath, zipName);
    }


    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            String shapeField,
            String crsType,
            String charset,
            String savePath,
            String zipName
    ) {
        return exportShape(dataList, fieldTypeMap, null, shapeField, crsType, charset, savePath, zipName);
    }

    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            Map<String, Integer> fieldLengthMap,
            String shapeField,
            String crsType,
            String charset,
            String savePath,
            String zipName
    ) {

        Map<String, List<Map<String, Object>>> groupShapeMap = dataList.stream()
                .filter(data -> data.get(shapeField) != null)
                .collect(Collectors.groupingBy(data -> {
                    try {
                        Geometry shapeValue = GeometryUtils.getGeometryValue(data.get(shapeField));
                        String geometryType = shapeValue.getGeometryType();
                        return ShapeType.getGeometryType(geometryType);
                    } catch (Exception e) {
                        log.error("矢量数据转换失败:{}", JSON.toJSONString(data));
                    }
                    return "ERRO";
                }));

        // 获取保存路径
        String defaultName = IdUtil.simpleUUID();
        if (StrUtil.isBlank(savePath)) {
            savePath = disposeSavePath(savePath, "exportShape") + File.separator + defaultName;
        }
        String finalSavePath = savePath;
        String finalZip = FileUtil.getParent(savePath, 1) + File.separator + getName(StrUtil.blankToDefault(zipName, defaultName), "zip");
        groupShapeMap.forEach((shapeType, maps) -> {
            exportShape(maps, fieldTypeMap, fieldLengthMap, shapeField, shapeType, crsType, charset, finalSavePath + File.separator + shapeType, zipName);
        });
        ZipUtil.zip(savePath, finalZip);
        if (StrUtil.isBlank(savePath)) {
            return finalZip.substring(finalZip.indexOf("exportShape"));
        }
        return finalZip;
    }

    /**
     * 出口形状
     * 到处Shape
     *
     * @param dataList       传入过来的数据
     * @param fieldTypeMap   字段对应的类型 可以为空（空的话按String处理） ||  常量类 {@link GenConstants}
     * @param shapeField     空间对象字段名称
     * @param shapeType      空间对象类型   ||  常量类 {@link ShapeType}
     * @param savePath       保存路径   可以为空
     * @param crsType        坐标系类型  可以为空
     * @param charset        字符集 可以为空
     * @param fieldLengthMap 字段值长度映射（默认 255）
     * @param zipName        邮政名字
     * @return {@link String}
     */
    public static String exportShape(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            Map<String, Integer> fieldLengthMap,
            String shapeField,
            String shapeType,
            String crsType,
            String charset,
            String savePath,
            String zipName
    ) {
        if (fieldTypeMap == null) {
            fieldTypeMap = new HashMap<>();
        }
        if (fieldLengthMap == null) {
            fieldLengthMap = new HashMap<>();
        }

        // 最终zip路径
        // String finalZip = savePath + File.separator + getName(zipName, "zip");
        String finalShp = savePath + File.separator + getName(FileUtil.getPrefix(zipName), "shp");
        // 获取坐标系
        CoordinateReferenceSystem crs = disposeCrs(crsType);
        CoordinateReferenceSystem sourceCRS = disposeCrs("EPSG:4326");
        MathTransform mathTransform = null;

        // 获取shape类型
        Class<?> finalShapeType = getShapeType(shapeType);
        FeatureWriter<SimpleFeatureType, SimpleFeature> writer = null;
        ShapefileDataStore sds = null;
        try {
            FileUtil.mkParentDirs(finalShp);
            File file = new File(finalShp);
            // 构建存储shape容器
            sds = (ShapefileDataStore) new ShapefileDataStoreFactory().createNewDataStore(
                    new HashMap<String, Serializable>(1) {{
                        put(ShapefileDataStoreFactory.URLP.key, file.toURI().toURL());
                    }}
            );
            //定义图形信息和属性信息
            SimpleFeatureTypeBuilder sftb = new SimpleFeatureTypeBuilder();
            // 坐标系
            sftb.setCRS(crs);
            // 内部名称
            sftb.setName(ShapeType.SHAPE_NAME);
            // 空间对象名称
            sftb.add(ShapeType.GEOM_NAME, finalShapeType);
            // sftb添加字段属性
            disposeClass(dataList, fieldTypeMap, fieldLengthMap, sftb, shapeField);
            // 创建默认模式
            sds.setCharset(Charset.forName(StrUtil.blankToDefault(charset, "GBK")));
            sds.createSchema(sftb.buildFeatureType());
            //设置Writer
            writer = sds.getFeatureWriter(sds.getTypeNames()[0], Transaction.AUTO_COMMIT);
            SimpleFeature feature;

            // 删除map里面的shape 避免重复添加
            fieldTypeMap.remove(shapeField);
            if (StrUtil.isNotBlank(crsType)) {
                Geometry tempShapeValue = null;
                for (Map<String, Object> stringObjectMap : dataList) {
                    Object object = stringObjectMap.get(shapeField);
                    if (object == null) continue;
                    tempShapeValue = GeometryUtils.getGeometryValue(object);
                    break;
                }
                if (tempShapeValue == null) {
                    return "无有效空间字段，导出shp失败";
                }
                mathTransform = CRS.findMathTransform(sourceCRS, crs, true);
            }
            for (int i = 0; i < dataList.size(); i++) {
                Map<String, Object> dataMap = dataList.get(i);
                Object shape = dataMap.get(shapeField);
                // 如果 shape 是null的情况
                if (shape == null) {
                    log.warn("{}的空间对象数据为null，不存入压缩包", JSONUtil.toJsonStr(dataMap));
                    continue;
                }
                // 获取 geometry 的值
                Geometry shapeValue = GeometryUtils.getGeometryValue(shape);
                if (mathTransform != null) {
                    shapeValue = JTS.transform(shapeValue, mathTransform);
                }
                feature = writer.next();
                // 序号
                feature.setAttribute("XH", i + 1);
                feature.setAttribute(ShapeType.GEOM_NAME, shapeValue);
                // 循环添加对应字段的值
                for (String field : fieldTypeMap.keySet()) {
                    Object obj = dataMap.getOrDefault(field, dataMap.get(field.toLowerCase()));
                    String finalFeild = field;
//                    if (field.length() > 10) {
//                        finalFeild = field.substring(0, 9);
//                    }
                    if (fieldTypeMap.get(field) == null && obj == null) {
                        feature.setAttribute(finalFeild.toUpperCase(), "");
                    } else if (obj instanceof Date) {
                        feature.setAttribute(finalFeild.toUpperCase(), DateUtil.formatDate((Date) obj));
                    } else {
                        feature.setAttribute(finalFeild.toUpperCase(), obj);
                    }
                }
            }
            writer.write();
            close(writer);
            sds.dispose();

            // ZipUtil.zip(FileUtil.getParent(finalShp, 1), finalZip);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        } finally {
            close(writer);
            if (sds != null) {
                sds.dispose();
            }
        }
//        return finalZip.split(BkConfig.getProfile())[1];
        return finalShp;
    }

    public static double[] getShapeExtent(String shpFile) {
        ShapefileDataStore shpDataStore = null;
        try {
            File file = new File(shpFile);
            shpDataStore = new ShapefileDataStore(file.toURI().toURL());
            String typeName = shpDataStore.getTypeNames()[0];
            SimpleFeatureSource featureSource = shpDataStore.getFeatureSource(typeName);
            SimpleFeatureCollection fc = featureSource.getFeatures();
            double xmin = fc.getBounds().getMinX();
            double ymin = fc.getBounds().getMinY();
            double xmax = fc.getBounds().getMaxX();
            double ymax = fc.getBounds().getMaxY();
            double[] doubles = {xmin, xmax, ymin, ymax};
            // 获取 GeometryDescriptor
            GeometryDescriptor geometryDescriptor = featureSource.getSchema().getGeometryDescriptor();
            if (geometryDescriptor != null) {
                CoordinateReferenceSystem crs = geometryDescriptor.getCoordinateReferenceSystem();
                if (crs != null) {
                    boolean crswgs84 = isCRSWGS84(crs);
                    if (crswgs84) {
                        return doubles;
                    } else {
                        return getDoubles(xmin, ymin, xmax, ymax, crs);
                    }
                } else {
                    log.error("未找到坐标系信息");
                }
            } else {
                log.error("未找到几何数据");
            }
            return doubles;
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        } finally {
            if (shpDataStore != null) {
                shpDataStore.dispose();
            }
        }
        return null;
    }

    private static double[] getDoubles(double xmin, double ymin, double xmax, double ymax, CoordinateReferenceSystem sourceCRS) {
        try {
            Geometry multiPolygon = getGeometryByFTRB(xmin, ymin, xmax, ymax);
            MathTransform transform = CRS.findMathTransform(sourceCRS, DefaultGeographicCRS.WGS84, true);
            multiPolygon = JTS.transform(multiPolygon, transform);
            Envelope en = multiPolygon.getEnvelope().getEnvelopeInternal();
            xmax = en.getMaxX();
            xmin = en.getMinX();
            ymax = en.getMaxY();
            ymin = en.getMinY();
            return new double[]{xmin, xmax, ymin, ymax};
        } catch (FactoryException | TransformException | MismatchedDimensionException e) {
            log.error(e.getMessage(), e);
        }
        return null;
    }

    /**
     * 通过四个边界获取矩形
     *
     * @param xmin
     * @param ymin
     * @param xmax
     * @param ymax
     * @return
     */
    public static Geometry getGeometryByFTRB(double xmin, double ymin, double xmax, double ymax) {
        try {
            String geojson = "{\"type\":\"Polygon\",\"coordinates\":[[ [" + xmin + "," + ymin + "], [" + xmin + "," + ymax + "], [" + xmax + "," + ymax + "], [" + xmax + "," + ymin + "],[" + xmin + "," + ymin + "] ]]}";
            return GeometryUtils.geojson2Geometry(geojson);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static boolean isCRSWGS84(CoordinateReferenceSystem crs) throws FactoryException {
        // 获取 WGS 84 坐标系
        CoordinateReferenceSystem wgs84 = CRS.decode("EPSG:4326");
        // 比较两个坐标系
        return crs.equals(wgs84);
    }

    private static String getName(String zipName, String suffix) {
        if (StrUtil.isNotBlank(zipName)) {
            if (zipName.contains(".")) {
                return zipName;
            } else {
                return zipName + "." + suffix;
            }
        } else {
            return IdUtil.simpleUUID() + "." + suffix;
        }
    }

    private static void close(Closeable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }


    /**
     * 获得形状类型
     *
     * @param shapeType 形状类型
     * @return {@link Class}<{@link ?}>
     */
    private static Class<?> getShapeType(String shapeType) {
        switch (shapeType) {
            case ShapeType.MULTI_LINE_STRING:
                return MultiLineString.class;
            case ShapeType.MULTI_POINT:
                return MultiPoint.class;
            case ShapeType.MULTI_POLYGON:
                return MultiPolygon.class;
            default:
                throw new RuntimeException("空间对象类型不能为空！");
        }
    }

    /**
     * 处理crs
     *
     * @param crsType crs型
     * @return {@link CoordinateReferenceSystem}
     */
    @SneakyThrows
    private static CoordinateReferenceSystem disposeCrs(String crsType) {
        if (StrUtil.isBlank(crsType) || ShapeType.CRS_84.equals(crsType)) {
            return DefaultGeographicCRS.WGS84;
        }
        if (crsType.startsWith("EPSG:")) {
            return CRS.decode(crsType, true);
        }
        return CRS.parseWKT(crsType);
    }


    /**
     * 对保存路径处理
     *
     * @param savePath 保存路径
     * @return {@link String}
     */
    private static String disposeSavePath(String savePath, String defaultPath) {

        // 保存路径是否为空 没有则生成
        if (StrUtil.isNotBlank(savePath)) {
            savePath = savePath.replace("\\", File.separator);
            // 判断是否是有 / 没有则添加
            if (savePath.startsWith(File.separator)) {
                savePath = SystemConfig.getProfile() + savePath;
            } else {
                savePath = SystemConfig.getProfile() + File.separator + savePath;
            }
            // 判断是否是zip后缀结尾 没有则添加
            // if (!savePath.endsWith(".zip")) {
            //     savePath += savePath.endsWith(File.separator) ? "" : File.separator;
            // }
        } else {
            savePath = SystemConfig.getProfile() + File.separator + defaultPath + File.separator + DateUtil.today() + File.separator + IdUtil.simpleUUID();
        }
        FileUtil.mkdir(savePath);
        return savePath;
    }

    /**
     * 处理每个字段的类型
     *
     * @param dataList     数据列表
     * @param fieldTypeMap 字段映射
     * @param sftb         领域类图
     * @param shapeField   形状领域
     */
    private static void disposeClass(
            List<Map<String, Object>> dataList,
            Map<String, Object> fieldTypeMap,
            Map<String, Integer> fieldLengthMap,
            SimpleFeatureTypeBuilder sftb,
            String shapeField
    ) {
        if (dataList == null || dataList.isEmpty()) {
            throw new RuntimeException("传入的数据不能为空！");
        }
        // 如果没有传字段类型 那么全按照string处理
        if (fieldTypeMap.isEmpty()) {
            dataList.get(0).keySet().forEach(field -> {
                field = field.toUpperCase();
                if (field.equalsIgnoreCase(shapeField)) {
                    return;
                }
                fieldTypeMap.put(field, null);
                String finalField = field;
                Integer fieldLength = fieldLengthMap.getOrDefault(field, fieldLengthMap.get(field.toLowerCase()));
                // 设置字段值长度
                if (fieldLength != null) {
                    sftb.length(fieldLength);
                }
                sftb.add(finalField, String.class);
            });
            sftb.add("XH", Integer.class);
        } else {
            // 处理字段类型
            fieldTypeMap.forEach((field, javaType) -> {
                field = field.toUpperCase();
                Integer fieldLength = fieldLengthMap.getOrDefault(field, fieldLengthMap.get(field.toLowerCase()));

                if (field.equalsIgnoreCase(shapeField)) {
                    return;
                }
                // 设置字段值长度
                if (fieldLength != null) {
                    sftb.length(fieldLength);
                }
                switch (javaType.toString()) {
                    case GenConstants.TYPE_INTEGER:
                    case GenConstants.TYPE_LONG:
                        sftb.add(field, Integer.class);
                        break;
                    case GenConstants.TYPE_DOUBLE:
                    case GenConstants.TYPE_BIGDECIMAL:
                        sftb.add(field, Double.class);
                        break;
                    default:
                        sftb.add(field, String.class);
                }
            });
            sftb.add("XH", Integer.class);
        }
    }


    public static void importShapeByFile(
            File shpFile,
            Function<List<ShpFile>, Boolean> callBackFunction
    ) {
        shp2List(shpFile, CharsetUtil.CHARSET_GBK, callBackFunction);
    }

    public static void importShapeByFile(
            File shpFile,
            Charset dataCharSet,
            Function<List<ShpFile>, Boolean> callBackFunction
    ) {
        if (FileUtil.getSuffix(shpFile).endsWith("shp")) {
            shp2List(shpFile, dataCharSet, callBackFunction);
        } else {
            throw new RuntimeException("传入的不是正确的shp文件");
        }
    }

    public static void importShapeByFile(
            File shpFile,
            Charset dataCharSet,
            Function<ShapeEntity, Boolean> callBackFunction,
            Entity entity
    ) {

        if (FileUtil.getSuffix(shpFile).endsWith("shp")) {
            shp2List(shpFile, dataCharSet, callBackFunction, entity);
        } else {
            throw new RuntimeException("传入的不是正确的shp文件");
        }
    }

    public static void importShapeByZip(
            File zipFile,
            Function<List<ShpFile>, Boolean> callBackFunction) {
        importShapeByZip(zipFile, null, CharsetUtil.CHARSET_GBK, callBackFunction);
    }

    public static void importShapeByZip(
            File zipFile,
            Charset zipCharSet,
            Function<List<ShpFile>, Boolean> callBackFunction) {
        importShapeByZip(zipFile, null, zipCharSet, callBackFunction);
    }

    public static void importShapeByZip(
            File zipFile,
            String unZipPath,
            Charset zipCharSet,
            Function<List<ShpFile>, Boolean> callBackFunction
    ) {
        importShapeByZip(zipFile, unZipPath, zipCharSet, Charset.defaultCharset(), callBackFunction);
    }

    /**
     * zip2shp
     *
     * @param zipFile          zip文件
     * @param unZipPath        相对路径 解压路径
     * @param zipCharSet       压缩包字符
     * @param dataCharSet      数据字符
     * @param callBackFunction 回调函数
     */
    public static void importShapeByZip(
            File zipFile,
            String unZipPath,
            Charset zipCharSet,
            Charset dataCharSet,
            Function<List<ShpFile>, Boolean> callBackFunction
    ) {
        String path = disposeSavePath(unZipPath, "unZipPath");

        String fileName = FileUtil.getName(zipFile);
        try {
            if (fileName.endsWith(".zip")) {

                File folder = FileUtil.mkdir(path);
                ZipUtil.unzip(zipFile, FileUtil.file(folder.getPath()), zipCharSet);
                File[] files = folder.listFiles();
                // shape文件处理
                List<File> shapeFileList = new ArrayList<>();
                getShapeFile(files, shapeFileList);
                for (File shpfile : shapeFileList) {
                    shp2List(shpfile, dataCharSet, callBackFunction);
                }
//                for (File shpfile : folder.listFiles()) {
//                    if (FileUtil.getSuffix(shpfile).endsWith("shp")) {
//                        shp2List(shpfile, charSet, callBackFunction);
//                    }
//                }
            }
        } catch (Exception var) {
            var.printStackTrace();
        }
    }

    private static File findKmlFile(File[] files) {
        for (File file : files) {
            String suffix = FileUtil.getSuffix(file);
            if ("kml".equalsIgnoreCase(suffix)) {
                return file;
            }
        }
        return null;
    }

    private static void getShapeFile(File[] files, List<File> shapeFileList) {
        if (files == null) {
            return;
        }

        for (File file : files) {
            if (FileUtil.isDirectory(file)) {
                getShapeFile(file.listFiles(), shapeFileList);
                continue;
            }
            if (FileUtil.getSuffix(file).endsWith("shp")) {
                shapeFileList.add(file);
            }
        }
    }


    private static Charset findDataChartSet(File shpfile, Charset defaultCharSet) {
        File file = FileUtil.getParent(shpfile, 1);
        for (File listFile : file.listFiles()) {
            String suffix = FileUtil.getSuffix(listFile);
            if ("cpg".equalsIgnoreCase(suffix) && FileUtil.getPrefix(shpfile).equals(FileUtil.getPrefix(listFile))) {
                byte[] bytes = FileUtil.readBytes(listFile);
                return Charset.forName(new String(bytes, StandardCharsets.UTF_8));
            }
        }
        return defaultCharSet;
    }

    public static String getShpType(File shpfile) {
        FeatureCollection features = getFeatures(shpfile);
        if (features == null) {
            log.error("FeatureCollection赋值失败！");
            return null;
        }
        return features.getSchema().getDescriptor("the_geom").getType().getName().toString();
    }

    public static String getShpType(String shpfilePath) {
        return getShpType(new File(shpfilePath));
    }

    public static boolean hasShpField(File shpfile, String field) {
        FeatureCollection features = getFeatures(shpfile);
        if (features == null) {
            log.error("FeatureCollection赋值失败！");
            return false;
        }
        PropertyDescriptor descriptor = features.getSchema().getDescriptor(field);
        if (descriptor == null) {
            return false;
        }
        return true;
    }

    public static boolean hasShpField(String shpfilePath, String field) {
        return hasShpField(new File(shpfilePath), field);

    }


    private static FeatureCollection getFeatures(File shpfile) {

        String fname = FileUtil.getPrefix(shpfile);
        ShapefileDataStore dsRoads = null;
        try {
            dsRoads = new ShapefileDataStore(shpfile.toURI().toURL());
        } catch (MalformedURLException var15) {
            var15.printStackTrace();
        }
        if (dsRoads == null) {
            return null;
        }

        dsRoads.setCharset(Charset.forName(CharsetUtil.GBK));
        ContentFeatureSource fsRoads;
        FeatureCollection features = null;

        try {
            fsRoads = dsRoads.getFeatureSource(fname);
            features = fsRoads.getFeatures();
        } catch (Exception var14) {
            var14.printStackTrace();
        }
        return features;
    }

    //  可以自定义参数
    public static void importShapeByZip(
            File zipFile,
            Charset charSet,
            Function<ShapeEntity, Boolean> callBackFunction,
            Entity entity
    ) {
        importShapeByZip(zipFile, null, charSet, callBackFunction, entity);
    }


    public static void importShapeByZip(
            File zipFile,
            String unZipPath,
            Charset charSet,
            Function<ShapeEntity, Boolean> callBackFunction,
            Entity entity
    ) {
        String path = disposeSavePath(unZipPath, "unZipPath");

        String fileName = FileUtil.getName(zipFile);
        try {
            if (fileName.endsWith(".zip")) {
                File folder = FileUtil.mkdir(path);
                ZipUtil.unzip(zipFile, FileUtil.file(folder.getPath()), Charset.defaultCharset());
                File[] files = folder.listFiles();

                List<File> shapeFileList = new ArrayList<>();
                getShapeFile(files, shapeFileList);
                for (File shpfile : shapeFileList) {
                    shp2List(shpfile, charSet, callBackFunction, entity);
                }
            }
        } catch (Exception var) {
            var.printStackTrace();
        }
    }

    private static void shp2List(File shpfile, Charset dataCharSet, Function<ShapeEntity, Boolean> callBackFunction, Entity attr) {
        List<ShpFile> list = new LinkedList<>();
        dataCharSet = findDataChartSet(shpfile, dataCharSet);
        String fname = FileUtil.getPrefix(shpfile);
        String filepath = shpfile.getAbsolutePath();
        ShapefileDataStore dsRoads = null;
        try {
            dsRoads = new ShapefileDataStore(shpfile.toURI().toURL());
        } catch (MalformedURLException var15) {
            var15.printStackTrace();
        }
        if (dsRoads == null) return;

        dsRoads.setCharset(dataCharSet);
        ContentFeatureSource fsRoads = null;
        FeatureCollection features = null;

        try {
            fsRoads = dsRoads.getFeatureSource(fname);
            features = fsRoads.getFeatures();
        } catch (Exception var14) {
            var14.printStackTrace();
        }
        if (features == null) {
            log.error("FeatureCollection赋值失败！");
            throw new RuntimeException();
        }
        SimpleFeatureType schema = (SimpleFeatureType) features.getSchema();
        List<AttributeDescriptor> columns = schema.getAttributeDescriptors();
        FeatureIterator<SimpleFeature> itertor = features.features();
        attr.set("createTable", true);
        while (itertor.hasNext()) {
            SimpleFeature feature = itertor.next();
            list.add(new ShpFile(feature, columns, filepath));
            if (list.size() == 10000) {
                callBackFunction.apply(new ShapeEntity().setShapeData(list).setAttr(attr));
                list.clear();
                attr.set("createTable", false);
            }
        }
        if (!list.isEmpty()) {
            callBackFunction.apply(new ShapeEntity().setShapeData(list).setAttr(attr));
        }
        itertor.close();
        dsRoads.dispose();
    }

    private static void shp2List(File shpfile, Charset dataCharSet, Function<List<ShpFile>, Boolean> callBackFunction) {

        String suffix = FileUtil.getSuffix(shpfile);
        dataCharSet = findDataChartSet(shpfile, dataCharSet);

        List<ShpFile> list = new LinkedList<>();
        String fname = FileUtil.getPrefix(shpfile);
        String filepath = shpfile.getAbsolutePath();
        ShapefileDataStore dsRoads = null;
        try {
            dsRoads = new ShapefileDataStore(shpfile.toURI().toURL());
        } catch (MalformedURLException var15) {
            var15.printStackTrace();
        }
        if (dsRoads == null) return;

        dsRoads.setCharset(dataCharSet);
        ContentFeatureSource fsRoads = null;
        FeatureCollection features = null;

        try {
            fsRoads = dsRoads.getFeatureSource(fname);
            features = fsRoads.getFeatures();
        } catch (Exception var14) {
            var14.printStackTrace();
        }
        if (features == null) {
            log.error("FeatureCollection赋值失败！");
            throw new RuntimeException();
        }
        SimpleFeatureType schema = (SimpleFeatureType) features.getSchema();
        List<AttributeDescriptor> columns = schema.getAttributeDescriptors();
        FeatureIterator<SimpleFeature> itertor = features.features();
        while (itertor.hasNext()) {
            SimpleFeature feature = itertor.next();
            list.add(new ShpFile(feature, columns, filepath));
            if (list.size() == 10000) {
                callBackFunction.apply(list);
                list.clear();
            }
        }
        if (!list.isEmpty()) {
            callBackFunction.apply(list);
        }
        itertor.close();
        dsRoads.dispose();
    }

    public static List<ShpFile> shp2List(File shpfile, Charset dataCharSet) {

        dataCharSet = findDataChartSet(shpfile, dataCharSet);

        List<ShpFile> list = new LinkedList<>();
        String fname = FileUtil.getPrefix(shpfile);
        String filepath = shpfile.getAbsolutePath();
        ShapefileDataStore dsRoads = null;
        try {
            dsRoads = new ShapefileDataStore(shpfile.toURI().toURL());
        } catch (MalformedURLException var15) {
            var15.printStackTrace();
        }
        if (dsRoads == null) return new ArrayList<>();

        dsRoads.setCharset(dataCharSet);
        ContentFeatureSource fsRoads = null;
        FeatureCollection features = null;

        try {
            fsRoads = dsRoads.getFeatureSource(fname);
            features = fsRoads.getFeatures();
        } catch (Exception var14) {
            var14.printStackTrace();
        }
        if (features == null) {
            log.error("FeatureCollection赋值失败！");
            throw new RuntimeException();
        }
        SimpleFeatureType schema = (SimpleFeatureType) features.getSchema();
        List<AttributeDescriptor> columns = schema.getAttributeDescriptors();
        FeatureIterator<SimpleFeature> itertor = features.features();
        while (itertor.hasNext()) {
            SimpleFeature feature = itertor.next();
            list.add(new ShpFile(feature, columns, filepath));
        }
        itertor.close();
        dsRoads.dispose();
        return list;
    }

    private static MultiPolygon mergePolygon(List<Geometry> list) {
        GeometryFactory geometryFactory = JTSFactoryFinder.getGeometryFactory((Hints) null);
        Polygon polygon = null;
        GeometryCollection geometryCollection = (GeometryCollection) geometryFactory.buildGeometry(list);
        Geometry union = geometryCollection.buffer(0.0D);
        if ("MultiLineString".equals(union.getBoundary().getGeometryType())) {
            MultiLineString multilinestring = (MultiLineString) union.getBoundary();
            LinearRing linearring = null;
            linearring = (LinearRing) multilinestring.getGeometryN(0);
            LinearRing[] holes = null;
            polygon = geometryFactory.createPolygon(linearring, (LinearRing[]) holes);
        } else if ("LinearRing".equals(union.getBoundary().getGeometryType())) {
            polygon = (Polygon) union;
        }

        return new MultiPolygon(new Polygon[]{polygon}, geometryFactory);
    }


}

