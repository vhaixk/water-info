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
    public AjaxResult download() {
        // 异步提交：全量下载耗时几十分钟，同步返回会被网关掐断
        boolean started = this.service.startDownload();
        return started ? AjaxResult.success("水质下载任务已提交")
                : AjaxResult.error("已有下载任务进行中或生产开关未开启");
    }

    @GetMapping("downloadStatus")
    public AjaxResult downloadStatus() {
        return AjaxResult.success(this.service.getDownloadStatus());
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
