-- 关联数据集（数据注册中心-关联数据集 tab）初始化脚本
-- 新环境部署须先执行本脚本，否则启动日志告警"初始化关联数据集缓存失败"
CREATE TABLE IF NOT EXISTS gen_dataset (
  dataset_id      BIGINT AUTO_INCREMENT PRIMARY KEY,
  dataset_name    VARCHAR(64)  NOT NULL COMMENT '数据集名，ds_前缀',
  dataset_comment VARCHAR(200) DEFAULT '' COMMENT '描述',
  main_table      VARCHAR(64)  NOT NULL COMMENT '主表，须已注册gen_table',
  join_config     TEXT         COMMENT '关联配置JSON',
  create_by       VARCHAR(64)  DEFAULT '',
  create_time     DATETIME,
  update_by       VARCHAR(64)  DEFAULT '',
  update_time     DATETIME,
  UNIQUE KEY uk_dataset_name (dataset_name)
) ENGINE=InnoDB COMMENT='关联数据集配置';

CREATE TABLE IF NOT EXISTS gen_dataset_column (
  column_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
  dataset_id    BIGINT       NOT NULL,
  source_table  VARCHAR(64)  NOT NULL,
  source_column VARCHAR(64)  NOT NULL,
  alias         VARCHAR(64)  NOT NULL COMMENT '输出列名',
  column_comment VARCHAR(200) DEFAULT '',
  dict_type     VARCHAR(100) DEFAULT '',
  is_show       CHAR(1) DEFAULT '1' COMMENT '列表显示',
  is_list       CHAR(1) DEFAULT '1' COMMENT '参与导出',
  sort          INT DEFAULT 0,
  KEY idx_dataset_id (dataset_id)
) ENGINE=InnoDB COMMENT='数据集输出列';

-- 代码生成页转型为数据注册中心
UPDATE sys_menu SET menu_name = '数据注册' WHERE component = 'tool/gen/index';