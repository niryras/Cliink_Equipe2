USE CLIIINK2;

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

# vérifier que le cl_nom de categorie_logement que l'on souhaite insérer n'est pas déjà pris
IF EXISTS (SELECT * FROM categorie_logement WHERE categorie_logement.cl_nom = cl_nom_) THEN
    SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'categorie_logement already existing';
END IF;

# Insertion
INSERT INTO categorie_logement (cl_nom)
VALUES (cl_nom_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_categorie_logement ('test_insert1'); 

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
				 IN 				lo_id_ int,
									lo_nbre_ varchar(50), 
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

# Mise à jour
UPDATE logement
SET lo_id = lo_id_, lo_nbre = lo_nbre_, lo_vi_id_fk = lo_vi_id_fk_, lo_cl_id_fk = lo_cl_id_fk_
WHERE lo_id = lo_id_ ;

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_logement(234, 'test_insert',3,3); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD UPDATE categorie_logement
-- ----------------------------
# -- Procédure stockée de type UPDATE sur la table categorie_logement

DELIMITER ||
CREATE PROCEDURE update_categorie_logement (
				 IN 				cl_id_ int,
									cl_nom_ varchar(50))

BEGIN
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

# Mise à jour
UPDATE categorie_logement
SET cl_id = cl_id_, cl_nom = cl_nom_
WHERE cl_id = cl_id_ ;

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_categorie_logement(121, 'test_insert'); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD DELETE logement
-- ----------------------------
# -- Procédure stockée de type DELETE sur la table logement

DROP PROCEDURE IF EXISTS `delete_logement`;

DELIMITER ||
CREATE PROCEDURE `delete_logement` (
				IN 					lo_id_ int)

BEGIN

#--suppression
DELETE
FROM logement
WHERE lo_id = lo_id_;
END ||
DELIMITER ;

START TRANSACTION; 

# On insère une ligne de test en utilisant la procédure stockée
CALL delete_logement(21); 
CALL delete_logement(22); 

ROLLBACK; #-- on annule toutes les actions précédentes

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD DELETE categorie_logement
-- ----------------------------
# -- Procédure stockée de type DELETE sur la table categorie_logement

DROP PROCEDURE IF EXISTS `detele_categorie_logement`;

DELIMITER ||
CREATE PROCEDURE `detele_categorie_logement` (
				IN 					cl_id_ int)
BEGIN

#--suppression
DELETE
	FROM categorie_logement
	WHERE cl_id = cl_id_;
END ||
DELIMITER ;

START TRANSACTION; 

# On insère une ligne de test en utilisant la procédure stockée
CALL detele_categorie_logement(5); 

ROLLBACK; #-- on annule toutes les actions précédentes

