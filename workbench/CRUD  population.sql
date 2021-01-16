USE CLIIINK2;

-- ----------------------------
-- CRUD CREATE population
-- ----------------------------
# Procédure stockée de type INSERT sur la table population

DROP PROCEDURE IF EXISTS `insert_population`;

DELIMITER ||
CREATE PROCEDURE insert_population (
				 IN 				po_source_ varchar(100), 
                                    po_annee_ int, 
                                    po_nbre_pop_ int,
									po_csp_id_fk_ int,
									po_ag_id_fk_ int,
									po_vi_id_fk_ int)

BEGIN
# Vérifier l'existence des valeurs des paramètres destinés à des clés étrangères
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

IF NOT EXISTS ( SELECT * FROM categorie_socio_pro WHERE categorie_socio_pro.csp_id = po_csp_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'categorie_socio_pro not found'; 
END IF;

IF NOT EXISTS ( SELECT * FROM age WHERE age.ag_id = po_ag_id_fk_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'age_not_found';
END IF;

IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = po_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'ville_not_found';
END IF;

# Insertion
INSERT INTO population (po_source,po_annee,po_nbre_pop,po_csp_id_fk,po_ag_id_fk,po_vi_id_fk)
VALUES (po_source_,po_annee_,po_nbre_pop_,po_csp_id_fk_,po_ag_id_fk_,po_vi_id_fk_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_population ('test_insert', 2017 , 12, 3, 3, 3); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

 -- ----------------------------
-- CRUD READ population
-- ----------------------------
# -- Procédure stockée de type READ sur la table population

DROP PROCEDURE IF EXISTS `read_population`;

DELIMITER ||
CREATE PROCEDURE `read_population` ()
BEGIN
	SELECT po_id,po_source,po_annee,po_nbre_pop,po_csp_id_fk,po_ag_id_fk,po_vi_id_fk
	FROM population;
END ||
DELIMITER ;

DELIMITER ||
CREATE PROCEDURE `read_entreprise` ()
BEGIN
	SELECT en_id, en_nom, en_siren, en_nic, en_adresse, en_code_postal, en_vi_id_fk, en_sa_id_fk
	FROM entreprise;
END ||
DELIMITER ;


DELIMITER ||
CREATE PROCEDURE `read_logement` ()
BEGIN
	SELECT lo_id, lo_nbre, lo_vi_id_fk, lo_cl_id_fk
	FROM logement;
END ||
DELIMITER ;

# FIND : renvoie la totalité des lignes de la table
DELIMITER ||
CREATE PROCEDURE `select_po` ()
BEGIN
	SELECT po_id,po_source,po_annee,po_nbre_pop,po_csp_id_fk,po_ag_id_fk,po_vi_id_fk
FROM population;
END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL read_population ('123459', 'test_insert', 2020 , 12, 3, 3, 3); 
CALL select_po ('123459', 'test_insert', 2020 , 12, 3, 3, 3); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

 -- ----------------------------
-- CRUD UPDATE population
-- ----------------------------
# -- Procédure stockée de type UPDATE sur la table population

DROP PROCEDURE IF EXISTS `update_population`;

DELIMITER ||
CREATE PROCEDURE update_population (
				 IN 				po_id_ int, 
									po_source_ varchar(100), 
                                    po_annee_ int, 
                                    po_nbre_pop_ int,
									po_csp_id_fk_ int,
									po_ag_id_fk_ int,
									po_vi_id_fk_ int)
                                    
BEGIN
# Vérifier l'existence des valeurs des paramètres destinés à des clés étrangères
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

IF NOT EXISTS ( SELECT * FROM categorie_socio_pro WHERE categorie_socio_pro.csp_id = po_csp_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'categorie_socio_pro not found'; 
END IF;

IF NOT EXISTS ( SELECT * FROM age WHERE age.ag_id = po_ag_id_fk_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'age_not_found';
END IF;

IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = po_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'ville_not_found';
END IF;

# Mise à jour
UPDATE population
SET po_id = po_id_, po_source = po_source_, po_annee = po_annee_, 
po_nbre_pop = po_nbre_pop_, po_csp_id_fk = po_csp_id_fk_, po_ag_id_fk = po_ag_id_fk_, po_vi_id_fk = po_vi_id_fk_
WHERE po_id = po_id_ ;

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_population ('123459', 'test_insert', 2020 , 12, 3, 3, 3); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD DELETE population
-- ----------------------------
# -- Procédure stockée de type DELETE sur la table population

DROP PROCEDURE IF EXISTS `delete_population`;

DELIMITER ||
CREATE PROCEDURE delete_population (
				 IN 				po_id_ int)

BEGIN
#--suppression
DELETE
	FROM population
	WHERE po_id = po_id_;
END ||
DELIMITER ;

START TRANSACTION; 

# On insère une ligne de test en utilisant la procédure stockée
CALL delete_population (111113); 
CALL delete_population (111114); 

ROLLBACK; #-- on annule toutes les actions précédentes



