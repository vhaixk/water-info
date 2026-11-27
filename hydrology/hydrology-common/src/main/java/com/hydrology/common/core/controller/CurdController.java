package com.hydrology.common.core.controller;

import cn.hutool.db.Entity;
import com.hydrology.common.annotation.Log;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.common.core.entity.QueryEntity;
import com.hydrology.common.core.service.CurdService;
import com.hydrology.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("curd")
public class CurdController {

    @Autowired
    private CurdService tableService;


    @GetMapping("{tableName}-column")
    public AjaxResult getColumnData(@PathVariable String tableName) {

        return AjaxResult.success(this.tableService.getColumnData(tableName));
    }


    @PostMapping("{tableName}-query")
    public AjaxResult getTableData(@PathVariable String tableName, @RequestBody(required = false) QueryEntity queryEntity) {
        if (queryEntity == null) {
            queryEntity = new QueryEntity();
        }
        // 路径表名为唯一权威，防止请求体携带其他表名绕过校验
        queryEntity.setTableName(tableName);
        return AjaxResult.success("查询成功", this.tableService.getTableData(queryEntity));
    }


    @PostMapping("{tableName}-queryOne")
    public AjaxResult getTableDataOne(@PathVariable String tableName, @RequestBody(required = false) QueryEntity queryOne) {
        if (queryOne == null) {
            queryOne = new QueryEntity();
        }
        queryOne.setTableName(tableName);
        return AjaxResult.success("查询成功", this.tableService.getTableDataOne(queryOne));
    }


    @Log(title = "通用数据维护", businessType = BusinessType.UPDATE)
    @PostMapping("{tableName}-insertOrUpdate")
    public AjaxResult insertOrUpdate(@PathVariable String tableName, @RequestBody Entity queryOne) {
        queryOne.set("tableName", tableName);
        return AjaxResult.success("修改成功", this.tableService.insertOrUpdate(queryOne));
    }


    @Log(title = "通用数据维护", businessType = BusinessType.DELETE)
    @PostMapping("{tableName}-delete")
    public AjaxResult delete(@PathVariable String tableName, @RequestBody Entity entity) {
        return AjaxResult.success("删除成功", this.tableService.delete(tableName, entity));
    }

    @Log(title = "通用数据导出", businessType = BusinessType.EXPORT)
    @PostMapping("{tableName}-export")
    public AjaxResult export(@PathVariable String tableName, @RequestParam(required = false) String exportName, @RequestBody QueryEntity queryEntity) {
        return AjaxResult.success("导出成功", this.tableService.export(tableName, exportName, queryEntity));
    }
}
