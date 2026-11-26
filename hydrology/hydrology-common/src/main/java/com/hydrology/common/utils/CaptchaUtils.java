package com.hydrology.common.utils;

import com.hydrology.common.config.SystemConfig;

/**
 * 验证码校验工具
 * 
 * @author hydrology
 */
public class CaptchaUtils
{
    /** 滑块验证码允许误差（像素） */
    public static final int SLIDER_TOLERANCE = 5;

    /**
     * 校验验证码：slider 模式比对滑块 x 坐标误差，image 模式比对字符
     *
     * @param stored 缓存中的验证码（字符或滑块目标 x 坐标）
     * @param code   用户提交的验证码（字符或滑块 x 坐标）
     * @return 是否匹配
     */
    public static boolean matches(String stored, String code)
    {
        if (StringUtils.isEmpty(code) || StringUtils.isEmpty(stored))
        {
            return false;
        }
        if ("slider".equals(SystemConfig.getCaptchaMode()))
        {
            try
            {
                return Math.abs(Integer.parseInt(code.trim()) - Integer.parseInt(stored.trim())) <= SLIDER_TOLERANCE;
            }
            catch (NumberFormatException e)
            {
                return false;
            }
        }
        return code.equalsIgnoreCase(stored);
    }
}