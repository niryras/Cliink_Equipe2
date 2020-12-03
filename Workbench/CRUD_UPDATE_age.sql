-- ----------------------------
-- CRUD UPDATE age
-- ----------------------------

# Procédure stockée de type UPDATE sur table la age
# Obtenir la liste des colonnes

DROP PROCEDURE IF EXISTS `update_age`;

DELIMITER ||
CREATE PROCEDURE update_age (
				 IN 				ag_id_ int,
									ag_tranche_age_ varchar(50))

BEGIN

# Mise à jour
UPDATE age
SET ag_id = ag_id_, ag_tranche_age = ag_tranche_age_
WHERE ag_id = ag_id_ ;

END ||

DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_age (6, '89 a 99');