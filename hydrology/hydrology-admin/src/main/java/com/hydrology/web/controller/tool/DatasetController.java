package com.hydrology.web.controller.tool;

import cn.hutool.db.Entity;
import cn.hutool.json.JSONUtil;
import com.hydrology.common.annotation.Log;
import com.hydrology.common.core.controller.BaseController;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.common.core.page.TableDataInfo;
import com.hydrology.common.core.service.DatasetService;
import com.hydrology.common.enums.BusinessType;
import com.hydrology.common.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 关联数据集管理（数据注册中心-数据集 tab）
 */
@RestController
@RequestMapping("/tool/dataset")
public class DatasetController extends BaseController {

    @Autowired
    private DatasetService datasetService;

    @PreAuthorize("@ss.hasPermi('tool:gen:list')")
    @GetMapping("/list")
    public TableDataInfo list(String datasetName, String datasetComment) {
        // 数据集数量级小，不走 PageHelper（其对 hutool Db 查询不生效），全量返回
        List<Entity> list = datasetService.listDataset(datasetName, datasetComment);
        TableDataInfo rsp = getDataTable(list);
        rsp.setTotal((long) list.size());
        return rsp;
    }

    @PreAuthorize("@ss.hasPermi('tool:gen:list')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        Entity ds = datasetService.getDataset(id);
        return success(Entity.create().set("dataset", ds).set("columns", datasetService.getDatasetColumns(id)));
    }

    @PreAuthorize("@ss.hasPermi('tool:gen:edit')")
    @Log(title = "关联数据集", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Entity body) {
        datasetService.saveDataset(toDataset(body), toColumns(body));
        return success();
    }

    @PreAuthorize("@ss.hasPermi('tool:gen:edit')")
    @Log(title = "关联数据集", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Entity body) {
        datasetService.saveDataset(toDataset(body), toColumns(body));
        return success();
    }

    @PreAuthorize("@ss.hasPermi('tool:gen:remove')")
    @Log(title = "关联数据集", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        datasetService.deleteDataset(ids);
        return success();
    }

    @PreAuthorize("@ss.hasPermi('tool:gen:list')")
    @PostMapping("/previewSql")
    public AjaxResult previewSql(@RequestBody Entity body) {
        Entity ds = toDataset(body);
        List<Entity> cols = toColumns(body);
        datasetService.validate(ds, cols);
        return success(datasetService.buildInnerSql(Entity.create()
                .set("main_table", ds.getStr("main_table"))
                .set("join_config", ds.getStr("join_config"))
                .set("columns_json", JSONUtil.toJsonStr(cols))));
    }

    @SuppressWarnings("unchecked")
    private Entity toDataset(Entity body) {
        Object d = body.get("dataset");
        if (!(d instanceof Map)) {
            throw new ServiceException("请求体缺少 dataset 对象");
        }
        Entity ds = Entity.create();
        ds.putAll((Map<String, Object>) d);
        return ds;
    }

    @SuppressWarnings("unchecked")
    private List<Entity> toColumns(Entity body) {
        Object c = body.get("columns");
        if (!(c instanceof List)) {
            throw new ServiceException("请求体缺少 columns 数组");
        }
        return ((List<Map<String, Object>>) c).stream()
                .map(m -> {
                    Entity col = Entity.create();
                    col.putAll(m);
                    return col;
                }).collect(Collectors.toList());
    }
}