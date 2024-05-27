-- 1. Nom des lieux qui finissent par 'um'

SELECT *
FROM lieu
WHERE nom_lieu
LIKE '%um'

-- 2. Nombre de personnages par lieu (trié par nombre de personnages décroissant).

SELECT COUNT(nom_personnage) AS nbrePersonnages, lieu.nom_lieu
FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
GROUP BY lieu.id_lieu
ORDER BY nbrePersonnages DESC

-- 3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom 
-- de personnage.

SELECT nom_personnage, id_specialite, adresse_personnage, id_lieu
FROM personnage
ORDER BY id_lieu, nom_personnage

-- 4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de 
-- personnages décroissant).

SELECT nom_specialite, COUNT(personnage.id_personnage) AS nbrePersonnages
FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY personnage.id_specialite
ORDER BY nbrePersonnages DESC

-- 5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées 
-- au format jj/mm/aaaa).

SELECT nom_bataille, DATE_FORMAT(date_bataille, "%d %m %Y") AS dateBataille, lieu.nom_lieu
FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu
ORDER BY date_bataille DESC

-- 6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant).

SELECT potion.nom_potion, SUM(qte * ingredient.cout_ingredient) AS coutDeReal
FROM  composer
INNER JOIN ingredient ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON composer.id_potion = potion.id_potion
GROUP BY potion.nom_potion
ORDER BY coutDeReal DESC

-- 7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'.

SELECT qte, ingredient.nom_ingredient, ingredient.cout_ingredient
FROM composer 
INNER JOIN ingredient  ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON composer.id_potion = potion.id_potion
WHERE potion.id_potion = '3'

-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village 
-- gaulois'.

SELECT personnage.nom_personnage, MAX(qte) AS maxCasques
FROM prendre_casque 
INNER JOIN personnage ON personnage.id_personnage = prendre_casque.id_personnage
INNER JOIN bataille ON bataille.id_bataille = prendre_casque.id_bataille
WHERE bataille.id_bataille = '1' 
AND qte = (	SELECT MAX(qte)
         	FROM prendre_casque
            INNER JOIN bataille ON bataille.id_bataille = prendre_casque.id_bataille
            WHERE bataille.id_bataille = '1' 
         	)
GROUP BY personnage.nom_personnage 

-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur 
-- au plus petit).

SELECT personnage.nom_personnage, dose_boire
FROM boire
INNER JOIN personnage ON personnage.id_personnage = boire.id_personnage
GROUP BY personnage.nom_personnage, boire.dose_boire
ORDER BY boire.dose_boire DESC