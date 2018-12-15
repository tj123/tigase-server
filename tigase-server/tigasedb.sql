/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : tigasedb

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2018-12-14 22:06:25
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for short_news
-- ----------------------------
DROP TABLE IF EXISTS `short_news`;
CREATE TABLE `short_news` (
  `snid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `publishing_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `news_type` varchar(10) DEFAULT NULL,
  `author` varchar(128) NOT NULL,
  `subject` varchar(128) NOT NULL,
  `body` varchar(1024) NOT NULL,
  PRIMARY KEY (`snid`),
  KEY `publishing_time` (`publishing_time`),
  KEY `author` (`author`),
  KEY `news_type` (`news_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of short_news
-- ----------------------------

-- ----------------------------
-- Table structure for tig_nodes
-- ----------------------------
DROP TABLE IF EXISTS `tig_nodes`;
CREATE TABLE `tig_nodes` (
  `nid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `parent_nid` bigint(20) unsigned DEFAULT NULL,
  `uid` bigint(20) unsigned NOT NULL,
  `node` varchar(255) NOT NULL,
  PRIMARY KEY (`nid`),
  UNIQUE KEY `tnode` (`parent_nid`,`uid`,`node`),
  KEY `node` (`node`),
  KEY `uid` (`uid`),
  KEY `parent_nid` (`parent_nid`),
  CONSTRAINT `tig_nodes_constr` FOREIGN KEY (`uid`) REFERENCES `tig_users` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tig_nodes
-- ----------------------------
INSERT INTO `tig_nodes` VALUES ('1', null, '1', 'root');

-- ----------------------------
-- Table structure for tig_pairs
-- ----------------------------
DROP TABLE IF EXISTS `tig_pairs`;
CREATE TABLE `tig_pairs` (
  `nid` bigint(20) unsigned DEFAULT NULL,
  `uid` bigint(20) unsigned NOT NULL,
  `pkey` varchar(255) NOT NULL,
  `pval` mediumtext DEFAULT NULL,
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pid`),
  KEY `pkey` (`pkey`),
  KEY `uid` (`uid`),
  KEY `nid` (`nid`),
  CONSTRAINT `tig_pairs_constr_1` FOREIGN KEY (`uid`) REFERENCES `tig_users` (`uid`),
  CONSTRAINT `tig_pairs_constr_2` FOREIGN KEY (`nid`) REFERENCES `tig_nodes` (`nid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

-- ----------------------------
-- Records of tig_pairs
-- ----------------------------
INSERT INTO `tig_pairs` VALUES ('1', '1', 'schema-version', '7.1', '1');

-- ----------------------------
-- Table structure for tig_users
-- ----------------------------
DROP TABLE IF EXISTS `tig_users`;
CREATE TABLE `tig_users` (
  `uid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` varchar(2049) NOT NULL,
  `sha1_user_id` char(128) NOT NULL,
  `user_pw` varchar(255) DEFAULT NULL,
  `acc_create_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `last_logout` timestamp NULL DEFAULT NULL,
  `online_status` int(11) DEFAULT 0,
  `failed_logins` int(11) DEFAULT 0,
  `account_status` int(11) DEFAULT 1,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `sha1_user_id` (`sha1_user_id`),
  KEY `user_pw` (`user_pw`),
  KEY `last_login` (`last_login`),
  KEY `last_logout` (`last_logout`),
  KEY `account_status` (`account_status`),
  KEY `online_status` (`online_status`),
  KEY `part_of_user_id` (`user_id`(255))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8;

-- ----------------------------
-- Records of tig_users
-- ----------------------------
INSERT INTO `tig_users` VALUES ('1', 'db-properties', 'aa546827cea73b2c960c2f16f4acb88f6972ff3d', null, '2018-12-14 14:05:37', null, null, '0', '0', '-1');

-- ----------------------------
-- Table structure for xmpp_stanza
-- ----------------------------
DROP TABLE IF EXISTS `xmpp_stanza`;
CREATE TABLE `xmpp_stanza` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stanza` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of xmpp_stanza
-- ----------------------------

-- ----------------------------
-- Procedure structure for TigActiveAccounts
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigActiveAccounts`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigActiveAccounts`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where account_status > 0; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigAddNode
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAddNode`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigAddNode`(_parent_nid bigint, _uid bigint, _node varchar(255) CHARSET utf8)
begin if exists(SELECT 1 FROM tig_nodes WHERE parent_nid = _parent_nid AND uid = _uid AND node = _node)  then SELECT nid FROM tig_nodes WHERE parent_nid = _parent_nid AND uid = _uid AND node = _node; ELSEIF exists(SELECT 1 FROM tig_nodes WHERE _parent_nid is null AND uid = _uid AND 'root' = _node)  then SELECT nid FROM tig_nodes WHERE uid = _uid AND node = _node; ELSE insert into tig_nodes (parent_nid, uid, node) values (_parent_nid, _uid, _node); select LAST_INSERT_ID() as nid; END IF; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigAddUser
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAddUser`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigAddUser`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin declare res_uid bigint unsigned; insert into tig_users (user_id, sha1_user_id, user_pw) values (_user_id, sha1(lower(_user_id)), _user_pw); select LAST_INSERT_ID() into res_uid; insert into tig_nodes (parent_nid, uid, node) values (NULL, res_uid, 'root'); if _user_pw is NULL then update tig_users set account_status = -1 where uid = res_uid; end if; select res_uid as uid; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigAddUserPlainPw
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAddUserPlainPw`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigAddUserPlainPw`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin case TigGetDBProperty('password-encoding') when 'MD5-PASSWORD' then call TigAddUser(_user_id, MD5(_user_pw)); when 'MD5-USERID-PASSWORD' then call TigAddUser(_user_id, MD5(CONCAT(_user_id, _user_pw))); when 'MD5-USERNAME-PASSWORD' then call TigAddUser(_user_id, MD5(CONCAT(substring_index(_user_id, '@', 1), _user_pw))); else call TigAddUser(_user_id, _user_pw); end case; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigAllUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAllUsers`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigAllUsers`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigAllUsersCount
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigAllUsersCount`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigAllUsersCount`()
begin select count(*) from tig_users; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigDisableAccount
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigDisableAccount`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigDisableAccount`(_user_id varchar(2049) CHARSET utf8)
begin update tig_users set account_status = 0 where sha1_user_id = sha1(lower(_user_id)); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigDisabledAccounts
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigDisabledAccounts`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigDisabledAccounts`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where account_status = 0; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigEnableAccount
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigEnableAccount`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigEnableAccount`(_user_id varchar(2049) CHARSET utf8)
begin update tig_users set account_status = 1 where sha1_user_id = sha1(lower(_user_id)); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigGetPassword
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigGetPassword`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigGetPassword`(_user_id varchar(2049) CHARSET utf8)
begin select user_pw from tig_users where sha1_user_id = sha1(lower(_user_id)); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigGetUserDBUid
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigGetUserDBUid`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigGetUserDBUid`(_user_id varchar(2049) CHARSET utf8)
begin select uid from tig_users where sha1_user_id = sha1(lower(_user_id)); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigInitdb
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigInitdb`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigInitdb`()
begin update tig_users set online_status = 0; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigOfflineUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigOfflineUsers`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigOfflineUsers`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where online_status = 0; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigOnlineUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigOnlineUsers`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigOnlineUsers`()
begin select user_id, last_login, last_logout, online_status, failed_logins, account_status from tig_users where online_status > 0; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigPutDBProperty
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigPutDBProperty`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigPutDBProperty`(_tkey varchar(255) CHARSET utf8, _tval mediumtext CHARSET utf8)
begin if exists( select 1 from tig_pairs, tig_users where (sha1_user_id = sha1(lower('db-properties'))) AND (tig_users.uid = tig_pairs.uid) AND (pkey = _tkey)) then update tig_pairs tp, tig_users tu, tig_nodes tn set pval = _tval where (tu.sha1_user_id = sha1(lower('db-properties'))) AND (tu.uid = tp.uid) AND (tp.pkey = _tkey) AND (tn.node = "root"); else insert into tig_pairs (pkey, pval, uid, nid) select _tkey, _tval, tu.uid, tn.nid from tig_users tu left join tig_nodes tn on tn.uid=tu.uid where (tu.sha1_user_id = sha1(lower('db-properties')) and tn.node="root"); end if; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigRemoveUser
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigRemoveUser`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigRemoveUser`(_user_id varchar(2049) CHARSET utf8)
begin declare res_uid bigint unsigned; select uid into res_uid from tig_users where sha1_user_id = sha1(lower(_user_id)); delete from tig_pairs where uid = res_uid; delete from tig_nodes where uid = res_uid; delete from tig_users where uid = res_uid; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigTestAddUser
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigTestAddUser`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigTestAddUser`(_user_id varchar(2049) CHARSET utf8, _user_passwd varchar(255) CHARSET utf8, success_text text CHARSET utf8, failure_text text CHARSET utf8)
begin declare insert_status int default 0; DECLARE CONTINUE HANDLER FOR 1062 SET insert_status=1; call TigAddUserPLainPw(_user_id, _user_passwd); if insert_status = 0 then select success_text; else select failure_text; end if; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUpdatePairs
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePairs`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUpdatePairs`(_nid bigint, _uid bigint, _tkey varchar(255) CHARSET utf8, _tval mediumtext CHARSET utf8)
begin if exists(SELECT 1 FROM tig_pairs WHERE nid = _nid AND uid = _uid AND pkey = _tkey) then UPDATE tig_pairs SET pval = _tval WHERE nid = _nid AND uid = _uid AND pkey = _tkey; ELSE INSERT INTO tig_pairs (nid, uid, pkey, pval) VALUES (_nid, _uid, _tkey, _tval); END IF; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUpdatePassword
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePassword`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUpdatePassword`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin update tig_users set user_pw = _user_pw where sha1_user_id = sha1(lower(_user_id)); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUpdatePasswordPlainPw
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePasswordPlainPw`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUpdatePasswordPlainPw`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin case TigGetDBProperty('password-encoding') when 'MD5-PASSWORD' then call TigUpdatePassword(_user_id, MD5(_user_pw)); when 'MD5-USERID-PASSWORD' then call TigUpdatePassword(_user_id, MD5(CONCAT(_user_id, _user_pw))); when 'MD5-USERNAME-PASSWORD' then call TigUpdatePassword(_user_id, MD5(CONCAT(substring_index(_user_id, '@', 1), _user_pw))); else call TigUpdatePassword(_user_id, _user_pw); end case; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUpdatePasswordPlainPwRev
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUpdatePasswordPlainPwRev`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUpdatePasswordPlainPwRev`(_user_pw varchar(255) CHARSET utf8, _user_id varchar(2049) CHARSET utf8)
begin call TigUpdatePasswordPlainPw(_user_id, _user_pw); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUserLogin
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUserLogin`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUserLogin`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin if exists(select 1 from tig_users where (account_status > 0) AND (sha1_user_id = sha1(lower(_user_id))) AND (user_pw = _user_pw) AND (user_id = _user_id)) then update tig_users set online_status = online_status + 1, last_login = CURRENT_TIMESTAMP where sha1_user_id = sha1(lower(_user_id)); select _user_id as user_id; else update tig_users set failed_logins = failed_logins + 1 where sha1_user_id = sha1(lower(_user_id)); select NULL as user_id; end if; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUserLoginPlainPw
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUserLoginPlainPw`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUserLoginPlainPw`(_user_id varchar(2049) CHARSET utf8, _user_pw varchar(255) CHARSET utf8)
begin case TigGetDBProperty('password-encoding') when 'MD5-PASSWORD' then call TigUserLogin(_user_id, MD5(_user_pw)); when 'MD5-USERID-PASSWORD' then call TigUserLogin(_user_id, MD5(CONCAT(_user_id, _user_pw))); when 'MD5-USERNAME-PASSWORD' then call TigUserLogin(_user_id, MD5(CONCAT(substring_index(_user_id, '@', 1), _user_pw))); else call TigUserLogin(_user_id, _user_pw); end case; end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUserLogout
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUserLogout`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUserLogout`(_user_id varchar(2049) CHARSET utf8)
begin update tig_users set online_status = greatest(online_status - 1, 0), last_logout = CURRENT_TIMESTAMP where sha1_user_id = sha1(lower(_user_id)); end
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for TigUsers2Ver4Convert
-- ----------------------------
DROP PROCEDURE IF EXISTS `TigUsers2Ver4Convert`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TigUsers2Ver4Convert`()
begin declare _user_id varchar(2049) CHARSET utf8; declare _password varchar(255) CHARSET utf8; declare _parent_nid bigint; declare _uid bigint; declare _node varchar(255) CHARSET utf8; declare l_last_row_fetched int default 0; DECLARE cursor_users CURSOR FOR select user_id, pval as password from tig_users, tig_pairs where tig_users.uid = tig_pairs.uid and pkey = 'password'; DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_last_row_fetched=1; START TRANSACTION; SET l_last_row_fetched=0; OPEN cursor_users; cursor_loop:LOOP FETCH cursor_users INTO _user_id, _password; IF l_last_row_fetched=1 THEN LEAVE cursor_loop; END IF; call TigUpdatePasswordPlainPw(_user_id, _password); END LOOP cursor_loop; CLOSE cursor_users; SET l_last_row_fetched=0; COMMIT; end
;;
DELIMITER ;

-- ----------------------------
-- Function structure for TigGetDBProperty
-- ----------------------------
DROP FUNCTION IF EXISTS `TigGetDBProperty`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `TigGetDBProperty`(_tkey varchar(255) CHARSET utf8) RETURNS mediumtext CHARSET utf8
    READS SQL DATA
begin declare _result mediumtext CHARSET utf8; select pval into _result from tig_pairs, tig_users where (pkey = _tkey) AND (sha1_user_id = sha1(lower('db-properties'))) AND (tig_pairs.uid = tig_users.uid); return (_result); end
;;
DELIMITER ;
