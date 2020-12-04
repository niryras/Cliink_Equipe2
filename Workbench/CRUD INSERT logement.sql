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






