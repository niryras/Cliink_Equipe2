CREATE DATABASE  IF NOT EXISTS `CLIIINK2` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `CLIIINK2`;

-- ----------------------------
-- Table structure for entreprise
-- ----------------------------
CREATE TABLE IF NOT EXISTS `entreprise` (
  `en_id` int NOT NULL AUTO_INCREMENT,
  `en_nom` varchar(50) NOT NULL,
  `en_siren` varchar(50) NOT NULL,
  `en_secteur_activité` varchar(200) NOT NULL,
  `en_adresse` varchar(5) NOT NULL,
  `en_code_postal` varchar(50) NOT NULL,
  `en_ville` varchar(10) NOT NULL,
  `en_géolocalisation` varchar(50) NOT NULL,
  `en_vi_id_fk` int NOT NULL,
  `en_sa_id_fk` int NOT NULL,
  KEY `ID` (`en_id`)
);

-- ----------------------------
-- Table structure for secteur_activité
-- ----------------------------
CREATE TABLE IF NOT EXISTS `secteur_activité` (
  `sa_id` int NOT NULL AUTO_INCREMENT,
  `sa_nom` varchar(50) NOT NULL,
  KEY `ID` (`sa_id`)
);

-- ----------------------------
-- Table structure for population
-- ----------------------------
CREATE TABLE IF NOT EXISTS `population` (
  `po_id` int NOT NULL AUTO_INCREMENT,
  `po_source` varchar(50) NOT NULL,
  `po_année` varchar(50) NOT NULL,
  `po_statut_pro` varchar(50) NOT NULL,
  `po_CSP` varchar(50) NOT NULL,
  `po_nbre_pop` varchar(50) NOT NULL,
  `po_se_id_fk` int NOT NULL,
  `po_ag_id_fk` int NOT NULL,
  `po_vi_id_fk` int NOT NULL,
  KEY `ID` (`po_id`)
);

-- ----------------------------
-- Table structure for ville
-- ----------------------------

CREATE TABLE IF NOT EXISTS `ville` (
  `vi_id` int NOT NULL AUTO_INCREMENT,
  `vi_nom` varchar(50) NOT NULL,
  KEY `ID` (`vi_id`)
);

-- ----------------------------
-- Table structure for sexe
-- ----------------------------

CREATE TABLE IF NOT EXISTS `sexe` (
  `se_id` int NOT NULL AUTO_INCREMENT,
  `se_nom` varchar(50) NOT NULL,
  KEY `ID` (`se_id`)
);

-- ----------------------------
-- Table structure for age
-- ----------------------------

CREATE TABLE IF NOT EXISTS `age` (
  `ag_id` int NOT NULL AUTO_INCREMENT,
  `ag_tranche_age` varchar(50) NOT NULL,
  KEY `ID` (`ag_id`)
);

-- ----------------------------
-- Table structure for logement
-- ----------------------------

CREATE TABLE IF NOT EXISTS `logement` (
  `lo_id` int NOT NULL AUTO_INCREMENT,
  `lo_nom` varchar(50) NOT NULL,
  `lo_nbre` varchar(50) NOT NULL,
  `lo_vi_id_fk` varchar(50) NOT NULL,
  KEY `ID` (`lo_id`)
);
