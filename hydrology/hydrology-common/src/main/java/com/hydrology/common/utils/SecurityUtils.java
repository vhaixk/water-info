package com.hydrology.common.utils;

import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Db;
import cn.hutool.db.Entity;
import cn.hutool.extra.spring.SpringUtil;
import com.hydrology.common.constant.Constants;
import com.hydrology.common.constant.HttpStatus;
import com.hydrology.common.constant.RedisConstants;
import com.hydrology.common.core.domain.entity.SysRole;
import com.hydrology.common.core.domain.model.LoginUser;
import com.hydrology.common.core.redis.RedisCache;
import com.hydrology.common.exception.ServiceException;
import com.hydrology.common.utils.db.GetDbUtils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.util.PatternMatchUtils;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 安全服务工具类
 *
 * @author hydrology
 */
@Slf4j
public class SecurityUtils {

    /**
     * 用户ID
     **/
    public static Long getUserId() {
        try {
            return getLoginUser().getUserId();
        } catch (Exception e) {
            throw new ServiceException("获取用户ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取部门ID
     **/
    public static Long getDeptId() {
        try {
            return getLoginUser().getDeptId();
        } catch (Exception e) {
            throw new ServiceException("获取部门ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取用户账户
     **/
    public static String getUsername() {
        try {
            return getLoginUser().getUsername();
        } catch (Exception e) {
            log.debug("获取用户账户异常");
            return null;
            // throw new ServiceException("获取用户账户异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取用户
     **/
    public static LoginUser getLoginUser() {
        try {
            return (LoginUser) getAuthentication().getPrincipal();
        } catch (Exception e) {
            throw new ServiceException("获取用户信息异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取Authentication
     */
    public static Authentication getAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    /**
     * 生成BCryptPasswordEncoder密码
     *
     * @param password 密码
     * @return 加密字符串
     */
    public static String encryptPassword(String password) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        return passwordEncoder.encode(password);
    }

    /**
     * 判断密码是否相同
     *
     * @param rawPassword     真实密码
     * @param encodedPassword 加密后字符
     * @return 结果
     */
    public static boolean matchesPassword(String rawPassword, String encodedPassword) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    /**
     * 是否为管理员
     *
     * @return 结果
     */
    public static boolean isAdmin() {
        return isAdmin(getUserId());
    }

    /**
     * 是否为管理员
     *
     * @param userId 用户ID
     * @return 结果
     */
    public static boolean isAdmin(Long userId) {
        return userId != null && 1L == userId;
    }

    /**
     * 验证用户是否具备某权限
     *
     * @param permission 权限字符串
     * @return 用户是否具备某权限
     */
    public static boolean hasPermi(String permission) {
        return hasPermi(getLoginUser().getPermissions(), permission);
    }

    /**
     * 判断是否包含权限
     *
     * @param authorities 权限列表
     * @param permission  权限字符串
     * @return 用户是否具备某权限
     */
    public static boolean hasPermi(Collection<String> authorities, String permission) {
        return authorities.stream().filter(StringUtils::hasText)
                .anyMatch(x -> Constants.ALL_PERMISSION.equals(x) || PatternMatchUtils.simpleMatch(x, permission));
    }

    /**
     * 验证用户是否拥有某个角色
     *
     * @param role 角色标识
     * @return 用户是否具备某角色
     */
    public static boolean hasRole(String role) {
        List<SysRole> roleList = getLoginUser().getUser().getRoles();
        Collection<String> roles = roleList.stream().map(SysRole::getRoleKey).collect(Collectors.toSet());
        return hasRole(roles, role);
    }

    /**
     * 判断是否包含角色
     *
     * @param roles 角色列表
     * @param role  角色
     * @return 用户是否具备某角色权限
     */
    public static boolean hasRole(Collection<String> roles, String role) {
        return roles.stream().filter(StringUtils::hasText)
                .anyMatch(x -> Constants.SUPER_ADMIN.equals(x) || PatternMatchUtils.simpleMatch(x, role));
    }

    /**
     * 获取所有涉及电站id
     *
     */
    public static String getPowerIds() {

        try {
            return getLoginUser().getUser().getRolePowerId();
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return null;
    }

    /**
     * 获取所属系统
     *
     */
    public static String getSystemId() {

        return getLoginUser().getUser().getRoleSystemId();
    }


    /**
     * 获取所有涉及测站
     *
     */
    public static Map<String, Entity> getFStations() {

        String roleSystemId = getLoginUser().getUser().getRoleSystemId();
        if (StrUtil.isBlank(roleSystemId)) return new HashMap<>();
        String powerIds = getPowerIds();

        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Entity tokenMapping = redisCache.getCacheMap(RedisConstants.STATION_PREFIX + RedisConstants.TOKEN_MAPPING, Entity.class).get(roleSystemId);
        String fBaseMapping = tokenMapping.getStr("token_f_base_mapping");

        Map<String, Entity> fBaseMap = redisCache.getCacheMap(RedisConstants.STATION_PREFIX + fBaseMapping + "-" + powerIds, Entity.class);
        if (fBaseMap.isEmpty()) {
            return refreshFStation(fBaseMapping, powerIds);
        }
        return fBaseMap;

    }

    @SneakyThrows
    public static Map<String, Entity> refreshFStation(String fBaseMapping, String powerIds) {
        if (StrUtil.isBlank(powerIds)) return new HashMap<>();
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Db db = GetDbUtils.getDb();
        List<Entity> query = db.query(
                StrUtil.format(
                        "select * from {} where power_station_id in ({})",
                        fBaseMapping,
                        powerIds
                )
        );
        Map<String, Entity> groupData = CollectionUtils.getGroupDataOne(query, "station_f_id");
        redisCache.setCacheMap(RedisConstants.STATION_PREFIX + fBaseMapping, groupData, true);
        if (StrUtil.isNotBlank(powerIds)) {
            redisCache.setCacheMap(RedisConstants.STATION_PREFIX + fBaseMapping + "-" + powerIds, groupData, true);

        }
        return groupData;
    }

    /**
     * 获取所有涉及测点
     *
     */
    public static Map<String, Entity> getStations() {

        String roleSystemId = getLoginUser().getUser().getRoleSystemId();
        if (StrUtil.isBlank(roleSystemId)) return new HashMap<>();
        String powerIds = getPowerIds();
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Entity tokenMapping = redisCache.getCacheMap(RedisConstants.STATION_PREFIX + RedisConstants.TOKEN_MAPPING, Entity.class).get(roleSystemId);
        String baseMapping = tokenMapping.getStr("token_base_mapping");
        Map<String, Entity> baseMap = redisCache.getCacheMap(RedisConstants.STATION_PREFIX + baseMapping + "-" + powerIds, Entity.class);


        if (baseMap.isEmpty()) {
            return refreshStation(baseMapping, powerIds);
        }
        return baseMap;

    }

    @SneakyThrows
    public static Map<String, Entity> refreshStation(String baseMapping, String powerIds) {

        Set<String> strings = getFStations().keySet();
        if (strings.isEmpty()) return new HashMap<>();
        RedisCache redisCache = SpringUtil.getBean(RedisCache.class);
        Db db = GetDbUtils.getDb();

        List<Entity> query = db.query(
                StrUtil.format(
                        "select * from {} where station_f_id in ({})",
                        baseMapping,
                        String.join(",", strings)
                )
        );
        Map<String, Entity> groupData = CollectionUtils.getGroupDataOne(query, "station_id");
        redisCache.setCacheMap(RedisConstants.STATION_PREFIX + baseMapping, groupData, true);
        if (StrUtil.isNotBlank(powerIds)) {
            redisCache.setCacheMap(RedisConstants.STATION_PREFIX + baseMapping + "-" + powerIds, groupData, true);

        }
        return groupData;
    }


}
