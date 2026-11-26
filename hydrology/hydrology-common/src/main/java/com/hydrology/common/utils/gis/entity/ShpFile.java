package com.hydrology.common.utils.gis.entity;

import com.hydrology.common.utils.gis.GeometryUtils;
import lombok.Data;
import org.locationtech.jts.geom.Geometry;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.springframework.util.LinkedCaseInsensitiveMap;

import java.util.List;
import java.util.Map;

@Data
public class ShpFile {

    public String filepath;
    public Geometry geometry;
    public Map<String, Object> attr = new LinkedCaseInsensitiveMap<>();
    public CoordinateReferenceSystem crs;


    public ShpFile() {

    }

    public ShpFile(SimpleFeature feature, List<AttributeDescriptor> columns) {

        for (AttributeDescriptor attributeDes : columns) {
            String attributeName = attributeDes.getName().toString();
            if (!"the_geom".equals(attributeName)) {
                this.attr.put(attributeName, feature.getAttribute(attributeName));
            }
        }

        this.geometry = (Geometry) feature.getDefaultGeometry();
        this.crs = feature.getFeatureType().getCoordinateReferenceSystem();
    }

    public ShpFile(SimpleFeature feature, List<AttributeDescriptor> columns, String filepath) {

        for (AttributeDescriptor attributeDes : columns) {
            String attributeName = attributeDes.getName().toString();
            if (!"the_geom".equals(attributeName)) {
                this.attr.put(attributeName, feature.getAttribute(attributeName));
            }
        }

        this.geometry = (Geometry) feature.getDefaultGeometry();
        this.crs = feature.getFeatureType().getCoordinateReferenceSystem();
        this.filepath = filepath;
    }

    public Map<String, Object> getAttrAndGeom2Wkt() {
        Map<String, Object> attr1 = getAttr();
        attr1.put("geom", GeometryUtils.geometry2Wkt(this.geometry));

        return this.attr;
    }

}
