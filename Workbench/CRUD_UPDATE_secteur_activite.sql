-- ----------------------------
-- CRUD UPDATE secteur_activite
-- ----------------------------

# Procédure stockée de type UPDATE sur table la secteur_activite
# Obtenir la liste des colonnes

DROP PROCEDURE IF EXISTS `update_secteur_activite`;

DELIMITER ||
CREATE PROCEDURE update_secteur_activite (
				 IN 					  sa_id_ int,
										  sa_nom_ varchar(150))

BEGIN

# Mise à jour
UPDATE secteur_activite
SET sa_id = sa_id_, sa_nom = sa_nom_
WHERE sa_id = sa_id_ ;

END ||

DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_secteur_activite (25, 'Devellopeur python');
