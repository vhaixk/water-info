package com.hydrology.waterDownload.task;

import cn.hutool.core.date.DateUtil;
import cn.hutool.db.Entity;
import com.hydrology.common.config.SystemConfig;
import com.hydrology.common.utils.db.GetDbUtils;
import com.hydrology.waterDownload.service.WaterQualityDownloadService;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 启动补偿：项目更新重启打断爬取时，启动完成后检查并补抓。
 * 水雨情：今日日期映射缺失且已过常规抓取时点时重新分发爬取；
 * 水质：今日台账存在未完成区域时只补抓缺失部分，不额外增加整轮请求。
 */
@Slf4j
@Component
public class DownloadCatchUpRunner {

    // 站点 8 点发布数据、常规抓取在 9 点后；早于该时点的重启交给当日定时任务，避免抓到昨日数据
    private static final int CATCH_UP_AFTER_HOUR = 9;

    private static final List<String> WATER_TABLES = Arrays.asList(
            "hy_download_water_dj", "hy_download_water_sk", "hy_download_water_yq");

    @Autowired
    private WaterDownloadTask waterDownloadTask;

    @Autowired
    private WaterQualityDownloadService waterQualityDownloadService;

    @EventListener(ApplicationReadyEvent.class)
    public void onReady() {
        // 补偿爬取耗时长，放独立线程，不阻塞启动完成
        Thread t = new Thread(() -> {
            try {
                this.catchUpWater();
            } catch (Exception e) {
                log.error("水雨情启动补偿检查失败", e);
            }
            try {
                this.waterQualityDownloadService.resumeInterrupted();
            } catch (Exception e) {
                log.error("水质启动补偿失败", e);
            }
        }, "download-catch-up");
        t.setDaemon(true);
        t.start();
    }

    @SneakyThrows
    private void catchUpWater() {
        Boolean prod = SystemConfig.getWaterDownloadProd();
        if (!prod) return;
        if (DateUtil.hour(new Date(), true) < CATCH_UP_AFTER_HOUR) return;
        String today = DateUtil.today();
        List<Entity> rows = GetDbUtils.getDb().query(
                "select data_type from hy_download_water_date_mapping where data_date = ?", today);
        Set<String> doneTypes = rows.stream().map(e -> e.getStr("data_type")).collect(Collectors.toSet());
        List<String> missing = new ArrayList<>();
        for (String table : WATER_TABLES) {
            if (!doneTypes.contains(table)) missing.add(table);
        }
        if (missing.isEmpty()) return;
        log.info("水雨情启动补偿：今日数据缺失 {}，只补爬缺失站点", missing);
        this.waterDownloadTask.runCrawlTables(missing);
    }
}