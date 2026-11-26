# 水质水雨情信息系统（前端）

基于 Vue 3 + Element Plus + Vite 的水质水雨情信息管理系统前端，提供水雨情信息、水质信息、映射管理三个业务页面及系统管理底座。

## 业务页面

- 水雨情信息：大江大河 / 大型水库 / 雨水情监测数据查询、过程线查看、原始数据导出
- 水质信息：全国地表水水质断面监测数据查询、水质类别色标展示、导出
- 映射管理：测站与流域 / 河流 / 省份映射关系维护

## 开发

```bash
npm install
npm run dev
```

- 开发端口：18891
- 接口代理：`/dev-api` → `http://127.0.0.1:18890`（后端服务）

## 构建

```bash
npm run build:prod    # 生产环境，部署子路径 /water-info/web/
npm run build:stage   # 预发布环境
```

## 环境变量

| 变量 | 说明 | 开发环境 | 生产环境 |
| --- | --- | --- | --- |
| VITE_APP_TITLE | 页面标题 | 水质水雨情信息系统 | 水质水雨情信息系统 |
| VITE_APP_BASE_API | 接口前缀 | /dev-api | /water-info/prod |

## 目录说明

- `src/views/hydrology/water-download/`：三个业务页面
- `src/views/hydrology/shared/`：主题与全局样式（theme.js / chartTheme.js / styles）
- `src/views/system|monitor|tool/`：系统管理、监控、代码生成底座
- `src/components/TableComponent/`：通用表格 CRUD 组件
- `src/api/water-download/`：业务接口封装