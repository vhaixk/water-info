package com.hydrology.common.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexUtils {

    // 1. 定义正则表达式：只允许 汉字、英文字母、数字
    // \u4e00-\u9fa5 表示常用汉字范围
    private static final String ALLOWED_REGEX = "^[\\u4e00-\\u9fa5a-zA-Z0-9]+$";
    private static final Pattern ALLOWED_PATTERN = Pattern.compile(ALLOWED_REGEX);

    // 2. 定义清洗用的正则：匹配所有 非(汉字、字母、数字) 的字符
    // ^ 在 [] 内部表示“非”，即匹配所有特殊符号、括号、空格等
    private static final String CLEAN_REGEX = "[^\\u4e00-\\u9fa5a-zA-Z0-9]";
    private static final Pattern CLEAN_PATTERN = Pattern.compile(CLEAN_REGEX);

    /**
     * 方法一：校验字符串是否只包含中文、英文和数字
     * 不包含任何括号、符号或空格
     *
     * @param input 待校验的字符串
     * @return true 表示合规（纯净），false 表示包含特殊符号
     */
    public static boolean isValid(String input) {
        if (input == null || input.isEmpty()) {
            return false;
        }
        // 使用预编译的 Pattern 进行匹配
        Matcher matcher = ALLOWED_PATTERN.matcher(input);
        return matcher.matches();
    }

    /**
     * 方法二：清洗字符串，移除所有括号和特殊符号
     * 只保留中文、英文和数字
     *
     * @param input 待处理的字符串
     * @return 清洗后的纯净字符串
     */
    public static String cleanString(String input) {
        if (input == null || input.isEmpty()) {
            return "";
        }
        // 将所有“非白名单字符”替换为空字符串
        Matcher matcher = CLEAN_PATTERN.matcher(input);
        return matcher.replaceAll("");
    }

    // --- 测试主方法 ---
    public static void main(String[] args) {
        String[] tests = {
                "你好World123",       // 合规
                "Hello(世界)",        // 含括号
                "Test@2026",          // 含符号
                "数据-分析",          // 含符号
                "NoSymbol"            // 合规
        };

        for (String test : tests) {
            System.out.println("原串: " + test);
            System.out.println("  -> 校验结果: " + isValid(test));
            System.out.println("  -> 清洗结果: " + cleanString(test));
            System.out.println("--------------------");
        }
    }
}