USE CLIIINK2;

-- ----------------------------
-- CRUD CREATE entreprise
-- ----------------------------

# Procédure stockée de type INSERT sur la table entreprise

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

# vérifier que le l'ID de l'entreprise que l'on souhaite insérer n'est pas déjà pris
IF EXISTS (SELECT * FROM entreprise WHERE entreprise.en_id = en_id_) THEN
	SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'en_id already existing';
END IF;

# vérifier l'existence des valeurs des paramètres destinés à des clés étrangères
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

-- ----------------------------
-- TEST UNITAIRE 
-- ----------------------------

# Debut du test
START TRANSACTION;
# il y a 2 clés étrangères pointant vers la table entreprise : en_sa_id_fk et en_vi_id_fk

# On insert un clé primaire dans la table ville
INSERT INTO ville (vi_nom)
VALUES ('Cannes-La-Bocca');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @vi_id = (SELECT vi_id FROM ville WHERE vi_nom = 'Cannes-La-Bocca');

# On insert un clé primaire dans la table secteur_activite
INSERT INTO secteur_activite (sa_nom)
VALUES ('developpeurs');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @sa_id = (SELECT sa_id FROM secteur_activite WHERE sa_nom = 'developpeurs');

# on choisit la 1ere valeur dispo pour en_id
SET @en_id = (SELECT max(en_id) FROM entreprise) +1;

# on s'assure que le l'ID de l'entreprise que l'on souhaite insérer n'est pas déjà pris
SET @en_id_test = (SELECT en_id FROM entreprise WHERE en_id = @en_id );
SELECT * FROM entreprise WHERE en_id = @en_id_test; # On souhaite voir 0 lignes retournées

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_entreprise (@en_id , 'Chez_Sophie', 77846, 14, '10 chemin du capitaine', '06400', @vi_id, @sa_id);

# on s'assure que la ligne de test inserée existe bien
SELECT * FROM entreprise WHERE en_id = @en_id;

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD READ entreprise
-- ----------------------------
-- GET
-- ----------------------------

# Procédure stockée de type READ sur la table entreprise

DROP PROCEDURE IF EXISTS `readGet_entreprise`;

DELIMITER ||
CREATE PROCEDURE `readGet_entreprise` (
				 IN 				   en_id_ bigint)
BEGIN

# Selection
SELECT en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk
	FROM entreprise
    WHERE entreprise.en_id = en_id_;
 
END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il y a 2 clés étrangères pointant vers la table entreprise : en_sa_id_fk et en_vi_id_fk

# On insert une clé primaire dans la table ville
INSERT INTO ville (vi_nom)
VALUES ('Guinguamp');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @vi_id = (SELECT vi_id FROM ville WHERE vi_nom = 'Guinguamp');

# On insert une clé primaire dans la table secteur_activite
INSERT INTO secteur_activite (sa_nom)
VALUES ('developpeur');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @sa_id = (SELECT sa_id FROM secteur_activite WHERE sa_nom = 'developpeur');

# on choisit la 1ere valeur dispo pour en_id
SET @en_id = (SELECT max(en_id) FROM entreprise) +1;

# on insère une premiere entreprise au cas où la table serait vide
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (@en_id , 'Chez_Sophie', 77846, 14, '10 chemin du capitaine', '06400', @vi_id, @sa_id);

# on récupère l'id max de toutes les entreprises dans la table, en l'occurrence celui qui a été inséré
SET @en_id = (SELECT max(en_id) FROM entreprise);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_entreprise(@en_id); # renvoie les infos de l'entreprise dont l'ID est spécifié

# on choisit la 1ere valeur dispo pour en_id
SET @en_id = (SELECT max(en_id) FROM entreprise) +1;

# on insère la ligne que l'on souhaite afficher
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (@en_id , 'en_test', 11111, 11, '10 chemin du capitaine', '06400', @vi_id, @sa_id);

# on récupère l'id max de tous les entreprises dans la table, en l'occurrence celui qui a été inséré en 2e
SET @en_id = (SELECT max(en_id) FROM entreprise);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_entreprise(@en_id); # renvoie les infos de l'entreprise dont l'ID est spécifié

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD READ entreprise
-- ----------------------------
-- FIND
-- ----------------------------

# Procédure stockée de type READ sur la table entreprise

DROP PROCEDURE IF EXISTS `readFind_entreprise`;

