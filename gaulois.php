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
ORDER BY lieu.nom_lieu, specialite.nom_specialite';
$persoStatement = $mysqlClient->prepare($sqlQuery);
$persoStatement -> execute();
$personnages = $persoStatement->fetchAll();

echo "<table>
        <tr>
            <th>Nom</th>
            <th>Lieu d'habitation</th>
			<th>Specialité<th>
        </tr>";

foreach ($personnages as $personnage) {
    echo "<tr>
    		<td><a href='personnage.php?id=".$personnage['id_personnage']."'>".$personnage['nom_personnage']."</a></td>
    		<td>".$personnage['nom_lieu']."</td>
			<td>".$personnage['nom_specialite']."</td>
		</tr>";
}

echo "</table>"
?>
