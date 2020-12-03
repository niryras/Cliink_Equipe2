-- ----------------------------
-- CRUD CREATE age
-- ----------------------------

# Procédure stockée de type INSERT sur la table age
# Obtenir la liste ds colonnes

DROP PROCEDURE IF EXISTS `insert_age`;

DELIMITER ||
CREATE PROCEDURE insert_age (
				 IN 		 ag_id_ int,
							 ag_tranche_age_ varchar(50))
BEGIN
# Insertion
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (ag_id_,ag_tranche_age_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_age (4, "77 a 88");