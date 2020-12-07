USE CLIIINK2;

-- ----------------------------
-- CRUD FK population
-- ----------------------------

DROP PROCEDURE IF EXISTS check_fk_population;
DELIMITER ||
CREATE PROCEDURE check_fk_population (
				 IN				 csp_id_ INT(11), 
								 IN ag_id INT(11), 
								 IN vi_id INT(11))

BEGIN 
	# vérifier que l'intégrité référentielle de la table population avec ces tables périphériques
    # Tests unitaires pour définir la référence des fk dans l'ordre parent-enfant

SELECT population.*
FROM categorie_socio_pro
RIGHT JOIN population ON categorie_socio_pro.csp_id = population.po_csp_id_fk
WHERE categorie_socio_pro.csp_id IS NULL

UNION

SELECT population.*
FROM age
RIGHT JOIN population ON age.ag_id = population.po_ag_id_fk
WHERE age.ag_id IS NULL

UNION

SELECT population.*
FROM ville
RIGHT JOIN population ON ville.vi_id = population.po_vi_id_fk
WHERE ville.vi_id IS NULL;

END ||
DELIMITER ;

# Tests unitaires pour la table population
# Désactivation temporaire des contraintes référentielles
# Recréer trois lignes dans la table population en insérant des test pour chacune des colonnes de la table
# Charger les données dans les colonnes foreign key dans l'ordre parent-enfant
SET FOREIGN_KEY_CHECKS=0;

# Les clés étrangères sont vérifiées
# On rétablit les droits d'accès
SET FOREIGN_KEY_CHECKS=1;


-- ----------------------------
-- CRUD FK entreprise
-- ----------------------------

DROP PROCEDURE IF EXISTS check_fk_entreprise;
DELIMITER ||
CREATE PROCEDURE check_fk_entreprise (
				 IN				 vi_id_ INT(11), 
								 IN sa_id INT(11))
                                 
BEGIN 
	# vérifier que l'intégrité référentielle de la table population avec ces tables périphériques
    # Tests unitaires pour définir la référence des fk dans l'ordre parent-enfant

SELECT entreprise.*
FROM ville
RIGHT JOIN entreprise ON ville.vi_id = entreprise.en_vi_id_fk
WHERE ville.vi_id IS NULL

UNION

SELECT entreprise.*
FROM secteur_activite
RIGHT JOIN entreprise ON secteur_activite.sa_id = entreprise.en_sa_id_fk
WHERE secteur_activite.sa_id IS NULL;

END ||
DELIMITER ;

# Tests unitaires pour la table entreprise
# Désactivation temporaire des contraintes référentielles
# Recréer trois lignes dans la table entreprise en insérant des test pour chacune des colonnes de la table
# Charger les données dans les colonnes foreign key dans l'ordre parent-enfant
SET FOREIGN_KEY_CHECKS=0;

# Les clés étrangères sont vérifiées
# On rétablit les droits d'accès
SET FOREIGN_KEY_CHECKS=1;


-- ----------------------------
-- CRUD FK logement
-- ----------------------------

DROP PROCEDURE IF EXISTS check_fk_logement;
DELIMITER ||
CREATE PROCEDURE check_fk_logement (
				 IN				 vi_id_ INT(11), 
								 IN cl_id INT(11))
                                 
BEGIN 
	# vérifier que l'intégrité référentielle de la table logement avec ces tables périphériques
    # Tests unitaires pour définir la référence des fk dans l'ordre parent-enfant

SELECT logement.*
FROM ville
RIGHT JOIN logement ON ville.vi_id = logement.lo_vi_id_fk
WHERE ville.vi_id IS NULL

UNION

SELECT logement.*
FROM categorie_logement
RIGHT JOIN logement ON categorie_logement.cl_id = logement.lo_cl_id_fk
WHERE categorie_logement.cl_id IS NULL;

END ||
DELIMITER ;

# Tests unitaires pour la table entreprise
# Désactivation temporaire des contraintes référentielles
# Recréer trois lignes dans la table entreprise en insérant des test pour chacune des colonnes de la table
# Charger les données dans les colonnes foreign key dans l'ordre parent-enfant
SET FOREIGN_KEY_CHECKS=0;

# Les clés étrangères sont vérifiées
# On rétablit les droits d'accès
SET FOREIGN_KEY_CHECKS=1;

