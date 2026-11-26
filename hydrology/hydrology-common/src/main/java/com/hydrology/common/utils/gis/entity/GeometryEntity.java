package com.hydrology.common.utils.gis.entity;


import cn.hutool.core.util.NumberUtil;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class GeometryEntity {
    private Double xmin;
    private Double ymin;
    private Double xmax;
    private Double ymax;
    private Double c_x;
    private Double c_y;
    private String c_x_str;
    private String c_y_str;
    private Double x_du;
    private Double x_fen;
    private Double x_miao;
    private Double y_du;
    private Double y_fen;
    private Double y_miao;


    public GeometryEntity setC_x(double x) {
        this.c_x = x;
        double v1 = Math.floor(x);
        double v2 = Math.floor((x - v1) * 60);
        double v3 = NumberUtil.round((x - v1) * 3600 % 60, 2).doubleValue();
        this.x_du = v1;
        this.x_fen = v2;
        this.x_miao = v3;
        this.c_x_str = (int) v1 + "°" + (int) v2 + "′" + v3 + "″";
        return this;
    }

    public GeometryEntity setC_y(double y) {
        this.c_y = y;
        double v1 = Math.floor(y);
        double v2 = Math.floor((y - v1) * 60);
        double v3 = NumberUtil.round((y - v1) * 3600 % 60, 2).doubleValue();
        this.y_du = v1;
        this.y_fen = v2;
        this.y_miao = v3;
        this.c_y_str = (int) v1 + "°" + (int) v2 + "′" + v3 + "″";
        return this;
    }

    public static GeometryEntity getKjdxEntity() {
        return new GeometryEntity();
    }
}
