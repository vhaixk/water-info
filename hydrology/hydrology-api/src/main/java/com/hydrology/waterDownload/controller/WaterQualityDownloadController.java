package com.hydrology.waterDownload.controller;


import cn.hutool.db.Entity;
import com.hydrology.common.core.domain.AjaxResult;
import com.hydrology.waterDownload.service.WaterQualityDownloadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("waterQuality")
public class WaterQualityDownloadController {

    @Autowired
    private WaterQualityDownloadService service;

    @GetMapping("download")
    public void download() {
        this.service.download();
    }

    //    @GetMapping("importData")
    public void importData() {
        this.service.importData();
    }

    @GetMapping("getWaterQualityDic")
    public AjaxResult getWaterQualityDic(@RequestParam String dicName) {
        return AjaxResult.success(this.service.getWaterQualityDic(dicName));
    }

    @PostMapping("getData")
    public AjaxResult getData(@RequestBody Entity entity) {
        return AjaxResult.success(this.service.getData(entity));
    }

}
