<?php

try
{
    $mysqlClient = new PDO('mysql:host=localhost;dbname=gaulois;charset=utf8', 'root', '');
}
catch (Exception $e)
{
    die('Erreur : ' . $e->getMessage());
}

$sqlQuery = 'SELECT nom_personnage, lieu.nom_lieu, specialite.nom_specialite, id_personnage
FROM personnage
JOIN lieu ON personnage.id_lieu = lieu.id_lieu
JOIN specialite ON personnage.id_specialite = specialite.id_specialite
WHERE personnage.id_personnage = :id';

$id = $_GET['id'];
$persoStatement = $mysqlClient->  prepare($sqlQuery);
$persoStatement -> execute(["id" => $id]);
$personnage = $persoStatement->fetch();

echo "Personnage : ".$personnage['nom_personnage']."<br>
    Lieu d'habitation : ".$personnage['nom_lieu']."<br>
     Spécialité : ".$personnage['nom_specialite']."<br>";



$sqlQuery2 = 'SELECT DISTINCT potion.nom_potion, boire.date_boire
FROM potion
JOIN boire ON potion.id_potion = boire.id_potion
JOIN personnage ON boire.id_personnage = personnage.id_personnage
WHERE personnage.id_personnage = :id';


$potionStatement = $mysqlClient ->prepare($sqlQuery2);
$potionStatement -> execute(["id" => $id]);
$potions = $potionStatement->fetchAll();

echo "<table>
        <tr>
            <th>Potions bues</th>
            <th>Date</th>
        </tr>";
        
foreach ($potions as $potion) {
    echo "<tr>
            <td>".$potion['nom_potion']."</td>
            <td>".$potion['date_boire']."</td>
        </tr>";
}


echo "</table>"

?>
