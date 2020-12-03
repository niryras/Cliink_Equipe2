-- ----------------------------
-- CRUD CREATE entreprise
-- ----------------------------

# Procédure stockée de type INSERT sur la table entreprise
# Obtenir la liste ds colonnes

DROP PROCEDURE IF EXISTS `insert_entreprise`;

DELIMITER ||
CREATE PROCEDURE insert_entreprise (
				 IN 				en_id_ bigint,
									en_nom_ varchar(100),
                                    en_siren_ int,
                                    en_nic_ int,
									en_adresse_ varchar(100),
                                    en_code_postal_ int,
									en_vi_id_fk_ int,
									en_sa_id_fk_ int)

BEGIN
# Vérifier l'existence des valeurs des paramètres destinés à des clés étrangères
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

IF NOT EXISTS ( SELECT * FROM secteur_activite WHERE secteur_activite.sa_id = en_sa_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'secteur_activite not found';
END IF;

IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = en_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'ville_not_found';
END IF;

# Insertion
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (en_id_,en_nom_,en_siren_,en_nic_,en_adresse_,en_code_postal_,en_vi_id_fk_,en_sa_id_fk_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_entreprise (1022666123, 'Chez_Sophie', 77846, 14, '10 chemin du capitaine', '06400', 1, 11);