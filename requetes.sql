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

SELECT personnage.nom_personnage, nom_specialite, personnage.adresse_personnage, lieu.nom_lieu
FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
ORDER BY nom_lieu, nom_personnage

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

SELECT personnage.nom_personnage, SUM(qte) AS maxCasques
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

SELECT personnage.id_personnage, SUM(dose_boire) AS qtePotionBue
FROM boire
INNER JOIN personnage ON personnage.id_personnage = boire.id_personnage
GROUP BY personnage.id_personnage
ORDER BY qtePotionBue DESC

-- 10. Nom de la bataille où le nombre de casques pris a été le plus important.

SELECT bataille.nom_bataille
FROM bataille
INNER JOIN prendre_casque 
ON bataille.id_bataille = prendre_casque.id_bataille
GROUP BY bataille.id_bataille
HAVING SUM(prendre_casque.qte) >= ALL (
					SELECT SUM(prendre_casque.qte) AS nombre_casque_pris
					FROM bataille
					INNER JOIN prendre_casque ON bataille.id_bataille = prendre_casque.id_bataille
					GROUP BY prendre_casque.id_bataille);

-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par 
-- nombre décroissant)

SELECT type_casque.nom_type_casque, SUM(casque.cout_casque) AS totalPrix, COUNT(casque.nom_casque) AS qteCasque
FROM casque
INNER JOIN type_casque ON type_casque.id_type_casque = casque.id_type_casque
GROUP BY type_casque.nom_type_casque
ORDER BY qteCasque DESC

-- 12. Nom des potions dont un des ingrédients est le poisson frais.

SELECT potion.nom_potion
FROM composer
INNER JOIN potion ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON ingredient.id_ingredient = composer.id_ingredient
WHERE ingredient.nom_ingredient = 'Poisson frais'

-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois.

SELECT lieu.nom_lieu
FROM lieu
INNER JOIN personnage 
ON lieu.id_lieu = personnage.id_lieu
WHERE lieu.nom_lieu != 'Village gaulois'
GROUP BY personnage.id_lieu
HAVING COUNT(personnage.id_lieu)>= ALL (
				SELECT COUNT(personnage.id_lieu) AS nombre_habitant
				FROM lieu
				INNER JOIN personnage ON lieu.id_lieu = personnage.id_lieu
				WHERE lieu.nom_lieu <> 'Village gaulois'
				GROUP BY personnage.id_lieu);

-- 14. Nom des personnages qui n'ont jamais bu aucune potion.

SELECT nom_personnage
FROM personnage
WHERE id_personnage NOT IN (
    SELECT id_personnage
    FROM boire
    WHERE dose_boire > 0
)

-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.

SELECT nom_personnage
FROM personnage 
WHERE id_personnage NOT IN (
    SELECT id_personnage
    FROM autoriser_boire 
    INNER JOIN potion ON potion.id_potion = autoriser_boire.id_potion
    WHERE potion.nom_potion = 'Magique'
)

-- A. Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus.

INSERT INTO personnage (nom_personnage,adresse_personnage, id_lieu, id_specialite)
VALUES ('Champdeblix','Ferme', '6', '12')

-- B. Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine...

INSERT INTO autoriser_boire (id_potion, id_personnage)
VALUES (1, 12);


-- C. Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille.

DELETE FROM casque
WHERE id_type_casque = (
		SELECT id_type_casque
   	FROM type_casque
   	WHERE nom_type_casque = 'Grec'
				)
AND id_casque NOT IN (
		SELECT prendre_casque.id_casque
		FROM prendre_casque)

-- D. Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate.

UPDATE personnage p
SET id_lieu = (
    SELECT l.id_lieu
    FROM personnage p
    INNER JOIN lieu l ON l.id_lieu = p.id_lieu
    WHERE l.nom_lieu = 'Condate'
)

-- E. La potion 'Soupe' ne doit plus contenir de persil.

DELETE FROM composer
WHERE (id_potion = 9 
AND id_ingredient = 19);

-- F. Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la bataille 'Attaque de la banque postale'. Corrigez son erreur !

UPDATE prendre_casque 
SET id_casque= 10 , qte = 42
WHERE id_bataille = 9;