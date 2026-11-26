-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: water_info
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `date_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '日期格式化类型',
  `entity_dic_json` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '实体表字典json',
  `refresh_cache` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否需要刷新缓存',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000038 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
INSERT INTO `gen_table` VALUES (13,'hy_download_water_mapping_dj','大江大河站名映射表',NULL,NULL,'HyDownloadWaterMappingDj','crud','element-plus','com.hydrology.system','system','dj','大江大河站名映射','hydrology','0','/','{}','admin','2026-04-30 16:29:55','','2026-05-01 17:43:36',NULL,NULL,NULL,NULL),(14,'hy_download_water_mapping_sk','大型水库映射表',NULL,NULL,'HyDownloadWaterMappingSk','crud','element-plus','com.hydrology.system','system','sk','大型水库映射','hydrology','0','/','{}','admin','2026-04-30 16:29:55','','2026-05-01 17:43:23',NULL,NULL,NULL,NULL),(15,'hy_download_water_mapping_yq','雨水情映射表',NULL,NULL,'HyDownloadWaterMappingYq','crud','element-plus','com.hydrology.system','system','yq','雨水情映射','hydrology','0','/','{}','admin','2026-04-30 16:29:55','','2026-05-01 17:43:11',NULL,NULL,NULL,NULL),(17,'hy_download_water_date_mapping','时间对应的数据截图和excel',NULL,NULL,'HyDownloadWaterDateMapping','crud','','com.hydrology.system','system','mapping','时间对应的数据截图和excel','hydrology','0','/',NULL,'admin','2026-05-01 19:12:57','',NULL,NULL,NULL,NULL,NULL),(18,'hy_download_water_dj','大江大河',NULL,NULL,'HyDownloadWaterDj','crud','element-plus','com.hydrology.system','system','dj','大江大河','hydrology','0','/','{}','admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,NULL,NULL),(19,'hy_download_water_sk','大型水库',NULL,NULL,'HyDownloadWaterSk','crud','element-plus','com.hydrology.system','system','sk','大型水库','hydrology','0','/','{\"parentMenuId\":0}','admin','2026-05-02 09:15:00','','2026-05-02 14:16:29',NULL,NULL,NULL,NULL),(20,'hy_download_water_yq','重点雨水情',NULL,NULL,'HyDownloadWaterYq','crud','element-plus','com.hydrology.system','system','yq','重点雨水情','hydrology','0','/','{\"parentMenuId\":0}','admin','2026-05-02 09:15:01','','2026-05-02 14:16:42',NULL,NULL,NULL,NULL),(22,'hy_download_water_quality','水质监测数据',NULL,NULL,'HyDownloadWaterQuality','crud','','com.hydrology.system','system','quality','水质监测数据','hydrology','0','/',NULL,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `edit_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '编辑类型',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `date_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '日期格式化类型',
  `best_width` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '最佳宽度',
  `min_width` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '最小宽度',
  `align_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对齐方式',
  `fixed_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '固定列',
  `sort_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '排序方式',
  `sort_sort` int DEFAULT NULL COMMENT 'orderSort',
  `upload_number` int DEFAULT NULL COMMENT '数据上传数量',
  `edit_list` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '编辑列表是否显示',
  `column_remark` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '字段说明',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4000437 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
