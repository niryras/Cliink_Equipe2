-- ----------------------------
-- CRUD CREATE categorie_socio_pro
-- ----------------------------

# Procédure stockée de type INSERT sur la table categorie_socio_pro
# Obtenir la liste ds colonnes

DROP PROCEDURE IF EXISTS `insert_categorie_socio_pro`;

DELIMITER ||
CREATE PROCEDURE insert_categorie_socio_pro (
				 IN 						 csp_id_ int,
											 csp_nom_ varchar(50))

BEGIN

# Insertion
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (csp_id_,csp_nom_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_categorie_socio_pro (11, 'chomeur');