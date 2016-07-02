-- MySQL dump 10.13  Distrib 5.7.10-3, for Linux (x86_64)
--
-- Host: localhost    Database: my_free
-- ------------------------------------------------------
-- Server version	5.7.10-3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `my_free`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `my_free` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `my_free`;

--
-- Table structure for table `sys_mysql_backup_info`
--

DROP TABLE IF EXISTS `sys_mysql_backup_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_backup_info` (
  `mysql_backup_info_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '备份过程信息ID',
  `mysql_instance_id` int(10) unsigned NOT NULL COMMENT 'MySQL实例ID',
  `backup_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '备份状态：1、未备份，2、正在备份，3、备份完成，4、备份失败，5、备份完成但和指定的有差异',
  `backup_data_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '备份数据状态：1、未备份，2、备份失败，3、备份完成',
  `check_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '校验备份集状态：1、未校验，2、正在校验，3、校验完成，4、校验失败',
  `binlog_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'binlog备份状态:1、未备份，2、备份失败，3、完成备份',
  `trans_data_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '备份数据远程传输状态：1、未传输，2、传输失败，3、传输完成',
  `trans_binlog_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '备份binlog远程传输状态：1、未传输，2、传输失败，3、传输完成',
  `compress_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'binlog备份状态:1、未压缩，2、压缩失败，3、压缩完成',
  `thread_id` int(11) NOT NULL DEFAULT '-1' COMMENT '备份操作系统进程ID',
  `backup_folder` varchar(50) NOT NULL DEFAULT '' COMMENT '备份文件夹名称',
  `backup_size` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '备份集大小',
  `backup_start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '备份开始时间',
  `backup_end_time` datetime DEFAULT NULL COMMENT '备份结束时间',
  `check_start_time` datetime DEFAULT NULL COMMENT '校验开始时间',
  `check_end_time` datetime DEFAULT NULL COMMENT '校验结束时间',
  `trans_start_time` datetime DEFAULT NULL COMMENT '传输至远程开始时间',
  `trans_end_time` datetime DEFAULT NULL COMMENT '传输至远程结束时间',
  `message` varchar(50) NOT NULL DEFAULT '' COMMENT '备份信息',
  PRIMARY KEY (`mysql_backup_info_id`),
  KEY `idx$mysql_instance_id` (`mysql_instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='描述整个备份过程的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_backup_instance`
--

DROP TABLE IF EXISTS `sys_mysql_backup_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_backup_instance` (
  `mysql_backup_instance_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '备份实例ID',
  `mysql_instance_id` int(10) unsigned NOT NULL COMMENT 'MySQL实例ID',
  `backup_tool` tinyint(3) unsigned NOT NULL DEFAULT '4' COMMENT '使用备份工具：1、mysqldump，2、mysqlpump、3、mydumper、4、xtrabackup',
  `backup_type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '备份类型: 1、强制指定实例备份，2、强制寻找备份，3、最优型备份',
  `is_all_instance` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '是否备份整个实例：0、否，1、是',
  `is_binlog` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '是否备份binlog：0、否，1、是',
  `is_compress` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '备份集是否压缩：0、否，1、是',
  `is_to_remote` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '将备份传输至远程：0、否，1、是',
  `backup_dir` varchar(200) NOT NULL DEFAULT '' COMMENT '本地备份目录',
  `backup_tool_file` varchar(200) NOT NULL DEFAULT '' COMMENT '备份工具路径及名称',
  `backup_tool_param` varchar(200) NOT NULL DEFAULT '' COMMENT '备份额外参数',
  `backup_name` varchar(100) NOT NULL DEFAULT '' COMMENT '备份名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_backup_instance_id`),
  UNIQUE KEY `udx$mysql_instance_id` (`mysql_instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='MySQL需要备份的实例信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_backup_remote`
--

DROP TABLE IF EXISTS `sys_mysql_backup_remote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_backup_remote` (
  `mysql_backup_remote_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '备份传输到远程系统ID',
  `os_id` int(10) unsigned NOT NULL COMMENT '操作系统ID',
  `mysql_instance_id` int(10) unsigned NOT NULL COMMENT 'MySQL实例ID',
  `remote_dir` varchar(200) NOT NULL DEFAULT '' COMMENT '远程备份目录',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_backup_remote_id`),
  UNIQUE KEY `udx$mysql_instance_id` (`mysql_instance_id`),
  KEY `idx$os_id` (`os_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='备份传输到远程机器';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_business_group`
--

DROP TABLE IF EXISTS `sys_mysql_business_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_business_group` (
  `mysql_business_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '业务组ID',
  `alias` varchar(40) NOT NULL DEFAULT '' COMMENT '组别名',
  `remark` varchar(50) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_business_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='MySQL业务组, 主要用于批量执行相关SQL';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_ha_group`
--

DROP TABLE IF EXISTS `sys_mysql_ha_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_ha_group` (
  `mysql_ha_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '高可用组ID',
  `alias` varchar(40) NOT NULL DEFAULT '' COMMENT '组别名',
  `remark` varchar(50) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_ha_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='MySQL高可用组, 主要用于MySQL备份使用';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_ha_group_detail`
--

DROP TABLE IF EXISTS `sys_mysql_ha_group_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_ha_group_detail` (
  `mysql_ha_group_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'HA GROUP MySQL 管理表',
  `mysql_instance_id` int(10) unsigned NOT NULL COMMENT 'MySQL实例ID',
  `mysql_ha_group_id` int(10) unsigned NOT NULL COMMENT '高可用组ID',
  `backup_priority` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '备份优先级，值越大优先级越高',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_ha_group_detail_id`),
  UNIQUE KEY `udx$mysql_instance_id` (`mysql_instance_id`),
  KEY `idx$mysql_ha_group_id` (`mysql_ha_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='MySQL HA 组和MySQL实例关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_instance`
--

DROP TABLE IF EXISTS `sys_mysql_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_instance` (
  `mysql_instance_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'MySQL实例ID',
  `os_id` int(10) unsigned NOT NULL COMMENT '操作系统ID',
  `host` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '链接MySQL HOST',
  `port` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '链接MySQL PORT',
  `username` varchar(30) NOT NULL DEFAULT '' COMMENT '管理MySQL用户名',
  `password` varchar(200) NOT NULL DEFAULT '' COMMENT '管理MySQL用户名密码，是个可逆的加密串',
  `remark` varchar(50) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_instance_id`),
  KEY `idx$os_id` (`os_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='MySQL实例信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_mysql_instance_info`
--

DROP TABLE IF EXISTS `sys_mysql_instance_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_mysql_instance_info` (
  `mysql_instance_info_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'MySQL实例ID',
  `mysql_instance_id` int(10) unsigned NOT NULL COMMENT 'MySQL实例ID',
  `my_cnf_path` varchar(200) NOT NULL DEFAULT '' COMMENT 'my.cnf 文件路径',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`mysql_instance_info_id`),
  KEY `idx$mysql_instance_id` (`mysql_instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='MySQL实例信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_os`
--

DROP TABLE IF EXISTS `sys_os`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_os` (
  `os_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '操作系统ID',
  `hostname` varchar(50) NOT NULL DEFAULT '' COMMENT '操作系统的hostname信息',
  `alias` varchar(40) NOT NULL DEFAULT '' COMMENT '别名',
  `ip` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作系统IP',
  `username` varchar(30) NOT NULL DEFAULT '' COMMENT '用于登陆操作系统执行一些命令的用户',
  `password` varchar(200) NOT NULL DEFAULT '' COMMENT '登陆用户密码，是个可逆的加密串',
  `remark` varchar(50) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`os_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='操作系统信息';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-07-02 22:36:10
