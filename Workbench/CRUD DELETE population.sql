-- ----------------------------
-- CRUD DELETE population
-- ----------------------------
# -- Procédure stockée de type DELETE sur la table population

DROP PROCEDURE IF EXISTS `delete_population`;

DELIMITER ||
CREATE PROCEDURE delete_population (
				 IN 				po_id_ int, 
									po_source_ varchar(100), 
                                    po_annee_ int, 
                                    po_nbre_pop_ int,
									po_csp_id_fk_ int,
									po_ag_id_fk_ int,
									po_vi_id_fk_ int)

BEGIN
# -- Vérifier que le film que l'on souhaite mettre à jour existe bien
IF NOT EXISTS ( SELECT * FROM categorie_socio_pro WHERE categorie_socio_pro.csp_id = po_csp_id_fk_) THEN
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'categorie_socio_pro not found'; 
END IF;

IF NOT EXISTS ( SELECT * FROM age WHERE age.ag_id = po_ag_id_fk_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'age_not_found';
END IF;

IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = po_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'ville_not_found';
END IF;

# Insertion
INSERT INTO population (po_id,po_source,po_annee,po_nbre_pop,po_csp_id_fk,po_ag_id_fk,po_vi_id_fk)
VALUES (po_id_,po_source_,po_annee_,po_nbre_pop_,po_csp_id_fk_,po_ag_id_fk_,po_vi_id_fk_);

END ||
DELIMITER ;

# On insère une ligne de test en utilisant la procédure stockée
CALL create_population ('123459', 'test_insert', 2017 , 12, 3, 3, 3); 
