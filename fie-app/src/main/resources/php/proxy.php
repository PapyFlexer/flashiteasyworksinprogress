<?php
//On verifie que l'on a bien recupere la variable venant de flash
if(!isset($_POST["proxy"])) {
//si vide on arrete le script
die( "Error" );
}
//si votre .php n'est pas encode en utf-8, decommentez cette ligne et supprimez l'autre echo
//echo utf8_encode(file_get_contents($_GET["maVariable"]));
//et si votre php est encode en utf8, faire l'inverse
echo file_get_contents($_POST["proxy"]);
?> 