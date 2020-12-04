USE CLIIINK2;

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





                                    