INSERT INTO `gen_table_column` VALUES (154,13,'basin_name','流域','varchar(32)','String','basinName','1','0','0','1','1','1','1','LIKE','input','input','',1,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:36',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(155,13,'river_name','河名','varchar(32)','String','riverName','1','0','0','1','1','1','1','LIKE','input','input','',2,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:36',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(156,13,'province_name','行政区划','varchar(32)','String','provinceName','1','0','0','1','1','1','1','LIKE','input','input','',3,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:36',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(157,13,'station_name','站名','varchar(32)','String','stationName','1','0','0','1','1','1','1','LIKE','input','input','',4,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:36',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(158,13,'station_name_alias','别名','varchar(32)','String','stationNameAlias','0','0','0','1','1','1',NULL,'EQ','input','input','',5,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:36',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(159,14,'basin_name','流域','varchar(32)','String','basinName','1','0','0','1','1','1','1','LIKE','input','input','',1,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:23',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(160,14,'river_name','河名','varchar(32)','String','riverName','1','0','0','1','1','1','1','LIKE','input','input','',2,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:23',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(161,14,'province_name','行政区划','varchar(32)','String','provinceName','1','0','0','1','1','1','1','LIKE','input','input','',3,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:23',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(162,14,'station_name','站名','varchar(32)','String','stationName','1','0','0','1','1','1','1','LIKE','input','input','',4,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:23',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(163,14,'station_name_alias','别名','varchar(32)','String','stationNameAlias','0','0','0','1','1','1',NULL,'EQ','input','input','',5,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:23',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(164,15,'basin_name','流域','varchar(32)','String','basinName','1','0','0','1','1','1','1','LIKE','input','input','',1,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:11',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(165,15,'river_name','河名','varchar(32)','String','riverName','1','0','0','1','1','1','1','LIKE','input','input','',2,'admin','2026-04-30 16:29:55','','2026-05-01 17:43:12',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(166,15,'province_name','行政区划','varchar(32)','String','provinceName','1','0','0','1','1','1','1','LIKE','input','input','',3,'admin','2026-04-30 16:29:56','','2026-05-01 17:43:12',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(167,15,'station_name','站名','varchar(32)','String','stationName','1','0','0','1','1','1','1','LIKE','input','input','',4,'admin','2026-04-30 16:29:56','','2026-05-01 17:43:12',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(168,15,'station_name_alias','别名','varchar(32)','String','stationNameAlias','0','0','0','1','1','1',NULL,'EQ','input','input','',5,'admin','2026-04-30 16:29:56','','2026-05-01 17:43:12',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(175,17,'data_date','数据日期','varchar(32)','String','dataDate','1','0','0','1',NULL,NULL,NULL,'BETWEEN','datetime','datetime','',1,'admin','2026-05-01 19:12:57','','2026-05-01 19:13:10','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(176,17,'data_type','数据类型','varchar(32)','String','dataType','1','0','0','1',NULL,NULL,NULL,'EQ','select','select','',2,'admin','2026-05-01 19:12:57','','2026-05-01 19:13:10',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(177,17,'data_excel_path','excel外部链接','varchar(500)','String','dataExcelPath','0','0','0','1','1','1',NULL,'EQ','textarea','textarea','',3,'admin','2026-05-01 19:12:57','','2026-05-01 19:13:10',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(178,17,'data_png_path','png外部链接','varchar(500)','String','dataPngPath','0','0','0','1','1','1',NULL,'EQ','textarea','textarea','',4,'admin','2026-05-01 19:12:57','','2026-05-01 19:13:10',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(179,17,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'BETWEEN','datetime','datetime','',5,'admin','2026-05-01 19:12:57','','2026-05-01 19:13:10','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(180,17,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'BETWEEN','datetime','datetime','',6,'admin','2026-05-01 19:12:57','','2026-05-01 19:13:10','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(181,18,'monitor_id','id','varchar(64)','String','monitorId','1','0','0','1',NULL,NULL,NULL,'EQ','input','input','',1,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(182,18,'station_name','站名','varchar(32)','String','stationName','0','0','0','1','1','1','1','LIKE','input','input','',2,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(183,18,'monitor_time','监测时间','datetime','Date','monitorTime','0','0','0','1','1','1',NULL,'BETWEEN','datetime','datetime','',3,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20','YYYY-MM-DD HH:mm',NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(184,18,'origin_monitor_time','(原)监测时间','varchar(32)','String','originMonitorTime','0','0','0','1','1','1',NULL,'EQ','input','input','',4,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(185,18,'monitor_value','水位(m)','decimal(10,2)','BigDecimal','monitorValue','0','0','0','1','1','1',NULL,'EQ','input','input','',5,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(186,18,'monitor_value_warn','警戒水位(m)','decimal(10,2)','BigDecimal','monitorValueWarn','0','0','0','1','1','1',NULL,'EQ','input','input','',6,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(187,18,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'BETWEEN','datetime','datetime','',7,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(188,18,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'BETWEEN','datetime','datetime','',8,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(189,18,'monitor_png_path','对应数据图片','varchar(255)','String','monitorPngPath','0','0','0','1','1','1',NULL,'EQ','input','input','',9,'admin','2026-05-01 22:34:41','','2026-05-02 14:16:20',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(190,19,'monitor_id','id','varchar(64)','String','monitorId','1','0','0','1',NULL,NULL,NULL,'EQ','input','input','',1,'admin','2026-05-02 09:15:00','','2026-05-02 14:16:29',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(191,19,'station_name','库名','varchar(32)','String','stationName','0','0','0','1','1','1','1','LIKE','input','input','',2,'admin','2026-05-02 09:15:00','','2026-05-02 14:16:29',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(192,19,'monitor_time','监测时间','datetime','Date','monitorTime','0','0','0','1','1','1',NULL,'BETWEEN','datetime','datetime','',3,'admin','2026-05-02 09:15:00','','2026-05-02 14:16:29','YYYY-MM-DD HH:mm',NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(193,19,'origin_monitor_time','(原)监测时间','varchar(32)','String','originMonitorTime','0','0','0','1','1','1',NULL,'EQ','input','input','',4,'admin','2026-05-02 09:15:00','','2026-05-02 14:16:29',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(194,19,'monitor_value','库水位(m)','decimal(10,2)','BigDecimal','monitorValue','0','0','0','1','1','1',NULL,'EQ','input','input','',5,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:30',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(195,19,'monitor_value_diff','日变幅(m)','decimal(10,2)','BigDecimal','monitorValueDiff','0','0','0','1','1','1',NULL,'EQ','input','input','',6,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:30',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(196,19,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'BETWEEN','datetime','datetime','',7,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:30','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(197,19,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'BETWEEN','datetime','datetime','',8,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:30','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(198,19,'monitor_png_path','对应数据图片','varchar(255)','String','monitorPngPath','0','0','0','1','1','1',NULL,'EQ','input','input','',9,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:30',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(199,20,'monitor_id','id','varchar(64)','String','monitorId','1','0','0','1',NULL,NULL,NULL,'EQ','input','input','',1,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:42',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'0',NULL),(200,20,'station_name','站名','varchar(32)','String','stationName','0','0','0','1','1','1','1','LIKE','input','input','',2,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:42',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(201,20,'monitor_time','监测时间','datetime','Date','monitorTime','0','0','0','1','1','1',NULL,'BETWEEN','datetime','datetime','',3,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:42','YYYY-MM-DD HH:mm',NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(202,20,'origin_monitor_time','(原)监测时间','varchar(32)','String','originMonitorTime','0','0','0','1','1','1',NULL,'EQ','input','input','',4,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:42',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(203,20,'monitor_value','日降雨(mm)','decimal(10,2)','BigDecimal','monitorValue','0','0','0','1','1','1',NULL,'EQ','input','input','',5,'admin','2026-05-02 09:15:01','','2026-05-02 14:16:42',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(204,20,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,'1',NULL,'BETWEEN','datetime','datetime','',6,'admin','2026-05-02 09:15:02','','2026-05-02 14:16:42','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(205,20,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1','1',NULL,'BETWEEN','datetime','datetime','',7,'admin','2026-05-02 09:15:02','','2026-05-02 14:16:42','YYYY-MM-DD HH:mm:ss',NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(206,20,'monitor_png_path','对应数据图片','varchar(255)','String','monitorPngPath','0','0','0','1','1','1',NULL,'EQ','input','input','',8,'admin','2026-05-02 09:15:02','','2026-05-02 14:16:42',NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(227,22,'wq_id','id','varchar(64)','String','wqId','1','0','0','1',NULL,NULL,NULL,'EQ','input','input','',1,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,NULL,NULL),(228,22,'wq_province','省','bigint','Long','wqProvince','0','0','0','1','1','1',NULL,'EQ','input','input','',2,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(229,22,'wq_city','市/区','bigint','Long','wqCity','0','0','0','1','1','1',NULL,'EQ','input','input','',3,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(230,22,'wq_basin','流域','varchar(64)','String','wqBasin','0','0','0','1','1','1',NULL,'EQ','input','input','',4,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(231,22,'wq_section_name','断面名称','varchar(64)','String','wqSectionName','0','0','0','1','1','1','1','LIKE','input','input','',5,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(232,22,'wq_monitor_time','监测时间','datetime','Date','wqMonitorTime','0','0','0','1','1','1',NULL,'BETWEEN','datetime','datetime','',6,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(233,22,'wq_monitor_time_origin','(原)监测时间','varchar(32)','String','wqMonitorTimeOrigin','0','0','0','1','1','1',NULL,'EQ','input','input','',7,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(234,22,'wq_type','水质类别','varchar(32)','String','wqType','0','0','0','1','1','1',NULL,'EQ','select','select','',8,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(235,22,'wq_temperature','水温(℃)','decimal(10,2)','BigDecimal','wqTemperature','0','0','0','1','1','1',NULL,'EQ','input','input','',9,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(236,22,'wq_ph','pH(无量纲)','decimal(10,2)','BigDecimal','wqPh','0','0','0','1','1','1',NULL,'EQ','input','input','',10,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(237,22,'wq_do','溶解氧(mg/L)','decimal(10,2)','BigDecimal','wqDo','0','0','0','1','1','1',NULL,'EQ','input','input','',11,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(238,22,'wq_ec','电导率(μS/cm)','decimal(10,2)','BigDecimal','wqEc','0','0','0','1','1','1',NULL,'EQ','input','input','',12,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(239,22,'wq_ntu','浊度(NTU)','decimal(10,2)','BigDecimal','wqNtu','0','0','0','1','1','1',NULL,'EQ','input','input','',13,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(240,22,'wq_permanganate','高锰酸盐指数(mg/L)','decimal(10,2)','BigDecimal','wqPermanganate','0','0','0','1','1','1',NULL,'EQ','input','input','',14,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(241,22,'wq_ammonia','氨氮(mg/L)','decimal(10,2)','BigDecimal','wqAmmonia','0','0','0','1','1','1',NULL,'EQ','input','input','',15,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(242,22,'wq_tp','总磷(mg/L)','decimal(10,2)','BigDecimal','wqTp','0','0','0','1','1','1',NULL,'EQ','input','input','',16,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(243,22,'wq_tn','总氮(mg/L)','decimal(10,2)','BigDecimal','wqTn','0','0','0','1','1','1',NULL,'EQ','input','input','',17,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(244,22,'wq_chla','叶绿素α(mg/L)','decimal(10,2)','BigDecimal','wqChla','0','0','0','1','1','1',NULL,'EQ','input','input','',18,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL),(245,22,'wq_algal','藻密度(cells/L)','decimal(10,2)','BigDecimal','wqAlgal','0','0','0','1','1','1',NULL,'EQ','input','input','',19,'admin','2026-05-12 16:57:58','',NULL,NULL,NULL,'120','center',NULL,NULL,NULL,NULL,'1',NULL);
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hy_download_water_basin_whitelist`
--

DROP TABLE IF EXISTS `hy_download_water_basin_whitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_basin_whitelist` (
  `basin_name` varchar(100) NOT NULL,
  PRIMARY KEY (`basin_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='水雨情流域白名单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hy_download_water_basin_whitelist`
--

LOCK TABLES `hy_download_water_basin_whitelist` WRITE;
/*!40000 ALTER TABLE `hy_download_water_basin_whitelist` DISABLE KEYS */;
INSERT INTO `hy_download_water_basin_whitelist` VALUES ('万泉河'),('三亚河'),('上饶以上'),('上饶到弋阳'),('世兜'),('乌江'),('克里雅诸小河流域'),('内陆'),('内陆河'),('内陆河湖'),('北江'),('南渡江'),('和田河流域'),('哈密吐鲁番地区诸河'),('嘉陵江'),('塔里木河'),('大凌河'),('太湖'),('太湖流域'),('太阳河'),('婺源以上'),('嫩江'),('宁远河'),('弋阳以下'),('弋阳到梅港'),('昌化江'),('晋江'),('望楼河'),('松花江'),('松花江吉林段'),('松花江流域'),('汉江'),('洞庭湖'),('流溪河'),('浙闽台河流'),('海河'),('海河流域'),('淮河'),('渤海岸'),('玛纳斯湖流域'),('珠江'),('白塔河'),('磨刀门'),('粤东沿海诸河'),('粤西沿海诸河'),('绕阳河'),('罗带河'),('艾比湖'),('萩芦溪'),('藤桥河'),('西江'),('辽河'),('辽河流域'),('鉴江'),('钱塘江'),('长上干'),('长江'),('长江流域'),('长江流域 区域'),('长江流域太湖区'),('闽东南诸河'),('闽东诸河'),('闽南沿海诸河'),('闽南诸河'),('闽江'),('陵水河'),('韩江'),('饶河'),('香屯以上'),('黄河'),('黄河流域'),('黑龙江'),('黑龙江流域');
/*!40000 ALTER TABLE `hy_download_water_basin_whitelist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hy_download_water_date_mapping`
--

DROP TABLE IF EXISTS `hy_download_water_date_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_date_mapping` (
  `data_date` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '数据日期',
  `data_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '数据类型',
  `data_excel_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'excel外部链接',
  `data_png_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'png外部链接',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`data_date`,`data_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='时间对应的数据截图和excel';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hy_download_water_date_mapping`
--

LOCK TABLES `hy_download_water_date_mapping` WRITE;
/*!40000 ALTER TABLE `hy_download_water_date_mapping` DISABLE KEYS */;
INSERT INTO `hy_download_water_date_mapping` VALUES ('2026-05-02','hy_download_water_dj','save_images/2026-05-02/11/大江大河.xlsx','save_images/2026-05-02/11/大江大河.png','2026-05-02 11:58:52','2026-05-02 11:58:52'),('2026-05-02','hy_download_water_sk','save_images/2026-05-02/11/大型水库.xlsx','save_images/2026-05-02/11/大型水库.png','2026-05-02 11:59:35','2026-05-02 11:59:35'),('2026-05-02','hy_download_water_yq','save_images/2026-05-02/11/重点雨水情.xlsx','save_images/2026-05-02/11/重点雨水情.png','2026-05-02 11:59:51','2026-05-02 11:59:51'),('2026-05-11','hy_download_water_dj','save_images/2026-05-11/16/大江大河.xlsx','save_images/2026-05-11/16/大江大河.png','2026-05-11 16:27:03','2026-05-11 16:27:03'),('2026-05-11','hy_download_water_sk','save_images/2026-05-11/16/大型水库.xlsx','save_images/2026-05-11/16/大型水库.png','2026-05-11 16:27:19','2026-05-11 16:27:19'),('2026-05-11','hy_download_water_yq','save_images/2026-05-11/16/重点雨水情.xlsx','save_images/2026-05-11/16/重点雨水情.png','2026-05-11 16:27:26','2026-05-11 16:27:26'),('2026-05-12','hy_download_water_dj','save_images/2026-05-12/10/大江大河.xlsx','save_images/2026-05-12/10/大江大河.png','2026-05-12 10:09:59','2026-05-12 10:09:59'),('2026-05-12','hy_download_water_sk','save_images/2026-05-12/10/大型水库.xlsx','save_images/2026-05-12/10/大型水库.png','2026-05-12 10:10:16','2026-05-12 10:10:16'),('2026-05-12','hy_download_water_yq','save_images/2026-05-12/10/重点雨水情.xlsx','save_images/2026-05-12/10/重点雨水情.png','2026-05-12 10:10:23','2026-05-12 10:10:23'),('2026-05-13','hy_download_water_dj','save_images/2026-05-13/10/大江大河.xlsx','save_images/2026-05-13/10/大江大河.png','2026-05-13 10:26:27','2026-05-13 10:26:27'),('2026-05-13','hy_download_water_sk','save_images/2026-05-13/10/大型水库.xlsx','save_images/2026-05-13/10/大型水库.png','2026-05-13 10:26:56','2026-05-13 10:26:56'),('2026-05-13','hy_download_water_yq','save_images/2026-05-13/10/重点雨水情.xlsx','save_images/2026-05-13/10/重点雨水情.png','2026-05-13 10:27:06','2026-05-13 10:27:06'),('2026-05-14','hy_download_water_dj','save_images/2026-05-14/10/大江大河.xlsx','save_images/2026-05-14/10/大江大河.png','2026-05-14 10:12:35','2026-05-14 10:12:35'),('2026-05-14','hy_download_water_sk','save_images/2026-05-14/10/大型水库.xlsx','save_images/2026-05-14/10/大型水库.png','2026-05-14 10:12:57','2026-05-14 10:12:57'),('2026-05-14','hy_download_water_yq','save_images/2026-05-14/10/重点雨水情.xlsx','save_images/2026-05-14/10/重点雨水情.png','2026-05-14 10:13:04','2026-05-14 10:13:04'),('2026-05-15','hy_download_water_dj','save_images/2026-05-15/10/大江大河.xlsx','save_images/2026-05-15/10/大江大河.png','2026-05-15 10:12:27','2026-05-15 10:12:27'),('2026-05-15','hy_download_water_sk','save_images/2026-05-15/10/大型水库.xlsx','save_images/2026-05-15/10/大型水库.png','2026-05-15 10:12:47','2026-05-15 10:12:47'),('2026-05-15','hy_download_water_yq','save_images/2026-05-15/10/重点雨水情.xlsx','save_images/2026-05-15/10/重点雨水情.png','2026-05-15 10:12:55','2026-05-15 10:12:55'),('2026-05-16','hy_download_water_dj','save_images/2026-05-16/10/大江大河.xlsx','save_images/2026-05-16/10/大江大河.png','2026-05-16 10:12:16','2026-05-16 10:12:16'),('2026-05-16','hy_download_water_sk','save_images/2026-05-16/10/大型水库.xlsx','save_images/2026-05-16/10/大型水库.png','2026-05-16 10:12:35','2026-05-16 10:12:35'),('2026-05-16','hy_download_water_yq','save_images/2026-05-16/10/重点雨水情.xlsx','save_images/2026-05-16/10/重点雨水情.png','2026-05-16 10:12:43','2026-05-16 10:12:43'),('2026-05-18','hy_download_water_dj','save_images/2026-05-18/10/大江大河.xlsx','save_images/2026-05-18/10/大江大河.png','2026-05-18 10:12:55','2026-05-18 10:12:55'),('2026-05-18','hy_download_water_sk','save_images/2026-05-18/10/大型水库.xlsx','save_images/2026-05-18/10/大型水库.png','2026-05-18 10:13:14','2026-05-18 10:13:14'),('2026-05-18','hy_download_water_yq','save_images/2026-05-18/10/重点雨水情.xlsx','save_images/2026-05-18/10/重点雨水情.png','2026-05-18 10:13:24','2026-05-18 10:13:24'),('2026-05-19','hy_download_water_dj','save_images/2026-05-19/10/大江大河.xlsx','save_images/2026-05-19/10/大江大河.png','2026-05-19 10:12:44','2026-05-19 10:12:44'),('2026-05-19','hy_download_water_sk','save_images/2026-05-19/10/大型水库.xlsx','save_images/2026-05-19/10/大型水库.png','2026-05-19 10:13:07','2026-05-19 10:13:07'),('2026-05-19','hy_download_water_yq','save_images/2026-05-19/10/重点雨水情.xlsx','save_images/2026-05-19/10/重点雨水情.png','2026-05-19 10:13:16','2026-05-19 10:13:16'),('2026-05-20','hy_download_water_dj','save_images/2026-05-20/10/大江大河.xlsx','save_images/2026-05-20/10/大江大河.png','2026-05-20 10:12:15','2026-05-20 10:12:15'),('2026-05-20','hy_download_water_sk','save_images/2026-05-20/10/大型水库.xlsx','save_images/2026-05-20/10/大型水库.png','2026-05-20 10:13:11','2026-05-20 10:13:11'),('2026-05-20','hy_download_water_yq','save_images/2026-05-20/10/重点雨水情.xlsx','save_images/2026-05-20/10/重点雨水情.png','2026-05-20 10:13:34','2026-05-20 10:13:34'),('2026-05-21','hy_download_water_dj','save_images/2026-05-21/10/大江大河.xlsx','save_images/2026-05-21/10/大江大河.png','2026-05-21 10:12:39','2026-05-21 10:12:39'),('2026-05-21','hy_download_water_sk','save_images/2026-05-21/10/大型水库.xlsx','save_images/2026-05-21/10/大型水库.png','2026-05-21 10:13:30','2026-05-21 10:13:30'),('2026-05-21','hy_download_water_yq','save_images/2026-05-21/10/重点雨水情.xlsx','save_images/2026-05-21/10/重点雨水情.png','2026-05-21 10:13:51','2026-05-21 10:13:51'),('2026-05-22','hy_download_water_dj','save_images/2026-05-22/10/大江大河.xlsx','save_images/2026-05-22/10/大江大河.png','2026-05-22 10:12:47','2026-05-22 10:12:47'),('2026-05-22','hy_download_water_sk','save_images/2026-05-22/10/大型水库.xlsx','save_images/2026-05-22/10/大型水库.png','2026-05-22 10:13:41','2026-05-22 10:13:41'),('2026-05-22','hy_download_water_yq','save_images/2026-05-22/10/重点雨水情.xlsx','save_images/2026-05-22/10/重点雨水情.png','2026-05-22 10:14:04','2026-05-22 10:14:04'),('2026-05-23','hy_download_water_dj','save_images/2026-05-23/10/大江大河.xlsx','save_images/2026-05-23/10/大江大河.png','2026-05-23 10:12:39','2026-05-23 10:12:39'),('2026-05-23','hy_download_water_sk','save_images/2026-05-23/10/大型水库.xlsx','save_images/2026-05-23/10/大型水库.png','2026-05-23 10:13:29','2026-05-23 10:13:29'),('2026-05-23','hy_download_water_yq','save_images/2026-05-23/10/重点雨水情.xlsx','save_images/2026-05-23/10/重点雨水情.png','2026-05-23 10:13:51','2026-05-23 10:13:51'),('2026-05-25','hy_download_water_dj','save_images/2026-05-25/10/大江大河.xlsx','save_images/2026-05-25/10/大江大河.png','2026-05-25 10:12:24','2026-05-25 10:12:24'),('2026-05-25','hy_download_water_sk','save_images/2026-05-25/10/大型水库.xlsx','save_images/2026-05-25/10/大型水库.png','2026-05-25 10:13:16','2026-05-25 10:13:16'),('2026-05-25','hy_download_water_yq','save_images/2026-05-25/10/重点雨水情.xlsx','save_images/2026-05-25/10/重点雨水情.png','2026-05-25 10:13:38','2026-05-25 10:13:38'),('2026-05-26','hy_download_water_dj','save_images/2026-05-26/10/大江大河.xlsx','save_images/2026-05-26/10/大江大河.png','2026-05-26 10:12:50','2026-05-26 10:12:50'),('2026-05-26','hy_download_water_sk','save_images/2026-05-26/10/大型水库.xlsx','save_images/2026-05-26/10/大型水库.png','2026-05-26 10:13:50','2026-05-26 10:13:50'),('2026-05-26','hy_download_water_yq','save_images/2026-05-26/10/重点雨水情.xlsx','save_images/2026-05-26/10/重点雨水情.png','2026-05-26 10:14:13','2026-05-26 10:14:13'),('2026-05-27','hy_download_water_dj','save_images/2026-05-27/10/大江大河.xlsx','save_images/2026-05-27/10/大江大河.png','2026-05-27 10:12:44','2026-05-27 10:12:44'),('2026-05-27','hy_download_water_sk','save_images/2026-05-27/10/大型水库.xlsx','save_images/2026-05-27/10/大型水库.png','2026-05-27 10:13:40','2026-05-27 10:13:40'),('2026-05-27','hy_download_water_yq','save_images/2026-05-27/10/重点雨水情.xlsx','save_images/2026-05-27/10/重点雨水情.png','2026-05-27 10:14:03','2026-05-27 10:14:03'),('2026-05-28','hy_download_water_dj','save_images/2026-05-28/10/大江大河.xlsx','save_images/2026-05-28/10/大江大河.png','2026-05-28 10:12:30','2026-05-28 10:12:30'),('2026-05-28','hy_download_water_sk','save_images/2026-05-28/10/大型水库.xlsx','save_images/2026-05-28/10/大型水库.png','2026-05-28 10:13:31','2026-05-28 10:13:31'),('2026-05-28','hy_download_water_yq','save_images/2026-05-28/10/重点雨水情.xlsx','save_images/2026-05-28/10/重点雨水情.png','2026-05-28 10:13:55','2026-05-28 10:13:55'),('2026-05-29','hy_download_water_dj','save_images/2026-05-29/10/大江大河.xlsx','save_images/2026-05-29/10/大江大河.png','2026-05-29 10:12:47','2026-05-29 10:12:47'),('2026-05-29','hy_download_water_sk','save_images/2026-05-29/10/大型水库.xlsx','save_images/2026-05-29/10/大型水库.png','2026-05-29 10:13:51','2026-05-29 10:13:51'),('2026-05-29','hy_download_water_yq','save_images/2026-05-29/10/重点雨水情.xlsx','save_images/2026-05-29/10/重点雨水情.png','2026-05-29 10:14:14','2026-05-29 10:14:14'),('2026-05-30','hy_download_water_dj','save_images/2026-05-30/10/大江大河.xlsx','save_images/2026-05-30/10/大江大河.png','2026-05-30 10:12:29','2026-05-30 10:12:29'),('2026-05-30','hy_download_water_sk','save_images/2026-05-30/10/大型水库.xlsx','save_images/2026-05-30/10/大型水库.png','2026-05-30 10:13:22','2026-05-30 10:13:22'),('2026-05-30','hy_download_water_yq','save_images/2026-05-30/10/重点雨水情.xlsx','save_images/2026-05-30/10/重点雨水情.png','2026-05-30 10:13:43','2026-05-30 10:13:43'),('2026-05-31','hy_download_water_dj','save_images/2026-05-31/10/大江大河.xlsx','save_images/2026-05-31/10/大江大河.png','2026-05-31 10:12:25','2026-05-31 10:12:25'),('2026-05-31','hy_download_water_sk','save_images/2026-05-31/10/大型水库.xlsx','save_images/2026-05-31/10/大型水库.png','2026-05-31 10:13:18','2026-05-31 10:13:18'),('2026-05-31','hy_download_water_yq','save_images/2026-05-31/10/重点雨水情.xlsx','save_images/2026-05-31/10/重点雨水情.png','2026-05-31 10:13:41','2026-05-31 10:13:41'),('2026-06-01','hy_download_water_dj','save_images/2026-06-01/10/大江大河.xlsx','save_images/2026-06-01/10/大江大河.png','2026-06-01 10:13:10','2026-06-01 10:13:10'),('2026-06-01','hy_download_water_sk','save_images/2026-06-01/10/大型水库.xlsx','save_images/2026-06-01/10/大型水库.png','2026-06-01 10:14:03','2026-06-01 10:14:03'),('2026-06-01','hy_download_water_yq','save_images/2026-06-01/10/重点雨水情.xlsx','save_images/2026-06-01/10/重点雨水情.png','2026-06-01 10:14:26','2026-06-01 10:14:26'),('2026-06-02','hy_download_water_dj','save_images/2026-06-02/10/大江大河.xlsx','save_images/2026-06-02/10/大江大河.png','2026-06-02 10:12:42','2026-06-02 10:12:42'),('2026-06-02','hy_download_water_sk','save_images/2026-06-02/10/大型水库.xlsx','save_images/2026-06-02/10/大型水库.png','2026-06-02 10:13:40','2026-06-02 10:13:40'),('2026-06-02','hy_download_water_yq','save_images/2026-06-02/10/重点雨水情.xlsx','save_images/2026-06-02/10/重点雨水情.png','2026-06-02 10:14:03','2026-06-02 10:14:03'),('2026-06-03','hy_download_water_dj','save_images/2026-06-03/10/大江大河.xlsx','save_images/2026-06-03/10/大江大河.png','2026-06-03 10:13:08','2026-06-03 10:13:08'),('2026-06-03','hy_download_water_sk','save_images/2026-06-03/10/大型水库.xlsx','save_images/2026-06-03/10/大型水库.png','2026-06-03 10:14:01','2026-06-03 10:14:01'),('2026-06-03','hy_download_water_yq','save_images/2026-06-03/10/重点雨水情.xlsx','save_images/2026-06-03/10/重点雨水情.png','2026-06-03 10:14:22','2026-06-03 10:14:22'),('2026-06-04','hy_download_water_dj','save_images/2026-06-04/10/大江大河.xlsx','save_images/2026-06-04/10/大江大河.png','2026-06-04 10:13:17','2026-06-04 10:13:17'),('2026-06-04','hy_download_water_sk','save_images/2026-06-04/10/大型水库.xlsx','save_images/2026-06-04/10/大型水库.png','2026-06-04 10:14:11','2026-06-04 10:14:11'),('2026-06-04','hy_download_water_yq','save_images/2026-06-04/10/重点雨水情.xlsx','save_images/2026-06-04/10/重点雨水情.png','2026-06-04 10:14:30','2026-06-04 10:14:30'),('2026-06-05','hy_download_water_dj','save_images/2026-06-05/10/大江大河.xlsx','save_images/2026-06-05/10/大江大河.png','2026-06-05 10:13:07','2026-06-05 10:13:07'),('2026-06-05','hy_download_water_sk','save_images/2026-06-05/10/大型水库.xlsx','save_images/2026-06-05/10/大型水库.png','2026-06-05 10:14:00','2026-06-05 10:14:00'),('2026-06-05','hy_download_water_yq','save_images/2026-06-05/10/重点雨水情.xlsx','save_images/2026-06-05/10/重点雨水情.png','2026-06-05 10:14:24','2026-06-05 10:14:24'),('2026-06-06','hy_download_water_dj','save_images/2026-06-06/10/大江大河.xlsx','save_images/2026-06-06/10/大江大河.png','2026-06-06 10:12:36','2026-06-06 10:12:36'),('2026-06-06','hy_download_water_sk','save_images/2026-06-06/10/大型水库.xlsx','save_images/2026-06-06/10/大型水库.png','2026-06-06 10:13:33','2026-06-06 10:13:33'),('2026-06-06','hy_download_water_yq','save_images/2026-06-06/10/重点雨水情.xlsx','save_images/2026-06-06/10/重点雨水情.png','2026-06-06 10:13:56','2026-06-06 10:13:56'),('2026-06-07','hy_download_water_dj','save_images/2026-06-07/10/大江大河.xlsx','save_images/2026-06-07/10/大江大河.png','2026-06-07 10:12:58','2026-06-07 10:12:58'),('2026-06-07','hy_download_water_sk','save_images/2026-06-07/10/大型水库.xlsx','save_images/2026-06-07/10/大型水库.png','2026-06-07 10:13:52','2026-06-07 10:13:52'),('2026-06-07','hy_download_water_yq','save_images/2026-06-07/10/重点雨水情.xlsx','save_images/2026-06-07/10/重点雨水情.png','2026-06-07 10:14:15','2026-06-07 10:14:15'),('2026-06-08','hy_download_water_dj','save_images/2026-06-08/10/大江大河.xlsx','save_images/2026-06-08/10/大江大河.png','2026-06-08 10:13:31','2026-06-08 10:13:31'),('2026-06-08','hy_download_water_sk','save_images/2026-06-08/10/大型水库.xlsx','save_images/2026-06-08/10/大型水库.png','2026-06-08 10:14:24','2026-06-08 10:14:24'),('2026-06-08','hy_download_water_yq','save_images/2026-06-08/10/重点雨水情.xlsx','save_images/2026-06-08/10/重点雨水情.png','2026-06-08 10:14:46','2026-06-08 10:14:46'),('2026-06-09','hy_download_water_dj','save_images/2026-06-09/10/大江大河.xlsx','save_images/2026-06-09/10/大江大河.png','2026-06-09 10:13:15','2026-06-09 10:13:15'),('2026-06-09','hy_download_water_sk','save_images/2026-06-09/10/大型水库.xlsx','save_images/2026-06-09/10/大型水库.png','2026-06-09 10:14:05','2026-06-09 10:14:05'),('2026-06-09','hy_download_water_yq','save_images/2026-06-09/10/重点雨水情.xlsx','save_images/2026-06-09/10/重点雨水情.png','2026-06-09 10:14:20','2026-06-09 10:14:20'),('2026-06-11','hy_download_water_dj','save_images/2026-06-11/10/大江大河.xlsx','save_images/2026-06-11/10/大江大河.png','2026-06-11 10:12:38','2026-06-11 10:12:38'),('2026-06-11','hy_download_water_sk','save_images/2026-06-11/10/大型水库.xlsx','save_images/2026-06-11/10/大型水库.png','2026-06-11 10:13:34','2026-06-11 10:13:34'),('2026-06-11','hy_download_water_yq','save_images/2026-06-11/10/重点雨水情.xlsx','save_images/2026-06-11/10/重点雨水情.png','2026-06-11 10:13:58','2026-06-11 10:13:58'),('2026-06-12','hy_download_water_dj','save_images/2026-06-12/10/大江大河.xlsx','save_images/2026-06-12/10/大江大河.png','2026-06-12 10:12:35','2026-06-12 10:12:35'),('2026-06-12','hy_download_water_sk','save_images/2026-06-12/10/大型水库.xlsx','save_images/2026-06-12/10/大型水库.png','2026-06-12 10:13:35','2026-06-12 10:13:35'),('2026-06-12','hy_download_water_yq','save_images/2026-06-12/10/重点雨水情.xlsx','save_images/2026-06-12/10/重点雨水情.png','2026-06-12 10:13:58','2026-06-12 10:13:58'),('2026-06-13','hy_download_water_dj','save_images/2026-06-13/10/大江大河.xlsx','save_images/2026-06-13/10/大江大河.png','2026-06-13 10:12:50','2026-06-13 10:12:50'),('2026-06-13','hy_download_water_sk','save_images/2026-06-13/10/大型水库.xlsx','save_images/2026-06-13/10/大型水库.png','2026-06-13 10:13:49','2026-06-13 10:13:49'),('2026-06-13','hy_download_water_yq','save_images/2026-06-13/10/重点雨水情.xlsx','save_images/2026-06-13/10/重点雨水情.png','2026-06-13 10:14:11','2026-06-13 10:14:11'),('2026-06-14','hy_download_water_dj','save_images/2026-06-14/10/大江大河.xlsx','save_images/2026-06-14/10/大江大河.png','2026-06-14 10:12:50','2026-06-14 10:12:50'),('2026-06-14','hy_download_water_sk','save_images/2026-06-14/10/大型水库.xlsx','save_images/2026-06-14/10/大型水库.png','2026-06-14 10:13:42','2026-06-14 10:13:42'),('2026-06-14','hy_download_water_yq','save_images/2026-06-14/10/重点雨水情.xlsx','save_images/2026-06-14/10/重点雨水情.png','2026-06-14 10:14:05','2026-06-14 10:14:05'),('2026-06-15','hy_download_water_dj','save_images/2026-06-15/10/大江大河.xlsx','save_images/2026-06-15/10/大江大河.png','2026-06-15 10:13:11','2026-06-15 10:13:11'),('2026-06-15','hy_download_water_sk','save_images/2026-06-15/10/大型水库.xlsx','save_images/2026-06-15/10/大型水库.png','2026-06-15 10:14:04','2026-06-15 10:14:04'),('2026-06-15','hy_download_water_yq','save_images/2026-06-15/10/重点雨水情.xlsx','save_images/2026-06-15/10/重点雨水情.png','2026-06-15 10:14:28','2026-06-15 10:14:28'),('2026-06-16','hy_download_water_dj','save_images/2026-06-16/10/大江大河.xlsx','save_images/2026-06-16/10/大江大河.png','2026-06-16 10:12:57','2026-06-16 10:12:57'),('2026-06-16','hy_download_water_sk','save_images/2026-06-16/10/大型水库.xlsx','save_images/2026-06-16/10/大型水库.png','2026-06-16 10:13:51','2026-06-16 10:13:51'),('2026-06-16','hy_download_water_yq','save_images/2026-06-16/10/重点雨水情.xlsx','save_images/2026-06-16/10/重点雨水情.png','2026-06-16 10:14:14','2026-06-16 10:14:14'),('2026-06-17','hy_download_water_dj','save_images/2026-06-17/10/大江大河.xlsx','save_images/2026-06-17/10/大江大河.png','2026-06-17 10:13:46','2026-06-17 10:13:46'),('2026-06-17','hy_download_water_sk','save_images/2026-06-17/10/大型水库.xlsx','save_images/2026-06-17/10/大型水库.png','2026-06-17 10:14:45','2026-06-17 10:14:45'),('2026-06-17','hy_download_water_yq','save_images/2026-06-17/10/重点雨水情.xlsx','save_images/2026-06-17/10/重点雨水情.png','2026-06-17 10:15:09','2026-06-17 10:15:09'),('2026-06-18','hy_download_water_dj','save_images/2026-06-18/10/大江大河.xlsx','save_images/2026-06-18/10/大江大河.png','2026-06-18 10:12:51','2026-06-18 10:12:51'),('2026-06-18','hy_download_water_sk','save_images/2026-06-18/10/大型水库.xlsx','save_images/2026-06-18/10/大型水库.png','2026-06-18 10:13:45','2026-06-18 10:13:45'),('2026-06-18','hy_download_water_yq','save_images/2026-06-18/10/重点雨水情.xlsx','save_images/2026-06-18/10/重点雨水情.png','2026-06-18 10:14:07','2026-06-18 10:14:07'),('2026-06-19','hy_download_water_dj','save_images/2026-06-19/10/大江大河.xlsx','save_images/2026-06-19/10/大江大河.png','2026-06-19 10:13:01','2026-06-19 10:13:01'),('2026-06-19','hy_download_water_sk','save_images/2026-06-19/10/大型水库.xlsx','save_images/2026-06-19/10/大型水库.png','2026-06-19 10:13:55','2026-06-19 10:13:55'),('2026-06-19','hy_download_water_yq','save_images/2026-06-19/10/重点雨水情.xlsx','save_images/2026-06-19/10/重点雨水情.png','2026-06-19 10:14:16','2026-06-19 10:14:16'),('2026-06-20','hy_download_water_dj','save_images/2026-06-20/10/大江大河.xlsx','save_images/2026-06-20/10/大江大河.png','2026-06-20 10:13:07','2026-06-20 10:13:07'),('2026-06-20','hy_download_water_sk','save_images/2026-06-20/10/大型水库.xlsx','save_images/2026-06-20/10/大型水库.png','2026-06-20 10:14:00','2026-06-20 10:14:00'),('2026-06-20','hy_download_water_yq','save_images/2026-06-20/10/重点雨水情.xlsx','save_images/2026-06-20/10/重点雨水情.png','2026-06-20 10:14:20','2026-06-20 10:14:20'),('2026-06-21','hy_download_water_dj','save_images/2026-06-21/10/大江大河.xlsx','save_images/2026-06-21/10/大江大河.png','2026-06-21 10:13:14','2026-06-21 10:13:14'),('2026-06-21','hy_download_water_sk','save_images/2026-06-21/10/大型水库.xlsx','save_images/2026-06-21/10/大型水库.png','2026-06-21 10:14:06','2026-06-21 10:14:06'),('2026-06-21','hy_download_water_yq','save_images/2026-06-21/10/重点雨水情.xlsx','save_images/2026-06-21/10/重点雨水情.png','2026-06-21 10:14:28','2026-06-21 10:14:28'),('2026-06-22','hy_download_water_dj','save_images/2026-06-22/10/大江大河.xlsx','save_images/2026-06-22/10/大江大河.png','2026-06-22 10:12:46','2026-06-22 10:12:46'),('2026-06-22','hy_download_water_sk','save_images/2026-06-22/10/大型水库.xlsx','save_images/2026-06-22/10/大型水库.png','2026-06-22 10:13:37','2026-06-22 10:13:37'),('2026-06-22','hy_download_water_yq','save_images/2026-06-22/10/重点雨水情.xlsx','save_images/2026-06-22/10/重点雨水情.png','2026-06-22 10:13:58','2026-06-22 10:13:58'),('2026-06-23','hy_download_water_dj','save_images/2026-06-23/10/大江大河.xlsx','save_images/2026-06-23/10/大江大河.png','2026-06-23 10:12:50','2026-06-23 10:12:50'),('2026-06-23','hy_download_water_sk','save_images/2026-06-23/10/大型水库.xlsx','save_images/2026-06-23/10/大型水库.png','2026-06-23 10:13:48','2026-06-23 10:13:48'),('2026-06-23','hy_download_water_yq','save_images/2026-06-23/10/重点雨水情.xlsx','save_images/2026-06-23/10/重点雨水情.png','2026-06-23 10:14:09','2026-06-23 10:14:09'),('2026-06-24','hy_download_water_dj','save_images/2026-06-24/10/大江大河.xlsx','save_images/2026-06-24/10/大江大河.png','2026-06-24 10:13:00','2026-06-24 10:13:00'),('2026-06-24','hy_download_water_sk','save_images/2026-06-24/10/大型水库.xlsx','save_images/2026-06-24/10/大型水库.png','2026-06-24 10:13:51','2026-06-24 10:13:51'),('2026-06-24','hy_download_water_yq','save_images/2026-06-24/10/重点雨水情.xlsx','save_images/2026-06-24/10/重点雨水情.png','2026-06-24 10:14:13','2026-06-24 10:14:13'),('2026-06-25','hy_download_water_dj','save_images/2026-06-25/10/大江大河.xlsx','save_images/2026-06-25/10/大江大河.png','2026-06-25 10:13:03','2026-06-25 10:13:03'),('2026-06-25','hy_download_water_sk','save_images/2026-06-25/10/大型水库.xlsx','save_images/2026-06-25/10/大型水库.png','2026-06-25 10:13:52','2026-06-25 10:13:52'),('2026-06-25','hy_download_water_yq','save_images/2026-06-25/10/重点雨水情.xlsx','save_images/2026-06-25/10/重点雨水情.png','2026-06-25 10:14:14','2026-06-25 10:14:14'),('2026-06-26','hy_download_water_dj','save_images/2026-06-26/10/大江大河.xlsx','save_images/2026-06-26/10/大江大河.png','2026-06-26 10:13:13','2026-06-26 10:13:13'),('2026-06-26','hy_download_water_sk','save_images/2026-06-26/10/大型水库.xlsx','save_images/2026-06-26/10/大型水库.png','2026-06-26 10:14:05','2026-06-26 10:14:05'),('2026-06-26','hy_download_water_yq','save_images/2026-06-26/10/重点雨水情.xlsx','save_images/2026-06-26/10/重点雨水情.png','2026-06-26 10:14:25','2026-06-26 10:14:25'),('2026-06-30','hy_download_water_dj','save_images/2026-06-30/10/大江大河.xlsx','save_images/2026-06-30/10/大江大河.png','2026-06-30 10:13:45','2026-06-30 10:13:45'),('2026-06-30','hy_download_water_sk','save_images/2026-06-30/10/大型水库.xlsx','save_images/2026-06-30/10/大型水库.png','2026-06-30 10:14:43','2026-06-30 10:14:43'),('2026-06-30','hy_download_water_yq','save_images/2026-06-30/10/重点雨水情.xlsx','save_images/2026-06-30/10/重点雨水情.png','2026-06-30 10:15:07','2026-06-30 10:15:07'),('2026-07-01','hy_download_water_dj','save_images/2026-07-01/10/大江大河.xlsx','save_images/2026-07-01/10/大江大河.png','2026-07-01 10:13:31','2026-07-01 10:13:31'),('2026-07-01','hy_download_water_sk','save_images/2026-07-01/10/大型水库.xlsx','save_images/2026-07-01/10/大型水库.png','2026-07-01 10:14:01','2026-07-01 10:14:01'),('2026-07-01','hy_download_water_yq','save_images/2026-07-01/10/重点雨水情.xlsx','save_images/2026-07-01/10/重点雨水情.png','2026-07-01 10:14:10','2026-07-01 10:14:10'),('2026-07-02','hy_download_water_dj','save_images/2026-07-02/10/大江大河.xlsx','save_images/2026-07-02/10/大江大河.png','2026-07-02 10:12:50','2026-07-02 10:12:50'),('2026-07-02','hy_download_water_sk','save_images/2026-07-02/10/大型水库.xlsx','save_images/2026-07-02/10/大型水库.png','2026-07-02 10:13:50','2026-07-02 10:13:50'),('2026-07-02','hy_download_water_yq','save_images/2026-07-02/10/重点雨水情.xlsx','save_images/2026-07-02/10/重点雨水情.png','2026-07-02 10:14:13','2026-07-02 10:14:13'),('2026-07-03','hy_download_water_dj','save_images/2026-07-03/10/大江大河.xlsx','save_images/2026-07-03/10/大江大河.png','2026-07-03 10:13:27','2026-07-03 10:13:27'),('2026-07-03','hy_download_water_sk','save_images/2026-07-03/10/大型水库.xlsx','save_images/2026-07-03/10/大型水库.png','2026-07-03 10:14:21','2026-07-03 10:14:21'),('2026-07-03','hy_download_water_yq','save_images/2026-07-03/10/重点雨水情.xlsx','save_images/2026-07-03/10/重点雨水情.png','2026-07-03 10:14:43','2026-07-03 10:14:43'),('2026-07-04','hy_download_water_dj','save_images/2026-07-04/10/大江大河.xlsx','save_images/2026-07-04/10/大江大河.png','2026-07-04 10:13:08','2026-07-04 10:13:08'),('2026-07-04','hy_download_water_sk','save_images/2026-07-04/10/大型水库.xlsx','save_images/2026-07-04/10/大型水库.png','2026-07-04 10:13:58','2026-07-04 10:13:58'),('2026-07-04','hy_download_water_yq','save_images/2026-07-04/10/重点雨水情.xlsx','save_images/2026-07-04/10/重点雨水情.png','2026-07-04 10:14:21','2026-07-04 10:14:21'),('2026-07-05','hy_download_water_dj','save_images/2026-07-05/10/大江大河.xlsx','save_images/2026-07-05/10/大江大河.png','2026-07-05 10:13:47','2026-07-05 10:13:47'),('2026-07-05','hy_download_water_sk','save_images/2026-07-05/10/大型水库.xlsx','save_images/2026-07-05/10/大型水库.png','2026-07-05 10:14:40','2026-07-05 10:14:40'),('2026-07-05','hy_download_water_yq','save_images/2026-07-05/10/重点雨水情.xlsx','save_images/2026-07-05/10/重点雨水情.png','2026-07-05 10:15:03','2026-07-05 10:15:03'),('2026-07-06','hy_download_water_dj','save_images/2026-07-06/10/大江大河.xlsx','save_images/2026-07-06/10/大江大河.png','2026-07-06 10:13:12','2026-07-06 10:13:12'),('2026-07-06','hy_download_water_sk','save_images/2026-07-06/10/大型水库.xlsx','save_images/2026-07-06/10/大型水库.png','2026-07-06 10:14:04','2026-07-06 10:14:04'),('2026-07-06','hy_download_water_yq','save_images/2026-07-06/10/重点雨水情.xlsx','save_images/2026-07-06/10/重点雨水情.png','2026-07-06 10:14:26','2026-07-06 10:14:26'),('2026-07-08','hy_download_water_dj','save_images/2026-07-08/10/大江大河.xlsx','save_images/2026-07-08/10/大江大河.png','2026-07-08 10:13:23','2026-07-08 10:13:23'),('2026-07-08','hy_download_water_sk','save_images/2026-07-08/10/大型水库.xlsx','save_images/2026-07-08/10/大型水库.png','2026-07-08 10:14:19','2026-07-08 10:14:19'),('2026-07-08','hy_download_water_yq','save_images/2026-07-08/10/重点雨水情.xlsx','save_images/2026-07-08/10/重点雨水情.png','2026-07-08 10:14:40','2026-07-08 10:14:40'),('2026-07-09','hy_download_water_dj','save_images/2026-07-09/10/大江大河.xlsx','save_images/2026-07-09/10/大江大河.png','2026-07-09 10:13:12','2026-07-09 10:13:12'),('2026-07-09','hy_download_water_sk','save_images/2026-07-09/10/大型水库.xlsx','save_images/2026-07-09/10/大型水库.png','2026-07-09 10:14:05','2026-07-09 10:14:05'),('2026-07-09','hy_download_water_yq','save_images/2026-07-09/10/重点雨水情.xlsx','save_images/2026-07-09/10/重点雨水情.png','2026-07-09 10:14:27','2026-07-09 10:14:27'),('2026-07-10','hy_download_water_dj','save_images/2026-07-10/10/大江大河.xlsx','save_images/2026-07-10/10/大江大河.png','2026-07-10 10:13:11','2026-07-10 10:13:11'),('2026-07-10','hy_download_water_sk','save_images/2026-07-10/10/大型水库.xlsx','save_images/2026-07-10/10/大型水库.png','2026-07-10 10:14:06','2026-07-10 10:14:06'),('2026-07-10','hy_download_water_yq','save_images/2026-07-10/10/重点雨水情.xlsx','save_images/2026-07-10/10/重点雨水情.png','2026-07-10 10:14:29','2026-07-10 10:14:29'),('2026-07-11','hy_download_water_dj','save_images/2026-07-11/10/大江大河.xlsx','save_images/2026-07-11/10/大江大河.png','2026-07-11 10:13:04','2026-07-11 10:13:04'),('2026-07-11','hy_download_water_sk','save_images/2026-07-11/10/大型水库.xlsx','save_images/2026-07-11/10/大型水库.png','2026-07-11 10:13:56','2026-07-11 10:13:56'),('2026-07-11','hy_download_water_yq','save_images/2026-07-11/10/重点雨水情.xlsx','save_images/2026-07-11/10/重点雨水情.png','2026-07-11 10:14:18','2026-07-11 10:14:18'),('2026-07-12','hy_download_water_dj','save_images/2026-07-12/10/大江大河.xlsx','save_images/2026-07-12/10/大江大河.png','2026-07-12 10:15:26','2026-07-12 10:15:26'),('2026-07-13','hy_download_water_dj','save_images/2026-07-13/10/大江大河.xlsx','save_images/2026-07-13/10/大江大河.png','2026-07-13 10:13:13','2026-07-13 10:13:13'),('2026-07-13','hy_download_water_sk','save_images/2026-07-13/10/大型水库.xlsx','save_images/2026-07-13/10/大型水库.png','2026-07-13 10:14:08','2026-07-13 10:14:08'),('2026-07-13','hy_download_water_yq','save_images/2026-07-13/10/重点雨水情.xlsx','save_images/2026-07-13/10/重点雨水情.png','2026-07-13 10:14:31','2026-07-13 10:14:31'),('2026-07-15','hy_download_water_dj','save_images/2026-07-15/10/大江大河.xlsx','save_images/2026-07-15/10/大江大河.png','2026-07-15 10:15:29','2026-07-15 10:15:29'),('2026-07-15','hy_download_water_sk','save_images/2026-07-15/10/大型水库.xlsx','save_images/2026-07-15/10/大型水库.png','2026-07-15 10:16:29','2026-07-15 10:16:29'),('2026-07-15','hy_download_water_yq','save_images/2026-07-15/10/重点雨水情.xlsx','save_images/2026-07-15/10/重点雨水情.png','2026-07-15 10:16:50','2026-07-15 10:16:50'),('2026-07-16','hy_download_water_dj','save_images/2026-07-16/10/大江大河.xlsx','save_images/2026-07-16/10/大江大河.png','2026-07-16 10:13:23','2026-07-16 10:13:23'),('2026-07-16','hy_download_water_sk','save_images/2026-07-16/10/大型水库.xlsx','save_images/2026-07-16/10/大型水库.png','2026-07-16 10:14:17','2026-07-16 10:14:17'),('2026-07-16','hy_download_water_yq','save_images/2026-07-16/10/重点雨水情.xlsx','save_images/2026-07-16/10/重点雨水情.png','2026-07-16 10:14:40','2026-07-16 10:14:40'),('2026-07-17','hy_download_water_dj','save_images/2026-07-17/10/大江大河.xlsx','save_images/2026-07-17/10/大江大河.png','2026-07-17 10:13:35','2026-07-17 10:13:35'),('2026-07-17','hy_download_water_sk','save_images/2026-07-17/10/大型水库.xlsx','save_images/2026-07-17/10/大型水库.png','2026-07-17 10:14:28','2026-07-17 10:14:28'),('2026-07-17','hy_download_water_yq','save_images/2026-07-17/10/重点雨水情.xlsx','save_images/2026-07-17/10/重点雨水情.png','2026-07-17 10:14:51','2026-07-17 10:14:51'),('2026-07-18','hy_download_water_dj','save_images/2026-07-18/10/大江大河.xlsx','save_images/2026-07-18/10/大江大河.png','2026-07-18 10:13:23','2026-07-18 10:13:23'),('2026-07-18','hy_download_water_sk','save_images/2026-07-18/10/大型水库.xlsx','save_images/2026-07-18/10/大型水库.png','2026-07-18 10:14:16','2026-07-18 10:14:16'),('2026-07-18','hy_download_water_yq','save_images/2026-07-18/10/重点雨水情.xlsx','save_images/2026-07-18/10/重点雨水情.png','2026-07-18 10:14:39','2026-07-18 10:14:39'),('2026-07-19','hy_download_water_dj','save_images/2026-07-19/10/大江大河.xlsx','save_images/2026-07-19/10/大江大河.png','2026-07-19 10:12:31','2026-07-19 10:12:31'),('2026-07-19','hy_download_water_sk','save_images/2026-07-19/10/大型水库.xlsx','save_images/2026-07-19/10/大型水库.png','2026-07-19 10:13:23','2026-07-19 10:13:23'),('2026-07-19','hy_download_water_yq','save_images/2026-07-19/10/重点雨水情.xlsx','save_images/2026-07-19/10/重点雨水情.png','2026-07-19 10:13:44','2026-07-19 10:13:44'),('2026-07-21','hy_download_water_dj','save_images/2026-07-21/10/大江大河.xlsx','save_images/2026-07-21/10/大江大河.png','2026-07-21 10:13:08','2026-07-21 10:13:08'),('2026-07-21','hy_download_water_sk','save_images/2026-07-21/10/大型水库.xlsx','save_images/2026-07-21/10/大型水库.png','2026-07-21 10:14:00','2026-07-21 10:14:00'),('2026-07-21','hy_download_water_yq','save_images/2026-07-21/10/重点雨水情.xlsx','save_images/2026-07-21/10/重点雨水情.png','2026-07-21 10:14:20','2026-07-21 10:14:20'),('2026-07-23','hy_download_water_dj','save_images/2026-07-23/10/大江大河.xlsx','save_images/2026-07-23/10/大江大河.png','2026-07-23 10:10:44','2026-07-23 10:10:44'),('2026-07-24','hy_download_water_dj','save_images/2026-07-24/17/大江大河.xlsx','save_images/2026-07-24/17/大江大河.png','2026-07-24 18:07:51','2026-07-24 18:07:51'),('2026-07-24','hy_download_water_sk','save_images/2026-07-24/18/大型水库.xlsx','save_images/2026-07-24/18/大型水库.png','2026-07-24 18:15:27','2026-07-24 18:15:27'),('2026-07-24','hy_download_water_yq','save_images/2026-07-24/17/重点雨水情.xlsx','save_images/2026-07-24/17/重点雨水情.png','2026-07-24 18:18:46','2026-07-24 18:18:46'),('2026-07-25','hy_download_water_dj','save_images/2026-07-25/10/大江大河.xlsx','save_images/2026-07-25/10/大江大河.png','2026-07-25 10:13:00','2026-07-25 10:13:00'),('2026-07-25','hy_download_water_sk','save_images/2026-07-25/10/大型水库.xlsx','save_images/2026-07-25/10/大型水库.png','2026-07-25 10:29:29','2026-07-25 10:29:29'),('2026-07-25','hy_download_water_yq','save_images/2026-07-25/10/重点雨水情.xlsx','save_images/2026-07-25/10/重点雨水情.png','2026-07-25 10:36:07','2026-07-25 10:36:07'),('2026-07-26','hy_download_water_dj','save_images/2026-07-26/10/大江大河.xlsx','save_images/2026-07-26/10/大江大河.png','2026-07-26 10:14:09','2026-07-26 10:14:09'),('2026-07-26','hy_download_water_sk','save_images/2026-07-26/10/大型水库.xlsx','save_images/2026-07-26/10/大型水库.png','2026-07-26 10:29:40','2026-07-26 10:29:40'),('2026-07-26','hy_download_water_yq','save_images/2026-07-26/10/重点雨水情.xlsx','save_images/2026-07-26/10/重点雨水情.png','2026-07-26 10:36:40','2026-07-26 10:36:40'),('2026-07-27','hy_download_water_dj','save_images/2026-07-27/10/大江大河.xlsx','save_images/2026-07-27/10/大江大河.png','2026-07-27 10:14:12','2026-07-27 10:14:12'),('2026-07-27','hy_download_water_sk','save_images/2026-07-27/10/大型水库.xlsx','save_images/2026-07-27/10/大型水库.png','2026-07-27 10:34:49','2026-07-27 10:34:49'),('2026-07-27','hy_download_water_yq','save_images/2026-07-27/10/重点雨水情.xlsx','save_images/2026-07-27/10/重点雨水情.png','2026-07-27 10:43:08','2026-07-27 10:43:08'),('2026-07-28','hy_download_water_dj','save_images/2026-07-28/10/大江大河.xlsx','save_images/2026-07-28/10/大江大河.png','2026-07-28 10:14:05','2026-07-28 10:14:05'),('2026-07-28','hy_download_water_sk','save_images/2026-07-28/10/大型水库.xlsx','save_images/2026-07-28/10/大型水库.png','2026-07-28 10:29:43','2026-07-28 10:29:43'),('2026-07-28','hy_download_water_yq','save_images/2026-07-28/10/重点雨水情.xlsx','save_images/2026-07-28/10/重点雨水情.png','2026-07-28 10:39:37','2026-07-28 10:39:37'),('2026-08-01','hy_download_water_dj','save_images/2026-08-01/10/大江大河.xlsx','save_images/2026-08-01/10/大江大河.png','2026-08-01 10:14:34','2026-08-01 10:14:34'),('2026-08-01','hy_download_water_sk','save_images/2026-08-01/10/大型水库.xlsx','save_images/2026-08-01/10/大型水库.png','2026-08-01 10:28:21','2026-08-01 10:28:21'),('2026-08-01','hy_download_water_yq','save_images/2026-08-01/10/重点雨水情.xlsx','save_images/2026-08-01/10/重点雨水情.png','2026-08-01 10:34:48','2026-08-01 10:34:48'),('2026-08-03','hy_download_water_dj','save_images/2026-08-03/10/大江大河.xlsx','save_images/2026-08-03/10/大江大河.png','2026-08-03 10:11:17','2026-08-03 10:11:17'),('2026-08-04','hy_download_water_dj','save_images/2026-08-04/10/大江大河.xlsx','save_images/2026-08-04/10/大江大河.png','2026-08-04 10:11:34','2026-08-04 10:11:34'),('2026-08-07','hy_download_water_dj','save_images/2026-08-07/10/大江大河.xlsx','save_images/2026-08-07/10/大江大河.png','2026-08-07 10:14:47','2026-08-07 10:14:47'),('2026-08-07','hy_download_water_sk','save_images/2026-08-07/10/大型水库.xlsx','save_images/2026-08-07/10/大型水库.png','2026-08-07 10:24:30','2026-08-07 10:24:30'),('2026-08-07','hy_download_water_yq','save_images/2026-08-07/10/重点雨水情.xlsx','save_images/2026-08-07/10/重点雨水情.png','2026-08-07 10:30:05','2026-08-07 10:30:05'),('2026-08-17','hy_download_water_dj','save_images/2026-08-17/10/大江大河.xlsx','save_images/2026-08-17/10/大江大河.png','2026-08-17 10:13:06','2026-08-17 10:13:06'),('2026-08-17','hy_download_water_sk','save_images/2026-08-17/10/大型水库.xlsx','save_images/2026-08-17/10/大型水库.png','2026-08-17 10:32:09','2026-08-17 10:32:09'),('2026-08-17','hy_download_water_yq','save_images/2026-08-17/10/重点雨水情.xlsx','save_images/2026-08-17/10/重点雨水情.png','2026-08-17 10:39:13','2026-08-17 10:39:13'),('2026-08-20','hy_download_water_dj','save_images/2026-08-20/10/大江大河.xlsx','save_images/2026-08-20/10/大江大河.png','2026-08-20 10:11:25','2026-08-20 10:11:25'),('2026-08-30','hy_download_water_dj','save_images/2026-08-30/10/大江大河.xlsx','save_images/2026-08-30/10/大江大河.png','2026-08-30 10:14:06','2026-08-30 10:14:06'),('2026-08-30','hy_download_water_sk','save_images/2026-08-30/10/大型水库.xlsx','save_images/2026-08-30/10/大型水库.png','2026-08-30 10:30:31','2026-08-30 10:30:31'),('2026-08-30','hy_download_water_yq','save_images/2026-08-30/10/重点雨水情.xlsx','save_images/2026-08-30/10/重点雨水情.png','2026-08-30 10:37:34','2026-08-30 10:37:34'),('2026-09-01','hy_download_water_dj','save_images/2026-09-01/10/大江大河.xlsx','save_images/2026-09-01/10/大江大河.png','2026-09-01 10:11:29','2026-09-01 10:11:29'),('2026-09-02','hy_download_water_dj','save_images/2026-09-02/10/大江大河.xlsx','save_images/2026-09-02/10/大江大河.png','2026-09-02 10:12:45','2026-09-02 10:12:45'),('2026-09-06','hy_download_water_dj','save_images/2026-09-06/10/大江大河.xlsx','save_images/2026-09-06/10/大江大河.png','2026-09-06 10:14:08','2026-09-06 10:14:08'),('2026-09-06','hy_download_water_sk','save_images/2026-09-06/10/大型水库.xlsx','save_images/2026-09-06/10/大型水库.png','2026-09-06 10:30:41','2026-09-06 10:30:41'),('2026-09-06','hy_download_water_yq','save_images/2026-09-06/10/重点雨水情.xlsx','save_images/2026-09-06/10/重点雨水情.png','2026-09-06 10:38:37','2026-09-06 10:38:37'),('2026-09-09','hy_download_water_dj','save_images/2026-09-09/10/大江大河.xlsx','save_images/2026-09-09/10/大江大河.png','2026-09-09 10:15:26','2026-09-09 10:15:26'),('2026-09-09','hy_download_water_sk','save_images/2026-09-09/10/大型水库.xlsx','save_images/2026-09-09/10/大型水库.png','2026-09-09 10:29:37','2026-09-09 10:29:37'),('2026-09-09','hy_download_water_yq','save_images/2026-09-09/10/重点雨水情.xlsx','save_images/2026-09-09/10/重点雨水情.png','2026-09-09 10:32:04','2026-09-09 10:32:04'),('2026-09-15','hy_download_water_dj','save_images/2026-09-15/10/大江大河.xlsx','save_images/2026-09-15/10/大江大河.png','2026-09-15 10:14:14','2026-09-15 10:14:14'),('2026-09-15','hy_download_water_sk','save_images/2026-09-15/10/大型水库.xlsx','save_images/2026-09-15/10/大型水库.png','2026-09-15 10:30:32','2026-09-15 10:30:32'),('2026-09-15','hy_download_water_yq','save_images/2026-09-15/10/重点雨水情.xlsx','save_images/2026-09-15/10/重点雨水情.png','2026-09-15 10:38:00','2026-09-15 10:38:00'),('2026-09-22','hy_download_water_dj','save_images/2026-09-22/10/大江大河.xlsx','save_images/2026-09-22/10/大江大河.png','2026-09-22 10:14:14','2026-09-22 10:14:14'),('2026-09-22','hy_download_water_sk','save_images/2026-09-22/10/大型水库.xlsx','save_images/2026-09-22/10/大型水库.png','2026-09-22 10:31:50','2026-09-22 10:31:50'),('2026-09-22','hy_download_water_yq','save_images/2026-09-22/10/重点雨水情.xlsx','save_images/2026-09-22/10/重点雨水情.png','2026-09-22 10:39:05','2026-09-22 10:39:05'),('2026-09-25','hy_download_water_dj','save_images/2026-09-25/10/大江大河.xlsx','save_images/2026-09-25/10/大江大河.png','2026-09-25 10:13:00','2026-09-25 10:13:00'),('2026-09-26','hy_download_water_dj','save_images/2026-09-26/10/大江大河.xlsx','save_images/2026-09-26/10/大江大河.png','2026-09-26 10:11:17','2026-09-26 10:11:17'),('2026-09-28','hy_download_water_dj','save_images/2026-09-28/10/大江大河.xlsx','save_images/2026-09-28/10/大江大河.png','2026-09-28 10:12:03','2026-09-28 10:12:03'),('2026-10-04','hy_download_water_dj','save_images/2026-10-04/10/大江大河.xlsx','save_images/2026-10-04/10/大江大河.png','2026-10-04 10:12:14','2026-10-04 10:12:14'),('2026-10-11','hy_download_water_dj','save_images/2026-10-11/10/大江大河.xlsx','save_images/2026-10-11/10/大江大河.png','2026-10-11 10:14:24','2026-10-11 10:14:24'),('2026-10-11','hy_download_water_sk','save_images/2026-10-11/10/大型水库.xlsx','save_images/2026-10-11/10/大型水库.png','2026-10-11 10:44:32','2026-10-11 10:44:32'),('2026-10-11','hy_download_water_yq','save_images/2026-10-11/10/重点雨水情.xlsx','save_images/2026-10-11/10/重点雨水情.png','2026-10-11 10:57:19','2026-10-11 10:57:19'),('2026-10-12','hy_download_water_dj','save_images/2026-10-12/10/大江大河.xlsx','save_images/2026-10-12/10/大江大河.png','2026-10-12 10:14:21','2026-10-12 10:14:21'),('2026-10-12','hy_download_water_sk','save_images/2026-10-12/10/大型水库.xlsx','save_images/2026-10-12/10/大型水库.png','2026-10-12 10:44:20','2026-10-12 10:44:20'),('2026-10-12','hy_download_water_yq','save_images/2026-10-12/10/重点雨水情.xlsx','save_images/2026-10-12/10/重点雨水情.png','2026-10-12 10:56:29','2026-10-12 10:56:29'),('2026-10-13','hy_download_water_dj','save_images/2026-10-13/10/大江大河.xlsx','save_images/2026-10-13/10/大江大河.png','2026-10-13 10:14:03','2026-10-13 10:14:03'),('2026-10-13','hy_download_water_sk','save_images/2026-10-13/10/大型水库.xlsx','save_images/2026-10-13/10/大型水库.png','2026-10-13 10:41:33','2026-10-13 10:41:33'),('2026-10-13','hy_download_water_yq','save_images/2026-10-13/10/重点雨水情.xlsx','save_images/2026-10-13/10/重点雨水情.png','2026-10-13 10:53:50','2026-10-13 10:53:50'),('2026-10-14','hy_download_water_dj','save_images/2026-10-14/10/大江大河.xlsx','save_images/2026-10-14/10/大江大河.png','2026-10-14 10:13:41','2026-10-14 10:13:41'),('2026-10-14','hy_download_water_sk','save_images/2026-10-14/10/大型水库.xlsx','save_images/2026-10-14/10/大型水库.png','2026-10-14 10:41:35','2026-10-14 10:41:35'),('2026-10-14','hy_download_water_yq','save_images/2026-10-14/10/重点雨水情.xlsx','save_images/2026-10-14/10/重点雨水情.png','2026-10-14 10:54:56','2026-10-14 10:54:56'),('2026-10-15','hy_download_water_dj','save_images/2026-10-15/10/大江大河.xlsx','save_images/2026-10-15/10/大江大河.png','2026-10-15 10:14:43','2026-10-15 10:14:43'),('2026-10-15','hy_download_water_sk','save_images/2026-10-15/10/大型水库.xlsx','save_images/2026-10-15/10/大型水库.png','2026-10-15 10:44:23','2026-10-15 10:44:23'),('2026-10-15','hy_download_water_yq','save_images/2026-10-15/10/重点雨水情.xlsx','save_images/2026-10-15/10/重点雨水情.png','2026-10-15 10:56:37','2026-10-15 10:56:37'),('2026-10-16','hy_download_water_dj','save_images/2026-10-16/10/大江大河.xlsx','save_images/2026-10-16/10/大江大河.png','2026-10-16 10:13:56','2026-10-16 10:13:56'),('2026-10-16','hy_download_water_sk','save_images/2026-10-16/10/大型水库.xlsx','save_images/2026-10-16/10/大型水库.png','2026-10-16 10:41:27','2026-10-16 10:41:27'),('2026-10-16','hy_download_water_yq','save_images/2026-10-16/10/重点雨水情.xlsx','save_images/2026-10-16/10/重点雨水情.png','2026-10-16 10:54:12','2026-10-16 10:54:12'),('2026-10-18','hy_download_water_dj','save_images/2026-10-18/10/大江大河.xlsx','save_images/2026-10-18/10/大江大河.png','2026-10-18 10:14:26','2026-10-18 10:14:26'),('2026-10-18','hy_download_water_sk','save_images/2026-10-18/10/大型水库.xlsx','save_images/2026-10-18/10/大型水库.png','2026-10-18 10:45:20','2026-10-18 10:45:20'),('2026-10-18','hy_download_water_yq','save_images/2026-10-18/10/重点雨水情.xlsx','save_images/2026-10-18/10/重点雨水情.png','2026-10-18 10:59:02','2026-10-18 10:59:02'),('2026-10-21','hy_download_water_dj','save_images/2026-10-21/10/大江大河.xlsx','save_images/2026-10-21/10/大江大河.png','2026-10-21 10:14:05','2026-10-21 10:14:05'),('2026-10-21','hy_download_water_sk','save_images/2026-10-21/10/大型水库.xlsx','save_images/2026-10-21/10/大型水库.png','2026-10-21 10:42:46','2026-10-21 10:42:46'),('2026-10-21','hy_download_water_yq','save_images/2026-10-21/10/重点雨水情.xlsx','save_images/2026-10-21/10/重点雨水情.png','2026-10-21 10:55:14','2026-10-21 10:55:14'),('2026-10-22','hy_download_water_dj','save_images/2026-10-22/10/大江大河.xlsx','save_images/2026-10-22/10/大江大河.png','2026-10-22 10:13:32','2026-10-22 10:13:32'),('2026-10-22','hy_download_water_sk','save_images/2026-10-22/10/大型水库.xlsx','save_images/2026-10-22/10/大型水库.png','2026-10-22 10:41:40','2026-10-22 10:41:40'),('2026-10-22','hy_download_water_yq','save_images/2026-10-22/10/重点雨水情.xlsx','save_images/2026-10-22/10/重点雨水情.png','2026-10-22 10:54:17','2026-10-22 10:54:17'),('2026-10-23','hy_download_water_dj','save_images/2026-10-23/10/大江大河.xlsx','save_images/2026-10-23/10/大江大河.png','2026-10-23 10:14:24','2026-10-23 10:14:24'),('2026-10-23','hy_download_water_sk','save_images/2026-10-23/10/大型水库.xlsx','save_images/2026-10-23/10/大型水库.png','2026-10-23 10:42:28','2026-10-23 10:42:28'),('2026-10-23','hy_download_water_yq','save_images/2026-10-23/10/重点雨水情.xlsx','save_images/2026-10-23/10/重点雨水情.png','2026-10-23 10:54:57','2026-10-23 10:54:57'),('2026-11-05','hy_download_water_dj','save_images/2026-11-05/10/大江大河.xlsx','save_images/2026-11-05/10/大江大河.png','2026-11-05 10:14:47','2026-11-05 10:14:47'),('2026-11-05','hy_download_water_sk','save_images/2026-11-05/10/大型水库.xlsx','save_images/2026-11-05/10/大型水库.png','2026-11-05 10:43:03','2026-11-05 10:43:03'),('2026-11-05','hy_download_water_yq','save_images/2026-11-05/10/重点雨水情.xlsx','save_images/2026-11-05/10/重点雨水情.png','2026-11-05 10:55:31','2026-11-05 10:55:31'),('2026-11-06','hy_download_water_dj','save_images/2026-11-06/10/大江大河.xlsx','save_images/2026-11-06/10/大江大河.png','2026-11-06 10:15:01','2026-11-06 10:15:01'),('2026-11-06','hy_download_water_sk','save_images/2026-11-06/10/大型水库.xlsx','save_images/2026-11-06/10/大型水库.png','2026-11-06 10:42:54','2026-11-06 10:42:54'),('2026-11-06','hy_download_water_yq','save_images/2026-11-06/10/重点雨水情.xlsx','save_images/2026-11-06/10/重点雨水情.png','2026-11-06 10:56:24','2026-11-06 10:56:24'),('2026-11-07','hy_download_water_dj','save_images/2026-11-07/10/大江大河.xlsx','save_images/2026-11-07/10/大江大河.png','2026-11-07 10:13:11','2026-11-07 10:13:11'),('2026-11-07','hy_download_water_sk','save_images/2026-11-07/10/大型水库.xlsx','save_images/2026-11-07/10/大型水库.png','2026-11-07 10:39:24','2026-11-07 10:39:24'),('2026-11-07','hy_download_water_yq','save_images/2026-11-07/10/重点雨水情.xlsx','save_images/2026-11-07/10/重点雨水情.png','2026-11-07 10:50:52','2026-11-07 10:50:52'),('2026-11-08','hy_download_water_dj','save_images/2026-11-08/10/大江大河.xlsx','save_images/2026-11-08/10/大江大河.png','2026-11-08 10:13:55','2026-11-08 10:13:55'),('2026-11-08','hy_download_water_sk','save_images/2026-11-08/10/大型水库.xlsx','save_images/2026-11-08/10/大型水库.png','2026-11-08 10:41:50','2026-11-08 10:41:50'),('2026-11-08','hy_download_water_yq','save_images/2026-11-08/10/重点雨水情.xlsx','save_images/2026-11-08/10/重点雨水情.png','2026-11-08 10:54:33','2026-11-08 10:54:33'),('2026-11-09','hy_download_water_dj','save_images/2026-11-09/10/大江大河.xlsx','save_images/2026-11-09/10/大江大河.png','2026-11-09 10:13:39','2026-11-09 10:13:39'),('2026-11-09','hy_download_water_sk','save_images/2026-11-09/10/大型水库.xlsx','save_images/2026-11-09/10/大型水库.png','2026-11-09 10:41:57','2026-11-09 10:41:57'),('2026-11-09','hy_download_water_yq','save_images/2026-11-09/10/重点雨水情.xlsx','save_images/2026-11-09/10/重点雨水情.png','2026-11-09 10:54:49','2026-11-09 10:54:49'),('2026-11-11','hy_download_water_dj','save_images/2026-11-11/10/大江大河.xlsx','save_images/2026-11-11/10/大江大河.png','2026-11-11 10:13:31','2026-11-11 10:13:31'),('2026-11-11','hy_download_water_sk','save_images/2026-11-11/10/大型水库.xlsx','save_images/2026-11-11/10/大型水库.png','2026-11-11 10:43:07','2026-11-11 10:43:07'),('2026-11-11','hy_download_water_yq','save_images/2026-11-11/10/重点雨水情.xlsx','save_images/2026-11-11/10/重点雨水情.png','2026-11-11 10:56:17','2026-11-11 10:56:17'),('2026-11-26','hy_download_water_dj','save_images/2026-11-26/11/大江大河.xlsx','save_images/2026-11-26/11/大江大河.png','2026-11-26 11:40:58','2026-11-26 11:40:58'),('2026-11-26','hy_download_water_sk','save_images/2026-11-26/11/大型水库.xlsx','save_images/2026-11-26/11/大型水库.png','2026-11-26 11:41:19','2026-11-26 11:41:19'),('2026-11-26','hy_download_water_yq','save_images/2026-11-26/11/重点雨水情.xlsx','save_images/2026-11-26/11/重点雨水情.png','2026-11-26 14:49:02','2026-11-26 14:49:02');
/*!40000 ALTER TABLE `hy_download_water_date_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hy_download_water_mapping_dj`
--

DROP TABLE IF EXISTS `hy_download_water_mapping_dj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_mapping_dj` (
  `basin_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '流域',
  `river_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '河名',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '行政区划',
  `station_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '站名',
  `station_name_alias` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '别名',
  PRIMARY KEY (`station_name`,`province_name`,`basin_name`,`river_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='大江大河站名映射表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hy_download_water_mapping_dj`
--

LOCK TABLES `hy_download_water_mapping_dj` WRITE;
/*!40000 ALTER TABLE `hy_download_water_mapping_dj` DISABLE KEYS */;
INSERT INTO `hy_download_water_mapping_dj` VALUES ('珠江','滃江','广东','?褰?',NULL),('珠江','瀚江','广东','?赛？',NULL),('黄河','黄河','山东','一号坝',NULL),('黄河','无定河','陕西','丁家沟',NULL),('长江','牛栏江','云南','七星桥',NULL),('淮河','麻河','安徽','七邻',NULL),('长江','巴河','四川','七里沱',NULL),('闽江','建溪','福建','七里街',NULL),('长江','长江','重庆','万县(二)',NULL),('辽河流域','百岔河','内蒙古','万合永',NULL),('长江流域','潦水','江西','万家埠',NULL),('黄河','黄河','山西','万家寨下',NULL),('黄河','黄河','陕西','万镇',NULL),('长江','冷水河','陕西','三华石',NULL),('长江','凯江','四川','三台',NULL),('辽河','养畜牧河','辽宁','三家子',NULL),('海河','永定河','北京','三家店',NULL),('珠江','龙江','广西','三岔',NULL),('辽河','大辽河','辽宁','三岔河',NULL),('长江','雍河-插江-东河','四川','三川',NULL),('长江','长江','湖北','三斗坪(二)',NULL),('珠江','北江干流水道','广东','三水(二)',NULL),('长江','渠江','四川','三汇',NULL),('海河','洵河','河北','三河',NULL),('韩江','韩江','广东','三河坝',NULL),('淮河','淮河','河南','三河尖',NULL),('南渡江','新吴溪','海南','三滩','川'),('长江','沱江','四川','三皇庙 二','三皇庙二'),('长江','白龙江','四川','三磊坝二',NULL),('海河','滦河','河北','三道河子',NULL),('黄河','黄河','河南','三门峡',NULL),('长江','清江河','四川','上寺 二','上寺二'),('韩江','汀江','福建','上杭',NULL),('珠江','清水河','广西','上林(二)',NULL),('长江流域','禾水','江西','上沙兰',NULL),('闽东诸河','交溪','福建','上白石',NULL),('黄河','黄河','甘肃','上诠',NULL),('上饶以上','信江','江西','上饶',NULL),('长江流域','锦河','江西','上高',NULL),('海河','潮河','北京','下会',NULL),('长江','马尾河','贵州','下司(二)',NULL),('淮河','荡泽河','河南','下孤山',NULL),('黑龙江','松花江干流','吉林','下岱吉',NULL),('黄河','洮河','甘肃','下巴沟 (洮二)',NULL),('海河','老牛河','河北','下板城',NULL),('长江','硕多岗河','云南','下桥头',NULL),('海河','蚁蚂吐河','河北','下河南',NULL),('黄河','黄河','宁夏','下河沿',NULL),('长江','独木河','贵州','下湾',NULL),('塔里木河','卡墙河','新疆','且末',NULL),('松花江','莲河','吉林','东丰',NULL),('淮河','泰东河','江苏','东台(泰)','东台(泰'),('黄河','五当沟','内蒙古','东园',NULL),('海河','水河','北京','东大桥',NULL),('长江','秦淮河','江苏','东山',NULL),('黄河','洪安涧河','山西','东庄',NULL),('海河','孝义河','河北','东方机站',NULL),('海河','桑干河','山西','东榆林水库坝下',NULL),('闽江','松溪','福建','东游',NULL),('黄河','伊河','河南','东湾',NULL),('长江流域 区域','綦江','重庆','东溪',NULL),('辽河','绕阳河','辽宁','东白城子',NULL),('海河','白沟河','河北','东茨村',NULL),('淮河','沂河','山东','东里店',NULL),('辽河','忙牛河','辽宁','东陵',NULL),('长江','渠溪河','重庆','两河',NULL),('长江','子午河','陕西','两河口',NULL),('长江','万马河','云南','中和街',NULL),('海河','唐河','河北','中唐梅河道','中唐梅　河道'),('闽东南诸河','西溪','福建','中山桥',NULL),('淮河','沙河','河南','中汤',NULL),('淮河','贾鲁河','河南','中牟',NULL),('珠江','马来河','广西','中里',NULL),('长江流域','赣江','江西','丰城',NULL),('长江流域太湖区','下塘河','浙江','临平(下)',NULL),('长江','南河','重庆','临江',NULL),('淮河','沂河','山东','临沂',NULL),('淮河','蔷薇河','江苏','临洪',NULL),('海河','洺河','河北','临洺关(二)',NULL),('淮河','淮河','安徽','临淮关',NULL),('海河','南运河','山东','临清',NULL),('黄河','渭河','陕西','临潼',NULL),('黄河','汾川河','陕西','临镇',NULL),('长江','丹江','陕西','丹凤',NULL),('长江','大渡河','四川','丹巴',NULL),('太湖','大运河','江苏','丹阳',NULL),('大凌河','大凌河','辽宁','义县',NULL),('黄河','汾河','山西','义棠',NULL),('长江','金沙江','云南','乌东德',NULL),('辽河流域','回今','内蒙古','乌丹(四)',NULL),('长江','岷江','四川','乌尤寺',NULL),('长江','乌江','贵州','乌江渡(三)',NULL),('长江流域太湖区','澜溪塘','浙江','乌镇',NULL),('海河流域','滦河','河北','乌龙矶',NULL),('海河','通惠河','北京','乐家花园',NULL),('黄河','湟水','青海','乐都',NULL),('内陆河','西营河','甘肃','九条岭',NULL),('长江','长江','江西','九江',NULL),('海河','蓟运河','天津','九王庄闸上',NULL),('辽河','忙牛河','辽宁','九连洞',NULL),('海河','子牙河','河北','九高庄',NULL),('淮河','泗河','山东','书院',NULL),('辽河','汤河','辽宁','二道河子',NULL),('松花江吉林段','二道白河','吉林','二道白河',NULL),('长江','牛渡河','贵州','二郎坝',NULL),('长江','綦江','重庆','五岔',NULL),('长江','沅水','湖南','五强溪(二)',NULL),('淮河','洪河','河南','五沟营',NULL),('淮河','淮河','安徽','五河',NULL),('长江','岷江','四川','五通桥二',NULL),('松花江吉林段','辉发河','吉林','五道沟',NULL),('海河','卫河','河南','五陵',NULL),('黄河','沁河','河南','五龙口',NULL),('黄河','北洛河','陕西','交口河',NULL),('黄河','大通河','青海','享堂',NULL),('珠江','桂江','广西','京南',NULL),('长江','马过河','云南','仁里二',NULL),('塔里木河','孔雀河','新疆','他什店五','他什店　五'),('辽河流域','他拉干库引水','内蒙古','他拉干五',NULL),('淮河','东汶河','山东','付旺庄',NULL),('长江','汉江','湖北','仙桃(二)',NULL),('长江','汨罗江','湖南','伍市',NULL),('长江','长江','湖北','众',NULL),('长江','鱼河','四川','会东桥',NULL),('黄河','祖厉河','甘肃','会宁',NULL),('淮河','澧河','河南','何口',NULL),('长江','余庆河','贵州','余庆(三)',NULL),('长江流域太湖区','南苕溪','浙江','余杭',NULL),('松花江','松花江','黑龙江','佳木斯',NULL),('松花江','松花江','黑龙江','依兰',NULL),('嫩江','乌裕尔河','黑龙江','依安大桥',NULL),('海河流域','浊漳河','山西','侯壁',NULL),('长江','郁江','重庆','保家楼',NULL),('珠江','贺江','广西','信都三',NULL),('长江','修文河','贵州','修文',NULL),('海河','大沙河','河南','修武',NULL),('海河','唐河','河北','倒马关河道二',NULL),('黄河','偏关河','山西','偏关',NULL),('长江','漾家河','陕西','元墩',NULL),('海河','卫河','河南','元村',NULL),('长江','濛溪河','四川','元滩湾',NULL),('塔里木河','盖孜河','新疆','克勒克三',NULL),('克里雅诸小河流域','克里雅河','新疆','克里雅',NULL),('长江','蔚竹水','湖南','党坪',NULL),('内陆河','党河','甘肃','党城湾 (二)',NULL),('长江','湘江','广西','全州二',NULL),('辽河','清河','辽宁','八棵树',NULL),('珠江','驮娘江','广西','八达',NULL),('辽河','秀水河','辽宁','公主屯',NULL),('辽河流域','兴隆河','吉林','公主岭',NULL),('长江','岚河','陕西','六口',NULL),('长江','滁河','江苏','六合',NULL),('长江','六洞河','贵州','六洞桥',NULL),('辽河','辽河','辽宁','六间房',NULL),('淮河','邵伯湖','江苏','六闸(三)',NULL),('黄河','黄河','甘肃','兰州',NULL),('塔里木河','库车河','新疆','兰干',NULL),('黄河','汾河','山西','兰村',NULL),('浙闽台河流','兰江','浙江','兰溪',NULL),('松花江','呼兰河','黑龙江','兰西',NULL),('长江','湔江','四川','关口',NULL),('辽河','复州河','辽宁','关家屯',NULL),('淮河','南官河','江苏','兴化',NULL),('黄河','蔚汾河','山西','兴县',NULL),('海河','柳河','河北','兴隆',NULL),('长江','汉江','湖北','兴隆',NULL),('辽河流域','老哈河','内蒙古','兴隆坡',NULL),('长江','湍河','河南','内乡',NULL),('黄河','黄河','青海','军功',NULL),('松花江吉林段','伊通河','吉林','农安',NULL),('珠江','洪奇沥水道','广东','冯马庙(二)',NULL),('辽河','英纳河','辽宁','冰峪沟',NULL),('长江','资水','湖南','冷水江(二)',NULL),('长江','澧水(北源)','湖南','凉水口',NULL),('长江','乌龙河(长滩河)-釜溪河','四川','凌家场',NULL),('辽河流域','大凌河','辽宁','凌海',NULL),('长江','岷江','四川','凤仪',NULL),('长江','沱江','湖南','凤凰(二)',NULL),('长江','嘉陵江','陕西','凤州',NULL),('浙闽台河流','分水江','浙江','分水江',NULL),('黄河','黄河','山东','刘家园',NULL),('海河','清漳河','山西','刘家庄',NULL),('黄河','北洛河','陕西','刘家河',NULL),('海河','共产主义渠','河南','刘庄',NULL),('长江','清江','湖北','利川二',NULL),('黄河','黄河','山东','利津',NULL),('长江','句容河','江苏','前垾村',NULL),('长江','句容河','江苏','前悍村',NULL),('海河','黎河','天津','前毛庄',NULL),('海河','怀九河','北京','前辛庄',NULL),('长江','闻溪河','四川','剑阁 二','剑阁二'),('长江','汨罗江','湖南','加义(二)',NULL),('嫩江','甘河','黑龙江','加格达奇',NULL),('万泉河','万泉河','海南','加积(二)',NULL),('珠江','古宜河','广西','勒黄',NULL),('珠江','贝江','广西','勾滩',NULL),('鉴江','鉴江','广东','化州(城)',NULL),('海河','淳沱河','河北','北中山(二)',NULL),('黄河','黄河','山东','北店子',NULL),('淮河','白鹭河','河南','北庙集',NULL),('海河','绛河','山西','北张店',NULL),('长江','球溪河','四川','北斗',NULL),('海河','龙河','河北','北昌',NULL),('黄河','大汶河','山东','北望',NULL),('海河','南拒马河','河北','北河店',NULL),('珠江','北流河','广西','北流',NULL),('长江','嘉陵江','重庆','北碚(三)',NULL),('海河','清水河','河北','北辛店',NULL),('黄河','渭河','陕西','北道',NULL),('海河','潴龙河','河北','北郭村',NULL),('海河','清漳河','河北','匡门口',NULL),('长江','巴河','四川','区',NULL),('辽河流域','小辽河','吉林','十屋',NULL),('黄河','干河','陕西','千阳',NULL),('长江','渭水河','陕西','升仙村',NULL),('长江','刁河','河南','半店',NULL),('黄河','石堡子河','甘肃','华亭',NULL),('黄河','渭河','陕西','华县',NULL),('长江','金沙江','四川','华弹',NULL),('黄河','渭河','陕西','华阴',NULL),('长江流域','盱江','江西','南丰','丰'),('珠江','白沙江','广西','南义',NULL),('海河','马颊河','河南','南乐',NULL),('长江','嘉陵江','四川','南充',NULL),('长江','涪江','四川','南北堰',NULL),('长江','藕池河(北支)','湖南','南县(罗文窖)',NULL),('长江','西洞庭湖湖口(北端)','湖南','南咀',NULL),('长江流域','盱江','江西','南城',NULL),('珠江','郁江','广西','南宁三','南宁　三'),('长江','金钱河','陕西','南宽坪',NULL),('海河','通天河','河北','南庄',NULL),('长江流域','赣江','江西','南昌',NULL),('淮河','大沽河','山东','南村',NULL),('黄河','黄河','山东','南桥',NULL),('长江','长江','湖北','南津关(二)',NULL),('长江流域太湖区','頔塘','浙江','南浔',NULL),('珠江','黄华江','广西','南渡',NULL),('淮河','淮河','安徽','南照集',NULL),('辽河','太子河(南支)','辽宁','南甸',NULL),('辽河','社河','辽宁','南章党',NULL),('淮河','南阳湖','山东','南阳',NULL),('长江','白河','河南','南阳',NULL),('海河','卫河','山东','南陶',NULL),('塔里木河','博斯腾湖','新疆','博斯腾湖',NULL),('珠江','南流江','广西','博白',NULL),('珠江','东江','广东','博罗(二)',NULL),('塔里木河','叶尔羌河','新疆','卡群二',NULL),('黄河','洛河','河南','卢氏',NULL),('海河','永定河','北京','卢沟桥',NULL),('长江','府澴河','湖北','卧龙潭',NULL),('长江','印江河','贵州','印江',NULL),('长江流域','万载河','江西','危坊',NULL),('长江','黄洋河','陕西','县河口',NULL),('海河','青龙河','河北','双山子',NULL),('长江','侧水','湖南','双峰(二)',NULL),('珠江','漠阳江','广东','双捷',NULL),('长江','潔水','湖南','双枫潭',NULL),('长江','浏渭河','湖南','双江口',NULL),('淮河','怀洪新河','江苏','双沟(合)',NULL),('长江','永宁河','四川','叙永',NULL),('松花江吉林段','温德河','吉林','口前',NULL),('海河','怀沙河','北京','口头',NULL),('长江','鸭河','河南','口子河',NULL),('海河','潮河','河北','古北口',NULL),('嫩江','诺敏河','黑龙江','古城子',NULL),('黄河','黄河','山西','古夺',NULL),('珠江','古宜河','广西','古宜',NULL),('珠江','贺江','广东','古榄',NULL),('珠江','绥江','广东','古水',NULL),('长江','滁河','安徽','古河',NULL),('长江','句容河','江苏','句容水文站',NULL),('辽河流域','西拉木伦河','内蒙古','台河口',NULL),('海河','赵王新河','河北','史各庄',NULL),('绕阳河','羊肠河','辽宁','司屯',NULL),('长江','长江','四川','合江',NULL),('珠江','合江','广西','合江',NULL),('海河','共产主义渠','河南','合河(共)',NULL),('长江','南渺河','安徽','合肥',NULL),('黄河','州川河','山西','吉县',NULL),('长江流域','赣江','江西','吉安',NULL),('松花江吉林段','松花江吉林段','吉林','吉林',NULL),('黄河','黄河','青海','吉迈',NULL),('长江','桐河','湖南','吉首',NULL),('黄河','隆务河','青海','同仁',NULL),('和田河流域','玉龙喀什河','新疆','同古孜洛克',NULL),('长江','湍河','河南','后会',NULL),('黄河','三川河','山西','后大成',NULL),('淮河','大运河','山东','后营',NULL),('长江','金沙江','四川','向家坝',NULL),('长江','旬河','陕西','向家坪(二)',NULL),('黄河','黄河','陕西','吴堡','吳堡'),('淮河','淮河','安徽','吴家渡','吳家渡'),('黄河','北洛河','陕西','吴旗','吳旗'),('淮河','回','河南','告成',NULL),('淮河','沙颖河','河南','周口',NULL),('淮河','黑河','河南','周堂桥',NULL),('海河','子牙新河','河北','周官屯',NULL),('海河','北排水河','河北','周官屯 北排 排下 四',NULL),('海河','北排水河','河北','周官屯北排排下',NULL),('长江','长河','安徽','周家河',NULL),('海河','漕河','河北','周庄',NULL),('长江','沅江','湖南','周文庙',NULL),('黑龙江','呼玛河','黑龙江','呼玛桥',NULL),('长江','干五里河','四川','和平',NULL),('黄河','渭河','陕西','咸阳',NULL),('长江','汉江','湖北','品口',NULL),('松花江','松花江','黑龙江','哈尔滨',NULL),('辽河','大凌河西支','辽宁','哈巴气',NULL),('辽河流域','羊肠子河','内蒙古','哈拉道口',NULL),('海河','洋河','河北','响水堡河道',NULL),('黄河','罕台川','内蒙古','响沙湾',NULL),('黄河','黄河','青海','唐乃亥',NULL),('黄河','白河','四川','唐克',NULL),('长江','唐河','河南','唐河',NULL),('辽河','太子河','辽宁','唐马寨',NULL),('长江流域太湖区','杭嘉平运河','浙江','嘉兴',NULL),('内陆河','讨赖河','甘肃','嘉峪关',NULL),('长江','钟水','湖南','嘉禾(二)',NULL),('珠江','绥江','广东','四会',NULL),('海河','潴龙河','河北','团丁庄',NULL),('黄河','清水河','宁夏','固原',NULL),('淮河','史河','河南','固始',NULL),('海河','永定河','河北','固安',NULL),('海河','桑干河','山西','固定桥',NULL),('黄河','黄河','山东','国那里',NULL),('海河','清漳河','河北','国门口',NULL),('黄河','毛不浪沟','内蒙古','图格日格',NULL),('黄河','北川河','山西','圪洞',NULL),('淮河','洪河分洪道','安徽','地理城',NULL),('太湖','太运河','江苏','坊前',NULL),('长江','章水','江西','坝上',NULL),('海河','路罗川','河北','坡底',NULL),('珠江','武江','广东','坪石(二)',NULL),('长江','洞庭湖湖口','湖南','城陵矶(七里山)',NULL),('长江','夫夷水','湖南','塘渡口',NULL),('大凌河','西河','辽宁','复兴堡',NULL),('黄河','大夏河','甘肃','夏河',NULL),('长江流域','赣江','江西','外洲',NULL),('黄河','大峪沟','甘肃','多坝',NULL),('长江','青衣江','四川','多营坪',NULL),('淮河','新沭河','江苏','大兴镇',NULL),('珠江','蒙江','广西','大化',NULL),('长江','汉江','湖北','大同(二)',NULL),('长江','青弋江','安徽','大坊',NULL),('淮河','淮河','河南','大坡岭',NULL),('黄河','昕水河','山西','大宁',NULL),('塔里木河','开都河','新疆','大山口',NULL),('黄河','大峪河','陕西','大峪',NULL),('珠江','向水河','广西','大新',NULL),('长江','大宁河','重庆','大昌(二)',NULL),('黄河','仕望川','陕西','大村',NULL),('黄河','大武口沟','宁夏','大武口二',NULL),('珠江','武思江','广西','大江口',NULL),('黄河','大汶河','山东','大汶口',NULL),('海河流域','吐力根河','内蒙古','大河口(四)',NULL),('辽河','蒲河','辽宁','大河泡',NULL),('太湖','太湖','江苏','大浦口',NULL),('珠江','浔江','广西','大湟江口(二)',NULL),('珠江','大溶江','广西','大溶江',NULL),('淮河','惠济河','河南','大王庙',NULL),('闽江','尤溪','福建','大田',NULL),('松花江吉林段','古洞河','吉林','大甸子',NULL),('黑龙江流域','归流河','内家占','大石亲',NULL),('黑龙江流域','归流河','内蒙古','大石寨',NULL),('长江','青弋江','安徽','大砻坊',NULL),('黄河','黄河','山西','大禹渡',NULL),('长江','任河','四川','大竹河二',NULL),('长江','舞阳河','贵州','大菜园二(水位)',NULL),('松花江吉林段','富尔河','吉林','大蒲柴河',NULL),('松花江','嫩江','吉林','大赉',NULL),('黄河','天然文岩渠','河南','大车集',NULL),('长江','长江','安徽','大通(二)',NULL),('长江','斜江-南河','四川','大邑',NULL),('长江','大金川','四川','大金',NULL),('海河','潮河','河北','大阁',NULL),('长江','梓江','四川','天仙寺二',NULL),('长江','天全河','四川','天全',NULL),('黄河','大通河','','天堂寺',NULL),('长江','小槽河-塘河狮头河','四川','天堂岩',NULL),('长江','花溪河','四川','天宫','天宮'),('珠江','红水河','广西','天峨',NULL),('海河','浊漳河','河南','天桥断',NULL),('黄河','藉河','甘肃','天水',NULL),('珠江','东小江','广西','天河',NULL),('磨刀门','西海水道','广东','天河(二)',NULL),('珠江','南盘江','贵州','天生桥(水位1)',NULL),('淮河','白塔河','安徽','天长',NULL),('珠江','蒙江','广西','太平',NULL),('太湖流域','太湖','太湖局','太湖水位',NULL),('黄河','黄河','内蒙','头道拐',NULL),('哈密吐鲁番地区诸河','头道沟','新疆','头道沟',NULL),('长江','青衣江','四川','夹江',NULL),('黄河','黄河','河南','夹河滩',NULL),('长江流域太湖区','夹浦港','浙江','夹浦',NULL),('长江流域','南潦水','江西','奉新',NULL),('长江','长江','重庆','奉节(二)',NULL),('大凌河','大凌河','辽宁','奥',NULL),('珠江','龙江','广西','妇川',NULL),('淮河','枋河','山东','姜庄湖',NULL),('长江','涟水','湖南','娄底',NULL),('婺源以上','乐安河','江西','婺源',NULL),('海河流域','子牙河','天津','子牙河第六堡二',NULL),('黄河','清涧河','陕西','子长',NULL),('长江','周公河','四川','孔坪',NULL),('黄河','沁河','山西','孔家坡',NULL),('黄河','黄河','山东','孙口',NULL),('淮河','万福河','山东','孙庄二',NULL),('海河','御河','山西','孤山',NULL),('长江','官山河','湖北','孤山',NULL),('长江','为水','湖南','宁乡(三)',NULL),('闽江','西溪','福建','宁化',NULL),('长江','黑水河','四川','宁南',NULL),('珠江','明江','广西','宁明',NULL),('长江','梅川','江西','宁都',''),('长江','松虎合流','湖南','安乡',NULL),('长江','永乐江','湖南','安仁',NULL),('黄河','延河','陕西','安塞',NULL),('黄河','漆水河','陕西','安头',NULL),('黄河','黄河','甘肃','安宁渡',NULL),('长江','长江','安徽','安庆',NULL),('长江','汉江','陕西','安康',NULL),('长江','沅水','湖南','安江',NULL),('海河','安阳河','河南','安阳',NULL),('珠江','中洲小江','广西','安马',NULL),('长江','松滋河(西支)','湖南','官坑',NULL),('长江','澧水','湖南','官垸',NULL),('长江','松滋河(西支)','湖南','官皖',NULL),('珠江','罗定江','广东','官良',NULL),('南渡江','南渡江','海南','定安三',NULL),('太湖','西沈','江苏','宜兴西',NULL),('长江','汉江','湖北','宜城',NULL),('长江','金沙江','四川','宜宾(二)',NULL),('长江','长江','湖北','宜昌',NULL),('长江流域','袁水','江西','宜春',NULL),('黄河','洛河','河南','宜阳',NULL),('长江','宝兴河','四川','宝兴',NULL),('辽河','二道河','辽宁','宝力镇',NULL),('淮河','里运河','江苏','宝应',NULL),('昌化江','昌化江','海南','宝桥',NULL),('长江','水阳江','安徽','宣城',NULL),('长江','忠建河','湖北','宣恩 二','宣恩二'),('珠江','北流河','广西','容县',NULL),('海河','瀑河','河北','宽城',NULL),('海河','白河','北京','密云(白河坝下)',NULL),('珠江','浪溪河','广西','富乐',NULL),('珠江','普厅河','','富宁',NULL),('嫩江','嫩江','黑龙江','富拉尔基',NULL),('浙闽台河流','富春江','浙江','富春江坝下',NULL),('珠江','富群水','广西','富罗二',NULL),('珠江','贺江','广西','富阳',NULL),('长江','沱江','四川','富顺',NULL),('黑龙江流域','洮儿河','内蒙古','察尔森',NULL),('黄河','汾河','山西','寨上',NULL),('珠江','寨蒿河','贵州','寨蒿',NULL),('长江','长江','重庆','寸滩',NULL),('珠江','洛清江','广西','对亭',NULL),('海河','云中河','山西','寺坪',NULL),('长江','涓水','湖南','射埠(二)',NULL),('长江','涪江','四川','射洪',NULL),('闽江','金溪','福建','将乐',NULL),('珠江','淡江','广东','小古？','小古?'),('黄河','黄河','甘肃','小川',NULL),('辽河','太子河','辽宁','小林子',NULL),('淮河','淮河','安徽','小柳巷',NULL),('长江流域太湖区','小梅港','浙江','小梅口',NULL),('长江','牛栏江','云南','小河',NULL),('长江','西洞庭湖湖口(南端)','湖南','小河咀',NULL),('长江','涪江','重庆','小河坝(三)',NULL),('黄河','黄河','河南','小浪底',NULL),('辽河','养息牧河','辽宁','小荒地',NULL),('海河','淳沱河','河北','小觉(河道二)',NULL),('海河','淳沱河','河北','小觉水电',NULL),('长江','小金川','四川','小金',NULL),('珠江','阳江','广西','小长安',NULL),('长江','龙川江','云南','小黄瓜园',NULL),('珠江','南盘江','云南','小龙潭',NULL),('淮河','洪泽湖','江苏','尚咀',NULL),('闽江','尤溪','福建','尤溪大桥',NULL),('长江','桃江','江西','居龙滩',NULL),('钱塘江','新安江','安徽','屯溪',NULL),('黄河','丹河','河南','山路坪',NULL),('珠江','义昌河','广西','岑溪',NULL),('淮河','小清河','山东','岔河',NULL),('长江','金沙江','四川','岗拖(三)',NULL),('黄河','东川河','山西','岢岚',NULL),('长江','渠水','湖南','岩头',NULL),('长江','尼日河','四川','岩润',NULL),('珠江','东江','广东','岭下',NULL),('长江','汉江','湖北','岳口',NULL),('长江','皖水','安徽','岳西',NULL),('长江','洞庭湖湖口','湖南','岳阳',NULL),('黄河','洮河','甘肃','岷县',NULL),('淮河','沙河','山东','峄城',NULL),('长江','贡水','江西','峡山(二)',NULL),('长江流域','赣江','江西','峡江',NULL),('长江','大渡河','四川','峨边',NULL),('长江流域','崇仁水','江西','崇仁',NULL),('珠江','左江','广西','崇左',NULL),('长江流域太湖区','杭嘉平运河','浙江','崇德',NULL),('海河','东沟','河北','崇礼',NULL),('长江','陆水','湖北','崇阳(二)',NULL),('海河','还乡河','河北','崖口(三)',NULL),('浙闽台河流','曹娥江','浙江','嵊州',NULL),('长江','长江','重庆','巫山',NULL),('长江','大宁河','重庆','巫溪(二)',NULL),('长江','长江','湖北','巴东(三)',NULL),('长江','南江-巴河','四川','巴中',NULL),('珠江','南流江','广西','常乐',NULL),('太湖','大运河改线段','江苏','常州(三)',NULL),('长江','沅水','湖南','常德(二)',NULL),('太湖','白茆塘','江苏','常熟',''),('黄河','干河','陕西','干阳',NULL),('珠江','桂江','广西','平乐',NULL),('珠江','洵江','广西','平南',''),('闽东南诸河','花山溪','福建','平和',NULL),('辽河','辽河','辽宁','平安堡',NULL),('长江','型江','贵州','平寨',NULL),('珠江','西枝江','广东','平山(三)',NULL),('海河','冶河','河北','平山(河道)',NULL),('太湖','太浦河','江苏','平望',NULL),('长江','涪江','四川','平武',NULL),('长江','三夹河','河南','平氏','出'),('长江','汨罗江','湖南','平江',NULL),('上饶以上','丰溪河','江西','广丰',NULL),('长江','嘉陵江','四川','广元',NULL),('长江','宁蒗河','四川','庄房 二','庄房二'),('辽河','亮子河','辽宁','庆云堡',NULL),('黄河','马连河','甘肃','庆阳',NULL),('嫩江','嫩江','黑龙江','库漠屯',NULL),('塔里木河','叶尔羌河','新疆','库鲁克栏干三',NULL),('长江','龙溪河','四川','底堡',NULL),('淮河','洪河','河南','庙湾',NULL),('黄河','黄河','陕西','府谷',NULL),('长江','折多河','四川','康定四',NULL),('长江','鄱阳湖','江西','康山',NULL),('海河','排干三渠','河北','康黄甫',NULL),('长江流域','抚河','江西','廖家湾',NULL),('黄河','延水','陕西','延安',NULL),('黄河','清涧河','陕西','延川',NULL),('闽江','闽江','福建','延福门',NULL),('闽江','金溪','福建','建宁',''),('淮河','西塘河','江苏','建湖',NULL),('闽江','建溪','福建','建阳',NULL),('辽河','清河','辽宁','开原',NULL),('内陆河湖','开垦河','新疆','开垦河(三)',NULL),('长江','南河','湖北','开峰峪',NULL),('黄河','茹河','甘肃','开边',NULL),('上饶到弋阳','信江','江西','弋阳',NULL),('海河','拒马河','北京','张坊',NULL),('海河','蓟运河','天津','张头窝闸下',NULL),('海河','白河','北京','张家坟',NULL),('黄河','泾河','陕西','张家山',NULL),('海河','凉水河','北京','张家湾',NULL),('长江','澧水','湖南','张家界',NULL),('黄河','葫芦河','陕西','张村驿',NULL),('黄河','泾河黑河','陕西','张河',NULL),('黄河','水河','山西','张留庄',NULL),('黄河','黄河','山东','张肖堂',NULL),('长江','濑溪河','重庆','弥陀',NULL),('长江','虎渡河','湖北','弥陀寺(二)',NULL),('长江','湘江','湖南','归阳',NULL),('长江','姑溪河','安徽','当涂',NULL),('长江','岷江','四川','彭山四',NULL),('长江','乌江','重庆','彭水(四)',NULL),('黄河','茹河','宁夏','彭阳',NULL),('辽河','柳河','辽宁','彰武',NULL),('海河','瀑河','河北','徐水国平',NULL),('黄河','黄河','青海','循化',NULL),('淮河','微山湖','山东','微山',NULL),('海河','冶河','河北','微水(河道二)',NULL),('内陆','巴音河','青海','德令哈（三）','德令哈（三'),('珠江','西江','广东','德庆(二)',NULL),('松花江吉林段','饮马河','吉林','德惠',NULL),('长江','安宁河','四川','德昌',NULL),('黄河','周河','陕西','志丹',NULL),('长江','长江','重庆','忠县(二)',NULL),('长江','巢湖','安徽','忠庙',NULL),('长江','乌江','贵州','思南',NULL),('长江','湍河','河南','急滩',''),('黄河','黄河','内蒙古','总干渠水文站',NULL),('长江','五郎河','云南','总管田',NULL),('长江','恒河','陕西','恒口',NULL),('长江','清江','湖北','恩施',NULL),('珠江','恭城河','广西','恭城',NULL),('淮河','淮河','河南','息县',NULL),('珠江','东江','广东','惠阳(二)',NULL),('长江','长丰河','甘肃','成县',NULL),('辽河','苏子河','辽宁','战贝',NULL),('黄河','大汶河','山东','戴村坝',NULL),('塔里木河','木扎提河','新疆','托克逊',NULL),('黑龙江','松花江','吉林','扶余',NULL),('珠江','左江','广西','扶绥',NULL),('海河','武烈河','河北','承德',NULL),('珠江','都柳江','贵州','把本临',NULL),('黄河','大夏河','甘肃','折桥二',NULL),('辽河','浑河','辽宁','抚顺',NULL),('黄河','渭河','陕西','拓石',NULL),('闽江','富屯溪','福建','拿口',NULL),('长江','金沙江','四川','攀枝花(二)',NULL),('闽江','七星溪','福建','政和',NULL),('辽河','哨子河','辽宁','文家街',NULL),('闽江','闽江','福建','文山里',NULL),('长江','马尾河','贵州','文峰塔',NULL),('淮河','沂河','山东','斜午',NULL),('海河','沙河','河北','新乐(三)',NULL),('辽河流域','召苏河','内蒙古','新井',NULL),('长江流域','袁水','江西','新余',NULL),('长江','资水','湖南','新化',NULL),('长江','大汶溪','云南','新华二',NULL),('长江','长江','湖北','新厂(二)',NULL),('淮河','潢河','河南','新县',NULL),('珠江','黑水河','广西','新和',NULL),('内陆河','洪水河','甘肃','新地',NULL),('长江','夫夷水','湖南','新宁',NULL),('淮河','老沭河','江苏','新安',NULL),('黄河','涧河','河南','新安 二',NULL),('黄河','涧河','河南','新安二',NULL),('浙闽台河流','新安江','浙江','新安江坝下',NULL),('长江流域太湖区','运河','浙江','新市',''),('黄河','汾川河','陕西','新市河',NULL),('长江','白河','河南','新店铺',NULL),('海河','胭脂河','河北','新房',NULL),('海河','淇河','河南','新村',NULL),('长江','松滋河(西支)','湖北','新江口',NULL),('长江','水阳江','安徽','新河庄',NULL),('塔里木河','塔里木河','新疆','新渠满',NULL),('长江流域','乌江','江西','新田',NULL),('长江','新田河','湖南','新田',NULL),('淮河','洪河','河南','新蔡',NULL),('淮河','双泊河','河南','新郑',NULL),('淮河','洪河','安徽','方集',NULL),('长江','清水江','贵州','施洞',NULL),('长江','舞阳河','贵州','施秉',NULL),('长江','徽水','安徽','旌德',NULL),('太湖','大运河','江苏','无锡南门',NULL),('海河','桃河','山西','旧街',NULL),('长江','东河','四川','旺苍',NULL),('长江','芙蓉江','贵州','旺草',NULL),('太湖','娄江','江苏','昆山',NULL),('内陆河','疏勒河','甘肃','昌马堡',NULL),('淮河','池河','安徽','明光',NULL),('长江','梅溪河','重庆','明水',NULL),('长江','湖口水道','江西','星子',NULL),('珠江','桂江','广西','昭平',NULL),('长江','昭觉河','四川','昭觉',NULL),('长江流域','南潦水','江西','晋坪',NULL),('长江','滁河','江苏','晓桥',NULL),('松花江','汤旺河','黑龙江','晨明',NULL),('黄河','泾河','陕西','景村',NULL),('长江','浏渭河','湖南','朗梨',NULL),('太湖','太湖','江苏','望亭 太','望亭太'),('辽河','大清河','辽宁','望宝山',NULL),('长江','府河','四川','望江楼',NULL),('辽河','大凌河','辽宁','朝阳',NULL),('长江','漾弓江','云南','木家桥',NULL),('辽河','太子河','辽宁','本溪',NULL),('内陆河','黑河','甘肃','札马什克',NULL),('黄河','天然文岩渠','河南','朱付村',NULL),('长江','蛮河','湖北','朱市',NULL),('长江','长江','重庆','朱沱(三)',NULL),('黄河','宏农涧河','河南','朱阳',NULL),('内陆河','杂木河','甘肃','杂木寺',NULL),('长江','杂谷脑河','四川','杂谷脑',NULL),('黄河','小理河','陕西','李家河',NULL),('长江流域','抚河','江西','李家渡',NULL),('长江','倒水','湖北','李家集',NULL),('长江','长江','四川','李庄',NULL),('海河','柳河','河北','李营',NULL),('长江','黄鸭河','河南','李青店',NULL),('黄河','杏子河','陕西','杏河',NULL),('长江','太平江','江西','杜头',NULL),('黑龙江流域','蛟流河','内蒙古','杜尔基',NULL),('黄河','清凉寺沟','山西','杨家坡',NULL),('黄河','泾河','甘肃','杨家坪',NULL),('淮河','洪河','河南','杨庄',NULL),('长江','白沙河','四川','杨柳坪',NULL),('珠江','杨梅河','广西','杨梅',NULL),('淮河','利民沟','安徽','杨楼',NULL),('黄河','黄河','山东','杨集',NULL),('长江流域太湖区','茗溪','浙江','杭长桥',NULL),('长江','松坎河','贵州','松坎(三)',NULL),('辽河','寇河','辽宁','松树',NULL),('松花江吉林段','五道白河','吉林','松江',NULL),('闽江','松溪','福建','松溪',NULL),('松花江吉林段','松花江吉林段','吉林','松花江',NULL),('长江','乌江','贵州','构皮滩',NULL),('淮河','分洪道','江苏','林子',NULL),('黄河','湫水河','山西','林家坪',NULL),('黄河','渭河','陕西','林家村',NULL),('长江','长江','湖北','枝城',NULL),('黄河','西川','陕西','枣园',NULL),('浙闽台河流','永安溪','浙江','柏枝岙',NULL),('长江流域','泸溪水','江西','柏泉',NULL),('长江','乾佑河','陕西','柞水',NULL),('珠江','融江','广西','柳城',NULL),('长江','举水','湖北','柳子港',NULL),('珠江','柳江','广西','柳州',NULL),('黄河','沮河','陕西','柳林',NULL),('长江','旬河','陕西','柴坪',NULL),('黄河','汾河','山西','柴庄',NULL),('海河','东洋河','河北','柴沟堡东 三 河道',NULL),('海河','洋河','河北','柴沟堡东河道',NULL),('海河','南洋河','河北','柴沟堡南',NULL),('海河','南洋河','河北','柴沟堡南 二',NULL),('辽河','柴河','辽宁','柴河',NULL),('淮河','十字河','山东','柴胡店',NULL),('长江流域','赣江','江西','栋背',NULL),('淮河','奎河','安徽','栏杆集','栏桿集'),('长江','湘江','湖南','株洲',NULL),('松花江吉林段','三统河','吉林','样子哨',NULL),('内陆','格尔木河','青海','格尔木四',NULL),('黄河','伊河','河南','栾川二',NULL),('淮河','洪河','河南','桂李',NULL),('珠江','桂江','广西','桂林',NULL),('长江','坝河','陕西','桂花园',NULL),('长江','资水','湖南','桃江(二)',NULL),('长江','沅水','湖南','桃源',NULL),('长江','丰乐河','安徽','桃溪',NULL),('长江流域','宜黄水','江西','桃陂',NULL),('长江','官渡河','贵州','桐梓',NULL),('淮河','新开河','江苏','桐槐树',NULL),('长江','澧水','湖南','桑植(三)',NULL),('黄河','朱家川','山西','桥头',NULL),('黄河','西阳河','山西','桥头',NULL),('辽河','细河','辽宁','桥头',NULL),('黄河','北川河','青海','桥头五',NULL),('闽江','沙溪','福建','梅列',NULL),('韩江','梅江','广东','梅县(四)',NULL),('弋阳以下','信江','江西','梅港',NULL),('长江流域太湖区','西茗溪','浙江','梅溪',NULL),('长江','博阳河','江西','梓坊',NULL),('长江','梓江','四川','梓潼',NULL),('嘉陵江','涪江','重庆','梓潼·盐关垭口',NULL),('珠江','西江','广西','梧州四',NULL),('珠江','武江','广东','梨市(二)',NULL),('辽河','兰河','辽宁','梨庇峪',NULL),('辽河流域','招苏台河','吉林','梨树',NULL),('长江','龙川江','云南','楚雄',NULL),('黄河','大汶河南支','山东','楼德',NULL),('松花江','卡岔河','吉林','榆树',NULL),('海河','榆社河','山西','榆社',NULL),('淮河','沙颖河','河南','槐店',NULL),('长江流域','赣江','江西','樟树',NULL),('长江流域','昌江','江西','樟树坑',NULL),('黄河','芦河','陕西','横山',NULL),('韩江','梅江','广东','横山(二)',NULL),('海河','安阳河','河南','横水',NULL),('珠江','南流江','广西','横江',NULL),('长江','横江','四川','横江(二)',NULL),('松花江吉林段','漂河','吉林','横道子',NULL),('长江流域太湖区','海盐塘','浙江','欤城',NULL),('内陆河','黑河','甘肃','正义峡',NULL),('淮河','淮河','安徽','正阳关',NULL),('长江','汉江','陕西','武侯镇',NULL),('长江','武关河','陕西','武关',NULL),('闽江','建溪','福建','武夷山',NULL),('珠江','黔江','广西','武宣',NULL),('黄河','渭河','甘肃','武山',NULL),('长江','嘉陵江','四川','武胜',NULL),('长江','白龙江','甘肃','武都',NULL),('黄河','沁河','河南','武陟',NULL),('长江','乌江','重庆','武隆',NULL),('黄河','黑木头川','陕西','殿市',NULL),('长江','后河-州河','四川','毛坝',NULL),('黄河','蒲河','甘肃','毛家河',NULL),('长江','大道河','陕西','民主',NULL),('黄河','湟水','青海','民和',NULL),('松花江吉林段','金沙河','吉林','民立',NULL),('闽江','南浦溪','福建','水吉',NULL),('珠江','大同江','广西','水晏',NULL),('长江','修河','江西','永修',NULL),('长江','未水','湖南','永兴(二)',NULL),('闽江','沙溪','福建','永安',NULL),('韩江','永定河','福建','永定',NULL),('长江流域','禾水','江西','永新',NULL),('晋江','晋江东溪','福建','永春',NULL),('闽江','大樟溪','福建','永泰',NULL),('长江','长滩河-巴河','四川','永红',NULL),('长江','猛洞河','湖南','永顺',NULL),('长江','汉江','陕西','汉中',NULL),('长江','长江','湖北','汉口',NULL),('长江','汉江','湖北','汉川',NULL),('长江','绵远河','四川','汉王场',NULL),('松花江吉林段','二道松花江','吉林','汉阳屯',NULL),('淮河','北汝河','河南','汝州',NULL),('黄河','汝箕沟','宁夏','汝箕沟三',NULL),('长江','褒河','陕西','江口',NULL),('长江','涪江','四川','江曲',NULL),('嫩江','嫩江','黑龙江','江桥',NULL),('长江','永明河','湖南','江永',NULL),('长江','涪江','四川','江油',NULL),('珠江','南盘江','云南','江边街',NULL),('闽江','金溪','福建','池潭坝下水文站',NULL),('婺源以上','段莘水','江西','汪口',NULL),('淮河','淮河','安徽','汪集',NULL),('海河','卫河','河南','汲县',NULL),('长江','梅川','江西','汾坑',NULL),('黄河','汾河','山西','汾河二坝 河道二','汾河二坝河道二'),('长江','万子湖','湖南','沅江(二)',NULL),('辽河','浑河','辽宁','沈阳',NULL),('淮河','新沂河','江苏','沐阳',NULL),('闽江','沙溪','福建','沙县',NULL),('珠江','北江','广东','沙口',NULL),('淮河','汝河','河南','沙口',NULL),('长江','资水','湖南','沙头(二)',NULL),('长江流域','盱江','江西','沙子岭',NULL),('长江','长江','湖北','沙市',NULL),('塔里木河','库山河','新疆','沙曼二',NULL),('长江','汉江','湖北','沙洋(三)',NULL),('长江','复兴河','重庆','沙滩',NULL),('长江','松滋河(东支)','湖北','沙道观(二)',NULL),('辽河','大洋河','辽宁','沙里寨',NULL),('辽河','庄河','辽宁','沙里涂',NULL),('辽河','崩河','内蒙古','沟门子(四)',NULL),('淮河','新沂河','江苏','沭阳',NULL),('上饶到弋阳','信江','江西','河口',NULL),('黄河','黄河','山西','河曲',NULL),('长江','中东津河','安徽','河沥溪',NULL),('黄河','汾河','山西','河津',NULL),('珠江','东江','广东','河源',NULL),('长江','武水','湖南','河溪',NULL),('长江','沮漳河','湖北','河溶',NULL),('长江','通口河','四川','治城',NULL),('长江','大溪河','重庆','沿塘',NULL),('长江','乌江','贵州','沿河',NULL),('海河','松溪河','山西','泉口',NULL),('黄河','清水河','宁夏','泉眼山(二)','泉眼山(二'),('长江','泌阳河','河南','泌阳',NULL),('黄河','王家河','山西','泗交',NULL),('淮河','濉河','江苏','泗洪(濉)','泗洪(潍)'),('淮河','老濉河','江苏','泗洪(老)',NULL),('海河','卫河','河南','波县',NULL),('淮河','泗河','山东','波罗树',NULL),('海河','兴州河','河北','波罗诺',NULL),('长江流域','赣江','江西','泰和',NULL),('长江','安居河','重庆','泰安',NULL),('长江','通扬运河','江苏','泰州(通)',NULL),('长江','雅江','四川','泸宁',NULL),('长江','大渡河','四川','泸定二',NULL),('长江','长江','四川','泸州(三)',NULL),('黄河','黄河','山东','泺口',NULL),('长江','汉江','湖北','泽口',NULL),('长江','青弋江','安徽','泾县',NULL),('黄河','泾河','甘肃','泾川',NULL),('黄河','泾河','宁夏','泾河源三',NULL),('闽东诸河','霍童溪','福建','洋中坂',NULL),('长江','汉江','陕西','洋县',NULL),('闽江','富屯溪','福建','洋口',NULL),('黄河','北川河','山西','洞',NULL),('长江','平溪','湖南','洞口(二)',NULL),('太湖','太湖','江苏','洞庭西山(三)',NULL),('长江','澧水','湖南','津市(二)','(二)册'),('长江','陆水','湖北','洪下',NULL),('长江','六冲河','贵州','洪家渡二',NULL),('黄河','马连河','甘肃','洪德',NULL),('长江','巫水','湖南','洪江(二)',NULL),('晋江','晋江东溪','福建','洪濑',NULL),('松花江','洮儿河','吉林','洮南',NULL),('长江','流沙河','四川','流沙河',NULL),('黄河','河南','河南','济源',NULL),('海河','淳沱河','山西','济胜桥',NULL),('闽东南诸河','九龙江','福建','浦南',NULL),('长江','沅水','湖南','浦市(二)',NULL),('淮河','通扬运河','江苏','海安(通)',NULL),('黄河','湟水','青海','海晏三',NULL),('海河','海河','天津','海河闸上',NULL),('珠江','都柳江','广西','涌尾',NULL),('长江','索溪-资水河阳化河','四川','涌泉',NULL),('黄河','涝河','陕西','涝峪口',NULL),('黄河','沁河','河南','润城',NULL),('淮河','淮河','安徽','润河集',NULL),('长江','涪江','四川','涪江桥二',NULL),('海河','卫河','河南','淇门',NULL),('海河','淋河','天津','淋河桥',NULL),('长江','溇水','湖南','淋溪河',NULL),('淮河','淮河','安徽','淮南',NULL),('淮河','淮河','河南','淮滨',NULL),('黄河','冶峪河','陕西','淳化',NULL),('海河','清水河','北京','清水',NULL),('黄河流域','清水河','内蒙古','清水河',NULL),('长江','马边河','四川','清水溪二',NULL),('黄河','黄河','山东','清河镇',NULL),('长江','东河','四川','清泉乡',NULL),('长江','长江','重庆','清溪场(四)',NULL),('珠江','北江','广东','清远(三)',NULL),('长江','渔子溪','四川','渔子溪',NULL),('长江','清江','湖北','渔峡口',NULL),('钱塘江','练江','安徽','渔梁',NULL),('长江','渔洋河','湖北','渔洋关',NULL),('长江流域','昌江','江西','渡峰坑',NULL),('黄河','窟野河','陕西','温家川',NULL),('艾比湖','博尔塔拉河','新疆','温泉',NULL),('淮河','沂河','江苏','港上',NULL),('长江流域太湖区','西苕溪','浙江','港口',NULL),('浙闽台河流','浦阳江','浙江','湄池',NULL),('长江','鄱阳湖湖口','江西','湖口',NULL),('晋江','晋江西溪','福建','湖头',NULL),('长江','涟水','湖南','湘乡',NULL),('太湖','阳澄湖','江苏','湘城',NULL),('长江','湘江','湖南','湘潭',NULL),('长江','湘江(东支)','湖南','湘阴',NULL),('黄河','湟水','青海','湟源',NULL),('长江','沅水','湖南','溆浦(二)',NULL),('太湖','宜溧漕河','江苏','溧阳(二)',NULL),('韩江','汀江','广东','溪口',NULL),('长江','清流河','安徽','滁州',NULL),('淮河','城河','山东','滕州',NULL),('海河','滦河','河北','滦县',NULL),('长江','乌江','重庆','滩(二)',NULL),('淮河','大运河','江苏','滩上集',NULL),('海河','漕河','河北','漕河',NULL),('海河','大石河','北京','漫水河',NULL),('松花江吉林段','漫江','吉林','漫江',NULL),('黄河','汤峪河','陕西','漫湾',NULL),('淮河','沙颖河','河南','漯河',NULL),('闽东南诸河','九龙江','福建','漳平',NULL),('内陆河','疏勒河','甘肃','潘家庄',NULL),('长江','东荆河','湖北','潜江',NULL),('淮河','潢河','河南','潢川',NULL),('长江流域','昌江','江西','潭口','口'),('黄河','伊河','河南','潭头',NULL),('韩江','韩江','广东','潮安',NULL),('黄河','黄河','陕西','潼关',NULL),('长江','涪江','四川','潼川',NULL),('长江','激水','湖南','激浦(二)',NULL),('闽南沿海诸河','木兰溪','福建','濑溪',NULL),('黄河','金堤河','河南','濮阳',NULL),('长江','马蹄河','贵州','濯河坝',NULL),('淮河','盐河','江苏','灌云',NULL),('长江','马蹄河','贵州','灌河坝',NULL),('长江','灌江','广西','灌阳',NULL),('黄河','洛河','陕西','灵口',NULL),('黄河','达溪河','甘肃','灵台',NULL),('珠江','灵渠','广西','灵渠',NULL),('长江','河漠水','湖南','炎陵',NULL),('塔里木河','开都河','新疆','焉耆',NULL),('辽河','熊岳河','辽宁','熊岳',NULL),('黄河','宝库河','青海','牛场',NULL),('长江','白水江','云南','牛街',NULL),('长江','沅江','湖南','牛鼻滩',NULL),('松花江','牡丹江','黑龙江','牡丹江',NULL),('珠江','武水','广东','犁市(二)',NULL),('黄河','北洛河','陕西','状头',NULL),('长江','舞阳河','贵州','玉屏(崇滩)',NULL),('上饶以上','玉山水','江西','玉山',NULL),('内陆河','石油河','甘肃','玉门市',''),('淮河','闾河','河南','王勿桥',NULL),('辽河','东辽河','吉林','王奔',NULL),('辽河','招苏台河','辽宁','王宝庆',NULL),('淮河','淮河','安徽','王家坝',NULL),('海河','沙河','河北','王林口',NULL),('长江流域太湖区','杭嘉平运河','浙江','王江泾',NULL),('黄河','窟野河','陕西','王道恒塔',NULL),('黄河','黄河','甘肃','玛曲',NULL),('珠江','环江','广西','环江',NULL),('珠江','滨江','广东','珠坑',NULL),('辽河','辽河','辽宁','珠尔山',NULL),('淮河','洪河','河南','班台',NULL),('太湖','琳桥港','江苏','琳桥',NULL),('长江','绵水','江西','瑞金',NULL),('太湖','瓜泾港','江苏','瓜泾口',NULL),('淮河','瓦埠湖','安徽','瓦埠',NULL),('长江流域太湖区','东苕溪','浙江','瓶窑',NULL),('长江','雅江','四川','甘孜二',NULL),('黄河','散渡河','甘肃','甘谷',NULL),('黄河','延水','陕西','甘谷驿',NULL),('太湖','望虞河','江苏','甘露',NULL),('黄河','佳芦河','陕西','申家湾',NULL),('海河','淳沱河','山西','界河铺',NULL),('淮河','沙颖河','安徽','界首',NULL),('长江','嘉陵江','陕西','略阳',NULL),('长江','沱江','四川','登瀛岩',NULL),('长江','白龙江','甘肃','白云',NULL),('黑龙江流域','霍林河','内蒙古','白云胡硕',NULL),('长江','白河','河南','白土岗',NULL),('闽东诸河','交溪','福建','白塔',NULL),('黄河','无定河','陕西','白家川',NULL),('长江','白石河','陕西','白岩',NULL),('辽河','乌根稿河','辽宁','白庙子',NULL),('长江流域','孤江','江西','白沙',NULL),('长江','汉江','陕西','白河',NULL),('淮河','白鹭河','河南','白雀园',NULL),('长江','大河','湖北','白霓桥(二)',NULL),('黄河','洛河','河南','白马寺',NULL),('长江','金沙江','云南','白鹤滩',NULL),('珠江','右江','广西','百色(三)',NULL),('长江','溧水','湖南','皂市(二)',NULL),('长江','汉江','湖北','皇庄',NULL),('黄河','皇甫川','陕西','皇甫',NULL),('黄河','亳清河','山西','皋落(河南)',NULL),('黄河','洮河','甘肃','皖县',NULL),('和田河流域','皮山河','新疆','皮山',NULL),('黄河','清姜河','陕四','益门镇',NULL),('黄河','清姜河','陕西','益门镇',NULL),('长江','资水','湖南','益阳(二)',NULL),('淮河','串场河','江苏','盐城',NULL),('长江','长江','湖北','监利(二)',NULL),('淮河','淮河','江苏','盱眙',NULL),('长江','通天河','青海','直门达',NULL),('海河','桑干河','河北','石匣里二',NULL),('黄河','黄河','宁夏','石嘴山',NULL),('长江','琴江','江西','石城',NULL),('长江','毗河','四川','石堤堰',NULL),('黄河','珍水','河南','石寺',NULL),('长江','澧水','湖南','石山',NULL),('淮河','沭河','山东','石拉渊',NULL),('淮河','小清河','山东','石村',NULL),('长江','龙河','重庆','石柱',NULL),('海河','浊漳河','山西','石梁',NULL),('长江','大渡河','四川','石棉',NULL),('长江','汉江','陕西','石泉',NULL),('珠江','都柳江','贵州','石灰厂',NULL),('长江','皖河中下游','安徽','石牌',NULL),('浙闽台河流','晋江','福建','石砻',NULL),('晋江','晋江','福建','石著',NULL),('珠江','北江','广东','石角',NULL),('长江流域 区域','蒲河','重庆','石角',NULL),('淮河','池河','安徽','石角桥',NULL),('长江','乐安河','江西','石镇街',NULL),('长江','澧水','湖南','石门',NULL),('长江','蒸水','湖南','石门坎',NULL),('辽河','柳河','辽宁','石门子',NULL),('黄河','石门川','陕西','石门峪二',NULL),('长江','石阡河','贵州','石阡(二)',NULL),('长江','长江','湖北','石首',NULL),('长江','金沙江','云南','石鼓',NULL),('长江','长江','江西','码头镇',NULL),('黄河','洮河','甘肃','碌曲',NULL),('长江','白龙江','甘肃','碧口',NULL),('长江','大通江-通江-巴河','四川','碧溪',NULL),('嫩江','雅鲁河','黑龙江','碾子山',NULL),('长江','唐河','河南','社旗',NULL),('黄河','牛头河','甘肃','社棠',NULL),('内陆河','八宝河','甘肃','祁连',NULL),('长江','湘江','湖南','祁阳(二)',NULL),('长江','蒸水','湖南','神山头',NULL),('黄河','窟野河','陕西','神木',NULL),('辽河','辽河','辽宁','福德店',NULL),('长江','南广河','四川','福溪',NULL),('长江','濑溪河','四川','福集',NULL),('长江','鱼梁河','贵州','禾丰',NULL),('长江','梅江','重庆','秀山',NULL),('黄河','葫芦河','甘肃','秦安',NULL),('黄河','沣河','陕西','秦渡镇',NULL),('海河','沙河','河北','端庄 二','端庄二'),('长江','堵河','湖北','竹山',NULL),('闽江','闽江','福建','竹岐',NULL),('长江','银花河','陕西','竹林关',NULL),('长江','洢溪','湖南','竹溪坡',NULL),('淮河','竹竿河','河南','竹竿铺',NULL),('长江','澧水','湖南','箦子头','簀子头'),('长江','澧水','湖南','簧子头',NULL),('长江','老灌河','河南','米坪',NULL),('艾比湖','精河','新疆','精河山口三',NULL),('淮河','北汝河','河南','紫罗山',NULL),('海河','拒马河','河北','紫荆关 河道','紫荆关河道'),('长江','红岩溪','湖南','红岩溪',NULL),('黄河','庄浪河','甘肃','红崖子',NULL),('黄河','洮河','甘肃','红旗',NULL),('辽河','绕阳河','辽宁','红旗堡',NULL),('黄河','红柳沟','宁夏','红柳沟鸣沙洲四',NULL),('长江','渚河','陕西','红椿',NULL),('内陆河','石羊河','甘肃','红水河',NULL),('长江','织金河','贵州','织金',NULL),('珠江','龙江','广西','绍川',NULL),('世兜','六股河','辽宁','绥中',NULL),('黄河','大理河','陕西','绥德',NULL),('粤西沿海诸河','九洲江','广东','缸瓦窑(三)',NULL),('渤海岸','小凌河','辽宁','缸窑口',NULL),('长江','西河','安徽','缺口',NULL),('长江','资水','湖南','罗家庙',NULL),('海河','洵河','天津','罗庄子',NULL),('黄河','潮河','陕西','罗李村',NULL),('长江','凯江','四川','罗江',NULL),('长江','渠江','四川','罗渡溪(二)',NULL),('长江','长河','湖北','罗田',NULL),('长江','濂水','江西','羊信江',NULL),('长江','美姑河','四川','美姑',NULL),('黄河流域','大黑河','内蒙古','美岱',NULL),('黄河','漆水河','陕西','耀县',NULL),('长江','湘江','湖南','老埠头',NULL),('淮河','洪泽湖','江苏','老子山',NULL),('长江','未水','湖南','耒阳',NULL),('白塔河','白塔河','江西','耙石',NULL),('辽河','碾盘河','辽宁','耿王庄',NULL),('长江','渔洋河','湖北','聂家河',NULL),('海河','徒骇河','山东','聊城',NULL),('内陆河','梨园河','甘肃','肃南',NULL),('长江','西河','四川','肖家',NULL),('玛纳斯湖流域','玛纳斯河','新疆','肯斯瓦特',NULL),('绕阳河','东沙河','辽宁','胡家',NULL),('长江','妻江','四川','胡家坝',NULL),('太湖','太湖','江苏','胥口(闸上游)',NULL),('珠江','新兴江','广东','腰古二',NULL),('辽河','辽河','辽宁','腰屯',NULL),('淮河','清洋河','山东','臧格庄',NULL),('长江','松滋河(中支)','湖南','自治局(三)',NULL),('长江','釜溪河','四川','自贡',NULL),('长江','白龙江','甘肃','舟曲',NULL),('闽东南诸河','船场溪','福建','船场',NULL),('黄河','黄河','山东','艾山',NULL),('海河','滏阳新河','河北','艾辛庄',NULL),('黄河','潇河','山西','芦家庄',NULL),('淮河','臻头河','河南','芦庄',NULL),('长江','长河','安徽','花凉亭东山头二',NULL),('长江','澴水','湖北','花园',NULL),('长江','濃水','湖北','花园',NULL),('黄河','黄河','河南','花园口',NULL),('长江','普里河','重庆','花林',NULL),('太湖','大运河','江苏','苏州枫桥',NULL),('海河','潮白河','北京','苏庄',NULL),('黄河','黄河','山东','苏泗庄',NULL),('黄河','黑河','四川','若尔盖',NULL),('黄河','苦水河','宁夏','苦水河郭家桥三','苦水河 郭家桥三'),('珠江','北江','广东','英德(五)',NULL),('内陆河','乌鲁木齐河','新疆','英雄桥(二)水文站',NULL),('黄河','金堤河','河南','范县',NULL),('长江','赤水河','贵州','茅台',NULL),('长江','长江','湖北','茅坪(二)',NULL),('辽河','碧流河','辽宁','茧场',NULL),('长江','沮水','陕西','茶店',NULL),('珠江','潭水河','广东','荆山',NULL),('长江','丹江','河南','荆紫关',NULL),('珠江','乌都河','贵州','草坪头(水位1)',NULL),('长江','草尾河','湖南','草尾',NULL),('珠江','樟江','贵州','荔波',NULL),('珠江','荔浦河','广西','荔浦',NULL),('珠江','鉴河','广西','荣华',NULL),('长江','荥经河','四川','荥经',NULL),('淮河','沭河','山东','莒县',NULL),('黄河','牟汶河','山东','莱芜',NULL),('松花江','蚂蚁河','黑龙江','莲花',NULL),('长江','长江','湖南','莲花塘',NULL),('内陆河','黑河','甘肃','莺落峡',NULL),('长江','横岭湖','湖南','营田',NULL),('海河','南拒马河','河北','落宝滩二',NULL),('长江','马汉河','江苏','葛塘',NULL),('淮河','沂河','山东','葛沟',NULL),('长江','长江','湖北','葛洲坝5#',NULL),('长江','唐白河','湖北','董坡',NULL),('黄河','药水河','青海','董家庄 三','董家庄三'),('长江','南渺河','安徽','董铺坝下',NULL),('淮河','洪泽湖','江苏','蒋坝',NULL),('淮河','史河','河南','蒋家集',NULL),('长江','沂溪','湖南','蒙公塘',NULL),('淮河','东汶河','山东','蒙阴',NULL),('海河','澈河','河北','蓝旗营',NULL),('长江','清溪河','四川','蓬安',NULL),('海河','清漳东源','山西','蔡家庄',NULL),('长江','螳螂川','云南','蔡家村',NULL),('松花江','拉林河','吉林','蔡家沟',NULL),('海河','漳河','河北','蔡小庄',NULL),('淮河','沙河','山东','薛城',NULL),('长江','安乡河','湖北','藕池(康三)',NULL),('长江','藕池河','湖北','藕池(管)',NULL),('珠江','浔江','广西','藤县',NULL),('长江流域','乐安河','江西','虎山',NULL),('淮河','淮河','安徽','蚌埠',NULL),('淮河','淮河','安徽','蚌埠闸下',NULL),('松花江吉林段','蛟河','吉林','蛟河',NULL),('长江','蜀河','陕西','蜀河',NULL),('珠江','融江','广西','融水',NULL),('长江','长江','湖北','螺山',NULL),('长江','金井河','湖南','螺岭桥',NULL),('长江','湘江','湖南','衡山(二)',NULL),('长江','湘江','湖南','衡阳',NULL),('浙闽台河流','衢江','浙江','衢州',NULL),('黄河','讷河','甘肃','袁家庵',NULL),('黄河','屈产河','山西','裴沟',NULL),('长江','汉江','湖北','襄阳',NULL),('长江','牧马河','陕西','西乡',NULL),('长江','淇河','河南','西坪',NULL),('长江','西宁河','四川','西宁',NULL),('长江','老灌河','河南','西峡',NULL),('珠江','南盘江','云南','西桥',NULL),('黄河','黄河','山东','西河口',NULL),('长江','青弋江','安徽','西河镇',NULL),('长江','蕲水','湖北','西河驿',NULL),('黄河','西纳川','青海','西纳川二',NULL),('淮河','康沟河','河南','西黄庄',NULL),('海河','漳河','河北','观台(河)',NULL),('长江','越溪河','四川','观音',NULL),('海河','十里河','山西','观音堂',NULL),('韩江','汀江','福建','观音桥',NULL),('淮河','访河','山东','角沂',NULL),('嫩江','讷谟尔河','黑龙江','讷河',NULL),('闽东南诸河','诏安东溪','福建','诏安',NULL),('浙闽台河流','浦阳江','浙江','诸暨浣纱桥',NULL),('长江','长江','湖北','调弦口',NULL),('长江','嘉陵江','甘肃','谈家庄',NULL),('淮河','狮河','河南','谭家河',NULL),('长江','南河','湖北','谷城',NULL),('长江','关河','云南','豆沙关二',NULL),('海河','牧马河','山西','豆罗桥',NULL),('珠江','柳江','广西','象州',NULL),('珠江','北流河','广西','象棋',NULL),('黄河','黄河','青海','贵德',NULL),('珠江','郁江','广西','贵港',NULL),('弋阳到梅港','信江','江西','贵溪',NULL),('长江','南明河','贵州','贵阳(三)水文站',NULL),('长江','天河','湖北','贾家坊',NULL),('黄河','东川','甘肃','贾桥',NULL),('长江','贡水','江西','赣州',NULL),('辽河流域','英金河','内蒙古','赤峰(五)',NULL),('长江','赤水河','贵州','赤水',NULL),('长江','赤水河','贵州','赤水河',NULL),('黄河','汾河','山西','赵城',NULL),('长江','李子溪','四川','赵家祠',NULL),('黄河','无定河','陕西','赵石窑',NULL),('长江','文井江-西河','四川','跃子岩',NULL),('渤海岸','女儿河','辽宁','边沿子',NULL),('辽河','辽河','辽宁','辽中',NULL),('辽河','太子河','辽宁','辽阳',NULL),('珠江','红水河','广西','迁江',NULL),('淮河','大运河','江苏','运河',NULL),('黄河','大通河','甘肃','连城',NULL),('长江','通江-巴河','四川','通江',NULL),('辽河','辽河','辽宁','通江口',NULL),('松花江','松花江','黑龙江','通河',NULL),('辽河流域','西辽河','内蒙古','通辽(五)',NULL),('长江','渠水','湖南','通道',NULL),('淮河','汝河','河南','遂平',NULL),('长江','潇水','湖南','道县(二)',NULL),('长江','鲜水河','四川','道孚三',NULL),('长江','南河','四川','邛崃',NULL),('辽河','浑河','辽宁','邢家窝棚',NULL),('长江','南江-巴河','四川','邮',NULL),('闽江','富屯溪','福建','邵武',NULL),('长江','资水','湖南','邵阳',NULL),('淮河','涡河','河南','邸阁',NULL),('辽河','西辽河','吉林','郑家屯',NULL),('闽东南诸河','西溪','福建','郑店',NULL),('辽河','汤河(西支)','辽宁','郝家店',NULL),('长江','长江','湖北','郝穴(二)',NULL),('海河','滦河','河北','郭家屯',NULL),('长江','唐河','河南','郭滩',''),('长江','郴水','湖南','郴州',NULL),('珠江','红水河','广西','都安',NULL),('长江','鄱阳湖','江西','都昌',NULL),('长江','岷江','四川','都江堰',NULL),('长江','饶河','江西','鄱阳',NULL),('长江','酉水河','陕西','酉水街',NULL),('淮河','沭河','山东','重沟',NULL),('浙闽台河流','金华江','浙江','金华',NULL),('珠江','龙江','广西','金城江',NULL),('南渡江','南渡江','海南','金江',NULL),('淮河','入江水道','江苏','金湖',NULL),('长江','嘉陵江','四川','金溪',NULL),('淮河','徐洪河','江苏','金锁镇',NULL),('珠江','北流河','广西','金鸡二',NULL),('淮河','官沙湖','安徽','钌岗',NULL),('淮河','官沙湖','安徽','钐岗','岗'),('长江流域太湖区','海盐塘','浙江','钦城',NULL),('辽河','辽河','辽宁','铁岭',NULL),('上饶到弋阳','含珠水','江西','铁路坪',NULL),('长江','玉带河','陕西','铁锁关',NULL),('渤海岸','小凌河','辽宁','锦州',NULL),('长江','岷江','四川','镇江关',NULL),('长江','皖江','四川','镇江天',NULL),('长江流域太湖区','长兴港','浙江','长兴',NULL),('淮河','淮河','河南','长台关',NULL),('长江','芙蓉江','贵州','长坝',NULL),('珠江','融江','广西','长安',NULL),('长江','长江','重庆','长寿(二)',NULL),('松花江吉林段','饮马河','吉林','长岭',NULL),('长江','月河','陕西','长枪铺',NULL),('黄河','洛河','河南','长水二',NULL),('长江','湘江','湖南','长沙(三)',NULL),('长江','金钱河','湖北','长沙坝(二)',NULL),('长江','肖溪河(东滩河','四川','长滩桥',NULL),('长江','溇水','湖南','长潭河',NULL),('长江','清江','湖北','长阳(二)',NULL),('黄河','黄河','青海','门堂',NULL),('闽江','梅溪','福建','闽清',NULL),('长江','嘉陵江','四川','阆中',NULL),('淮河','射阳河','江苏','阜宁',NULL),('海河','沙河','河北','阜平三',NULL),('大凌河','细河','辽宁','阜新',NULL),('珠江','防城河','广西','防城',NULL),('珠江','桂江','广西','阳朔',NULL),('海河','桃河','山西','阳泉',NULL),('长江','三岔河','贵州','阳长(纳雍县)',NULL),('塔里木河','塔里木河','新疆','阿拉尔',NULL),('内陆河湖','阿拉沟','新疆','阿拉沟(二)',NULL),('珠江','钦江','广西','陆屋',NULL),('太湖','陈墓荡','江苏','陈墓(锦溪)',NULL),('长江','长江','湖北','陈家湾',NULL),('陵水河','陵水河','海南','陵水',NULL),('长江','辰水','湖南','陶伊',NULL),('长江','报水','湖南','隆回',NULL),('珠江','右江','广西','隆安',NULL),('黄河','清流河','宁夏','隆德',NULL),('长江','涢水','湖北','隔蒲潭',NULL),('海河','永定河','北京','雁翅',NULL),('长江','雅蓉江','四川','雅江三',NULL),('黄河','马连河','甘肃','雨落坪',NULL),('珠江','蒙江','贵州','雷公滩',NULL),('长江','雾渡河','湖北','雾渡河',NULL),('长江','小通江-通江-巴河','四川','青峪',NULL),('长江','乔庄河','四川','青川',NULL),('长江','乾佑河','陕西','青泥湾',NULL),('海河','清水河','北京','青白口',NULL),('长江','岷江','四川','青神','旱'),('黄河','黄河','宁夏','青铜峡',NULL),('黄河','河东总干渠','宁夏','青铜峡东总',NULL),('黄河','河西总干渠','宁夏','青铜峡西总',NULL),('黄河','大理河','陕西','青阳岔',NULL),('松花江吉林段','珠子河','吉林','靖宇',NULL),('黄河','祖厉河','甘肃','靖远',NULL),('黄河','汾河','山西','静乐',NULL),('黄河','葫芦河','甘肃','静宁',NULL),('长江','流江河','四川','静边',NULL),('黄河','黄河','山东','韩刘',NULL),('黄河','韩城河','河南','韩城',NULL),('辽河','绕阳河','辽宁','韩家杖子',NULL),('淮河','微山湖','山东','韩庄(微)',NULL),('黄河','清水河','宁夏','韩府湾三',NULL),('海河','午河','河北','韩村三',NULL),('珠江','北江','广东','韶关(二)',NULL),('长江','巴河','四川','风滩',NULL),('黄河','沁河','山西','飞岭',NULL),('珠江','北江','广东','飞来峡',NULL),('香屯以上','乐安河','江西','香屯',NULL),('珠江','西江干流水道','广东','马',NULL),('淮河','独山湖','山东','马口','马'),('长江流域','相水','江西','马口','马'),('长江','长江','湖北','马家店',NULL),('长江','巴水','湖北','马家潭',NULL),('珠江','马别河','贵州','马岭水位1',NULL),('淮河','白马河','山东','马楼',NULL),('长江','池河','陕西','马池',NULL),('黄河','灞河','陕西','马渡王',NULL),('辽河','辽河','辽宁','马虎山',NULL),('长江','马边河','四川','马边',NULL),('长江','褒河','陕西','马道',NULL),('珠江','刁江','广西','马陇',NULL),('淮河','练江河','河南','驻马店',NULL),('松花江吉林段','头道松花江','吉林','高丽城子',NULL),('珠江','南盘江','','高古马',NULL),('长江','岷江','四川','高场(五)',NULL),('长江','清江','湖北','高坝洲',NULL),('长江流域','锦河','江西','高安',NULL),('黄河','秃尾河','陕西','高家堡',NULL),('长江','丹水','湖北','高家堰',NULL),('黄河','秃尾河','陕西','高家川',NULL),('内陆河','黑河','甘肃','高崖',NULL),('鉴江','鉴江','广东','高州(四)',NULL),('长江','石亭江','四川','高景关',NULL),('黄河','黄河','山东','高村',NULL),('黄河','滴河','陕西','高桥',NULL),('长江','修河','江西','高沙',''),('长江','固城湖','江苏','高淳',NULL),('长江','任河','陕西','高滩',NULL),('黄河','孤山川','陕西','高石崖',NULL),('长江','酉水','湖南','高砌头(二)',NULL),('西江','西江','广东','高要',NULL),('珠江','连江','广东','高道',NULL),('淮河','里运河','江苏','高邮(大)',NULL),('淮河','高邮湖','江苏','高邮(高)',NULL),('淮河','蒙河','山东','高里',NULL),('黄河','渭河','陕西','魏家堡',NULL),('淮河','东鱼河','山东','鱼台',NULL),('淮河','淮河','安徽','鲁台子',NULL),('长江','湘江','贵州','鲤鱼塘',NULL),('浙闽台河流','瓯江','浙江','鹤城',NULL),('长江','漾弓江','云南','鹤庆',NULL),('黄河','石头河','陕西','鹦鸽',NULL),('弋阳到梅港','信江','江西','鹰潭',NULL),('长江','东洞庭湖','湖南','鹿角(二)',NULL),('珠江','增江','广东','麒麟咀(二)',NULL),('长江','湘水','江西','麻州',NULL),('闽江','麻阳溪','福建','麻沙',''),('黄河','黄河','山东','麻湾',NULL),('长江','攸水','湖南','黄丰桥',NULL),('珠江','洛清江','广西','黄冕',NULL),('淮河','小清河','山东','黄台桥',NULL),('海河','共产主义渠','河南','黄土岗',NULL),('长江','落漏河','云南','黄坪',NULL),('长江','汉江','湖北','黄家港','黃家港'),('淮河','胜利河','山东','黄寺',NULL),('淮河','黄尾河','安徽','黄尾河',NULL),('长江','虎渡河','湖北','黄山头(闸上)',NULL),('长江','虎渡河','湖北','黄山头(闸下)',NULL),('淮河','洗府河','山东','黄庄',NULL),('黄河','黄河','山东','黄庄',NULL),('长江','老龙河','江苏','黄桥',NULL),('淮河','颖河','河南','黄桥',NULL),('长江','报水','湖南','黄桥',NULL),('塔里木河','黄水沟','新疆','黄水沟','黃水沟'),('黄河','黄河','青海','黄河沿',NULL),('淮河','史河','安徽','黄泥庄',NULL),('长江','长江','湖北','黄石港','黃石港'),('辽河','浑河','辽宁','黄腊坨',NULL),('长江','中河-后河-州河','四川','黄金口',NULL),('长江','混水','湖北','黄陂',NULL),('黄河','沮河','陕西','黄陵',NULL),('长江','长江','湖北','黄陵庙(陡)',NULL),('长江','堵河','湖北','黄龙滩',NULL),('淮河','史河','河南','黎集',NULL),('塔里木河','黑孜河','新疆','黑孜',NULL),('黄河','黑河','陕西','黑峪口',NULL),('长江','黑水河','四川','黑水',NULL),('黄河','伊洛河','河南','黑石关',NULL),('长江','沅水','湖南','黔城',NULL),('嫩江','嫩江','黑龙江','齐齐哈尔',NULL),('南渡江','南渡江','海南','龙塘',NULL),('黄河','西柳沟','内蒙古','龙头拐',NULL),('长江','涞水','湖南','龙家山',NULL),('闽东南诸河','芗江','福建','龙山',NULL),('珠江','东江','广东','龙川',NULL),('长江','金沙江','云南','龙街(三)',NULL),('黄河','黄河','陕西','龙门',NULL),('黄河','伊河','河南','龙门镇',NULL);
/*!40000 ALTER TABLE `hy_download_water_mapping_dj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hy_download_water_mapping_sk`
--

DROP TABLE IF EXISTS `hy_download_water_mapping_sk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_mapping_sk` (
  `basin_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '流域',
  `river_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '河名',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '行政区划',
  `station_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '站名',
  `station_name_alias` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '别名',
  PRIMARY KEY (`station_name`,`province_name`,`basin_name`,`river_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='大型水库映射表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hy_download_water_mapping_sk`
--

LOCK TABLES `hy_download_water_mapping_sk` WRITE;
/*!40000 ALTER TABLE `hy_download_water_mapping_sk` DISABLE KEYS */;
INSERT INTO `hy_download_water_mapping_sk` VALUES ('淮河','索河','河南','丁店',''),('珠江','东江','广东','七水库',''),('珠江','东江','广东','七磜水库',NULL),('太阳河','太阳河','海南','万宁水库 (大坝)','万宁水库大坝'),('长江流域','赣江','江西','万安水库',''),('闽东南诸河','万安溪','福建','万安水库',''),('黄河','黄河','山西','万家寨上',NULL),('黄河','黄河','山西','万家赛上',''),('长江','梁河','河南','三山',''),('长江','长江','湖北','三峡',''),('长江','阎家河','湖北','三河口',''),('长江','陆马河','湖北','三湖连江',''),('长江','蛮河','湖北','三道河',''),('粤东沿海诸河','三坑溪','广东','上三坑',''),('珠江','二渡河','广东','上板桥',''),('长江流域','苏溪','江西','上游水库',''),('粤东沿海诸河','金溪河','广东','上金溪',''),('黄河','大汶河南支','山东','东周水库',''),('闽南沿海诸河','延寿溪','福建','东圳',''),('黄河','巴燕河','青海','东大滩',''),('黄河','东平湖','山东','东平湖老湖',''),('闽南诸河','龙江','福建','东张水库',''),('萩芦溪','三叉河溪','福建','东方红',''),('海河','滏阳河','河北','东武仕水库(坝上)',''),('长江','耒水','湖南','东江',''),('珠江','廊田水','广东','东洛',''),('珠江','那龙河','广东','东湖',''),('闽江','建溪','福建','东溪水库',''),('长江','两河口河','湖北','两河口',''),('松花江流域','松花江吉林段','吉林','丰满',''),('海河','溉河','河北','临城水库',''),('长江','汉江','湖北','丹江口水库',''),('长江','乌江','贵州','乌江渡水电站',''),('珠江','长利水','广东','九坑河',''),('黄河','马涧河','河南','九龙角',''),('辽河','东辽河','吉林','二龙山',''),('长江','丹江','陕西','二龙山',''),('海河','州河','天津','于桥坝上',''),('长江','黑河','湖北','云台山',''),('海河','白河','河北','云州水库 (坝上)','云州水库坝上'),('淮河','青龙河','河南','五岳',''),('长江','沅水','湖南','五强溪',''),('闽东南诸河','湖内溪','福建','亚湖水库',''),('淮河','大沽河','山东','产芝水库',''),('浙闽台河流','刿江','浙江','亭下水库',''),('海河流域','深河','海姿','人黑门',''),('长江','戴文义河','湖北','仙人坝',''),('粤西沿海诸河','沙铲河','广东','仙人域',''),('长江','仙居河','湖北','仙居河',''),('淮河','西珈河','山东','会宝岭水库(南)',''),('淮河','河东源','安徽','佛子岭',''),('长江','浆溪店河','湖北','先觉庙',''),('黄河','光明河','山东','光明水库',''),('长江','党水河','陕西','党河',''),('内陆河','党河','甘肃','党河水库 (坝上)',''),('长江','澴水支流，张家岗河','湖北','八汉洼',''),('长江','澴水支流　张家岗河','湖北','八汊洼',NULL),('长江','张家河','湖北','八角庙',''),('粤东沿海诸河','黄江','广东','公平',''),('长江','十二里河','河南','兰营',''),('长江','乐安河','江西','共库',''),('珠江','社圩水','广东','共成',''),('海河','浊漳河北源','山西','关河水库',''),('海河','桑干河','山西','册田','冊田'),('长江','泗水河','河南','冢岗庙',''),('黄河','千河','陕西','冯家山',''),('淮河','弥河','山东','冶源水库',''),('长江','长河','湖北','凤凰关',''),('韩江','凤凰溪','广东','凤溪',''),('长江','酉水','湖南','凤滩',''),('黄河','黄河','甘肃','刘家峡水库',''),('海河','雁栖河','北京','北台上水库',''),('长江','句容河','江苏','北山水库(镇江)',''),('珠江','勒竹河','广东','北峰山',''),('珠江','漠阳江','广东','北河',''),('长江','新河','湖北','北河水库',''),('长江','沙河','湖北','北郊',''),('海河','温榆河','北京','十三陵水库',''),('海河','东沙河','北京','十三陵水库上池',''),('海河','白洋淀','河北','十方院 (白） (堰上)','十方院白　堰上'),('海河','忙牛河','北京','半城子水库',''),('三亚河','三亚河','海南','半岭水库',''),('长江','比河','河南','华山',''),('淮河','黄沟河','山东','华村水库',''),('长江','华阳河','湖北','华阳河',''),('闽东南诸河','船场溪','福建','南一水库',''),('浙闽台河流','南山江','浙江','南山水库',''),('长江','涂河','湖北','南川',''),('北江','南水','广东','南水',''),('浙闽台河流','南江','浙江','南江水库',''),('长江','南河','湖北','南河',''),('淮河','狮河','河南','南湾',''),('海河','露水河','河南','南谷洞',''),('长江流域','牛吼江','江西','南车水库',''),('黄河','玉符河','山东','卧虎山水库',''),('长江','界溪河','湖北','卷桥水库',''),('内陆河','疏勒河','甘肃','双塔堡水库 (坝上)','双塔堡水库坝上'),('内陆河','洪水河','甘肃','双树寺水库',''),('海河','粉红江','河南','双泉',''),('长江','湘江','湖南','双牌',''),('长江','汀泗河','湖北','双石水库',''),('海河','郜河','河北','口头水库',''),('闽南沿海诸河','苦溪','福建','古洋',''),('闽江','古田溪','福建','古田一级水库',''),('长江','古角河','湖北','古角',''),('黄河','黄河','河南','史家滩',''),('珠江','新兴江','广东','合河',''),('长江','沙河','湖北','吉河',''),('珠江','黄沙水','广东','同沙',''),('海河','浊漳河西源','山西','后湾水库',''),('长江','溠水','湖北','吴山','吳山'),('长江','天门河','湖北','吴岭',''),('淮河','西珈河','山东','周村水库',''),('长江','苍龙河','','周桥',''),('韩江','和山河','广东','和山岩',''),('流溪河','沙坑','广东','和龙',''),('淮河','洪河西源','安徽','响洪甸',''),('黄河','枯河','河南','唐岗',''),('淮河','浚河','山东','唐村水库',''),('长江','汉江','陕西','喜河',''),('珠江','沙坪水','广东','四堡',''),('长江','黄水河','湖北','四门楼水库',''),('长江','迥龙河','湖北','回龙河',''),('海河','团泊洼','天津','团泊洼水库',''),('长江','天惠河','湖北','土门',''),('闽江','屏山溪','福建','坑口水库',''),('长江','城坪河','湖北','城坪',''),('海河','沧河','河南','塔岗',''),('淮河','潍河','山东','墙齐水库(东库)',''),('淮河','潍河','山东','墙齐水库(西库)',''),('长江','夏家河','湖北','夏家寺',''),('辽河','浑河','辽宁','大伙房水库',''),('黄河','大南川河','青海','大南川',''),('长江','蕲水','湖北','大同',''),('长江','修水','江西','大塅水库',NULL),('海河','小清河','北京','大宁水库',''),('昌化江','昌化江','海南','大广坝水库',''),('海河','瀑河','河北','大庆水库',''),('长江流域','修河','江西','大段水库',''),('海河','沙河','北京','大水峪水库',''),('粤西沿海诸河','大水桥河','广东','大水桥',''),('珠江','鹤洲水','广东','大沙河',''),('黄河','马营润','河南','大沟口',''),('长江','跳石河','湖北','大河铺',''),('长江','溃水','湖北','大洪山',''),('长江','大洪河','重庆','大洪河',''),('长江','土塘水','江西','大港水库',''),('太湖','大溪水库','江苏','大溪水库',''),('珠江','秦皇水','广东','大秦',''),('珠江','大镜山溪','广东','大镜山',''),('宁远河','宁远河','海南','大隆水库',''),('珠江','大隆洞河','广东','大隆洞',''),('海河流域','','海委','大黑汀',''),('长江','新昌河','湖北','天堂',''),('长江','新昌河','湖北','天堂二级',''),('珠江','增江','广东','天堂山',''),('黄河','黄河','山西','天桥上',''),('长江','江华水','湖南','天河',''),('长江','封江口河','湖北','天河口',''),('流溪河','天湖水库水','广东','天湖',''),('珠江','南盘江','贵州','天生桥一级',''),('淮河','淄河','山东','太河水库',''),('长江','沮漳河','湖北','太湖港水库',''),('长江','沙河','湖北','姚棚',''),('长江','汉江','湖北','孟桥川',''),('淮河','澧河','河南','孤石滩',''),('海河','潮白新河','天津','宁车沽上',''),('淮河','渭东干渠','安徽','安丰塘',''),('淮河','厚镇河','江苏','安峰山水库',''),('长江','汉江','陕西','安康库',''),('海河','中易水','河北','安格庄水库',''),('闽江','九龙溪','福建','安砂水库',''),('长江','十八道河','河南','宋家场',''),('海河','永定河','北京','官厅水库',''),('长江','涧江','湖南','官庄',''),('长江','官沟河','湖北','官沟',''),('海河','卫河','河南','宝泉',''),('珠江','莲塘水','广东','宝鸭仔',''),('淮河','汝河','河南','宿鸭湖',''),('海河','白河','北京','密云白河坝上',''),('浙闽台河流','富春江','浙江','富春江水库',''),('长江','富水','湖北','富水',''),('黑龙江流域','洮儿河','内蒙古','察尔森上',''),('长江流域太湖区','余英溪','浙江','对河口水库',''),('长江','南河','湖北','寺坪',''),('黄河','陈宅河','河南','寺河',''),('长江','封江口河','湖北','封江口',''),('淮河','袁公河','山东','小仕阳水库',''),('长江','小南河','湖北','小南河',''),('海河','安阳河','河南','小南海',''),('珠江','枫湾河','广东','小坑',''),('淮河','青口河','江苏','小塔山水库',''),('黄河','黄河','河南','小浪底水库',''),('淮河','小潢河','河南','小龙山',''),('粤东沿海诸河','小龙溪','广东','小龙溪',''),('海河','引滦明渠','天津','尔王庄库',''),('淮河','贾鲁河','河南','尖岗',''),('鉴江','六雅河','广东','尚文',''),('黄河','榆溪河','陕西','尤家',''),('淮河','猪洞河','山东','尹府水库',''),('黑龙江流域','嫩江','黑龙江','尼尔基坝上',''),('淮河','小沂河','山东','尼山水库',''),('长江','杨家河','湖北','尾斗山',''),('闽东诸河','螯江','福建','山仔水库',''),('珠江','船步河','广东','山垌','山'),('晋江','晋江东溪','福建','山美水库',''),('海河','沱河','河北','岗南水库(坝上)',''),('淮河','城河','山东','岩马水库',''),('粤西沿海诸河','沙铲河','广东','岭背下',''),('海河流域','漳河','海委','岳城水库 (坝上)','岳城水库坝上'),('淮河','东汶河','山东','岸堤水库',''),('淮河','潍河','山东','峡山水库',''),('闽东南诸河','漳江','福建','峰头水库',''),('淮河','白沙河','山东','崂山水库',''),('海河','刺猬河','北京','崇青水库',''),('长江','巩河','湖北','巩河水库',''),('黄河','蒲河','帐Ⅱ','巴家嘴水库',''),('淮河','贾峪河','河南','常庄',''),('海河','伊逊河','河北','庙宫水库',''),('长江流域','抚河','江西','廖坊',''),('海河','浙河','河南','弓上',''),('长江','西河','湖北','张家嘴',''),('海河','安阳河','河南','彰武',''),('长江','徐家河','湖北','徐家河',''),('海河','怀河','北京','怀柔水库',''),('长江','鬼水','湖北','患亭山',''),('长江','汉江','湖北','惠亭山',NULL),('闽南沿海诸河','大罗溪','福建','惠女水库',''),('淮河','城河','山东','户主水库',''),('宁远河','宁远河','海南','抱古水库',''),('黄河','洛河','河南','故县水库',''),('黄河','文峪河','山西','文峪河水库',''),('海河','清水河','北京','斋堂水库',''),('珠江','新丰江','广东','新丰江',''),('海河','白洋淀','河北','新安',''),('浙闽台河流','新安江','浙江','新安江水库',''),('长江','新峡河','湖北','新峡水库',''),('粤东沿海诸河','新西河','广东','新西河',''),('淮河','付瞳河','山东','日照',''),('海河','北易水','河北','旺隆',''),('淮河','西皋河','山东','昌里水库',''),('长江','白杲河','湖北','明山',''),('淮河','沙河','河南','昭平台',''),('珠江','沙河','广东','显岗',''),('嫩江','洮儿河','吉林','月亮湖',''),('珠江','罗坪水','广东','朝阳',''),('粤东沿海诸河','黄江','广东','朝面山',''),('海河','沙河','河北','朱庄水库',''),('长江','漳河','湖北','李家州',''),('黄河','南洛河','陕西','李村',''),('内陆河','马营河','甘肃','李桥水库 (坝上)','李桥水库坝上'),('淮河','双泊河','河南','李湾',''),('淮河','资邱河','山东','杨庄水库',''),('珠江','龙岗河','广东','松子坑',''),('南渡江','南渡江','海南','松涛水库 (南丰)','松涛水库南丰'),('淮河','汝河','河南','板桥',''),('珠江','东江','广东','枫树坝',''),('长江','修河','江西','柘林',''),('长江','资水','湖南','柘溪',''),('长江','柳堰河','湖北','柳堰集',''),('辽河','柴河','辽宁','柴河水库',''),('海河','温榆河','北京','桃峪口水库',''),('黄河','沮河','陕西','桃曲坡',''),('海河','青龙河','河业','桃林口水库',''),('海河','青龙河','河北','桃林口水库',''),('淮河','史河','安徽','梅山',''),('长江','梅川河','湖北','梅川',''),('长江','栗树河','湖北','梅店',''),('珠江','新洲河','广东','梅林',''),('韩江','程江','广东','梅西',''),('韩江','汀江','福建','棉花滩水库',''),('海河','磁河','河北','横山岭水库 (坝上)','横山岭水库坝上'),('太湖','屋溪','江苏','横山水库',''),('浙闽台河流','县江','浙江','横山水库',''),('粤东沿海诸河','横江水','广东','横江',''),('浙闽台河流','东阳江','浙江','横锦水库',''),('长江','檀树岗河','湖北','檀树岗',''),('长江','春陵水','湖南','欧阳海',''),('粤西沿海诸河','武陵河','广东','武陵',''),('黄河','千河','陕西','段家峡',''),('闽江','尤溪','福建','水东水库',''),('闽江','闽江','福建','水口水库',''),('长江','清江','湖北','水布垭(坝上)',''),('长江','涟水','湖南','水府庙',''),('长江','澹水','湖北','水水库',''),('三亚河','三亚河','海南','水源池水库',''),('闽东南诸河','汀溪','福建','汀溪水库',''),('长江流域','袁水','江西','江口',''),('长江','水','湖南','江垭',''),('珠江','江谷河','广东','江谷',''),('闽江','金溪','福建','池潭水库',''),('粤东沿海诸河','练江','广东','汤坑',''),('海河','汤河','河南','汤河',''),('黄河','汾河','山西','汾河水库',''),('黄河','沋河','陕西','沋河',''),('淮河','蚬河','山东','沐浴水库',''),('海河','红门川','北京','沙厂水库',''),('淮河','沭河','山东','沙沟水库',''),('长江','沙河','湖北','沙河',''),('太湖','沙河水库','江苏','沙河水库',''),('长江','清流河','安徽','沙河集',''),('闽江','沙溪','福建','沙溪口水库',''),('黄河','芦河','陕西','河口庙',''),('长江','泊漠河','湖北','泥河',''),('淮河','泼陂河','河南','泼河',''),('长江','洈水','湖北','洈水水库',NULL),('海河','洋河','河北','洋河水库',''),('长江','银花河','陕西','洛峪*',''),('淮河','洪泽湖','江苏','洪泽湖',''),('闽东南诸河','陈巷溪','福建','活盘水库',''),('流溪河','流溪河','广东','流溪河',''),('长江','浪河','湖北','浪河店',''),('长江','浮桥河','湖北','浮桥河',''),('海河','洵河','北京','海子水库',''),('长江','潇水','湖南','涔天河',NULL),('珠江','深圳水','广东','深圳',''),('长江','溃水','湖北','清水河',''),('辽河','清河','辽宁','清河水库',''),('长江','敖水','湖北','温峡口',''),('内陆河','雪水河','青海','温泉',''),('长江','界河','湖北','滑石冲',''),('长江','滔河','湖北','滔河',''),('海河','浊漳河南源','山西','漳泽水库',''),('海河流域','滦河','海委','潘家口',''),('长江流域','秀水','江西','潘桥水库',''),('长江','北河','湖北','潭口',''),('珠江','潭源洞水','广东','潭岭',''),('淮河','澎河','河南','澎河',''),('淮河','大沙河','河南','火石山',''),('长江','火莲畈','湖北','火莲畈',''),('长江','漳河','湖北','烟墩','煙墩'),('长江','四马河','湖北','烟宝地','煙宝地'),('长江','熊河','湖北','熊河',''),('浙闽台河流','逆溪','浙江','牛头山水库',''),('万泉河','万泉河','海南','牛路岭水库',''),('长江','巴水','湖北','牛车河',''),('淮河','坟河','山东','牟山水库',''),('长江','龙溪河','重庆','狮子滩',''),('海河','沧河','河南','狮豹头',''),('黄河','西芦河','陕西','猪头山',''),('淮河','马兰河','河南','玉马',''),('淮河','十字江','河南','王堂',''),('长江','水','湖南','王家厂',''),('黄河','千河','陕西','王家崖',''),('海河','白洋淀','河北','王家赛',''),('淮河','黄水河','山东','王屋水库',''),('海河','沙河','河北','王快水库',''),('黄河','杏子河','陕西','王瑶',''),('长江','三溪河','湖北','王英',''),('海河','通河','河南','琵琶寺',''),('内陆河','大堵马河','甘肃','瓦房城水库',''),('淮河','沂河','山东','田庄水库',''),('长江','澴水东支上游','湖北','界牌',''),('长江流域','富田水','江西','白云山水库',''),('黄河','涝河','河南','白墙',''),('松花江流域','松花江吉林段','吉林','白山',''),('淮河','沙河','河南','白山',''),('淮河','颍河','河南','白沙',''),('粤东沿海诸河','练江','广东','白沙溪',''),('海河','白河','北京','白河堡',''),('长江','玛瑙河','湖北','白河水库',''),('淮河','白浪河','山东','白浪河水库',''),('珠江','西枝江','广东','白盆珠',''),('长江','浠水','湖北','白莲河',''),('长江','易家段河','湖北','百丈潭',''),('长江','猫跳河','贵州','百花水库',''),('浙闽台河流','樟溪','浙江','皎口水库',''),('韩江','五华河','广东','益塘',''),('长江','大富水','湖北','短港',''),('海河','清漳西源','山西','石匣',''),('浙闽台河流','开化江','浙江','石壁水库',''),('黄河','石头河','陕西','石头河',''),('长江','花庙河','湖北','石子岭水库',''),('淮河','小潢河','河南','石山口',''),('长江','龙河','重庆','石板水',''),('淮河','新沭河','江苏','石梁河水库',''),('长江','沙河','湖北','石梯',''),('粤东沿海诸河','罗溪','广东','石榴潭',''),('长江','汉江','陕西','石泉',''),('淮河','滚河','河南','石漫滩',''),('黄河','石砭峪','陕西','石砭峪',''),('昌化江','石碌河','海南','石碌水库',''),('长江','老灌河','河南','石门',''),('长江','寨子河','湖北','石门',''),('长江','褒河','陕西','石门',''),('长江','宋家港','湖北','石门塘水库',''),('海河','石门河','河南','石门水库',''),('望楼河','望楼河','海南','石门水库',''),('长江','石门港','湖北','石门水库',''),('长江','司马河','湖北','石龙',''),('长江','白龙江','帐Ⅱ','碧口水库',''),('淮河','河东源','安徽','磨子潭',''),('长江流域','泸水','江西','社上水库',''),('三亚河','三亚河','海南','福万水库',''),('长江','郁江','湖北','福宝山水库',''),('粤东沿海诸河','练江','广东','秋风岭',''),('珠江','稿树下水','广东','稿树下',''),('珠江','大镇水','广东','空子',''),('黄河','宏农润河','河南','窄口',''),('辽河','太子河','辽宁','窝水库',''),('海河','忙牛河','河北','窟窿山水库',''),('海河','白洋淀','河北','端村',''),('长江','竹溪河','湖北','竹溪河',''),('淮河','母猪河','山东','米山水库',''),('淮河','母猪河','山车','米山水库',''),('浙闽台河流','龙泉溪','浙江','紧水滩水库',''),('长江流域','丰水','江西','紫云山水库',''),('粤东沿海诸河','锣鼓水','广东','红场',''),('内陆河','石羊河','甘肃','红崖山水库 (坝上)',''),('长江','猫跳河','贵州','红枫水库',''),('长江','红水河','湖北','红水河',''),('淮河','明河','河南','红石嘴',''),('黄河','榆溪河','陕西','红石峡库',''),('珠江','东江','广东','红花湖',''),('珠江','新榕河','广东','罗光',''),('鉴江','庙背水','广东','罗坑',''),('长江','罗河','湖北','罗河',''),('珠江','茅洲河','广东','罗田',''),('黄河','漆水河','陕西','羊毛湾',''),('淮河','黄溪河','河南','老河',''),('长江流域太湖区','南溪','浙江','老石坎水库',''),('长江流域','云亭水','江西','老营盘水库',''),('珠江','里波水','广东','联和',''),('鉴江','大井河','广东','良德水库(大坝)',''),('长江','芭茅河','湖北','芭茅河',''),('长江','长河','安徽','花凉亭',''),('长江','蕲水','湖北','花园',''),('淮河','界河','湖北','花山',''),('长江','澴水支流，胡家河','湖北','芳畈',''),('闽东诸河','穆阳溪','福建','芹山水库',''),('黄河','甘水河','河南','范店',''),('珠江','洋边河','广东','茅垌','茅'),('长江','茅塔河','湖北','茅塔河',''),('长江','荆竹河','兴舜','荆竹',''),('长江','莺河','湖北','莺河一库',''),('长江','南渺河','安徽','董铺',''),('长江','岚河','陕西','蔺河口',''),('淮河','臻头河','河南','薄山',''),('黄河','居水','陕西','薛峰',''),('长江','丑河','河南','虎山',''),('粤东沿海诸河','雷岭河','广东','蜈蚣岭',''),('长江','黄柏河','湖北','西北口水库',''),('海河','唐河','河北','西大洋水库',''),('海河','洵河','北京','西峪水库',''),('长江','西排子河','湖北','西排子河',''),('珠江','南头河','广东','西沥',''),('粤西沿海诸河','东运河','广东','西湖',''),('海河','垒子河','河北','西累子',''),('淮河','大沙河','山东','西苇水库',''),('长江','漫水支流，晏家河','兴舜','观音岩',''),('长江','观音河','陕西','观音河',''),('辽河','太子河','辽宁','观音阁水库',''),('淮河','温凉河','山东','许家崖水库',''),('长江','小河','兴','谭家湾',''),('长江','马家港','湖北','象河',''),('淮河','泗河','山东','贺庄水库',''),('长江流域太湖区','西溪','浙江','赋石水库',''),('藤桥河','藤桥西河','海南','赤田水库',''),('长江','赵河','河南','赵湾',''),('淮河','沂河','山东','跋山水库',''),('长江','印河','湖北','跑马水库',''),('长江','长河','湖北','跨马墩',''),('长江','车坝河','湖北','车坝水库',''),('长江','流鸭河','河南','辛庄',''),('珠江','迎咀河','广东','迎咀',''),('长江','沙河','湖北','道观河',''),('海河','安达木河','北京','遥桥峪水库',''),('海河','还乡河','河北','邱庄水库(坝上)',''),('长江','涢水支流，漳河','湖北','郑家河',''),('海河','松溪河','山西','郭庄',''),('淮河','东母猪河','山东','郭格庄水库',''),('长江','攸水','湖南','酒埠江',''),('浙闽台河流','始丰溪','浙江','里石门水库',''),('海河','沙河','河北','野沟门水库',''),('长江','金沙河','湖北','金沙河',''),('长江','澴水支流，晏家河','湖北','金盆',''),('黄河','黑河','陕西','金盆',''),('珠江','罗定江','广东','金银河',''),('长江','旬河','陕西','钟家坪',''),('淮河','陶家河','河南','铁佛寺',''),('长江','新墙河','湖南','铁山',''),('珠江','西乡水','广东','铁岗',''),('浙闽台河流','铜山源','浙江','铜山源水库',''),('长江','司马河','湖北','铜钱山',''),('珠江','银盏河','广东','银盏',''),('珠江','潭江','广东','锦江',''),('珠江','锦江','广东','锦江(仁化)',''),('粤东沿海诸河','雷岭河','广东','镇北',''),('珠江','镇海水','广东','镇海',''),('珠江','小隐涌','广东','长江',''),('淮河','泼陂河','河南','长洲河',''),('珠江','翁江','广东','长湖',''),('浙闽台河流','永宁江','浙江','长潭水库',''),('望楼河','望楼河','海南','长茅水库',''),('浙闽台河流','新昌江','浙江','长诏水库',''),('淮河','清洋河','山东','门楼水库',''),('辽河','柳河','辽宁','闹德海',''),('长江','鲤港','湖北','阁壁',''),('淮河','淋头河','江苏','阿湖水库站',''),('珠江','儒洞河','广东','陂底',''),('长江','陆水','湖北','陆水水库',''),('黄河','伊河','河南','陆浑坝上',''),('海河','淇河','河南','陈家院',''),('长江','青戈江','安徽','陈村',''),('浙闽台河流','陈蔡江','浙江','陈蔡水库',''),('淮河','浔河','山东','陡山水库',''),('海河','陡河','河北','陡河水库(坝上)',''),('长江','泊漠河','湖北','院基寺',''),('黄河','刘涧河','河南','陶花店',''),('长江','清江','湖北','隔河岩(坝上)',''),('长江','湄港','湖北','雨山水库',''),('黄河','瀛汶河','山东','雪野水库',''),('淮河','象河','河南','霍庄',''),('长江','霍河','湖北','霍河',''),('长江','广水河','湖北','霞家河',''),('黄河','丹河','河南','青天河',''),('长江','青山河','兴','青山',''),('长江','永乐江','湖南','青山城',''),('长江流域太湖区','南苕溪','浙江','青山水库',''),('淮河','沭河','山东','青峰岭水库',''),('黄河','焦家川','河南','青沟',''),('韩江','汀江','广东','青溪',''),('黄河','黄河','宁夏','青铜峡水库',''),('长江流域','尧市','江西','飞剑潭一坝水库',''),('珠江','北江','广东','飞来峡',''),('淮河','界河','湖北','飞沙河',''),('淮河','田铺河','河南','香山',''),('海河','马头沟','河北','马头',''),('长江','沙河','湖北','马安山',''),('长江','马家河','湖北','马家河',''),('长江','马张河','湖北','马张河',''),('长江','粉青河','湖北','马桥',''),('淮河','北沙河','山东','马河水库',''),('长江','漂水','湖北','马鞍山',''),('淮河','骆马湖','江苏','骆马湖水库',''),('长江','大富水','湖北','高关',''),('长江','清江','湖北','高坝洲(坝上)',''),('罗带河','罗带河','海南','高坡岭水库',''),('鉴江','小水河','广东','高城',''),('淮河','汶河','山东','高崖水库',''),('淮河','灌河','河南','鱼山',''),('长江','长江','湖北','鲁家港水库',''),('珠江','黄泥河','云南','鲁布革',''),('淮河','灌河','河南','鲇鱼山',NULL),('珠江','横岭水','广东','鸡心石',''),('长江','白河','河南','鸭河口',''),('内陆河','讨赖河','甘肃','鸳鸯池水库 (坝上)',''),('长江','新桥河','湖北','鹞鹰岩',''),('粤西沿海诸河','九洲江','广东','鹤地水库(大坝)',''),('黄河','石汶河','山东','黄前水库',''),('浙闽台河流','乌溪江','浙江','黄坛口水库',''),('长江','敖水','湖北','黄坡',''),('海河','澎沱河','河北','黄壁庄水库(坝上)',''),('粤东沿海诸河','大液河','广东','黄山洞',''),('长江','水','湖南','黄材',''),('海河','洵河','北京','黄松峪水库',''),('长江','襄河','安徽','黄栗树',''),('鉴江','袂花江','广东','黄沙','黃沙'),('长江','雷溪河','湖北','黄河厂',''),('海河','潮白新河','天津','黄白桥上',''),('长江','白洋河','湖南','黄石','黃石'),('流溪河','流溪河','广东','黄龙带','黄龙帯'),('长江','堵河','湖北','黄龙滩',''),('长江','溠水','湖北','黑屋湾',''),('长江','黑清河','湖北','黑清河',''),('长江','黑清河','湖南','黑清河',''),('长江','沙河','湖北','黑石嘴',''),('内陆','巴音河','青海','黑石山',''),('长江','杭埠河','安徽','龙河口(内)',''),('淮河','济河','山东','龙湾套水库',''),('粤东沿海诸河','龙溪水','广东','龙溪一级',''),('粤东沿海诸河','龙溪水','广东','龙溪二级',''),('粤东沿海诸河','龙江','广东','龙潭',''),('海河','界河','河北','龙潭',''),('长江','何家港','湖北','龙潭',''),('黄河','黄河','青海','龙羊峡',''),('淮河','乳山河','山东','龙角山水库',''),('粤西沿海诸河','龙门河','广东','龙门',''),('海河','漕河','河北','龙门水库',''),('珠江','黄洞水','广东','龙须带',''),('粤东沿海诸河','五经富水','广东','龙颈(上)',''),('粤东沿海诸河','五经富水','广东','龙颈(下)','');
/*!40000 ALTER TABLE `hy_download_water_mapping_sk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hy_download_water_mapping_yq`
--

DROP TABLE IF EXISTS `hy_download_water_mapping_yq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_mapping_yq` (
  `basin_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '流域',
  `river_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '河名',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '行政区划',
  `station_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '站名',
  `station_name_alias` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '别名',
  PRIMARY KEY (`station_name`,`province_name`,`basin_name`,`river_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='雨水情映射表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hy_download_water_mapping_yq`
--

LOCK TABLES `hy_download_water_mapping_yq` WRITE;
/*!40000 ALTER TABLE `hy_download_water_mapping_yq` DISABLE KEYS */;
INSERT INTO `hy_download_water_mapping_yq` VALUES ('黄河','秃尾河','陕西','*公草湾',''),('黄河','头道川','陕西','*铁边城',''),('长江','丁河','河南','丁河',''),('海河','武烈河','河北','七家',''),('长江','蒲河','重庆','万东·团结',''),('长江','文锦江','四川','万家',''),('饶河','建节水','江西','万村',''),('海河','老牛河','河北','三沟',''),('海河','南入河','田四','三生后',''),('长江','通惠河','重庆','三角·乐兴',''),('长江','马水河','湖北','三里坝',''),('钱塘江','梅溪','安徽','三阳坑',''),('长江','深河','湖北','上',''),('长江','南江-巴河','四川','上两',''),('长江流域','盱江','江西','上唐',NULL),('长江流域','肝江','江西','上唐',''),('淮河','漫水河','安徽','上土寺',''),('黄河','柳青河','河南','上官村',''),('海河','沱河','山西','上永兴',''),('海河','滹沱河','山西','上永兴',NULL),('白塔河','白塔河','江西','上清',''),('钱塘江','率水','安徽','上溪口',''),('淮河','灌河','河南','上石桥',''),('海河','龙华河','山西','上社',''),('长江','独木河','贵州','下湾',''),('辽河','细河','辽宁','下马塘',''),('海河','沙河','河北','不老台',''),('淮河','指封河','安徽','与儿街',''),('淮河','包河','河南','业庙',NULL),('海河','南运河','河北','东光',''),('海河','拒马河','河北','东团堡',''),('汉江','任河','重庆','东安·场镇',''),('长江','东川河','陕西','东川',''),('海河','陶清河','山西','东柏林',''),('长江流域','北漳','江西','东源',''),('长江流域','北潦','江西','东源',NULL),('海河','妫水河','河北','东花园',NULL),('海河','水河','河北','东花园',''),('嘉陵江','巴川河','重庆','东郭',''),('海河','七里店河','山西','东阳关',''),('淮河','北汝河','河南','两河口',''),('长江','两路河','四川','两路',''),('香屯以上','中云水','江西','中云',''),('淮河','燕子河','安徽','中光',''),('长江','深河','湖北','中坝',''),('长江流域太湖区','南苕溪','浙江','临安',''),('黄河','水河','山西','临晋',''),('黄河','涑水河','山西','临晋',NULL),('上饶以上','灵溪水','江西','临江湖',''),('长江','官渡河','重庆','临溪·高建窑湾',''),('长江','徐堰河-丹山河-漾溪河','四川','丹山镇',''),('长江','徐堰河-丹山河-蒙溪河','四川','丹山镇',NULL),('长江','丹水河','河南','丹水',''),('辽河','小汤河','辽宁','久才峪',''),('黄河','义合沟','陕西','义合',''),('长江','乌江','贵州','乌江渡(三)',''),('长江流域','螯溪水','江西','乐安',''),('长江流域','鳌溪水','江西','乐安',NULL),('长江','官渡河','湖北','九道梁',''),('淮河','沙河','河南','二郎庙',''),('长江','仪陇河','四川','二龙',''),('长江','天池河','湖北','五峰',''),('长江','石溪水','江西','五府山',''),('黄河','元城川','甘肃','五蛟',''),('长江','澧水(北源)','湖南','五道水',''),('海河','南大河','山西','五里后',''),('淮河','浉河','河南','五里店',NULL),('淮河','狮河','河南','五里店',''),('长江','茫溪河','四川','井研',''),('海河','唐河','河北','仁',''),('长江','妻江','四川','仓山',''),('长江','郪江','四川','仓山',NULL),('海河','清漳东源','山西','仙人坪',''),('上饶以上','沧溪','江西','仙岩',''),('长江','汉江','湖北','仙桃(二)',''),('长江流域','仰山','江西','仰山',NULL),('海河','小白河','河北','任丘',''),('海河','露水河','河南','任村',''),('长江流域','南漳河','江西','会埠',''),('长江流域','南潦河','江西','会埠',NULL),('海河','宋家庄川','河北','侯家庄',''),('长江','修文河','贵州','修文',''),('海河','清漳河','河北','偏城',''),('海河','拒马河','河北','偏道子',''),('长江流域','盱江','江西','傅坊',NULL),('长江流域','肝江','江西','傅坊',''),('淮河','潢河','河南','光山',''),('长江','莳竹水','湖南','党坪',''),('长江','滁河','安徽','八斗岭',''),('黄河','县川河','山西','八角',NULL),('松花江吉林段','金沙河','吉林','八道河子',''),('长江','六洞河','贵州','六洞桥',''),('长江流域','黄水','江西','兰水',''),('淮河','淤泥河','河南','兰考',''),('长江','北星河','湖北','关帝庙',''),('淮河','白沙河','安徽','关庙',''),('淮河','茨河','安徽','关集',''),('松花江吉林段','兴华沟','吉林','兴华',''),('长江','威远河/釜溪河','四川','兴隆',''),('海河','拒马河','河北','其中口',''),('海河','硝河','河南','内黄',''),('黄河','水河','山西','冯村',''),('黄河','涑水河','山西','冯村',NULL),('长江','汉江','湖北','冷水',''),('辽河','碾盘河','辽宁','凉水泉子','涼水泉子'),('长江','沱江','湖南','凤凰(二)',''),('长江','沮河','湖北','分水',''),('长江','魏城河-梓江','四川','刘家河',''),('长江','马边河','四川','利店',''),('辽河','大青山河','吉林','前双龙泉',''),('闽东南诸河','厦门港','福建','前埔',''),('淮河','燕子河','安徽','前畈',''),('长江','与边河','四川','办吹',''),('淮河','闾河','河南','包信',''),('黄河','延河','陕西','化子坪',''),('上饶以上','丰溪河','江西','十都',''),('海河','潵河','河北','半壁山',NULL),('海河','澈河','河北','半壁山',''),('珠江','六洞河','广西','华江',''),('长江','酉水河','陕西','华阳',''),('海河','瀑河','河北','南五十家子',''),('长江','藕池河(北支)','湖南','南县(罗文窖)',''),('长江','梅子水','湖北','南坪',''),('长江','石家河','湖南','南坪',''),('海河','淇河','河南','南寨',''),('淮河','竹竿河','河南','南李店',''),('长江','蒲河','重庆','南桐·石桥1',''),('海河','唐河','山西','南水芦',''),('长江','南沙河','陕西','南沙河',''),('海河','南运河','河北','南皮',''),('长江','南雅河','重庆','南雅·场镇',''),('海河','运粮河','河南','博爱',''),('香屯以上','中云水','江西','占才',''),('淮河','竹竿河','河南','卡房',''),('海河','老盐河','河北','卷子',NULL),('长江','利济河','安徽','历口',''),('长江','昌江','江西','历口',''),('黄河','文岩渠','河南','原阳',''),('淮河','大沙河','河南','双庙',''),('辽河','二道河','辽宁','双庙子',''),('淮河','白鹭河','河南','双柳树',''),('长江','汝河','陕西','双河',''),('黄河','沙河','陕西','古城',''),('黄河','皇甫川','陕西','古城',''),('海河','清水河','山西','台怀',''),('海河','史水河','山西','史北',''),('长江','恒河','陕西','叶家坪',''),('珠江','青化河','广东','司前',''),('长江','普里河','重庆','合兴·银恒',''),('黄河','合水川','甘肃','合水',''),('黄河','允西河','山西','同善',''),('长江','清溪河','湖北','后坪',''),('海河','永定河','河北','后奕',''),('长江','新民河','重庆','吐祥·龙泉',''),('松花江吉林段','一统河','吉林','向阳',''),('长江','头兴港','江苏','启东',''),('淮河','月河','河南','吴城','吳城'),('海河','大峪河','山西','吴家窑','吳家窑'),('淮河','根河','安徽','吴店','吳店'),('海河','南运河','河北','吴桥',''),('长江','梅江河','重庆','吴滩·现龙',''),('淮河','晏河','河南','吴陈河',''),('长江流域','北漳','江西','周坊',''),('长江流域','北潦','江西','周坊',NULL),('淮河','臻头河','河南','和孝店',NULL),('长江','忠建河','湖北','咸丰',''),('黄河','哈拉赛河','陕西','哈镇',''),('长江','橙子河-巴河','四川','响滩',''),('长江','磴子河-巴河','四川','响滩',NULL),('黄河','五里镇河','陕西','哭泉',''),('长江','喜神坝','陕西','喜神坝',''),('长江','钟水','湖南','嘉禾(二)',''),('黄河','渭河','甘肃','嘴头',''),('长江','蒲河','陕西','四亩地',''),('辽河','条子河','吉林','四平',''),('淮河','文河','江苏','四户','四戶'),('长江','清江','湖北','团堡',''),('辽河','大四家子河','辽宁','团山子',''),('海河','磁河','河北','团泊口',''),('长江','前河-州河','四川','土黄',''),('海河','漕河','河北','坡仓',''),('长上干','大洪河','四川','垭口村',''),('长江','沿渡河','湖北','堆子',''),('长江','丹水','湖北','堡子',''),('珠江','小溶江','广西','塔边',''),('长江','白羊河','重庆','塘坊',''),('弋阳到梅港','罗塘水','江西','塘湾',''),('淮河','毛河','河南','夏邑',''),('海河','鲍邱河','河北','大厂',''),('长江','汉江','湖北','大同(二)',''),('内陆河','内陆河','河北','大囫囵',NULL),('内陆河','内陆河','河北','大國图',''),('辽河','土龙小河','吉林','大城子',''),('长江','索溪河-资水河 (阳化河)','四川','大堰',''),('长江','索溪河-资水河阳化河','四川','大堰',NULL),('辽河','清河','辽宁','大孤家子',NULL),('长江','汉江','陕西','大安',''),('淮河','沛河','河南','大庙畈',''),('淮河','浉河','河南','大庙畈',NULL),('长江','大木河','湖北','大木厂',''),('长江','西河','四川','大桥',''),('海河','沙河','河北','大河局',''),('长江','驷步河','重庆','大滩口',''),('长江','严陵河','河南','大王集',''),('长江','沂溪','湖南','大福坪',''),('长江','巴渠河','重庆','大进·万年',''),('长江','清江河','四川','大院',''),('长江','清溪河','四川','天池',''),('长江','祥符寺河-九曲河','四川','太平',''),('长江','黑清河','湖北','太平',''),('珠江','七拱河','广东','太平(阳山)',''),('长江','蛇尾河','河南','太平镇',''),('淮河','涡河','河南','太康',''),('乌江','金溪河','重庆','太极·太极',''),('黄河','葫芦河','陕西','太白镇',''),('淮河','太阳河','安徽','太阳',''),('淮河','头陀河','安徽','头陀',''),('长江','南河','四川','夹关',''),('黄河','黄庄河','河南','孔村',''),('黄河','榆溪河','陕西','孟家湾',''),('海河','宣惠河','河北','孟村',''),('长江','沩水','湖南','宁乡(三)',''),('黄河','马连河','甘肃','宁县',''),('海河','郭苏河','河北','宅北',''),('长江','汉江','陕西','安康',''),('长江','油子河','四川','安德铺',''),('海河','南运河','河北','安陵 (节制闸闸上)','安陵节制闸闸上'),('海河','南运河','河北','安陵节制闸闸上',NULL),('淮河','谷河','安徽','宋集',''),('长江','松滋河(西支)','湖南','官垸',NULL),('长江','澧水','湖南','官垸',NULL),('淮河','干江河','河南','官寨',''),('海河','马头口','河南','官山',''),('长江流域','北漳','江西','官庄',''),('长江流域','北潦','江西','官庄',NULL),('长江','松滋河(西支)','湖南','官皖',''),('淮河','竹竿河','河南','定远店',''),('珠江','洛清江','广西','宛田',''),('长江','汉江','湖北','宜城',''),('长江','长江','湖北','宜昌',''),('长江','苦桃河','湖北','宝丰',''),('长江','球溪河-清江河','四川','宝飞',''),('海河','浊漳河','山西','实会',NULL),('海河','虹雷河','山西','寺头',''),('海河','虹霓河','山西','寺头',''),('黄河','清涧河','陕西','寺湾',''),('长江','南淝河','安徽','将军岭',NULL),('长江','南肥河','安徽','将军岭',''),('淮河','干江河','河南','小史店',NULL),('辽河','太子河','辽宁','小市(山洪)',''),('海河','宣惠河','河北','小庄',''),('长江','小河','陕西','小河',''),('长江','晋水河','陕西','小河口',''),('长江','胥水河','陕西','小河口',''),('长江','西洞庭湖湖口(南端)','湖南','小河咀',''),('长江','汤溪河','重庆','尖山·场镇',''),('淮河','滚河','河南','尚店',''),('黄河','茹河','甘肃','屯字',''),('黄河','山泽河','山西','山泽',''),('上饶以上','丰溪河','江西','岭底',''),('长江','汉江','湖北','岳口',''),('长江','武关河','陕西','峦庄',''),('长江流域','高陂河','江西','嵩市',''),('黄河','禹平河','陕西','巡检',''),('长江','滔河','湖北','工',''),('长江','襄河','安徽','常山岭',''),('海河','小漳河','河北','平乡',''),('长江','坝河','陕西','平利',''),('长江','渚河','陕西','平安场',''),('长江','型江','贵州','平寨',NULL),('长江','汨罗江','湖南','平江',''),('黄河','洪河','甘肃','平泉',''),('长江','型江','贵州','平赛',''),('淮河','沙河','河南','平顶山',NULL),('辽河','太子河(北支)','辽宁','平顶山',NULL),('海河','老漳河','河北','广宗',''),('汉江','庙坝河','重庆','庙坝·桥北',''),('长江','庙宇河','重庆','庙宇·',''),('辽河','东马莲河','辽宁','康平',''),('长江','磨刀溪','湖北','建南',''),('长江','后溪河','重庆','建楼',''),('淮河','惠济河','河南','开封',''),('淮河','燕子河','安徽','张冲',NULL),('黄河','南洛河','陕西','张坪',''),('海河','日登河','山西','张官屯',''),('海河','白登河','山西','张官屯',''),('长江','张家河','陕西','张家河',''),('长江','敖水','湖北','张集',''),('长江','米水河','湖北','当阳坝',''),('淮河','九龙河','河南','彭新店',''),('长江','乌江','重庆','彭水(四)',''),('长江','东溪河','重庆','徐家坝',''),('海河','宁晋泊','河北','徐家河',''),('淮河','废黄河','江苏','徐州',''),('黄河','金堤河','河南','徐镇',''),('长江','长江','重庆','忠县(二)',''),('长江流域','宝塘水','江西','戴坊',''),('长江','金钱河','陕西','户家垣','戶家垣'),('黄河','杏子河','陕西','招安',''),('海河','拒马河','河北','插箭岭',''),('海河','白玉河','山西','故县',''),('辽河','东洲河','辽宁','救兵',''),('长江','茅溪','湖南','教字垭',''),('长江','桃溪河','重庆','敦好·正坝正兴',''),('长江','马尾河','贵州','文峰塔',''),('珠江','四甲河','广西','斗江',''),('长江流域','黄水','江西','新丰','丰'),('长江','新场河-威远河/釜溪河','四川','新场',''),('淮河','沛河','河南','新店',''),('淮河','浉河','河南','新店',NULL),('淮河','狮河','河南','新店',''),('长江','出 江河-南河','四川','新新场',''),('长江','出阝 江河-南河','四川','新新场',NULL),('长江','清江','湖北','新板桥',''),('长江','越溪河','四川','新桥',''),('黄河','孤山川','陕西','新民镇',''),('长江','岷江','四川','新津',NULL),('长江','铜钵河-州河','四川','新生',''),('长江','潘河','河南','方城',''),('长江','舞阳河','贵州','施秉',''),('黄河','北洛河','陕西','旦八',''),('黄河','县川河','山西','旧县',''),('淮河','老沭河','江苏','时集',''),('辽河','亮子河','辽宁','昌图',NULL),('辽河','辽河','辽宁','昌图',NULL),('海河','宣惠河','河北','明泊洼',NULL),('长江','忠建河','湖北','晓关',''),('长江','杭埠河','安徽','晓天',''),('饶河','泊水','江西','暖水',''),('饶河','洎水','江西','暖水',NULL),('长江','清流河','安徽','曲亭',''),('黄河','马连河','甘肃','曲子',''),('长江','清流河','安徽','曲高',''),('黄河','暖水河','甘肃','曹务',''),('长江','金井河','陕西','曹坪',''),('海河','黑龙港河','河北','曹寺',''),('辽河','服茂排水干渠','吉林','服先',''),('长江','浏渭河','湖南','朗梨',''),('太湖','望虞河','江苏','望亭 (立交)','望亭立交'),('太湖','望虞河','江苏','望亭立交',NULL),('淮河','淠河','安徽','望城岗',NULL),('淮河','澳河','安徽','望城岗',''),('海河','思德河','河南','朝歌',''),('黄河','马连河','甘肃','木钵',''),('长江','长江','重庆','朱沱(三)',''),('辽河','老虎山河','辽宁','朱碌科','硃碌科'),('黄河','干江','陕西','李垣',''),('香屯以上','李宅水','江西','李宅',''),('长江','长江','四川','李庄',''),('长江','泉河','湖北','杨家扒',''),('长江','九湾溪','湖北','杨林桥(河道)',''),('松花江吉林段','汤河','吉林','松树镇',''),('松花江吉林段','松江河','吉林','松江河',''),('海河','安阳河','河南','林县',''),('珠江','都郎河','广西','林洞',''),('淮河','灌河','河南','枫香树',''),('长江','举水','湖北','柳子港',''),('黄河','金堤河','河南','柳屯',''),('长江','后河','湖北','桃园',''),('长江','油港','湖南','桃林(二)',''),('长江','资水','湖南','桃江(二)',''),('淮河','淮河','河南','桐柏',NULL),('海河','北流河','河北','桥南沟',''),('长江','龙河','重庆','桥头·桥头',''),('黄河','清水河','甘肃','梁山上',''),('长江','洢溪','湖南','梅城',NULL),('长江','湃溪','湖南','梅城',''),('弋阳以下','信江','江西','梅港',''),('淮河','淮河','河南','楚子集',''),('长江流域太湖区','中苕溪','浙江','横畈',NULL),('长江流域太湖区','中茗溪','浙江','横畈',''),('淮河','慎水河','河南','正阳',NULL),('淮河','淮河','河南','正阳',NULL),('海河','蚁蚂吐河','河北','步古沟',''),('长江','汉江','陕西','武侯镇',''),('黄河','胡乔沟','陕西','武家庄',''),('长江','蛮河','湖北','武镇',NULL),('长江','乌江','重庆','武隆',''),('辽河','老虎山河','辽宁','殊碌科',''),('黄河','马家河','甘肃','殷家城',''),('辽河','辽河','辽宁','毓宝台',''),('长江','毛坝河','陕西','毛坝河',''),('长江','渔洋河','湖北','毛湖',''),('长江','渔洋河','湖北','毛湖埫',NULL),('淮河','涡河','安徽','毫县',''),('淮河','大沙河','河南','民权',''),('长江','小通江-通江-巴河','四川','民胜',''),('长江','消水河','四川','水匣子',''),('长江流域','盱江','江西','水南',NULL),('长江流域','肝江','江西','水南',''),('海河','中易水','河北','水口',''),('海河','唐河','河北','水堡',''),('长江','董家河','湖北','水月寺',''),('长江','清溪河','重庆','永新·富家',''),('长江','汉江','陕西','汉中',''),('长江','长江','湖北','汉口',''),('长江','汉江','湖北','汉川',''),('长江','汉江','陕西','汉王城',''),('海河','小白河','河北','汜水',NULL),('黄河','汜水','河南','汜水',NULL),('淮河','颍河','安徽','江口集',NULL),('淮河','颖河','安徽','江口集',''),('长江','渫水','湖南','江坪',NULL),('长江','潇水','湖南','江坪',''),('长江','滔河','湖北','江湾',NULL),('淮河','白沙河','安徽','汤汇',''),('海河','小白河','河北','汨水',''),('长江','清江','湖北','汪营',''),('长江','龙河','重庆','沙子·人和',''),('长江','汤溪河','重庆','沙沱',''),('淮河','白露河','河南','沙窝',''),('白塔河','白塔河','江西','沟树',''),('海河','南运河','河北','沧州',''),('海河','浊漳河','山西','河南',NULL),('长江','前河-州河','四川','河口',''),('长江','大通江-通江-巴河','四川','河口',''),('淮河','沣河','安徽','河口集',''),('长江','盐井坝河','重庆','河堰·岩水',''),('海河','古洋河','河北','河间',''),('汉江','后裕河','重庆','河鱼·河鱼',''),('长江','乌江','贵州','沿河',''),('松花江吉林段','二道松江河','吉林','泉阳',''),('闽江','泰宁溪','福建','泰宁',''),('长江','汉江','湖北','泽口',''),('长江','汉江','陕西','洋县',''),('黄河','县河','陕西','洛南',''),('长江','平溪','湖南','洞口(二)',''),('长江','六冲河','贵州','洪家渡 (二)','洪家渡二'),('长江','六冲河','贵州','洪家渡二',NULL),('淮河','浉河','河南','浉河港',NULL),('测试脏流域','某河','某省','测试脏站',NULL),('香屯以上','乐安河','江西','海口',''),('黄河','涧峪岔河','陕西','涧峪岔',''),('淮河','小潢河','河南','涩港店',''),('淮河','新蔡河','河南','淮阳',''),('海河','滏阳河','河北','深州',''),('长江流域','东河','江西','深渡',''),('婺源以上','清华水','江西','清华',''),('上饶以上','横峰水','江西','清水',''),('辽河','清河','辽宁','清河城',NULL),('长江','清江','湖北','渔峡口',''),('海河','唐河','河北','温仁',NULL),('长江','湖口水道','江西','湖口','口'),('长江','湘江(东支)','湖南','湘阴',''),('长江','滔河','陕西','滔河',''),('长江','乌江','重庆','滩(二)',''),('长江','金钱河','陕西','漫川关',''),('海河','浊漳河西源','山西','漳源',''),('长江','修河','江西','澧溪',''),('长江流域','宫山','江西','澧溪',''),('黄河','濮城沟','河南','濮城',''),('淮河','汲河','安徽','火星庙',''),('长江','西河','陕西','照川',''),('淮河','燕子河','安徽','燕子河',''),('长江','通口河','四川','片口',''),('长江','沅江','湖南','牛鼻滩',''),('长江','南木溪河','陕西','狮坪',''),('长江','东津河','安徽','狮桥',''),('淮河','沛河','河南','狮河港',''),('辽河','柴河','辽宁','猴石',NULL),('海河','泜河','河北','獐么',NULL),('海河','溉河','河北','獐么',''),('海河','大沙河','河南','玄坛庙',''),('长江','茶坝河-恩阳河-巴河','四川','玉山',''),('海河','拒马河','河北','王安镇',''),('海河','白洋淀','河北','王家寨',NULL),('长江','澄溪','湖南','王家湾',''),('淮河','西淝河','安徽','王市集',NULL),('淮河','西肥河','安徽','王市集',''),('长江流域','延桥水','江西','琉璃',''),('黄河','沮河','陕西','瑶曲',''),('长江','白河','河南','瓦店',''),('长江流域','南漳','江西','甘坊',''),('长江流域','南潦','江西','甘坊',NULL),('长江','西津河','安徽','甲路',''),('海河','漳河','河北','白土',''),('长江','汉江','陕西','白河',''),('弋阳到梅港','河桥溪','江西','白田',''),('乌江','中井河','重庆','白石·城镇',''),('海河','黑河','河北','白草',''),('淮河','漫水河','安徽','白莲崖',''),('长江','大河','湖北','白霓桥(二)',''),('海河','潵河','河北','白马川',NULL),('海河','澈河','河北','白马川',''),('黄河','牛头河','甘肃','百家',''),('长江','渫水','湖南','皂市(二)',NULL),('长江','潇水','湖南','皂市(二)',''),('长江','汉江','湖北','皇庄',''),('黄河','亳清河','山西','皋落',''),('海河','宣惠河','河北','盐山','山'),('长江','浪河','湖北','盐池河',''),('长江','岷江','四川','眉山',NULL),('长江','崛江','四川','眉山',''),('淮河','小潍河','江苏','睢宁',''),('淮河','小濉河','江苏','睢宁',NULL),('黄河','槐理河','陕西','石嘴驿',''),('海河','浊漳河','山西','石城',NULL),('海河','潵河','河北','石庙子',NULL),('海河','澈河','河北','石庙子',''),('长江','思蒙河/丹棱河','四川','石桥',''),('长江','沱江','四川','石桥',''),('长江','汉江','陕西','石泉',''),('黄河','大理河','陕西','石湾镇',''),('珠江','北流河','广西','石碗咀',''),('长江','御临河','重庆','石船·梅溪',''),('黄河','窟野河','陕西','石角塔',''),('长江流域','抚河','江西','石门',''),('长江','澧水','湖南','石门',''),('长江','清凉河','湖北','石门集',''),('长江','石阡河','贵州','石阡(二)',''),('黄河','砖庙沟','陕西','砖庙',''),('淮河','惠济河','河南','砖桥闸',''),('淮河','汝河','河南','确山',NULL),('淮河','臻头河','河南','确山',NULL),('长江','碑坝河','陕西','碑坝',''),('海河','榆社河','山西','社城',''),('辽河','小沙河','辽宁','祝家',''),('海河','营里河','河北','神堂关',''),('长江','蒸水','湖南','神山头',''),('长江流域','宜水','江西','神岗',''),('长江','大槽河/塘河 (狮头河)','四川','福宝',''),('长江','大槽河/塘河狮头河','四川','福宝',NULL),('长江','桥头河','重庆','福田',''),('淮河','颍河','河南','禹州',NULL),('淮河','颖河','河南','禹州',''),('长江','鱼梁河','贵州','禾丰',''),('长江','秋河','陕西','秋坪',''),('长江','县河','湖北','秦古',''),('辽河','卡伦涝区干渠','吉林','秦家屯',''),('海河','古洋河','河北','窝北',''),('黄河','伊洛河','河南','站街',''),('长江流域','东谷水','江西','章庄',''),('上饶以上','玉琊溪','江西','童家坊',''),('黄河','端氏河','山西','端氏',''),('长江','澧水','湖南','箦子头','簀子头'),('长江','澧水','湖南','簧子头',''),('海河','清漳东源','山西','紫罗',''),('长江','清江','湖北','红土溪',''),('黄河','白水河','陕西','红土镇',''),('长江','织金河','贵州','织金',''),('长江流域','昌江','江西','经公桥',''),('黄河','水河','山西','绛县',''),('黄河','涑水河','山西','绛县',NULL),('长江','淳河','湖北','罗岗',''),('淮河','泥河','河南','罗店',''),('长江','南广河','四川','罗渡',''),('长江','渠江','四川','罗渡溪(二)',''),('淮河','瓦埠河','安徽','罗集',''),('长江','小江','重庆','老关嘴',''),('长江','耒水','湖南','耒阳',''),('黄河','耿湾川','甘肃','耿湾',''),('淮河','淮河','河南','肖曹店',''),('淮河','永民河','河南','胡家湾',''),('海河','甘陶河','河北','胡家滩',''),('长江','汉江','湖北','胡集',''),('长江流域','梦港水','江西','腾桥',''),('淮河','汝河','河南','臧集',''),('长江','马边河','四川','舟坝',''),('黄河','泗河','山西','良马',''),('黄河','沙菀沟','陕西','艾好',''),('海河','拒马河','河北','艾河村',''),('长江','龙河','安徽','芦镇关',''),('长江','清江','湖北','花果坪',''),('长江','马边河','四川','苏坝',''),('海河','漳卫新河','河北','苏基',''),('黄河','马坊川','甘肃','苦水掌',''),('辽河','英额河','辽宁','英额门',NULL),('辽河流域','浑河','辽宁','英额门',NULL),('长江','酉水河','陕西','茅坪',''),('长江','付家河','陕西','茨沟',''),('长江','沮水','陕西','茶店',''),('淮河','索河','河南','荥阳',''),('长江流域','萍水','江西','萍乡',''),('弋阳到梅港','葛溪水','江西','葛源',''),('长江','斜江-南河','四川','董场',''),('海河','鹞子河','河北','董家村',''),('淮河','沥沛河','河南','董家河',''),('淮河','浉河','河南','董家河',NULL),('长江','黄柏河','湖北','董家河',''),('珠江','壬山河','广西','蒙山',''),('海河','潮河','河北','虎什哈',''),('长江流域','乐安河','江西','虎山',''),('黄河','黄河','陕西','蝗蜊峪',''),('黄河','黄河','陕西','螅蜊峪',NULL),('海河','蟠洪河','山西','蟠龙',''),('长江','湘江','湖南','衡山(二)',''),('长江','海河','四川','袁家山',''),('淮河','慎水河','河南','袁寨',''),('长江','裴兴河','重庆','裴兴',NULL),('长江','汉江','湖北','襄阳',''),('辽河','下三家河','辽宁','西五家子',''),('海河','茅岭底沟','山西','西井',''),('淮河','沛河','河南','西双河',''),('淮河','浉河','河南','西双河',NULL),('长江','西溪河','重庆','西宁',''),('长江','蕲水','湖北','西河驿',''),('淮河','洪河','河南','西洪桥',''),('长江','带水河','湖北','西流水',''),('长江流域','昌江','江西','西湖',''),('长江','小河','湖北','西蒿坪',''),('长江','清江','湖北','见天坝',''),('长江','渚河','陕西','观音堂',''),('淮河','清溪河','河南','许昌',''),('长江流域太湖区','合溪涧','浙江','访贤',''),('淮河','桃源河','安徽','诸佛庵',''),('长江','磨刀溪','湖北','谋道',''),('长江','平通河','四川','豆叩寺',''),('长江','神潭河-南江-巴河','四川','贵民',''),('长江','南明河','贵州','贵阳(三)水文站',''),('淮河','洪河','河南','贺道桥',''),('长江','海螺河-绛溪河','四川','贾家',''),('黄河','永坪川','陕西','贾家坪',''),('海河','浑河','山西','贾庄',''),('淮河','汝河','河南','贾楼',''),('淮河','不牢河','江苏','贾汪',''),('香屯以上','赋春水','江西','赋春',''),('海河','槐河','河北','赞皇',''),('海河','白河','河北','赤城',''),('长江流域','盱江','江西','赤水',''),('海河','拒马河','河北','赵各庄',''),('长江','滔河','陕西','赵川',''),('海河','泥河','河北','赵川堡',''),('海河','江江河','河北','赵行',NULL),('上饶到弋阳','车盘水','江西','车盘',''),('黄河','姚暹渠','山西','运城',''),('黄河','牛头河','甘肃','远门镇',''),('海河','南运河','河北','连镇',NULL),('海河','兴州河','河北','选将营子',''),('淮河','九曲河','河南','通城店',''),('长江','潇水','湖南','道县(二)',''),('长江','资水','湖南','邵阳',''),('长江','汉江','湖北','郧县',''),('海河','南屯河','山西','郭郊',''),('淮河','石槽河','河南','郭陆滩',''),('长江','磨刀河','湖北','野三关',''),('长江','古楼河','湖南','金屋塘',''),('黄河','金明寺川','陕西','金明寺',''),('黄河','金明等川','陕西','金明等',''),('长江','翟家河','湖北','金果坪',''),('淮河','脱脚河','河南','金汤寨',''),('长江流域','抚河','江西','金溪',''),('长江','越溪河','四川','金石井',''),('长江','牧马河','陕西','钟家沟',''),('长江','两河','陕西','钢铁',''),('淮河','青龙河','河南','钱大湾',''),('海河','沙河','河北','钱营',''),('长江','大道河','陕西','铁佛',''),('长江','玉带河','陕西','铁锁关',''),('长江','玉帯河','陕西','铁锁关',NULL),('长江流域太湖区','山河港','浙江','银坑',''),('黄河','黄河','宁夏','银川科研站 (水文局)','银川科研站水文局'),('黄河','黄河','宁夏','银川科研站水文局',NULL),('黄河','锹峪河','甘肃','锹峪',''),('长江','芙蓉江','贵州','长坝',''),('海河','漳河','山西','长子',NULL),('海河','雍河','山西','长子',NULL),('长江','东溪河','重庆','长安',''),('长江','忠建河','湖北','长潭河',''),('长江','溇水','湖南','长潭河',''),('淮河','灌河','河南','长竹园',''),('长江流域','盱江','江西','长陂',''),('长江','杨叉河','湖北','门古',''),('长江','闪里河','安徽','闪里',''),('海河','桑干河','河北','阳原',''),('长江','嘉陵江','陕西','阳平关',''),('长江','粉青河','湖北','阳日湾',''),('长江','三岔河','贵州','阳长(纳雍县)',''),('黄河','丹河','山西','附城',''),('上饶到弋阳','大洲溪','江西','陈坊',''),('海河','南运河','河北','青县',''),('淮河','青口河','江苏','青口',''),('长江','渭溪','湖南','青山',''),('淮河','河西源','安徽','青山 (汤店)','青山汤店'),('淮河','淠河西源','安徽','青山汤店',NULL),('长江','马栏河','湖北','青峰',''),('长江','临江河','四川','青龙',''),('黄河','芦河','陕西','靖边',''),('海河','白河','河北','鞍匠',''),('淮河','北汝河','河南','韩店',''),('长江','西溪河','四川','顾县',''),('饶河','长乐水','江西','饶二',''),('长江','饶良河','河南','饶良',''),('长江','渝江','四川','马井',''),('长江','湔江','四川','马井',NULL),('黄河','大南河','甘肃','马坞镇',''),('黄河','马连河','甘肃','马岭',''),('乌江','普子河','重庆','马武·来佛2',''),('黄河','散渡河','甘肃','马营镇',''),('长江','梓樟河','四川','马角坝',''),('长江','梓橦河','四川','马角坝',NULL),('长江流域','盱江','江西','驿前',''),('海河','西沟','河北','驿马图',''),('长江','龙洞河','重庆','骡坪·迎春',NULL),('长江','龙洞河','重庆','骤坪·迎春',''),('长江','南广河','四川','高县',''),('长江','岷江','四川','高场(五)',NULL),('长江','崛江','四川','高场(五)',''),('长江','仪陇河','四川','高峰',''),('长江','花溪河','四川','高庙',''),('长江','小青龙河','四川','高梁镇',''),('长江','西溪河','重庆','高楼',''),('淮河','六塘河','江苏','高沟',''),('长江','酉水','湖南','高砌头(二)',''),('汉江','任河','重庆','高观·场镇',''),('长江','湘江','贵州','鲤鱼塘',''),('长江','马边河','四川','黄丹',''),('长江','燕岔河','湖北','黄云铺',''),('长江','西津河','安徽','黄土坎',''),('闽江','黄坑溪','福建','黄坑','黃坑'),('长江流域','昌江','江西','黄坛',''),('长江','汉江','湖北','黄家港','黃家港'),('长江','逍遥溪','安徽','黄山',''),('长江','虎渡河','湖北','黄山头(闸上)',''),('淮河','固县河','河南','黄岗',''),('辽河','柴河','辽宁','黄旗寨',''),('长江','赧水','湖南','黄桥',NULL),('长江','郝水','湖南','黄桥',''),('长江','悦崃河','重庆','黄水·莲市',''),('长江','汉江','湖北','黄莺',''),('长江','绵远河','四川','黄许镇',''),('长江','浙滩河-通江-巴河','四川','黄钟',''),('长江','澌滩河-通江-巴河','四川','黄钟',NULL),('海河','南排水河','河北','黄骅','巢'),('黄河','石堡川','陕西','黄龙',''),('长江','沅水','湖南','黔城',''),('长江','长宁河','四川','龙头',''),('长江','洣水','湖南','龙家山',''),('长江','龙池河','四川','龙池',''),('松花江吉林段','珠子河','吉林','龙泉',''),('海河','北流河','河北','龙泉关',''),('长江','旭水河-釜溪河','四川','龙潭',''),('洞庭湖','龙潭河','重庆','龙潭·龙泉街道',''),('长江','野三河','湖北','龙潭坪',''),('长江','澧水(北源)','湖南','龙潭坪',''),('淮河','北汝河','河南','龙王庙',''),('海河','平顺河','山西','龙镇',NULL),('长江','磨刀溪','重庆','龙驹·永兴','');
/*!40000 ALTER TABLE `hy_download_water_mapping_yq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hy_upload_token_mapping`
--

DROP TABLE IF EXISTS `hy_upload_token_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_upload_token_mapping` (
  `token_id` bigint NOT NULL COMMENT 'token_id',
  `token_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'token名称',
  `token_f_base_mapping` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '测站表名称',
  `token_base_mapping` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '基础表名称',
  `token_monitor_mapping` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '监测表名称',
  `token_warn_mapping` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '告警表名称',
  `token_report_mapping` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '报告表名称',
  `token_remark` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `power_station_id` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '水电站名称',
  `basin_id` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '流域名称',
  `upload_hz` int DEFAULT NULL COMMENT '上传频率',
  `upload_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '上传类型',
  PRIMARY KEY (`token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='token对应的表名称';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hy_upload_token_mapping`
--

LOCK TABLES `hy_upload_token_mapping` WRITE;
/*!40000 ALTER TABLE `hy_upload_token_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `hy_upload_token_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `hydrology`.`qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `hydrology`.`qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `hydrology`.`qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `hydrology`.`qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `hydrology`.`qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-02-23 16:20:28','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-02-23 16:20:28','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-02-23 16:20:28','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-02-23 16:20:28','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2026-02-23 16:20:28','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-02-23 16:20:28','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-02-23 16:20:28','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-02-23 16:20:28','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','水文',0,'','15888888888','','0','0','admin','2026-02-23 16:20:27','admin','2026-02-26 15:03:24'),(101,100,'0,100','默认分组',1,'','15888888888','','0','0','admin','2026-02-23 16:20:27','admin','2026-02-26 15:10:02'),(103,101,'0,100,101','管理员分组',1,'','15888888888','','0','0','admin','2026-02-23 16:20:27','admin','2026-02-26 15:10:11'),(200,101,'0,100,101','普通分组',2,NULL,NULL,NULL,'0','0','admin','2026-02-26 15:12:03','admin','2026-02-26 15:12:08');
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1000124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-02-23 16:20:28','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-02-23 16:20:28','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-02-23 16:20:28','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-02-23 16:20:28','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-02-23 16:20:28','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-02-23 16:20:28','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-02-23 16:20:28','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-02-23 16:20:28','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-02-23 16:20:28','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-02-23 16:20:28','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-02-23 16:20:28','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-02-23 16:20:28','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-02-23 16:20:28','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-02-23 16:20:28','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-02-23 16:20:28','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-02-23 16:20:28','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-02-23 16:20:28','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-02-23 16:20:28','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-02-23 16:20:28','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-02-23 16:20:28','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-02-23 16:20:28','',NULL,'停用状态'),(100,2,'实体表字典','entity_dic','sys_dict_category',NULL,'success','N','0','admin','2026-03-11 09:45:46','admin','2026-03-11 10:08:14',NULL),(101,1,'系统字典','system_dic','sys_dict_category',NULL,'primary','N','0','admin','2026-03-11 09:46:24','admin','2026-03-11 10:08:09',NULL),(102,0,'正常','1','hy_data_status',NULL,'success','N','0','admin','2026-03-11 17:17:54','',NULL,NULL),(103,0,'异常','2','hy_data_status',NULL,'danger','N','0','admin','2026-03-11 17:18:05','admin','2026-03-11 17:18:10',NULL),(104,0,'数据中断','3','hy_data_status',NULL,'warning','N','0','admin','2026-03-11 17:18:28','',NULL,NULL),(105,0,'已弃用','4','hy_data_status',NULL,'info','N','0','admin','2026-03-11 17:18:48','admin','2026-03-11 17:18:53',NULL),(106,0,'自动采集测站','1','hy_station_f_type_name',NULL,'primary','N','0','admin','2026-03-31 14:58:07','admin','2026-04-03 10:25:26',NULL),(107,1,'人工采集测站','2','hy_station_f_type_name',NULL,'success','N','0','admin','2026-03-31 14:58:20','admin','2026-04-03 10:25:30',NULL),(108,0,'表层温度测站','1','hy_station_f_data_type',NULL,'primary','N','0','admin','2026-03-31 14:59:02','admin','2026-04-09 17:54:55',NULL),(109,1,'垂向温度测站','2','hy_station_f_data_type',NULL,'success','N','0','admin','2026-03-31 14:59:07','admin','2026-04-09 17:55:50',NULL),(110,0,'是','1','sys_sf10',NULL,'success','N','0','admin','2026-04-13 09:09:47','',NULL,NULL),(111,0,'否','0','sys_sf10',NULL,'info','N','0','admin','2026-04-13 09:09:59','',NULL,NULL),(112,0,'℃','水温','hy_data_unit',NULL,'default','N','0','admin','2026-04-13 09:50:00','admin','2026-04-13 09:50:22',NULL),(113,1,'℃','温度','hy_data_unit',NULL,'default','N','0','admin','2026-04-13 09:50:09','admin','2026-04-13 09:50:28',NULL),(114,2,'m','米','hy_data_unit',NULL,'default','N','0','admin','2026-04-13 09:50:37','admin','2026-04-13 09:50:56',NULL),(115,3,'m','千米','hy_data_unit',NULL,'default','N','0','admin','2026-04-13 09:50:51','',NULL,NULL),(116,4,'Mpa','兆帕','hy_data_unit',NULL,'default','N','0','admin','2026-04-13 09:51:45','admin','2026-04-13 09:51:51',NULL),(117,1,'固定高程采集','1','hy_ad_type',NULL,'success','N','0','admin','2026-04-22 18:03:49','admin','2026-04-22 18:04:23',NULL),(118,0,'浮漂相对深度采集','2','hy_ad_type',NULL,'primary','N','0','admin','2026-04-22 18:04:04','admin','2026-04-22 18:04:14',NULL),(119,0,'监测','1','hy_monitor_data_source',NULL,'primary','N','0','admin','2026-05-26 11:20:12','',NULL,NULL),(120,0,'召测','2','hy_monitor_data_source',NULL,'success','N','0','admin','2026-05-26 11:20:25','',NULL,NULL),(121,6,'kPa','压力','hy_data_unit',NULL,'default','N','0','admin','2026-06-09 11:38:12','',NULL,NULL),(122,5,'kPa','千帕','hy_data_unit',NULL,'default','N','0','admin','2026-06-09 11:38:37','',NULL,NULL),(123,0,'导入','3','hy_monitor_data_source',NULL,'info','N','0','admin','2026-06-17 16:51:53','',NULL,NULL),(124,0,'已处置','1','hy_monitor_process_status',NULL,'success','N','0','admin','2026-08-13 15:43:37','',NULL,NULL),(125,0,'待处置','2','hy_monitor_process_status',NULL,'info','N','0','admin','2026-08-13 15:43:55','admin','2026-08-13 15:44:11',NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `dict_category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '字典类别',
  `dict_entity_json` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '实体表json',
  `create_by` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=1002011 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','system_dic',NULL,'admin','2026-02-23 16:20:28','',NULL,'登录状态列表'),(100,'字典类别','sys_dict_category','0','system_dic',NULL,'admin','2026-03-11 09:37:54','',NULL,'字典类别列表'),(103,'监测数据状态','hy_data_status','0','system_dic',NULL,'admin','2026-03-11 17:17:34','admin','2026-06-17 16:54:07',NULL),(104,'测站数据类型','hy_station_f_data_type','0','system_dic',NULL,'admin','2026-03-31 09:31:18','admin','2026-04-15 10:56:09',NULL),(105,'测站类型','hy_station_f_type_name','0','system_dic',NULL,'admin','2026-03-31 09:33:03','admin','2026-04-15 10:55:49',NULL),(108,'token映射表','hy_upload_token_mapping','0','entity_dic','{\"tableName\":\"hy_upload_token_mapping\",\"dictType\":\"hy_upload_token_mapping\",\"dictCode\":\"token_id\",\"dictLabel\":\"token_name\",\"dictValue\":\"token_id\",\"dictSort\":\"create_time\",\"dictRemark\":\"power_station_id\",\"cssClass\":null,\"listClass\":null,\"isDefault\":null,\"status\":null,\"whereSql\":\" where 1=1 \",\"orderSql\":\"\",\"remark\":\"as 前面可以写 case when,如果dictType为空tableName为缓存key,dictCode为空dictValue为dictCode\"}','admin','2026-04-01 10:06:02','',NULL,NULL),(109,'是否10','sys_sf10','0','system_dic',NULL,'admin','2026-04-13 09:09:22','admin','2026-04-13 09:09:31',NULL),(110,'数据类型单位表','hy_data_unit','0','system_dic',NULL,'admin','2026-04-13 09:49:18','',NULL,NULL),(2003,'采集方式','hy_ad_type','0','system_dic',NULL,'admin','2026-04-22 18:03:24','',NULL,NULL),(2004,'监测数据来源','hy_monitor_data_source','0','system_dic',NULL,'admin','2026-05-26 11:19:50','',NULL,NULL),(2011,'处置状态','hy_monitor_process_status','0','system_dic',NULL,'admin','2026-08-13 15:42:55','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=2000105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (102,'下载水文数据','SYSTEM','waterDownloadTask.runCrawl','0 0 9 * * ?','1','1','0','admin','2026-05-01 17:09:33','admin','2026-11-26 03:21:48',''),(103,'下载水质数据','SYSTEM','waterQualityDownloadService.download','0 0 9 * * ?','1','1','0','admin','2026-05-12 16:43:31','admin','2026-11-20 16:32:53','');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (1,'admin','127.0.0.1','内网IP','QoderCNIDE 1.41.1','Windows 10.0','1','用户不存在/密码错误','2026-11-26 02:40:07'),(2,'admin','127.0.0.1','内网IP','QoderCNIDE 1.41.1','Windows 10.0','1','用户不存在/密码错误','2026-11-26 02:40:12'),(3,'admin','127.0.0.1','内网IP','QoderCNIDE 1.41.1','Windows 10.0','1','用户不存在/密码错误','2026-11-26 02:48:03'),(4,'admin','127.0.0.1','内网IP','QoderCNIDE 1.41.1','Windows 10.0','0','登录成功','2026-11-26 02:48:12'),(5,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 02:53:22'),(6,'admin','127.0.0.1','内网IP','QoderCNIDE 1.41.1','Windows 10.0','0','退出成功','2026-11-26 02:54:24'),(7,'admin','127.0.0.1','内网IP','QoderCNIDE 1.41.1','Windows 10.0','0','登录成功','2026-11-26 02:54:57'),(8,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','用户不存在/密码错误','2026-11-26 03:20:24'),(9,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','用户不存在/密码错误','2026-11-26 03:20:27'),(10,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','用户不存在/密码错误','2026-11-26 03:20:36'),(11,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','用户不存在/密码错误','2026-11-26 03:20:44'),(12,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','用户不存在/密码错误','2026-11-26 03:20:58'),(13,'admin','127.0.0.1','内网IP','Chrome 157','Windows10','1','验证码已失效','2026-11-26 03:23:33'),(14,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','1','密码输入错误5次，帐户锁定10分钟','2026-11-26 03:27:38'),(15,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 03:27:49'),(16,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 03:33:01'),(17,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 03:40:39'),(18,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 03:53:00'),(19,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 04:50:56'),(20,'admin','127.0.0.1','内网IP','PowerShell 7.6.10','Windows 10.0','0','登录成功','2026-11-26 06:48:05');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1002067 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,90,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-02-23 16:20:28','',NULL,'系统管理目录'),(2,'系统监控',0,91,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-02-23 16:20:28','',NULL,'系统监控目录'),(3,'系统工具',0,92,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2026-02-23 16:20:28','admin','2026-06-17 16:56:32','系统工具目录'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-02-23 16:20:28','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-02-23 16:20:28','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-02-23 16:20:28','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-02-23 16:20:28','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-02-23 16:20:28','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-02-23 16:20:28','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-02-23 16:20:28','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-02-23 16:20:28','',NULL,'通知公告菜单'),(108,'日志管理',2,9,'log','','','',1,0,'M','0','0','','log','admin','2026-02-23 16:20:28','admin','2026-06-17 16:57:25','日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-02-23 16:20:28','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-02-23 16:20:28','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-02-23 16:20:28','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-02-23 16:20:28','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-02-23 16:20:28','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-02-23 16:20:28','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2026-02-23 16:20:28','',NULL,'表单构建菜单'),(116,'代码生成',1,99,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2026-02-23 16:20:28','admin','2026-06-17 16:56:12','代码生成菜单'),(117,'系统接口',1,3,'swagger','tool/swagger/index','','88',1,0,'C','0','0','tool:swagger:list','swagger','admin','2026-02-23 16:20:28','admin','2026-06-17 16:56:44','系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-02-23 16:20:28','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-02-23 16:20:28','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-02-23 16:20:28','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-02-23 16:20:28','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-02-23 16:20:28','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-02-23 16:20:28','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-02-23 16:20:28','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-02-23 16:20:28','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-02-23 16:20:28','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-02-23 16:20:28','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-02-23 16:20:28','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-02-23 16:20:28','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-02-23 16:20:28','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-02-23 16:20:28','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-02-23 16:20:28','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-02-23 16:20:28','',NULL,''),(2030,'大江大河',0,1,'hy_download_water_dj','hydrology/water-download/water-download','{\"meta\":\"hy_download_water_dj\",\"mapping\":\"hy_download_water_mapping_dj\"}','hy_download_water_dj',1,0,'C','0','0','','build','admin','2026-05-02 14:30:37','admin','2026-05-13 14:39:17',''),(2031,'大型水库',0,2,'hy_download_water_sk','hydrology/water-download/water-download','{\"meta\":\"hy_download_water_sk\",\"mapping\":\"hy_download_water_mapping_sk\"}','hy_download_water_sk',1,0,'C','0','0','','build','admin','2026-05-02 14:30:37','admin','2026-05-13 14:39:08',''),(2032,'重点水雨情',0,3,'hy_download_water_yq','hydrology/water-download/water-download','{\"meta\":\"hy_download_water_yq\",\"mapping\":\"hy_download_water_mapping_yq\"}','hy_download_water_yq',1,0,'C','0','0',NULL,'build','admin','2026-05-02 14:30:37','',NULL,''),(2033,'全国水质数据',0,4,'water-quality','hydrology/water-download/water-quality',NULL,'water-quality',1,0,'C','0','0','','build','admin','2026-05-13 09:41:22','admin','2026-05-13 14:39:24',''),(2041,'大江大河映射',0,5,'hy_download_water_mapping_dj','hydrology/water-download/water-mapping','{\"meta\":\"hy_download_water_dj\",\"mapping\":\"hy_download_water_mapping_dj\"}','hy_download_water_mapping_dj',1,0,'C','0','0','','build','admin','2026-05-02 14:30:37','admin','2026-05-13 14:39:34',''),(2042,'大型水库映射',0,6,'hy_download_water_mapping_sk','hydrology/water-download/water-mapping','{\"meta\":\"hy_download_water_sk\",\"mapping\":\"hy_download_water_mapping_sk\"}','hy_download_water_mapping_sk',1,0,'C','0','0','','build','admin','2026-05-02 14:30:37','admin','2026-05-13 14:39:42',''),(2043,'重点水雨情映射',0,7,'hy_download_water_mapping_yq','hydrology/water-download/water-mapping','{\"meta\":\"hy_download_water_yq\",\"mapping\":\"hy_download_water_mapping_yq\"}','hy_download_water_mapping_yq',1,0,'C','0','0','','build','admin','2026-05-02 14:30:37','admin','2026-05-13 14:39:50','');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (1,'定时任务',2,'com.hydrology.quartz.controller.SysJobController.changeStatus()','PUT',1,'admin','管理员分组','/monitor/job/changeStatus','127.0.0.1','内网IP','{\"jobId\":102,\"misfirePolicy\":\"0\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-11-26 03:21:48',63);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2026-02-23 16:20:28','',NULL,''),(2,'se','项目经理',2,'0','admin','2026-02-23 16:20:28','',NULL,''),(3,'hr','人力资源',3,'0','admin','2026-02-23 16:20:28','',NULL,''),(4,'user','普通员工',4,'0','admin','2026-02-23 16:20:28','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-02-23 16:20:28','',NULL,'超级管理员'),(2,'叶巴滩用户','common',2,'2',1,1,'0','0','admin','2026-02-23 16:20:28','admin','2026-07-21 17:34:50','普通角色'),(100,'上传数据查看用户','upload:user',3,'1',1,1,'0','0','admin','2026-04-01 10:29:31','admin','2026-07-21 16:43:37',NULL),(101,'水科院用户','shui',4,'1',1,1,'0','0','admin','2026-04-14 09:47:18','admin','2026-09-15 11:03:21',NULL),(102,'大渡河','DDHUser',0,'1',1,1,'0','0','admin','2026-04-27 18:20:43','admin','2026-09-15 11:03:01',NULL),(103,'高级用户','advancd:user',0,'1',1,1,'0','0','admin','2026-05-12 18:32:14','admin','2026-09-15 11:03:07',NULL),(104,'雅砻江','YLJUser',5,'1',1,1,'0','0','admin','2026-06-17 17:02:33','admin','2026-07-21 17:34:36',NULL),(105,'糯扎渡黄登','NZDHDUser',6,'1',1,1,'0','0','admin','2026-06-17 17:02:49','admin','2026-07-21 17:34:26',NULL),(106,'猴子岩','HzyUser',103,'1',1,1,'0','0','admin','2026-07-21 16:44:55','admin','2026-07-22 14:36:35',NULL);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,200);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (101,2030),(101,2031),(101,2032),(101,2033),(101,2041),(101,2042),(101,2043),(103,2030),(103,2031),(103,2032),(103,2033),(103,2041),(103,2042),(103,2043);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `role_power_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '涉及电站',
  `role_system_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '所属系统',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','超级管理员','00','vhaixk@163.com','15888888888','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-11-26 14:48:04','2026-02-23 16:20:27','admin','2026-02-23 16:20:27','','2026-05-13 18:24:48','管理员',NULL,NULL),(100,200,'普通用户','YBTUser','00','','','0','','$2a$10$YUqi5j9cov9ndca/qURUh.UnnYlFPP4hIqq9UXaVCNqffuk9wMqr.','0','2','127.0.0.1','2026-02-26 15:48:49','2026-02-26 15:17:36','admin','2026-02-26 15:14:28','admin','2026-03-09 17:26:29',NULL,NULL,NULL),(101,200,'YBTUser','YBTUser','00','','','0','','$2a$10$jYuy5gmVCoyB/2yFhQncq.b4xOA4YbvguwdNkd9bqeQc3QxlR7Dt2','0','0','172.21.0.1','2026-11-24 15:49:31','2026-10-13 14:18:56','admin','2026-03-09 17:27:06','admin','2026-10-13 14:18:56',NULL,'7','184309536616640518'),(102,200,'uploadUser','uploadUser','00','','','0','','$2a$10$3yooYvLLsRSG2xXuFON26.2NbD8NFbC.1oKI1KHlvrKW3SBW/CzKS','0','0','172.31.0.1','2026-07-14 17:30:10','2026-10-13 14:19:03','admin','2026-04-01 10:28:47','','2026-10-13 14:19:03',NULL,NULL,NULL),(103,200,'shui','shui','00','','','0','','$2a$10$s/rfLjC1CULxlozzMP1UL.oxYkVo1lN5k5yT2BNtXXa0t853meKhC','0','0','172.21.0.1','2026-10-13 10:48:31','2026-10-13 14:18:49','admin','2026-04-14 09:47:47','','2026-10-13 14:18:49',NULL,NULL,NULL),(104,200,'DDHUser','DDHUser','00','','','0','','$2a$10$5n1svdiN6jHtNpT/V/amSuSis90uymt0QPKXluxR2S1JujfoWNr3W','0','0','172.21.0.1','2026-11-26 08:42:16','2026-09-09 16:26:45','admin','2026-04-27 18:21:01','admin','2026-09-10 15:15:47',NULL,'2067170542168748032,2067170590000590848,2067170617242595328','174309536616640518'),(105,103,'zhangdi','zhangdi','00','','','0','','$2a$10$f7Cs8K6huU159aVZV4JF5eqPiiTy7R.WkgrZDhDsrzcjg8KPFwzmO','0','0','172.21.0.1','2026-11-24 15:11:21','2026-09-09 16:31:33','admin','2026-05-12 18:32:47','admin','2026-09-09 16:31:33',NULL,NULL,NULL),(106,103,'linjunqiang','linjunqiang','00','','','0','','$2a$10$SYk.HRSazC6dEWf1cF68T.v69JqPX0uzOgNWDDMwhAfBlHQJeRbta','0','0','172.31.0.1','2026-05-13 14:38:15',NULL,'admin','2026-05-13 14:10:43','',NULL,NULL,NULL,NULL),(107,200,'YLJUser','YLJUser','00','','','0','','$2a$10$LUpZV.bm0glA/ofa4i1LueDNYf6H5105JTuFzII9JeeUnBMSIpc3C','0','0','127.0.0.1','2026-06-17 17:06:40','2026-09-09 16:27:30','admin','2026-06-17 17:04:13','admin','2026-09-10 15:15:58',NULL,'2067173473475538944','284309556656540518'),(108,200,'NZDHDUser','NZDHDUser','00','','','0','','$2a$10$EoKDThdUK5gf7ghYn77ox.PXy6gf8gbo0owLIcEhMnDZ5GooQkgra','0','0','',NULL,'2026-09-09 16:27:36','admin','2026-06-17 17:04:32','admin','2026-09-10 15:16:04',NULL,'2','164309532616540518'),(109,103,'wumaoxi','wumaoxi','00','','','0','','$2a$10$QzGZd0We4.Iy8rCTZ6QFUeBjaT5aJEPSZnCNEg/zUFJfvTdDc5/.2','0','0','172.31.0.1','2026-06-20 14:45:41','2026-06-20 14:46:04','admin','2026-06-17 17:05:38','','2026-06-20 14:46:04',NULL,NULL,NULL),(110,200,'HZYUser','HZYUser','00','','','0','','$2a$10$p9rt7hpOinK5.fszXlYEH.U7rfsJdvOpQ4UUkF4Rf46.3wRzFuOMe','0','0','172.21.0.1','2026-11-17 19:14:58','2026-09-09 16:26:59','admin','2026-07-21 16:45:43','admin','2026-09-09 16:26:59',NULL,'2067170617242595328','174309536616640518'),(111,200,'PBGUser','PBGUser','00','','','0','','$2a$10$5/7u8YzhMVEsITajhkvgiuum28hbpQxRkAPLtAgrh9ei0sxx8gAGW','0','0','172.21.0.1','2026-11-17 16:57:23','2026-09-09 16:27:05','admin','2026-07-22 17:52:44','admin','2026-09-09 16:27:05',NULL,'2067170590000590848','174309536616640518'),(112,200,'DGSUser','DGSUser','00','','','0','','$2a$10$hbXgWi/t4bEidCAvFMsMj.z.foda6Mr3bVrIpn6PQAgdpzu3aCFDu','0','0','172.21.0.1','2026-11-24 11:30:37','2026-09-09 16:27:10','admin','2026-07-22 17:58:10','admin','2026-09-09 16:27:10',NULL,'2067170542168748032','174309536616640518');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(101,2),(102,100),(103,101),(104,102),(105,101),(105,103),(106,101),(106,103),(107,104),(108,105),(109,101),(109,103),(110,102),(111,102),(112,102);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-26  6:52:38
-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: water_info
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `hy_download_water_dj`
--

DROP TABLE IF EXISTS `hy_download_water_dj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_dj` (
  `monitor_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `station_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '站名',
  `monitor_time` datetime DEFAULT NULL COMMENT '监测时间',
  `origin_monitor_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(原)监测时间',
  `monitor_value` decimal(10,2) DEFAULT NULL COMMENT '水位(m)',
  `monitor_value_warn` decimal(10,2) DEFAULT NULL COMMENT '警戒水位(m)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `monitor_png_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对应数据图片',
  PRIMARY KEY (`monitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='大江大河';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hy_download_water_sk`
--

DROP TABLE IF EXISTS `hy_download_water_sk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_sk` (
  `monitor_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `station_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '库名',
  `monitor_time` datetime DEFAULT NULL COMMENT '监测时间',
  `origin_monitor_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(原)监测时间',
  `monitor_value` decimal(10,2) DEFAULT NULL COMMENT '库水位(m)',
  `monitor_value_diff` decimal(10,2) DEFAULT NULL COMMENT '日变幅(m)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `monitor_png_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对应数据图片',
  PRIMARY KEY (`monitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='大型水库';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hy_download_water_yq`
--

DROP TABLE IF EXISTS `hy_download_water_yq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_yq` (
  `monitor_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `station_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '站名',
  `monitor_time` datetime DEFAULT NULL COMMENT '监测时间',
  `origin_monitor_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(原)监测时间',
  `monitor_value` decimal(10,2) DEFAULT NULL COMMENT '日降雨(mm)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `monitor_png_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对应数据图片',
  PRIMARY KEY (`monitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='重点雨水情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hy_download_water_quality`
--

DROP TABLE IF EXISTS `hy_download_water_quality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hy_download_water_quality` (
  `wq_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'id',
  `wq_province` bigint DEFAULT NULL COMMENT '省',
  `wq_city` bigint DEFAULT NULL COMMENT '市/区',
  `wq_basin` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '流域',
  `wq_section_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '断面名称',
  `wq_monitor_time` datetime DEFAULT NULL COMMENT '监测时间',
  `wq_monitor_time_origin` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '(原)监测时间',
  `wq_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '水质类别',
  `wq_temperature` decimal(10,2) DEFAULT NULL COMMENT '水温(℃)',
  `wq_ph` decimal(10,2) DEFAULT NULL COMMENT 'pH(无量纲)',
  `wq_do` decimal(10,2) DEFAULT NULL COMMENT '溶解氧(mg/L)',
  `wq_ec` decimal(10,2) DEFAULT NULL COMMENT '电导率(μS/cm)',
  `wq_ntu` decimal(10,2) DEFAULT NULL COMMENT '浊度(NTU)',
  `wq_permanganate` decimal(10,2) DEFAULT NULL COMMENT '高锰酸盐指数(mg/L)',
  `wq_ammonia` decimal(10,2) DEFAULT NULL COMMENT '氨氮(mg/L)',
  `wq_tp` decimal(10,2) DEFAULT NULL COMMENT '总磷(mg/L)',
  `wq_tn` decimal(10,2) DEFAULT NULL COMMENT '总氮(mg/L)',
  `wq_chla` decimal(15,2) DEFAULT NULL COMMENT '叶绿素α(mg/L)',
  `wq_algal` decimal(15,2) DEFAULT NULL COMMENT '藻密度(cells/L)',
  PRIMARY KEY (`wq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='水质监测数据';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-26  6:52:38
