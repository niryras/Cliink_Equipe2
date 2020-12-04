-- ----------------------------
-- CRUD READ population
-- ----------------------------
# Procédure stockée de type READ sur la table population

DROP PROCEDURE IF EXISTS `read_population`;

DELIMITER ||
CREATE PROCEDURE `read_population` ()
BEGIN
	SELECT po_id,po_source,po_annee,po_nbre_pop,po_csp_id_fk,po_ag_id_fk,po_vi_id_fk
	FROM population;
END ||
DELIMITER ;


DELIMITER ||
CREATE PROCEDURE `read_entreprise` ()
BEGIN
	SELECT en_id, en_nom, en_siren, en_nic, en_adresse, en_code_postal, en_vi_id_fk, en_sa_id_fk
	FROM entreprise;
END ||
DELIMITER ;


DELIMITER ||
CREATE PROCEDURE `read_logement` ()
BEGIN
	SELECT lo_id, lo_nbre, lo_vi_id_fk, lo_cl_id_fk
	FROM logement;
END ||
DELIMITER ;

# FIND : renvoie la totalité des lignes de la table
DELIMITER ||
CREATE PROCEDURE `select_po` ()
BEGIN
	SELECT po_id,po_source,po_annee,po_nbre_pop,po_csp_id_fk,po_ag_id_fk,po_vi_id_fk
FROM population;
END ||
DELIMITER ;


# On insère une ligne de test en utilisant la procédure stockée
CALL read_population ('123459', 'test_insert', 2020 , 12, 3, 3, 3); 
CALL select_po ('123459', 'test_insert', 2020 , 12, 3, 3, 3); 







