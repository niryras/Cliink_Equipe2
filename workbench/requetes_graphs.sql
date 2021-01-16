SELECT sum(po_nbre_pop) as population, vi_nom
FROM categorie_socio_pro 
INNER JOIN population ON categorie_socio_pro.csp_id = population.po_csp_id_fk and csp_nom in ('Total')
INNER JOIN ville ON population.po_vi_id_fk = ville.vi_id
INNER JOIN age ON age.ag_id = population.po_ag_id_fk
INNER JOIN collecte ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom;

-------------------------------------------------------------------------------------------------------------------------

SELECT po_nbre_pop as population, vi_nom
FROM categorie_socio_pro 
JOIN population ON categorie_socio_pro.csp_id = population.po_csp_id_fk
JOIN ville ON population.po_vi_id_fk = ville.vi_id
JOIN age ON age.ag_id = population.po_ag_id_fk
INNER JOIN collecte ON ville.vi_id = collecte.co_vi_id_fk
WHERE csp_nom not in ('Total')
GROUP BY vi_nom;

-------------------------------------------------------------------------------------------------------------------------

SELECT demo.population, demo.vi_nom, poubelle.poids
FROM

(SELECT sum(po_nbre_pop) as population, vi_nom
FROM categorie_socio_pro 
JOIN population ON categorie_socio_pro.csp_id = population.po_csp_id_fk
JOIN ville ON population.po_vi_id_fk = ville.vi_id
WHERE csp_nom not in ('Total')
GROUP BY vi_nom) as demo

INNER JOIN 

(SELECT vi_nom, sum(poids) as poids
FROM collecte
INNER JOIN ville ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom) as poubelle

ON demo.vi_nom = poubelle.vi_nom;

-------------------------------------------------------------------------------------------------------------------------

SELECT categorie_lo.logement, categorie_lo.vi_nom, categorie_lo.cl_nom, poubelle.poids
FROM

(SELECT sum(lo_nbre) as logement, cl_nom, vi_nom
FROM logement
INNER JOIN ville ON ville.vi_id = logement.lo_vi_id_fk
INNER JOIN categorie_logement ON categorie_logement.cl_id = logement.lo_cl_id_fk
WHERE cl_nom = 'Résidences principales'
GROUP BY cl_nom, vi_nom) as categorie_lo

INNER JOIN 

(SELECT vi_nom, sum(poids) as poids
FROM collecte
INNER JOIN ville ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom) as poubelle

ON categorie_lo.vi_nom = poubelle.vi_nom;

-------------------------------------------------------------------------------------------------------------------------

SELECT categorie_lo.logement, categorie_lo.vi_nom, categorie_lo.cl_nom, poubelle.poids
FROM

(SELECT sum(lo_nbre) as logement, cl_nom, vi_nom
FROM logement
INNER JOIN ville ON ville.vi_id = logement.lo_vi_id_fk
INNER JOIN categorie_logement ON categorie_logement.cl_id = logement.lo_cl_id_fk
WHERE cl_nom = 'Résid. secondaires et log. occasionnels'
GROUP BY cl_nom, vi_nom) as categorie_lo

INNER JOIN 

(SELECT vi_nom, sum(poids) as poids
FROM collecte
INNER JOIN ville ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom) as poubelle

ON categorie_lo.vi_nom = poubelle.vi_nom;

-------------------------------------------------------------------------------------------------------------------------

#le nombre d'entreprise dans certains secteurs d'activité plus prompts à consommer du verre avec les collectes

SELECT secte.nbre_entreprise, secte.vi_nom, poubelle.poids
FROM

(SELECT count(en_id) as nbre_entreprise, vi_nom
FROM secteur_activite
JOIN entreprise ON sa_id = entreprise.en_sa_id_fk
JOIN ville ON entreprise.en_vi_id_fk = ville.vi_id
GROUP BY vi_nom) as secte

INNER JOIN 

(SELECT vi_nom, sum(poids) as poids
FROM collecte
INNER JOIN ville ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom) as poubelle

ON secte.vi_nom = poubelle.vi_nom;

-------------------------------------------------------------------------------------------------------------------------

#SA Restauration
SELECT secte.nbre_entreprise, secte.vi_nom, poubelle.poids
FROM

(SELECT count(en_id) as nbre_entreprise, vi_nom
FROM secteur_activite
JOIN entreprise ON sa_id = entreprise.en_sa_id_fk
JOIN ville ON entreprise.en_vi_id_fk = ville.vi_id
WHERE sa_nom = 'Hébergement et restauration'
GROUP BY vi_nom) as secte

INNER JOIN 

(SELECT vi_nom, sum(poids) as poids
FROM collecte
INNER JOIN ville ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom) as poubelle

ON secte.vi_nom = poubelle.vi_nom;

-------------------------------------------------------------------------------------------------------------------------

SELECT secte.nbre_entreprise, secte.vi_nom, secte.sa_nom, poubelle.poids
FROM

(SELECT count(en_id) as nbre_entreprise, vi_nom, sa_nom
FROM secteur_activite
JOIN entreprise ON sa_id = entreprise.en_sa_id_fk
JOIN ville ON entreprise.en_vi_id_fk = ville.vi_id
GROUP BY vi_nom, sa_nom) as secte

INNER JOIN 

(SELECT vi_nom, sum(poids) as poids
FROM collecte
INNER JOIN ville ON ville.vi_id = collecte.co_vi_id_fk
GROUP BY vi_nom) as poubelle

ON secte.vi_nom = poubelle.vi_nom;

-------------------------------------------------------------------------------------------------------------------------

#collecte par rapport aux tranches dage et aux csp

SELECT sum(po_nbre_pop) as population, ag_tranche_age, csp_nom
FROM population
INNER JOIN age ON age.ag_id = population.po_ag_id_fk
INNER JOIN categorie_socio_pro ON categorie_socio_pro.csp_id = population.po_csp_id_fk
WHERE csp_nom not in ('Total')
GROUP BY ag_tranche_age, csp_nom;

-------------------------------------------------------------------------------------------------------------------------

SELECT po_nbre_pop, vi_nom, csp_nom FROM categorie_socio_pro JOIN population
ON categorie_socio_pro.csp_id = population.po_csp_id_fk
JOIN ville
ON population.po_vi_id_fk = ville.vi_id
JOIN age 
ON age.ag_id = population.po_ag_id_fk
WHERE csp_nom not in ('Total');