DELIMITER ||
CREATE PROCEDURE `readFind_entreprise` ()

BEGIN

# Selection
SELECT en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk
	FROM entreprise;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il y a 2 clés étrangères pointant vers la table entreprise : en_sa_id_fk et en_vi_id_fk

# On insert une clé primaire dans la table ville
INSERT INTO ville (vi_nom)
VALUES ('Guinguamp');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @vi_id = (SELECT vi_id FROM ville WHERE vi_nom = 'Guinguamp');

# On insert une clé primaire dans la table secteur_activite
INSERT INTO secteur_activite (sa_nom)
VALUES ('developpeur');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @sa_id = (SELECT sa_id FROM secteur_activite WHERE sa_nom = 'developpeur');

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_entreprise(); # on affiche la totalité des lignes de la table, peut renvoyer 0 lignes

SELECT count(*) FROM entreprise; # on souhaite compter le nombre de lignes avant (surtout s'il y en a beaucoup)

# on insère 2 films pour être sûrs que la procédure puisse renvoyer plus d'une ligne
# on choisit la 1ere valeur dispo pour en_id
SET @en_id = (SELECT max(en_id) FROM entreprise) +1;
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (@en_id , 'en_test1', 11111, 11, '10 chemin du capitaine', '06400', @vi_id, @sa_id);
# on choisit la 2eme valeur dispo pour en_id
SET @en_id2 = (SELECT max(en_id) FROM entreprise) +1;
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (@en_id2 , 'en_test2', 22222, 22, '20 chemin du matelot', '06400', @vi_id, @sa_id);

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_entreprise(); # on affiche la totalité des lignes de la table, doit renvoyer au moins 2 lignes

SELECT count(*) FROM entreprise; # on souhaite compter le nombre de lignes après (surtout s'il y en a beaucoup)

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD UPDATE entreprise
-- ----------------------------

# Procédure stockée de type UPDATE sur la table entreprise

DROP PROCEDURE IF EXISTS `update_entreprise`;

