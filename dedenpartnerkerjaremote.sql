/*
SQLyog Ultimate v11.33 (32 bit)
MySQL - 10.1.25-MariaDB : Database - partnerkerjaremote
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`partnerkerjaremote` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `partnerkerjaremote`;

/*Table structure for table `jaringan` */

DROP TABLE IF EXISTS `jaringan`;

CREATE TABLE `jaringan` (
  `id_member` varchar(11) NOT NULL,
  `id_upline` varchar(11) DEFAULT NULL,
  `id_kiri` varchar(11) DEFAULT NULL,
  `id_kanan` varchar(11) DEFAULT NULL,
  `posisi` varchar(10) DEFAULT 'kosong',
  `kiri` int(20) DEFAULT '0',
  `kanan` int(20) DEFAULT '0',
  `level` int(11) DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Data for the table `jaringan` */

insert  into `jaringan`(`id_member`,`id_upline`,`id_kiri`,`id_kanan`,`posisi`,`kiri`,`kanan`,`level`) values ('ID000','ID',NULL,NULL,'kosong',NULL,NULL,1);

/*Table structure for table `komisi_bonus` */

DROP TABLE IF EXISTS `komisi_bonus`;

CREATE TABLE `komisi_bonus` (
  `id_member` varchar(11) NOT NULL,
  `bonus_sponsor` int(20) DEFAULT NULL,
  `bonus_pasangan` int(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Data for the table `komisi_bonus` */

insert  into `komisi_bonus`(`id_member`,`bonus_sponsor`,`bonus_pasangan`) values ('ID000',0,0);

/* Trigger structure for table `jaringan` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `jaringan_tambah` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `jaringan_tambah` AFTER INSERT ON `jaringan` FOR EACH ROW BEGIN
	DECLARE check_member_komisi INT;
	DECLARE n INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE member_id VARCHAR(11);
	
	SELECT count(*) into check_member_komisi FROM komisi_bonus where id_member=NEW.id_member;
	if check_member_komisi = 0 THEN
		INSERT INTO komisi_bonus VALUES(NEW.id_member, 0,0);
	end IF;
	SET n = NEW.level-1;
	SET member_id = NEW.id_upline;
	WHILE i < n DO
		UPDATE komisi_bonus SET bonus_sponsor = bonus_sponsor+10000 WHERE id_member = member_id;
		SELECT id_upline INTO member_id from jaringan WHERE id_member = member_id;
	  SET i = i + 1;	
	END WHILE;		
	#CALL tambah_pasangan(NEW.id_upline, NEW.id_member);
	
END */$$


DELIMITER ;

/* Trigger structure for table `jaringan` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `jaringan_hapus` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `jaringan_hapus` AFTER DELETE ON `jaringan` FOR EACH ROW BEGIN
	DECLARE n INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE member_id VARCHAR(11);
	
	SET n = OLD.level-1;
	SET member_id = OLD.id_upline;
	UPDATE komisi_bonus SET bonus_pasangan = 0 WHERE id_member = member_id;
	WHILE i < n DO
		UPDATE komisi_bonus SET bonus_sponsor = bonus_sponsor-10000 WHERE id_member = member_id;
		SELECT id_upline INTO member_id FROM jaringan WHERE id_member = member_id;
	  SET i = i + 1;	
	END WHILE;
	DELETE FROM komisi_bonus where id_member=OLD.id_member;
    END */$$


DELIMITER ;

/* Procedure structure for procedure `delete_pasangan` */

/*!50003 DROP PROCEDURE IF EXISTS  `delete_pasangan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_pasangan`(IN p_id_member VARCHAR(11), IN p_id_upline VARCHAR(11))
BEGIN
	DECLARE v_kiri VARCHAR(11);
	DECLARE v_kanan VARCHAR(11);
		
	SELECT id_kiri, id_kanan INTO v_kiri, v_kanan FROM jaringan WHERE id_member = p_id_upline;
	
	if v_kiri = p_id_member THEN
		UPDATE jaringan set id_kiri = null where id_member = p_id_upline;
	elseif v_kanan = p_id_member then
		UPDATE jaringan SET id_kanan = NULL WHERE id_member = p_id_upline;
	end if;	
	
	DELETE FROM jaringan where id_member=p_id_member;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `tambah_pasangan` */

/*!50003 DROP PROCEDURE IF EXISTS  `tambah_pasangan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_pasangan`(IN p_id_member VARCHAR(11), IN p_id_upline VARCHAR(11))
BEGIN
	DECLARE check_member_jaringan INT;
	DECLARE v_level INT;
	DECLARE v_kiri VARCHAR(11);
	declare v_kanan VARCHAR(11);
	DECLARE v_posisi VARCHAR(11);
	
	SELECT COUNT(*) INTO check_member_jaringan FROM jaringan WHERE id_member=p_id_member;
	
	SELECT (CASE WHEN level !='ID' THEN level+1 ELSE 1 end), (CASE WHEN id_kiri IS NULL THEN 'kiri' ELSE 'kanan' END), id_kiri, id_kanan into v_level, v_posisi, v_kiri, v_kanan from jaringan where id_member = p_id_upline;
		
	if check_member_jaringan = 0 THEN
		INSERT INTO jaringan(id_member, id_upline, posisi, level) VALUES(p_id_member, p_id_upline, v_posisi, v_level);
	ELSE
		UPDATE jaringan set id_upline = p_id_upline, posisi = v_posisi, level=v_level where id_member = p_id_member; 
	end if;	
	IF v_posisi ='kiri' THEN
		UPDATE jaringan SET id_kiri = p_id_member where id_member = p_id_upline;
	ELSEIF v_posisi ='kanan' THEN
		UPDATE jaringan SET id_kanan = p_id_member WHERE id_member = p_id_upline;	
	end if;	
	
	IF v_kiri IS NOT NULL AND v_kanan IS NOT NULL THEN
		update komisi_bonus SET bonus_pasangan = 5000 where id_member = p_id_upline;
	END IF;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
