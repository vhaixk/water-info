package com.hydrology.common.utils;

import com.github.houbb.opencc4j.util.ZhConverterUtil;

/**
 * 站名/流域名规范化：繁简转换 + 全角转半角 + 清洗，
 * 数据侧与映射侧使用同一规范化键，吸收 OCR 繁简/标点波动。
 */
public class StationNameUtils {

    /**
     * 繁体转简体（覆盖全量汉字，替代手工繁简表）
     */
    public static String toSimplified(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        return ZhConverterUtil.toSimple(input);
    }

    /**
     * 全角字符转半角，全角空格转普通空格
     */
    public static String fullToHalf(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        char[] chars = input.toCharArray();
        for (int i = 0; i < chars.length; i++) {
            if (chars[i] == '\u3000') {
                chars[i] = ' ';
            } else if (chars[i] >= '\uFF01' && chars[i] <= '\uFF5E') {
                chars[i] = (char) (chars[i] - 0xFEE0);
            }
        }
        return new String(chars);
    }

    /**
     * 规范化匹配键：繁简归一 + 全角转半角 + 仅保留汉字/字母/数字。
     * 例如 "黃石港"、"黄石港"、"黃石港 " 均归一为 "黄石港"。
     */
    public static String normalizeKey(String input) {
        if (input == null || input.isEmpty()) {
            return "";
        }
        return RegexUtils.cleanString(fullToHalf(toSimplified(input)));
    }
}