DELIMITER ||
CREATE PROCEDURE update_entreprise (
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
		SIGNAL SQLSTATE '50002' SET MESSAGE_TEXT = 'secteur_activite not found not found';
END IF;

IF NOT EXISTS ( SELECT * FROM ville WHERE ville.vi_id = en_vi_id_fk_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'ville_not_found';
END IF;

# Mise à jour
UPDATE entreprise
SET en_id = en_id_, en_nom = en_nom_, en_siren = en_siren_,
en_nic = en_nic_, en_adresse = en_adresse_, en_code_postal = en_code_postal_,
en_vi_id_fk = en_vi_id_fk_, en_sa_id_fk = en_sa_id_fk_
WHERE en_id = en_id_ ;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il y a 2 clés étrangères pointant vers la table entreprise : en_sa_id_fk et en_vi_id_fk

# On insert une clé primaire dans la table ville
INSERT INTO ville (vi_nom)
VALUES ('Guinguamp');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @vi_id = (SELECT vi_id FROM ville WHERE vi_nom = 'Guinguamp');

# On insert une clé primaire dans la table secteur_activite
INSERT INTO secteur_activite (sa_nom)
VALUES ('developpeur');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @sa_id = (SELECT sa_id FROM secteur_activite WHERE sa_nom = 'developpeur');

# on choisit la 1ere valeur dispo pour en_id
SET @en_id = (SELECT max(en_id) FROM entreprise) +1;

# on insère une ligne témoin
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (@en_id , 'Chez_Sophie', 77846, 14, '10 chemin du capitaine', '06400', @vi_id, @sa_id);

# on récupère l'id max de toutes les entreprises dans la table, en l'occurrence celui qui a été inséré
SET @en_id = (SELECT max(en_id) FROM entreprise);

SELECT * FROM entreprise WHERE en_id = @en_id; # on affiche la ligne avant modification

# appel à la procédure d'update avec de nouvelles valeurs
CALL update_entreprise (@en_id , 'Chez_Sophia', 66646, 14, '10 chemin du matelot', '06400', @vi_id, @sa_id);

SELECT * FROM entreprise WHERE en_id = @en_id; # on affiche la ligne après modification

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD DELETE entreprise
-- ----------------------------

# Procédure stockée de type DELETE sur la table entreprise

DROP PROCEDURE IF EXISTS `delete_entreprise`;

DELIMITER ||
CREATE PROCEDURE `delete_entreprise` (
				IN 					  en_id_ bigint)

BEGIN

# suppression
DELETE
FROM entreprise
WHERE entreprise.en_id = en_id_;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il y a 2 clés étrangères pointant vers la table entreprise : en_sa_id_fk et en_vi_id_fk

# On insert une clé primaire dans la table ville
INSERT INTO ville (vi_nom)
VALUES ('Guinguamp');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @vi_id = (SELECT vi_id FROM ville WHERE vi_nom = 'Guinguamp');

# On insert une clé primaire dans la table secteur_activite
INSERT INTO secteur_activite (sa_nom)
VALUES ('developpeur');
# on récupère la clé primaire correspondante à la ligne que l'on vient d'insérer
SET @sa_id = (SELECT sa_id FROM secteur_activite WHERE sa_nom = 'developpeur');

# on choisit la 1ere valeur dispo pour en_id
SET @en_id = (SELECT max(en_id) FROM entreprise) +1;

# on insère une ligne témoin
INSERT INTO entreprise (en_id,en_nom,en_siren,en_nic,en_adresse,en_code_postal,en_vi_id_fk,en_sa_id_fk)
VALUES (@en_id , 'Chez_Sophie', 77846, 14, '10 chemin du capitaine', '06400', @vi_id, @sa_id);

# on récupère l'id max de toutes les entreprises dans la table, en l'occurrence celui qui a été inséré
SET @en_id = (SELECT max(en_id) FROM entreprise);

SELECT * FROM entreprise WHERE en_id = @en_id; # on affiche la ligne inséré

CALL delete_entreprise (@en_id); # on supprime la ligne

SELECT * FROM entreprise WHERE en_id = @en_id; # on essaye d'afficher la ligne et on doit constater la suppression

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD CREATE age
-- ----------------------------

# Procédure stockée de type INSERT sur la table age

DROP PROCEDURE IF EXISTS `insert_age`;

DELIMITER ||
CREATE PROCEDURE insert_age (
				IN 			 ag_tranche_age_ varchar(50))
BEGIN

# vérifier que l'ag_tranche_age de l'age que l'on souhaite insérer n'est pas déjà pris
IF EXISTS (SELECT * FROM age WHERE age.ag_tranche_age = ag_tranche_age_) THEN
	SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'ag_tranche_age already existing';
END IF;

# Insertion
INSERT INTO age (ag_tranche_age)
VALUES (ag_tranche_age_);

END ||
DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE 
-- ----------------------------

# Debut du test
START TRANSACTION;

# on s'assure que le la valeur de age que l'on souhaite insérer n'est pas déjà pris
SET @ag_tranche_age = (SELECT ag_tranche_age FROM age WHERE ag_tranche_age = "99 à 101" );
SELECT * FROM age WHERE ag_tranche_age = @ag_tranche_age; # On souhaite voir 0 lignes retournées

# on choisit la 1ere valeur dispo pour ag_tranche_age
SET @ag_tranche_age = "99 à 101";

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_age (@ag_tranche_age);

# on s'assure que la ligne de test inserée existe bien
SELECT * FROM age WHERE ag_tranche_age = @ag_tranche_age;

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD READ age
-- ----------------------------
-- GET
-- ----------------------------

# Procédure stockée de type READ sur la table age

DROP PROCEDURE IF EXISTS `readGet_age`;

DELIMITER ||
CREATE PROCEDURE `readGet_age` (
				 IN 			ag_id_ int)
BEGIN

# Selection
SELECT ag_id,ag_tranche_age
	FROM age
    WHERE age.ag_id = ag_id_;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table age

# on choisit la 1ere valeur dispo pour ag_id
SET @ag_id = (SELECT max(ag_id) FROM age) +1;

# on insère une premiere tranche d'age au cas où la table serait vide
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (@ag_id , 'de 89 à 101');

# on récupère l'id max de toutes les tranches d'ages dans la table, en l'occurrence celui qui a été insérée
SET @ag_id = (SELECT max(ag_id) FROM age);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_age(@ag_id); # renvoie les infos de l'entreprise dont l'ID est spécifié

# on choisit la 1ere valeur dispo pour en_id
SET @ag_id = (SELECT max(ag_id) FROM age) +1;

# on insère la ligne que l'on souhaite afficher
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (@ag_id , 'de 102à 105');

# on récupère l'id max de toutes les tranches d'ages dans la table, en l'occurrence celui qui a été inséré en 2e
SET @ag_id = (SELECT max(ag_id) FROM age);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_age(@ag_id); # renvoie les infos de la tranches d'ages dont l'ID est spécifié

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- FIND
-- ----------------------------

# Procédure stockée de type READ sur la age

DROP PROCEDURE IF EXISTS `readFind_age`;

DELIMITER ||
CREATE PROCEDURE `readFind_age` ()

BEGIN

# Selection
SELECT ag_id,ag_tranche_age
	FROM age;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table age

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_age(); # on affiche la totalité des lignes de la table, peut renvoyer 0 lignes

SELECT count(*) FROM age; # on souhaite compter le nombre de lignes avant (surtout s'il y en a beaucoup)

# on insère 2 tranches d'ages pour être sûrs que la procédure puisse renvoyer plus d'une ligne
# on choisit la 1ere valeur dispo pour ag_id
SET @ag_id = (SELECT max(ag_id) FROM age) +1;
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (@ag_id , 'ag_test1');
# on choisit la 2eme valeur dispo pour ag_id
SET @ag_id2 = (SELECT max(ag_id) FROM age) +1;
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (@ag_id2 , 'ag_test2');

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_age(); # on affiche la totalité des lignes de la table, doit renvoyer au moins 2 lignes

SELECT count(*) FROM age; # on souhaite compter le nombre de lignes après (surtout s'il y en a beaucoup)

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD UPDATE age
-- ----------------------------

# Procédure stockée de type UPDATE sur table la age

DROP PROCEDURE IF EXISTS `update_age`;

DELIMITER ||
CREATE PROCEDURE update_age (
				 IN 				ag_id_ int,
									ag_tranche_age_ varchar(50))

BEGIN

# Mise à jour
UPDATE age
SET ag_id = ag_id_, ag_tranche_age = ag_tranche_age_
WHERE ag_id = ag_id_ ;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table age

# on choisit la 1ere valeur dispo pour ag_id
SET @ag_id = (SELECT max(ag_id) FROM age) +1;

# on insère une ligne témoin
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (@ag_id , 'de 89 à 101');

# on récupère l'id max de toutes les tranches d'ages dans la table, en l'occurrence celui qui a été insérée
SET @ag_id = (SELECT max(ag_id) FROM age);

SELECT * FROM age WHERE ag_id = @ag_id; # on affiche la ligne avant modification

# appel à la procédure d'update avec de nouvelles valeurs
CALL update_age (@ag_id , 'de 90 à 99');

SELECT * FROM age WHERE ag_id = @ag_id; # on affiche la ligne après modification

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD DELETE age
-- ----------------------------

# Procédure stockée de type DELETE sur la table age

DROP PROCEDURE IF EXISTS `delete_age`;

DELIMITER ||
CREATE PROCEDURE `delete_age` (
				IN 			   ag_id_ int)

BEGIN

# verification des clés étrangères pointant sur ag_id
IF EXISTS ( SELECT * FROM population WHERE po_ag_id_fk = ag_id_) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'age.ag_id still present in population: delete all entries or allow
delete on cascade and remove this check';
END IF;

# suppression
DELETE
FROM age
WHERE ag_id = ag_id_;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table age

# on choisit la 1ere valeur dispo pour ag_id
SET @ag_id = (SELECT max(ag_id) FROM age) +1;

# on insère une ligne témoin
INSERT INTO age (ag_id,ag_tranche_age)
VALUES (@ag_id , 'de 89 à 101');

# on récupère l'id max de toutes les tranches d'ages dans la table, en l'occurrence celui qui a été insérée
SET @ag_id = (SELECT max(ag_id) FROM age);

SELECT * FROM age WHERE ag_id = @ag_id; # on affiche la ligne inséré

CALL delete_age (@ag_id); # on supprime la ligne

SELECT * FROM age WHERE ag_id = @ag_id; # on essaye d'afficher la ligne et on doit constater la suppression

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD CREATE categorie_socio_pro
-- ----------------------------

# Procédure stockée de type INSERT sur la table categorie_socio_pro

DROP PROCEDURE IF EXISTS `insert_categorie_socio_pro`;

DELIMITER ||
CREATE PROCEDURE insert_categorie_socio_pro (
				 IN 						 csp_nom_ varchar(50))

BEGIN

# vérifier que le csp_nom de la categorie_socio_pro que l'on souhaite insérer n'est pas déjà pris
IF EXISTS (SELECT * FROM categorie_socio_pro WHERE categorie_socio_pro.csp_nom = csp_nom_) THEN
	SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'csp_nom already existing';
END IF;

# Insertion
INSERT INTO categorie_socio_pro (csp_nom)
VALUES (csp_nom_);

END ||
DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE 
-- ----------------------------

# Debut du test
START TRANSACTION;

# on s'assure que le la valeur de categorie_socio_pro que l'on souhaite insérer n'est pas déjà pris
SET @csp_nom = (SELECT csp_nom FROM categorie_socio_pro WHERE csp_nom = 'chomeur' );
SELECT * FROM categorie_socio_pro WHERE csp_nom = @csp_nom; # On souhaite voir 0 lignes retournées

# on choisit la 1ere valeur dispo pour csp_nom
SET @csp_nom = 'chomeur';

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_categorie_socio_pro (@csp_nom);

# on s'assure que la ligne de test inserée existe bien
SELECT * FROM categorie_socio_pro WHERE csp_nom = @csp_nom;

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD READ categorie_socio_pro
-- ----------------------------
-- GET
-- ----------------------------

# Procédure stockée de type READ sur la table categorie_socio_pro

DROP PROCEDURE IF EXISTS `readGet_categorie_socio_pro`;

DELIMITER ||
CREATE PROCEDURE `readGet_categorie_socio_pro` (
				 IN 							csp_id_ int)
BEGIN

# Selection
SELECT csp_id,csp_nom
	FROM categorie_socio_pro
    WHERE categorie_socio_pro.csp_id = csp_id_;
 
END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table categorie_socio_pro

# on choisit la 1ere valeur dispo pour csp_id
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro) +1;

# on insère une premiere categorie socio pro au cas où la table serait vide
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (@csp_id , 'categorie test 1');

# on récupère l'id max de toutes les categories socio pro dans la table, en l'occurrence celui qui a été insérée
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_categorie_socio_pro(@csp_id); # renvoie les infos de la categorie socio pro dont l'ID est spécifié

# on choisit la 1ere valeur dispo pour csp_id
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro) +1;

