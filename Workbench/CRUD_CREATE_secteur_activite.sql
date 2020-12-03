-- ----------------------------
-- CRUD CREATE secteur_activite
-- ----------------------------

# Procédure stockée de type INSERT sur la table secteur_activite
# Obtenir la liste ds colonnes

DROP PROCEDURE IF EXISTS `insert_secteur_activite`;

DELIMITER ||
CREATE PROCEDURE insert_secteur_activite (
				IN		  				  sa_id_ int,
										  sa_nom_ varchar(150))

BEGIN

# Insertion
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (sa_id_,sa_nom_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_secteur_activite (25, 'Devellopement');