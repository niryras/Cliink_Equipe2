#CREATE DATABASE  IF NOT EXISTS `CLIIINK2` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `CLIIINK2`;

-- ----------------------------
-- Table structure for entreprises
-- ----------------------------
CREATE TABLE IF NOT EXISTS `entreprises` (
  `en_id` int(11) NOT NULL AUTO_INCREMENT,
  `en_nom` varchar(50) NOT NULL,
  `en_siren` varchar(50) NOT NULL,
  `en_secteur_activite` varchar(200) NOT NULL,
  `en_adresse` varchar(5) NOT NULL,
  `en_code_postal` varchar(50) NOT NULL,
  `en_ville` varchar(10) NOT NULL,
  `en_geolocalisation` varchar(50) NOT NULL,
  `en_id_fk` varchar(20) NOT NULL,
  KEY `ID` (`en_id`)
);

-- ----------------------------
-- Table structure for secteur_activite
-- ----------------------------
CREATE TABLE IF NOT EXISTS `secteur_activite` (
  `sa_id` int(11) NOT NULL AUTO_INCREMENT,
  `sa_nom` varchar(50) NOT NULL,
  KEY `ID` (`sa_id`)
);

-- ----------------------------
-- Table structure for population
-- ----------------------------
CREATE TABLE IF NOT EXISTS `population` (
  `po_id` int(11) NOT NULL AUTO_INCREMENT,
  `po_annee_2017` varchar(50) NOT NULL,
  `po_pyramide_ages` varchar(50) NOT NULL,
  `po_age_CSP` varchar(50) NOT NULL,
  `po_age_sexe_CSP` varchar(50) NOT NULL,
  `po_15_24_CSP` varchar(50) NOT NULL,
  `po_25_54_CSP` varchar(50) NOT NULL,
  `po_55_plus_CSP` varchar(50) NOT NULL,
  `po_type_activite` varchar(50) NOT NULL,
  `po_emploi_age` varchar(50) NOT NULL,
  `po_emploi_femme_age` varchar(50) NOT NULL,
  `po_emploi_homme_age` varchar(50) NOT NULL,
  `po_chomage_age` varchar(50) NOT NULL,
  `po_taux_chomage_age_sexe` varchar(50) NOT NULL,
  `po_emploi_categorie_socio_pro` varchar(50) NOT NULL,
  `po_logement_par_categorie` varchar(50) NOT NULL,
  `po_logement_par_types` varchar(50) NOT NULL,
  `po_sa_id_fk` varchar(50) NOT NULL,
  KEY `ID` (`po_id`)
);