# on insère la ligne que l'on souhaite afficher
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (@csp_id , 'categorie test 2');

# on récupère l'id max de toutes les categories socio pro dans la table, en l'occurrence celui qui a été inséré en 2e
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_categorie_socio_pro(@csp_id); # renvoie les infos de la categorie socio pro dont l'ID est spécifié

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- FIND
-- ----------------------------

# Procédure stockée de type READ sur la table categorie_socio_pro

DROP PROCEDURE IF EXISTS `readFind_categorie_socio_pro`;

DELIMITER ||
CREATE PROCEDURE `readFind_categorie_socio_pro` ()

BEGIN

# Selection
SELECT csp_id,csp_nom
	FROM categorie_socio_pro;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table categorie_socio_pro

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_categorie_socio_pro(); # on affiche la totalité des lignes de la table, peut renvoyer 0 lignes

SELECT count(*) FROM categorie_socio_pro; # on souhaite compter le nombre de lignes avant (surtout s'il y en a beaucoup)

# on insère 2 categorie socio pro pour être sûrs que la procédure puisse renvoyer plus d'une ligne
# on choisit la 1ere valeur dispo pour csp_id
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro) +1;
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (@csp_id , 'categorie test 1');
# on choisit la 2eme valeur dispo pour csp_id
SET @csp_id2 = (SELECT max(csp_id) FROM categorie_socio_pro) +1;
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (@csp_id2 , 'categorie test 2');

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_categorie_socio_pro(); # on affiche la totalité des lignes de la table, doit renvoyer au moins 2 lignes

