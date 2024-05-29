<?php
try
{
	$mysqlClient = new PDO('mysql:host=localhost;dbname=gaulois;charset=utf8', 'root', '');
}
catch (Exception $e)
{
    die('Erreur : ' . $e->getMessage());
}

$sqlQuery = 'SELECT nom_personnage, lieu.nom_lieu, specialite.nom_specialite
FROM personnage
JOIN lieu ON personnage.id_lieu = lieu.id_lieu
JOIN specialite ON personnage.id_specialite = specialite.id_specialite';
$persoStatement = $mysqlClient->prepare($sqlQuery);
$persoStatement -> execute();
$personnages = $persoStatement->fetchAll();

echo "<table>
        <tr>
            <th>Nom</th>
			<th>Specialité<th>
            <th>Lieu d'habitation</th>
        </tr>";

foreach ($personnages as $personnage) {
    echo "<tr>
    		<td>".$personnage['nom_personnage']."</td>
			<td>".$personnage['nom_specialite']."</td>
    		<td>".$personnage['nom_lieu']."</td>
		</tr>";
}

echo "</table>"
?>