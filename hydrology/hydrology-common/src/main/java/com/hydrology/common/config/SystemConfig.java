package com.hydrology.common.config;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.NumberUtil;
import cn.hutool.core.util.StrUtil;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.List;

/**
 * 读取项目相关配置
 *
 * @author hydrology
 */
@Component
@ConfigurationProperties(prefix = "system")
@Slf4j
public class SystemConfig {
    /**
     * 项目名称
     */
    private String name;

    /**
     * 版本
     */
    private String version;

    /**
     * 版权年份
     */
    private String copyrightYear;

    /**
     * 上传路径
     */
    @Getter
    private static String profile;

    /**
     * 获取地址开关
     */
    @Getter
    private static boolean addressEnabled;

    /**
     * 验证码类型
     */
    @Getter
    private static String captchaType;

    /**
     * 验证码模式 image 图片验证码 slider 滑块验证码
     */
    @Getter
    private static String captchaMode;


    /**
     * 系统是否生成环境
     */
    @Getter
    private static Boolean systemProd;

    /**
     * 水文信息下载地址
     */
    @Getter
    private static Boolean waterDownloadProd;

    @Getter
    private static String waterDownloadUrl;

    @Getter
    private static String waterDownloadToken;

    /**
     * 水质下载请求间隔下限（秒）：站点访问频率过大会封禁 IP，只允许调大不允许调小
     */
    @Getter
    private static Integer waterQualityIntervalMin = 30;

    /**
     * 水质下载请求间隔上限（秒）：实际间隔在上下限间随机抖动
     */
    @Getter
    private static Integer waterQualityIntervalMax = 75;

    /**
     * 水质下载熔断阈值：连续失败达到该次数中止本轮，避免持续请求导致 IP 进黑名单
     */
    @Getter
    private static Integer waterQualityCircuitBreakFailures = 5;

    /**
     * 上传路径
     */
    @Getter
    @Setter
    private static List<Long> permitPathHeaderValues;


    public static boolean checkPermitPathToken(String token) {
        if (StrUtil.isBlank(token)) {
            return false;
        }

        if (!NumberUtil.isNumber(token)) {
            return false;
        }
        return SystemConfig.getPermitPathHeaderValues().contains(Long.valueOf(token));
    }

    /**
     * 上传路径
     */
    @Getter
    private static List<String> excludePath;


    public void setExcludePath(List<String> excludePath) {
        SystemConfig.excludePath = excludePath;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getCopyrightYear() {
        return copyrightYear;
    }

    public void setCopyrightYear(String copyrightYear) {
        this.copyrightYear = copyrightYear;
    }

    public void setProfile(String profile) {
        if (StrUtil.isBlank(profile)) {
            SystemConfig.profile = System.getProperty("user.dir") + File.separator + "profile";
            FileUtil.mkdir(SystemConfig.profile);
        } else {
            SystemConfig.profile = profile;
        }
        log.info("文件存储路径 ---> {}", SystemConfig.profile);
    }

    public static String getRealPath(String path) {
        if (StrUtil.isBlank(path)) {
            throw new RuntimeException("传入文件不能为空");
        }
        if (path.contains("profile")) {
            return profile + path.split("profile")[1];
        }
        if ("/".equals(path.replace("\\", "/").substring(0, 1))) {
            return profile + path;
        }
        return profile + "/" + path;
    }

    public void setAddressEnabled(boolean addressEnabled) {
        SystemConfig.addressEnabled = addressEnabled;
    }

    public void setCaptchaType(String captchaType) {
        SystemConfig.captchaType = captchaType;
    }

    public void setCaptchaMode(String captchaMode) {
        SystemConfig.captchaMode = captchaMode;
    }


    public void setSystemProd(Boolean systemProd) {
        SystemConfig.systemProd = systemProd;
    }

    public void setWaterDownloadProd(Boolean waterDownloadProd) {
        SystemConfig.waterDownloadProd = waterDownloadProd;
    }

    public void setWaterDownloadUrl(String waterDownloadUrl) {
        SystemConfig.waterDownloadUrl = waterDownloadUrl;
    }

    public void setWaterDownloadToken(String waterDownloadToken) {
        SystemConfig.waterDownloadToken = waterDownloadToken;
    }

    public void setWaterQualityIntervalMin(Integer waterQualityIntervalMin) {
        SystemConfig.waterQualityIntervalMin = waterQualityIntervalMin;
    }

    public void setWaterQualityIntervalMax(Integer waterQualityIntervalMax) {
        SystemConfig.waterQualityIntervalMax = waterQualityIntervalMax;
    }

    public void setWaterQualityCircuitBreakFailures(Integer waterQualityCircuitBreakFailures) {
        SystemConfig.waterQualityCircuitBreakFailures = waterQualityCircuitBreakFailures;
    }

    /**
     * 获取导入上传路径
     */
    public static String getImportPath() {
        return getProfile() + "/import";
    }

    /**
     * 获取头像上传路径
     */
    public static String getAvatarPath() {
        return getProfile() + "/avatar";
    }

    /**
     * 获取下载路径
     */
    public static String getDownloadPath() {
        return getProfile() + "/download/";
    }

    /**
     * 获取上传路径
     */
    public static String getUploadPath() {
        return getProfile() + "/upload";
    }
}
