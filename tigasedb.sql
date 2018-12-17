/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 100211
 Source Host           : localhost:3306
 Source Schema         : tigasedb

 Target Server Type    : MySQL
 Target Server Version : 100211
 File Encoding         : 65001

 Date: 14/12/2018 15:08:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for broadcast_msgs
-- ----------------------------
DROP TABLE IF EXISTS `broadcast_msgs`;
CREATE TABLE `broadcast_msgs`  (
  `id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expired` datetime(0) NOT NULL,
  `msg` varchar(4096) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for broadcast_msgs_recipients
-- ----------------------------
DROP TABLE IF EXISTS `broadcast_msgs_recipients`;
CREATE TABLE `broadcast_msgs_recipients`  (
  `msg_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `jid_id` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`msg_id`, `jid_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for msg_history
-- ----------------------------
DROP TABLE IF EXISTS `msg_history`;
CREATE TABLE `msg_history`  (
  `msg_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ts` timestamp(0) NOT NULL DEFAULT current_timestamp(0),
  `expired` datetime(0) NULL DEFAULT NULL,
  `sender_uid` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `receiver_uid` bigint(20) UNSIGNED NOT NULL,
  `msg_type` int(11) NOT NULL DEFAULT 0,
  `message` varchar(4096) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  UNIQUE INDEX `msg_id`(`msg_id`) USING BTREE,
  INDEX `expired`(`expired`) USING BTREE,
  INDEX `sender_uid`(`sender_uid`, `receiver_uid`) USING BTREE,
  INDEX `receiver_uid`(`receiver_uid`, `sender_uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for short_news
-- ----------------------------
DROP TABLE IF EXISTS `short_news`;
CREATE TABLE `short_news`  (
  `snid` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `publishing_time` timestamp(0) NOT NULL DEFAULT current_timestamp(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `news_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `author` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `subject` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `body` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`snid`) USING BTREE,
  INDEX `publishing_time`(`publishing_time`) USING BTREE,
  INDEX `author`(`author`) USING BTREE,
  INDEX `news_type`(`news_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tig_nodes
-- ----------------------------
DROP TABLE IF EXISTS `tig_nodes`;
CREATE TABLE `tig_nodes`  (
  `nid` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_nid` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `uid` bigint(20) UNSIGNED NOT NULL,
  `node` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`nid`) USING BTREE,
  UNIQUE INDEX `tnode`(`parent_nid`, `uid`, `node`) USING BTREE,
  INDEX `node`(`node`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `parent_nid`(`parent_nid`) USING BTREE,
  CONSTRAINT `tig_nodes_constr` FOREIGN KEY (`uid`) REFERENCES `tig_users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tig_nodes
-- ----------------------------
INSERT INTO `tig_nodes` VALUES (1, NULL, 1, 'root');
INSERT INTO `tig_nodes` VALUES (2, NULL, 2, 'root');
INSERT INTO `tig_nodes` VALUES (3, NULL, 4, 'root');

-- ----------------------------
-- Table structure for tig_pairs
-- ----------------------------
DROP TABLE IF EXISTS `tig_pairs`;
CREATE TABLE `tig_pairs`  (
  `nid` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `uid` bigint(20) UNSIGNED NOT NULL,
  `pkey` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pval` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pid`) USING BTREE,
  INDEX `pkey`(`pkey`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `nid`(`nid`) USING BTREE,
  CONSTRAINT `tig_pairs_constr_1` FOREIGN KEY (`uid`) REFERENCES `tig_users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tig_pairs_constr_2` FOREIGN KEY (`nid`) REFERENCES `tig_nodes` (`nid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci KEY_BLOCK_SIZE = 8 ROW_FORMAT = Compressed;

-- ----------------------------
-- Records of tig_pairs
-- ----------------------------
INSERT INTO `tig_pairs` VALUES (1, 1, 'schema-version', '7.1', 1);

-- ----------------------------
-- Table structure for tig_users
-- ----------------------------
DROP TABLE IF EXISTS `tig_users`;
CREATE TABLE `tig_users`  (
  `uid` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` varchar(2049) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sha1_user_id` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_pw` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `acc_create_time` timestamp(0) NOT NULL DEFAULT current_timestamp(0),
  `last_login` timestamp(0) NULL DEFAULT NULL,
  `last_logout` timestamp(0) NULL DEFAULT NULL,
  `online_status` int(11) NULL DEFAULT 0,
  `failed_logins` int(11) NULL DEFAULT 0,
  `account_status` int(11) NULL DEFAULT 1,
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE INDEX `sha1_user_id`(`sha1_user_id`) USING BTREE,
  INDEX `user_pw`(`user_pw`) USING BTREE,
  INDEX `last_login`(`last_login`) USING BTREE,
  INDEX `last_logout`(`last_logout`) USING BTREE,
  INDEX `account_status`(`account_status`) USING BTREE,
  INDEX `online_status`(`online_status`) USING BTREE,
  INDEX `part_of_user_id`(`user_id`(255)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci KEY_BLOCK_SIZE = 8 ROW_FORMAT = Compressed;

-- ----------------------------
-- Records of tig_users
-- ----------------------------
INSERT INTO `tig_users` VALUES (1, 'db-properties', 'aa546827cea73b2c960c2f16f4acb88f6972ff3d', NULL, '2018-12-14 07:06:20', NULL, NULL, 0, 0, -1);
INSERT INTO `tig_users` VALUES (2, 'vhost-manager', 'af51856190a694c5a46d7a5131063caedbbaf809', NULL, '2018-12-14 07:07:28', NULL, NULL, 0, 0, -1);
INSERT INTO `tig_users` VALUES (4, 'tigase-monitor', '821751b4d6cadbf2dbd6cef48fea77172eb043aa', NULL, '2018-12-14 07:07:29', NULL, NULL, 0, 0, -1);

-- ----------------------------
-- Table structure for user_jid
-- ----------------------------
DROP TABLE IF EXISTS `user_jid`;
CREATE TABLE `user_jid`  (
  `jid_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `jid_sha` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `jid` varchar(2049) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `history_enabled` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`jid_id`) USING BTREE,
  UNIQUE INDEX `jid_id`(`jid_id`) USING BTREE,
  UNIQUE INDEX `jid_sha`(`jid_sha`) USING BTREE,
  INDEX `jid`(`jid`(255)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for xmpp_stanza
-- ----------------------------
DROP TABLE IF EXISTS `xmpp_stanza`;
CREATE TABLE `xmpp_stanza`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `stanza` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Procedure structure for TigActiveAccounts
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigActiveAccounts`;
delimiter ;;
CREATE PROCEDURE `TigActiveAccounts`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where account_status > 0; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigAddNode
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAddNode`;
delimiter ;;
CREATE PROCEDURE `TigAddNode`(_parent_nid bigint, _uid bigint, _node varchar(255) CHARSET utf8)
begin if exists(SELECT 1 FROM tig_nodes WHERE parent_nid = _parent_nid AND uid = _uid AND node = _node)  then SELECT nid FROM tig_nodes WHERE parent_nid = _parent_nid AND uid = _uid AND node = _node; ELSEIF exists(SELECT 1 FROM tig_nodes WHERE _parent_nid is null AND uid = _uid AND 'root' = _node)  then SELECT nid FROM tig_nodes WHERE uid = _uid AND node = _node; ELSE insert into tig_nodes (parent_nid, uid, node) values (_parent_nid, _uid, _node); select LAST_INSERT_ID() as nid; END IF; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigAddUser
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAddUser`;
delimiter ;;
CREATE PROCEDURE `TigAddUser`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin declare res_uid bigint unsigned; insert into tig_users (user_id, sha1_user_id, user_pw) values (_user_id, sha1(lower(_user_id)), _user_pw); select LAST_INSERT_ID() into res_uid; insert into tig_nodes (parent_nid, uid, node) values (NULL, res_uid, 'root'); if _user_pw is NULL then update tig_users set account_status = -1 where uid = res_uid; end if; select res_uid as uid; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigAddUserPlainPw
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAddUserPlainPw`;
delimiter ;;
CREATE PROCEDURE `TigAddUserPlainPw`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin case TigGetDBProperty('password-encoding') when 'MD5-PASSWORD' then call TigAddUser(_user_id, MD5(_user_pw)); when 'MD5-USERID-PASSWORD' then call TigAddUser(_user_id, MD5(CONCAT(_user_id, _user_pw))); when 'MD5-USERNAME-PASSWORD' then call TigAddUser(_user_id, MD5(CONCAT(substring_index(_user_id, '@', 1), _user_pw))); else call TigAddUser(_user_id, _user_pw); end case; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigAllUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAllUsers`;
delimiter ;;
CREATE PROCEDURE `TigAllUsers`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigAllUsersCount
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAllUsersCount`;
delimiter ;;
CREATE PROCEDURE `TigAllUsersCount`()
begin select count(*) from tig_users; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigDisableAccount
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigDisableAccount`;
delimiter ;;
CREATE PROCEDURE `TigDisableAccount`(_user_id varchar(2049) CHARSET utf8)
begin update tig_users set account_status = 0 where sha1_user_id = sha1(lower(_user_id)); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigDisabledAccounts
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigDisabledAccounts`;
delimiter ;;
CREATE PROCEDURE `TigDisabledAccounts`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where account_status = 0; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigEnableAccount
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigEnableAccount`;
delimiter ;;
CREATE PROCEDURE `TigEnableAccount`(_user_id varchar(2049) CHARSET utf8)
begin update tig_users set account_status = 1 where sha1_user_id = sha1(lower(_user_id)); end
;;
delimiter ;

-- ----------------------------
-- Function structure for TigGetDBProperty
-- ----------------------------
DROP FUNCTION IF EXISTS `TigGetDBProperty`;
delimiter ;;
CREATE FUNCTION `TigGetDBProperty`(_tkey varchar(255) CHARSET utf8)
 RETURNS mediumtext CHARSET utf8
  READS SQL DATA 
begin declare _result mediumtext CHARSET utf8; select pval into _result from tig_pairs, tig_users where (pkey = _tkey) AND (sha1_user_id = sha1(lower('db-properties'))) AND (tig_pairs.uid = tig_users.uid); return (_result); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigGetPassword
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigGetPassword`;
delimiter ;;
CREATE PROCEDURE `TigGetPassword`(_user_id varchar(2049) CHARSET utf8)
begin select user_pw from tig_users where sha1_user_id = sha1(lower(_user_id)); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigGetUserDBUid
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigGetUserDBUid`;
delimiter ;;
CREATE PROCEDURE `TigGetUserDBUid`(_user_id varchar(2049) CHARSET utf8)
begin select uid from tig_users where sha1_user_id = sha1(lower(_user_id)); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigInitdb
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigInitdb`;
delimiter ;;
CREATE PROCEDURE `TigInitdb`()
begin update tig_users set online_status = 0; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigOfflineUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigOfflineUsers`;
delimiter ;;
CREATE PROCEDURE `TigOfflineUsers`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where online_status = 0; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigOnlineUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigOnlineUsers`;
delimiter ;;
CREATE PROCEDURE `TigOnlineUsers`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where online_status > 0; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigPutDBProperty
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigPutDBProperty`;
delimiter ;;
CREATE PROCEDURE `TigPutDBProperty`(_tkey varchar(255) CHARSET utf8, _tval mediumtext CHARSET utf8)
begin if exists( select 1 from tig_pairs, tig_users where (sha1_user_id = sha1(lower('db-properties'))) AND (tig_users.uid = tig_pairs.uid) AND (pkey = _tkey)) then update tig_pairs tp, tig_users tu, tig_nodes tn set pval = _tval where (tu.sha1_user_id = sha1(lower('db-properties'))) AND (tu.uid = tp.uid) AND (tp.pkey = _tkey) AND (tn.node = "root"); else insert into tig_pairs (pkey, pval, uid, nid) select _tkey, _tval, tu.uid, tn.nid from tig_users tu left join tig_nodes tn on tn.uid=tu.uid where (tu.sha1_user_id = sha1(lower('db-properties')) and tn.node="root"); end if; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigRemoveUser
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigRemoveUser`;
delimiter ;;
CREATE PROCEDURE `TigRemoveUser`(_user_id varchar(2049) CHARSET utf8)
begin declare res_uid bigint unsigned; select uid into res_uid from tig_users where sha1_user_id = sha1(lower(_user_id)); delete from tig_pairs where uid = res_uid; delete from tig_nodes where uid = res_uid; delete from tig_users where uid = res_uid; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigTestAddUser
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigTestAddUser`;
delimiter ;;
CREATE PROCEDURE `TigTestAddUser`(_user_id varchar(2049) CHARSET utf8, _user_passwd varchar(255) CHARSET utf8, success_text text CHARSET utf8, failure_text text CHARSET utf8)
begin declare insert_status int default 0; DECLARE CONTINUE HANDLER FOR 1062 SET insert_status=1; call TigAddUserPLainPw(_user_id, _user_passwd); if insert_status = 0 then select success_text; else select failure_text; end if; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUpdatePairs
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePairs`;
delimiter ;;
CREATE PROCEDURE `TigUpdatePairs`(_nid bigint, _uid bigint, _tkey varchar(255) CHARSET utf8, _tval mediumtext CHARSET utf8)
begin if exists(SELECT 1 FROM tig_pairs WHERE nid = _nid AND uid = _uid AND pkey = _tkey) then UPDATE tig_pairs SET pval = _tval WHERE nid = _nid AND uid = _uid AND pkey = _tkey; ELSE INSERT INTO tig_pairs (nid, uid, pkey, pval) VALUES (_nid, _uid, _tkey, _tval); END IF; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUpdatePassword
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePassword`;
delimiter ;;
CREATE PROCEDURE `TigUpdatePassword`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin update tig_users set user_pw = _user_pw where sha1_user_id = sha1(lower(_user_id)); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUpdatePasswordPlainPw
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePasswordPlainPw`;
delimiter ;;
CREATE PROCEDURE `TigUpdatePasswordPlainPw`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin case TigGetDBProperty('password-encoding') when 'MD5-PASSWORD' then call TigUpdatePassword(_user_id, MD5(_user_pw)); when 'MD5-USERID-PASSWORD' then call TigUpdatePassword(_user_id, MD5(CONCAT(_user_id, _user_pw))); when 'MD5-USERNAME-PASSWORD' then call TigUpdatePassword(_user_id, MD5(CONCAT(substring_index(_user_id, '@', 1), _user_pw))); else call TigUpdatePassword(_user_id, _user_pw); end case; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUpdatePasswordPlainPwRev
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePasswordPlainPwRev`;
delimiter ;;
CREATE PROCEDURE `TigUpdatePasswordPlainPwRev`(_user_pw varchar(255) CHARSET utf8, _user_id varchar(2049) CHARSET utf8)
begin call TigUpdatePasswordPlainPw(_user_id, _user_pw); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUserLogin
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUserLogin`;
delimiter ;;
CREATE PROCEDURE `TigUserLogin`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin if exists(select 1 from tig_users where (account_status > 0) AND (sha1_user_id = sha1(lower(_user_id))) AND (user_pw = _user_pw) AND (user_id = _user_id)) then update tig_users set online_status = online_status + 1, last_login = CURRENT_TIMESTAMP where sha1_user_id = sha1(lower(_user_id)); select _user_id as user_id; else update tig_users set failed_logins = failed_logins + 1 where sha1_user_id = sha1(lower(_user_id)); select NULL as user_id; end if; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUserLoginPlainPw
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUserLoginPlainPw`;
delimiter ;;
CREATE PROCEDURE `TigUserLoginPlainPw`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin case TigGetDBProperty('password-encoding') when 'MD5-PASSWORD' then call TigUserLogin(_user_id, MD5(_user_pw)); when 'MD5-USERID-PASSWORD' then call TigUserLogin(_user_id, MD5(CONCAT(_user_id, _user_pw))); when 'MD5-USERNAME-PASSWORD' then call TigUserLogin(_user_id, MD5(CONCAT(substring_index(_user_id, '@', 1), _user_pw))); else call TigUserLogin(_user_id, _user_pw); end case; end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUserLogout
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUserLogout`;
delimiter ;;
CREATE PROCEDURE `TigUserLogout`(_user_id varchar(2049) CHARSET utf8)
begin update tig_users set online_status = greatest(online_status - 1, 0), last_logout = CURRENT_TIMESTAMP where sha1_user_id = sha1(lower(_user_id)); end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for TigUsers2Ver4Convert
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUsers2Ver4Convert`;
delimiter ;;
CREATE PROCEDURE `TigUsers2Ver4Convert`()
begin declare _user_id varchar(2049) CHARSET utf8; declare _password varchar(255) CHARSET utf8; declare _parent_nid bigint; declare _uid bigint; declare _node varchar(255) CHARSET utf8; declare l_last_row_fetched int default 0; DECLARE cursor_users CURSOR FOR select user_id, pval as password from tig_users, tig_pairs where tig_users.uid = tig_pairs.uid and pkey = 'password'; DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_last_row_fetched=1; START TRANSACTION; SET l_last_row_fetched=0; OPEN cursor_users; cursor_loop:LOOP FETCH cursor_users INTO _user_id, _password; IF l_last_row_fetched=1 THEN LEAVE cursor_loop; END IF; call TigUpdatePasswordPlainPw(_user_id, _password); END LOOP cursor_loop; CLOSE cursor_users; SET l_last_row_fetched=0; COMMIT; end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
