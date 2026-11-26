package com.hydrology.common.utils.gis.entity;

import cn.hutool.db.Entity;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

@Data
@Accessors(chain = true)
public class ShapeEntity {

    /**
     * shp数据
     */
    List<ShpFile> shapeData;

    /**
     * 其他数据
     */
    Entity attr;
}
