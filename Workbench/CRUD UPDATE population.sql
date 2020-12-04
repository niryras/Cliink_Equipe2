-- ----------------------------
-- CRUD UPDATE population
-- ----------------------------
# Procédure stockée de type UPDATE sur la table population

DROP PROCEDURE IF EXISTS `update_population`;

DELIMITER ||
CREATE PROCEDURE update_population (
				 IN 				po_id_ int, 
									po_source_ varchar(100), 
                                    po_annee_ int, 
                                    po_nbre_pop_ int,
									po_csp_id_fk_ int,
									po_ag_id_fk_ int,
									po_vi_id_fk_ int)
                                    
BEGIN
# Vérifier l'existence des valeurs des paramètres destinés à des clés étrangères
# Permet au code python de relever les messages produits par la procdure SQL en cas d'erreurs de saisi de données

IF NOT EXISTS ( SELECT * FROM categorie_socio_pro WHERE categorie_socio_pro.csp_id = po_csp_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'categorie_socio_pro not found'; 
END IF;

IF NOT EXISTS ( SELECT * FROM age WHERE age.ag_id = po_ag_id_fk_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'age_not_found';
END IF;

IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = po_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'ville_not_found';
END IF;

# Mise à jour
UPDATE population
SET po_id = po_id_, po_source = po_source_, po_annee = po_annee_, 
po_nbre_pop = po_nbre_pop_, po_csp_id_fk = po_csp_id_fk_, po_ag_id_fk = po_ag_id_fk_, po_vi_id_fk = po_vi_id_fk_
WHERE po_id = po_id_ ;

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL update_population ('123459', 'test_insert', 2020 , 12, 3, 3, 3); 

