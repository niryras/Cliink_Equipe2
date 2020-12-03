-- ----------------------------
-- CRUD UPDATE categorie_socio_pro
-- ----------------------------

# Procédure stockée de type UPDATE sur table la age
# Obtenir la liste des colonnes

DROP PROCEDURE IF EXISTS `update_categorie_socio_pro`;

DELIMITER ||
CREATE PROCEDURE update_categorie_socio_pro (
				 IN 						 csp_id_ int,
											 csp_nom_ varchar(50))

BEGIN

# Mise à jour
UPDATE categorie_socio_pro
SET csp_id = csp_id_, csp_nom = csp_nom_
WHERE csp_id = csp_id_ ;

END ||

DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_categorie_socio_pro (11, 'nouveau riche');
