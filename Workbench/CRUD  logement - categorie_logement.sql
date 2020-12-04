-- ----------------------------
-- CRUD INSERT logement
-- ----------------------------
# Procédure stockée de type INSERT sur la table logement

DROP PROCEDURE IF EXISTS `insert_logement`;

DELIMITER ||
CREATE PROCEDURE insert_logement (
				 IN 				lo_nbre_ varchar(50), 
                                    lo_vi_id_fk_ int, 
                                    lo_cl_id_fk_ int)

BEGIN
# Vérifier l'existence des valeurs des paramètres destinés à des clés étrangères
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

IF NOT EXISTS ( SELECT * FROM categorie_logement WHERE categorie_logement.cl_id = lo_cl_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'categorie_logement not found'; 
END IF;


IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = lo_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'ville not found'; 
END IF;


# Insertion
INSERT INTO logement (lo_nbre, lo_vi_id_fk, lo_cl_id_fk)
VALUES (lo_nbre_, lo_vi_id_fk_, lo_cl_id_fk_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_logement ('test_insert', 1 , 1);

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD INSERT categorie_logement
-- ----------------------------

DROP PROCEDURE IF EXISTS `insert_categorie_logement`;

DELIMITER ||
CREATE PROCEDURE insert_categorie_logement (
				 IN                         cl_nom_ varchar(50))

BEGIN

# Insertion
INSERT INTO categorie_logement (cl_nom)
VALUES (cl_nom_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_categorie_logement ('test_insert'); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD READ logement
-- ----------------------------
# -- Procédure stockée de type READ sur la table logement

DROP PROCEDURE IF EXISTS `read_logement`;

DELIMITER ||
CREATE PROCEDURE `read_logement` ()
BEGIN
	SELECT lo_id, lo_nbre, lo_vi_id_fk, lo_cl_id_fk
	FROM logement;
END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL read_logement ();
 
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

 -- ----------------------------
-- CRUD READ categorie_logement
-- ----------------------------
# -- Procédure stockée de type READ sur la table categorie_logement

DROP PROCEDURE IF EXISTS `read_categorie_logement`;

DELIMITER ||
CREATE PROCEDURE `read_categorie_logement` ()
BEGIN
	SELECT cl_id, cl_nom
	FROM categorie_logement;
END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL read_categorie_logement ();
 
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD UPDATE logement
-- ----------------------------
# -- Procédure stockée de type UPDATE sur la table logement

DELIMITER ||
CREATE PROCEDURE update_logement (
				 IN 				lo_nbre_ varchar(50), 
                                    lo_vi_id_fk int,
									lo_cl_id_fk int)

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

