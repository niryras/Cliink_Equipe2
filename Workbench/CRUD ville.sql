-- ----------------------------
-- CRUD INSERT ville
-- ----------------------------
# Procédure stockée de type INSERT sur la table ville

DROP PROCEDURE IF EXISTS `create_ville`;

DELIMITER ||
CREATE PROCEDURE create_ville (
				 IN 			 vi_nom_ varchar(50))

BEGIN

# vérifier que le vi_nom de ville que l'on souhaite insérer n'est pas déja pris
IF EXISTS (SELECT * FROM ville WHERE ville.vi_nom = vi_nom_) THEN
    SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'ville already existing';
END IF;

# Insertion
INSERT INTO ville (vi_nom)
VALUES (vi_nom_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL create_ville ('test_insert'); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-------------------------------
-- CRUD READ ville
-- ----------------------------
# -- Procédure stockée de type READ sur la table ville

DROP PROCEDURE IF EXISTS `read_ville`;

DELIMITER ||
CREATE PROCEDURE `read_ville` ()
BEGIN
	SELECT vi_id, vi_nom
    FROM ville;
END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL read_ville ();
 
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD UPDATE ville
-- ----------------------------
# -- Procédure stockée de type UPDATE sur la table ville

DELIMITER ||
CREATE PROCEDURE update_ville (
				 IN 			vi_id_ int,
								vi_nom_ varchar(50))

BEGIN
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

# Mise à jour
UPDATE ville
SET vi_id = vi_id_, vi_nom = vi_nom_
WHERE vi_id = vi_id_ ;

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_ville(177, 'test_insert'); 

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- CRUD DELETE ville
-- ----------------------------
# -- Procédure stockée de type DELETE sur la table ville

DROP PROCEDURE IF EXISTS `detele_ville`;

DELIMITER ||
CREATE PROCEDURE `detele_ville` (
				IN 				 vi_id_ int)
BEGIN

#--suppression
DELETE
	FROM ville
	WHERE vi_id = vi_id_;
END ||
DELIMITER ;

START TRANSACTION; 

# On insère une ligne de test en utilisant la procédure stockée
CALL detele_ville(9); 

ROLLBACK; #-- on annule toutes les actions précédentes


































