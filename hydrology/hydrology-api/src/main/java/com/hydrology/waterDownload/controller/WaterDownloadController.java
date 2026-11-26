package com.hydrology.waterDownload.controller;

import cn.hutool.db.Entity;
import com.hydrology.common.constant.WaterDownloadConstants;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.common.utils.WaterDownloadCacheUtils;
import com.hydrology.waterDownload.service.WaterDownloadService;
import com.hydrology.waterDownload.task.WaterDownloadTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("water")
public class WaterDownloadController {

    @Autowired
    private WaterDownloadTask waterDownloadTask;

    @Autowired
    private WaterDownloadService waterDownloadService;

    @GetMapping("download")
    public void download(
            @RequestParam String tableName,
            @RequestParam String excelPath,
            @RequestParam String imagePath
    ) {
        this.waterDownloadTask.downloadAndSave(tableName, excelPath, imagePath);
    }

    @GetMapping("runCrawl")
    public void runCrawl() {
        this.waterDownloadTask.runCrawl();
    }

    /**
     * 手动重建水雨情映射树/字典缓存（批量修改映射表后调用）
     */
    @GetMapping("refreshMapping")
    public AjaxResult refreshMapping() {
        for (String table : WaterDownloadConstants.TABLES) {
            WaterDownloadCacheUtils.refreshMappingCache(table);
        }
        return AjaxResult.success();
    }


    @GetMapping("getTreeData")
    public AjaxResult getTreeData(@RequestParam String mappingName) {
        return AjaxResult.success(this.waterDownloadService.getTreeData(mappingName));
    }


    @GetMapping("getDicMapping")
    public AjaxResult getDicMapping(@RequestParam String mappingName) {
        return AjaxResult.success(this.waterDownloadService.getDicMapping(mappingName));
    }

    @PostMapping("getData")
    public AjaxResult getData(@RequestBody Entity entity) {
        return AjaxResult.success(this.waterDownloadService.getData(entity));
    }


    @GetMapping("getProfileData")
    public void getProfileData(@RequestParam String profilePath, HttpServletResponse response) {
        this.waterDownloadService.getProfileData(profilePath, response);
    }

    @PostMapping("handleExportOrigin")
    public AjaxResult handleExportOrigin(@RequestBody Entity entity) {
        return AjaxResult.success("导出成功！", this.waterDownloadService.handleExportOrigin(entity));
    }

}
