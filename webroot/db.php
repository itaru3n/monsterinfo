<?php
$dsn = 'mysql:dbname=monsterinfo;host=monsterinfodb';
$user = 'root';
$password = 'monsterinfopw';

try {
    $dbh = new PDO($dsn, $user, $password);
} catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
}

foreach($dbh->query("Show variables like '%char%'") as $row) {
    printf("%s: %s<br />", htmlspecialchars($row[0]), htmlspecialchars($row[1]));
}
