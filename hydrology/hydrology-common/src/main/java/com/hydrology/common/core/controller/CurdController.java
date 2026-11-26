package com.hydrology.common.core.controller;

import cn.hutool.db.Entity;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.common.core.entity.QueryEntity;
import com.hydrology.common.core.service.CurdService;
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
    public AjaxResult getTableData(@RequestBody(required = false) QueryEntity queryEntity) {

        return AjaxResult.success("查询成功", this.tableService.getTableData(queryEntity));
    }


    @PostMapping("{tableName}-queryOne")
    public AjaxResult getTableDataOne(@RequestBody(required = false) QueryEntity queryOne) {

        return AjaxResult.success("查询成功", this.tableService.getTableDataOne(queryOne));
    }


    @PostMapping("{tableName}-insertOrUpdate")
    public AjaxResult insertOrUpdate(@RequestBody Entity queryOne) {

        return AjaxResult.success("修改成功", this.tableService.insertOrUpdate(queryOne));
    }


    @PostMapping("{tableName}-delete")
    public AjaxResult delete(@PathVariable String tableName, @RequestBody Entity entity) {
        return AjaxResult.success("删除成功", this.tableService.delete(tableName, entity));
    }

    @PostMapping("{tableName}-export")
    public AjaxResult export(@PathVariable String tableName, @RequestParam(required = false) String exportName, @RequestBody QueryEntity queryEntity) {
        return AjaxResult.success("导出成功", this.tableService.export(tableName, exportName, queryEntity));
    }
}