SELECT count(*) FROM categorie_socio_pro; # on souhaite compter le nombre de lignes après (surtout s'il y en a beaucoup)

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD UPDATE categorie_socio_pro
-- ----------------------------

# Procédure stockée de type UPDATE sur table la age

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

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table categorie_socio_pro

# on choisit la 1ere valeur dispo pour csp_id
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro) +1;

# on insère une ligne témoin
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (@csp_id , 'categorie test 1');

# on récupère l'id max de toutes les categories socio pro dans la table, en l'occurrence celui qui a été insérée
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro);

SELECT * FROM categorie_socio_pro WHERE csp_id = @csp_id; # on affiche la ligne avant modification

# appel à la procédure d'update avec de nouvelles valeurs
CALL update_categorie_socio_pro (@csp_id , 'categorie test 2');

SELECT * FROM categorie_socio_pro WHERE csp_id = @csp_id; # on affiche la ligne après modification

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD DELETE categorie_socio_pro
-- ----------------------------

# Procédure stockée de type DELETE sur la categorie_socio_pro
# Obtenir la liste ds colonnes

DROP PROCEDURE IF EXISTS `delete_categorie_socio_pro`;

DELIMITER ||
CREATE PROCEDURE `delete_categorie_socio_pro` (
				IN 			   				   csp_id_ int)

