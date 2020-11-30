CREATE DATABASE  IF NOT EXISTS `CLIIINK2` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `CLIIINK2`;

-- ----------------------------
-- Table structure for entreprise
-- ----------------------------
CREATE TABLE IF NOT EXISTS `entreprise` (
  `en_id` int NOT NULL AUTO_INCREMENT,
  `en_siren` int NOT NULL,
  `en_nic` int NOT NULL,
  `en_denomination_unite_legal` varchar(50) NOT NULL,
  `en_activite_principale_etablissement` varchar(50) NOT NULL,
  `en_adresse` varchar(50) NOT NULL,
  `en_codePostal` int(5) NOT NULL,
  `en_ville` varchar(50) NOT NULL,
  `en_vi_id_fk` int NOT NULL,
  `en_sa_id_fk` int NOT NULL,
  KEY `ID` (`en_id`)
);

-- ----------------------------
-- Table structure for secteur_activite
-- ----------------------------
CREATE TABLE IF NOT EXISTS `secteur_activite` (
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
  `po_annee` date NOT NULL,
  `po_nbre_pop` int NOT NULL,
  `po_csp_id_fk` int NOT NULL,
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
-- Table structure for categorie_socio_pro
-- ----------------------------
CREATE TABLE IF NOT EXISTS `categorie_socio_pro` (
  `csp_id` int NOT NULL AUTO_INCREMENT,
  `csp_nom` varchar(50) NOT NULL,
  KEY `ID` (`csp_id`)
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
  `lo_nbre` varchar(50) NOT NULL,
  `lo_vi_id_fk` int NOT NULL,
  `lo_cl_id_fk` int NOT NULL,
  KEY `ID` (`lo_id`)
);

-- ----------------------------
-- Table structure for categorie_logement
-- ----------------------------
CREATE TABLE IF NOT EXISTS `categorie_logement` (
  `cl_id` int NOT NULL AUTO_INCREMENT,
  `cl_nom` int NOT NULL,
  KEY `ID` (`cl_id`)
);
