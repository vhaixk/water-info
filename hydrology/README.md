# 水质水雨情信息系统（后端）

基于 Spring Boot 多模块架构的水质水雨情信息管理系统后端，提供水雨情信息、水质信息、映射管理三个业务模块及系统管理底座。

## 模块结构

| 模块 | 职责 |
| --- | --- |
| hydrology-admin | 启动入口、Web 配置、接口文档 |
| hydrology-api | 业务模块：waterDownload（水雨情/水质数据下载与查询） |
| hydrology-framework | 安全认证、权限、数据源、拦截器 |
| hydrology-system | 系统管理（用户/角色/菜单/字典/配置） |
| hydrology-common | 通用工具、Redis 缓存、动态 CRUD（GetDbUtils）、系统配置 |
| hydrology-quartz | 定时任务调度（水雨情爬取、水质下载） |
| hydrology-generator | 代码生成与表元数据缓存（gen_table / gen_table_column） |

## 业务接口

- `/water/*`：水雨情树、字典映射、数据查询、过程线文件、原始数据导出、爬取触发
- `/waterQuality/*`：水质字典、数据查询、水质下载触发

## 外部依赖

- MySQL：`water_info` 库（本机 Docker 容器 water-info-mysql，端口 3308）
- Redis：localhost:16379，database 1
- 水雨情爬取服务：`waterDownloadUrl`（water-download 容器，端口 18883）
- 水质数据源：国家地表水水质自动监测实时数据发布系统（szzdjc.cnemc.cn）

## 构建与运行

```bash
mvn install -DskipTests -pl hydrology-admin -am
mvn spring-boot:run -pl hydrology-admin
```

- 开发端口：18890
- 配置文件：`hydrology-admin/src/main/resources/application-dev.yml`、`application-druid.yml`
- 启动初始化：`CommandLineUtils` 加载水雨情映射树与水质区域/流域缓存（依赖 `profile/water-download/water-quality/` 下 JSON）

## 数据库初始化

`sql/water_info_init.sql` 为完整初始化脚本（系统表 + 业务表 + 菜单 + 定时任务）。