BEGIN

# verification des clés étrangères pointant sur csp_id
IF EXISTS ( SELECT * FROM population WHERE csp_id_ = po_csp_id_fk) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'categorie_socio_pro.csp_id still present in population:
delete all entries or allow delete on cascade and remove this check';
END IF;

# suppression
DELETE
FROM categorie_socio_pro
WHERE csp_id = csp_id_;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table categorie_socio_pro

# on choisit la 1ere valeur dispo pour csp_id
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro) +1;

# on insère une ligne témoin
INSERT INTO categorie_socio_pro (csp_id,csp_nom)
VALUES (@csp_id , 'categorie test 1');

# on récupère l'id max de toutes les categories socio pro dans la table, en l'occurrence celui qui a été insérée
SET @csp_id = (SELECT max(csp_id) FROM categorie_socio_pro);

SELECT * FROM categorie_socio_pro WHERE csp_id = @csp_id; # on affiche la ligne inséré

CALL delete_categorie_socio_pro (@csp_id); # on supprime la ligne

SELECT * FROM categorie_socio_pro WHERE csp_id = @csp_id; # on essaye d'afficher la ligne et on doit constater la suppression

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD CREATE secteur_activite
-- ----------------------------

# Procédure stockée de type INSERT sur la table secteur_activite

DROP PROCEDURE IF EXISTS `insert_secteur_activite`;

DELIMITER ||
CREATE PROCEDURE insert_secteur_activite (
				IN		  				  sa_nom_ varchar(150))

BEGIN

# vérifier que le sa_nom du secteur_activite que l'on souhaite insérer n'est pas déjà pris
IF EXISTS (SELECT * FROM secteur_activite WHERE secteur_activite.sa_nom = sa_nom_) THEN
	SIGNAL SQLSTATE '50004' SET MESSAGE_TEXT = 'csp_nom already existing';
END IF;

# Insertion
INSERT INTO secteur_activite (sa_nom)
VALUES (sa_nom_);

END ||
DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;

# on s'assure que le la valeur de secteur_activite que l'on souhaite insérer n'est pas déjà pris
SET @sa_nom = (SELECT sa_nom FROM secteur_activite WHERE sa_nom = 'Devellopement' );
SELECT * FROM secteur_activite WHERE sa_nom = @sa_nom; # On souhaite voir 0 lignes retournées

# on choisit la 1ere valeur dispo pour csp_nom
SET @sa_nom = 'Devellopement';

# On insère une ligne de test en utilisant la procédure stockée
CALL insert_secteur_activite (@sa_nom);

# on s'assure que la ligne de test inserée existe bien
SELECT * FROM secteur_activite WHERE sa_nom = @sa_nom;

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD READ secteur_activite
-- ----------------------------
-- GET
-- ----------------------------

# Procédure stockée de type READ sur la table secteur_activite

DROP PROCEDURE IF EXISTS `readGet_secteur_activite`;

DELIMITER ||
CREATE PROCEDURE `readGet_secteur_activite` (
				 IN 						 sa_id_ int)
BEGIN

# Selection
SELECT sa_id,sa_nom
	FROM secteur_activite
    WHERE secteur_activite.sa_id = sa_id_;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table secteur_activite

# on choisit la 1ere valeur dispo pour sa_id
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite) +1;

# on insère un premier secteur d'activité au cas où la table serait vide
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (@sa_id , 'secteur test 1');

# on récupère l'id max de tout les secteur d'activité dans la table, en l'occurrence celui qui a été insérée
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_secteur_activite(@sa_id); # renvoie les infos du secteur d'activité dont l'ID est spécifié

# on choisit la 1ere valeur dispo pour sa_id
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite) +1;

# on insère la ligne que l'on souhaite afficher
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (@sa_id , 'secteur test 2');

