package com.hydrology.common.utils.db;

import cn.hutool.db.Entity;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

@Data
@Accessors(chain = true)
public class ResultEntity {

    Long total;
    Long page;
    Long pageSize;
    Long totalPage;
    List<Entity> dataList;

    public static ResultEntity getInstance() {
        return new ResultEntity();
    }
}