# on récupère l'id max de tout les secteurs d'activité dans la table, en l'occurrence celui qui a été inséré en 2e
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite);

# On insère une ligne de test en utilisant la procédure stockée
CALL readGet_secteur_activite(@sa_id); # renvoie les infos du secteur d'activité dont l'ID est spécifié

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- FIND
-- ----------------------------

# Procédure stockée de type READ sur la table secteur_activite

DROP PROCEDURE IF EXISTS `readFind_secteur_activite`;

DELIMITER ||
CREATE PROCEDURE `readFind_secteur_activite` ()

BEGIN

# Selection
SELECT sa_id,sa_nom
	FROM secteur_activite;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table secteur_activite

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_secteur_activite(); # on affiche la totalité des lignes de la table, peut renvoyer 0 lignes

SELECT count(*) FROM secteur_activite; # on souhaite compter le nombre de lignes avant (surtout s'il y en a beaucoup)

# on insère 2 secteurs d'activité pour être sûrs que la procédure puisse renvoyer plus d'une ligne
# on choisit la 1ere valeur dispo pour sa_id
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite) +1;
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (@sa_id , 'secteur test 1');
# on choisit la 2eme valeur dispo pour sa_id
SET @sa_id2 = (SELECT max(sa_id) FROM secteur_activite) +1;
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (@sa_id2 , 'secteur test 2');

# On insère une ligne de test en utilisant la procédure stockée
CALL readFind_secteur_activite(); # on affiche la totalité des lignes de la table, doit renvoyer au moins 2 lignes

SELECT count(*) FROM secteur_activite; # on souhaite compter le nombre de lignes après (surtout s'il y en a beaucoup)

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD UPDATE secteur_activite
-- ----------------------------

# Procédure stockée de type UPDATE sur table la secteur_activite

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

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table secteur_activite

# on choisit la 1ere valeur dispo pour sa_id
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite) +1;

# on insère une ligne témoin
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (@sa_id , 'secteur test 1');

# on récupère l'id max de tout les secteur d'activité dans la table, en l'occurrence celui qui a été insérée
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite);

SELECT * FROM secteur_activite WHERE sa_id = @sa_id; # on affiche la ligne avant modification

# appel à la procédure d'update avec de nouvelles valeurs
CALL update_secteur_activite (@sa_id , 'secteur test 2');

SELECT * FROM secteur_activite WHERE sa_id = @sa_id; # on affiche la ligne après modification

ROLLBACK; #-- on annule toutes les actions précédentes

-- ----------------------------
-- CRUD DELETE secteur_activite
-- ----------------------------

# Procédure stockée de type DELETE sur la secteur_activite

DROP PROCEDURE IF EXISTS `delete_secteur_activite`;

DELIMITER ||
CREATE PROCEDURE `delete_secteur_activite` (
				IN 			   				sa_id_ int)

BEGIN

# verification des clés étrangères pointant sur sa_id
IF  EXISTS ( SELECT * FROM entreprise WHERE sa_id_ = en_sa_id_fk) THEN
		SIGNAL SQLSTATE '50003' SET MESSAGE_TEXT = 'secteur_activite.sa_id still present in entreprise:
delete all entries or allow delete on cascade and remove this check';
END IF;

# suppression
DELETE
FROM secteur_activite
WHERE sa_id = sa_id_;

END ||

DELIMITER ;

-- ----------------------------
-- TEST UNITAIRE
-- ----------------------------

# Debut du test
START TRANSACTION;
# il n'y a pas de clés étrangères pointant vers la table secteur_activite

# on choisit la 1ere valeur dispo pour sa_id
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite) +1;

# on insère une ligne témoin
INSERT INTO secteur_activite (sa_id,sa_nom)
VALUES (@sa_id , 'secteur test 1');

# on récupère l'id max de tout les secteur d'activité dans la table, en l'occurrence celui qui a été insérée
SET @sa_id = (SELECT max(sa_id) FROM secteur_activite);

SELECT * FROM secteur_activite WHERE sa_id = @sa_id; # on affiche la ligne inséré

CALL delete_secteur_activite (@sa_id); # on supprime la ligne

SELECT * FROM secteur_activite WHERE sa_id = @sa_id; # on essaye d'afficher la ligne et on doit constater la suppression

ROLLBACK; #-- on annule toutes les actions précédentes