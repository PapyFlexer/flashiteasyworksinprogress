<?php
/* Connexion et fonction de communication MySql
*
*/

if (! @$cc=mysql_connect("$MYSQL_HOST","$MYSQL_USER","$MYSQL_PWD")) {
   echo utf8_encode("Impossible d'établir de connexion à ".$MYSQL_HOST."<br>");
   die;
}
// Selection de la base
mysql_select_db ($MYSQL_DB);
// Jeu de caracteres et collation Mysql
$sql = "SET NAMES 'utf8'";
$rec = sql_exec($sql);
$sql = "SET CHARACTER SET 'utf8'";
$rec = sql_exec($sql);


function sql_select($query){ // SELECT - SHOW
	global $cc;
	$recordset=array();
	if (!$result = mysql_query($query,$cc)){
		return false;
	}else{
		while($row=mysql_fetch_array($result,MYSQL_ASSOC)) {
			$recordset[]=$row;
		}
		return $recordset;
	}
}

function sql_exec($query){ // INSERT - UPDATE - DELETE
	global $cc;
	if (!$result = mysql_query($query,$cc)){
		echo mysql_error()."<br>";
		return false;
	}else{
		return true;
	}
}

function insert_SQL($table="0",$data=array()){
// fonction d'insertion de $data dans $table
	if (! empty($table)){
		$sqlS1 = "";
		$sqlS2 = "";
		$virg = "";
		foreach ($data as $k=>$v){
			$sqlS1 .= $virg.$k;
			$sqlS2 .= $virg."'".encodage($v)."'";
			$virg = ",";
		}
		if (! empty($sqlS1) && ! empty($sqlS2)){
			$sql = "INSERT INTO $table ($sqlS1) VALUES ($sqlS2)";
			if (sql_exec($sql)){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}else{
		return false;
	}
}

function insert_SQL_GetId($table="0",$data=array()){
// fonction d'insertion de $data dans $table avec recuperation et renvoi de l'ID generee
	// On verouille la table concernÈe
	$sqlLock = "LOCK TABLE $table WRITE";
	sql_exec($sqlLock);
	// On execute la requete
	insert_SQL($table,$data);
	// On recupere l'ID
	//$newID = mysql_insert_id();
	$sqlId = "SELECT LAST_INSERT_ID() AS increment FROM $table";
	$rec = sql_select($sqlId);
	// On deverouille la table
	$sqlUnlock = "UNLOCK TABLES";
	sql_exec($sqlUnlock);
	// Retourne l'ID
	return $rec[0]["increment"];
}

function update_SQL($table="0",$eleID=array(),$data=array()){
// fonction d'update de $table avec $data selon $eleID
	if (! empty($table) && is_array($eleID) && count($eleID) > 0){
		// WHERE
		$where = "";
		$and = "";
		foreach ($eleID as $k=>$v){
			$where .= $and.$k."='".$v."'";
			$and = " AND ";
		}
		// SET
		$sqlS = "";
		$virg = "";
		foreach ($data as $k=>$v){
			$sqlS .= $virg.$k."='".encodage($v)."'";
			$virg = ",";
		}
		if (! empty($where) && ! empty($sqlS)){
			$sql = "UPDATE $table SET $sqlS WHERE $where";
			if (sql_exec($sql)){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}else{
		return false;
	}
}

function delete_SQL($table="0",$eleID=array()){
// fonction de suppression de $data dans $table
	if (! empty($table) && is_array($eleID) && count($eleID) > 0){
		// WHERE
		$where = "";
		$and = "";
		foreach ($eleID as $k=>$v){
			$where .= $and.$k."='".$v."'";
			$and = " AND ";
		}
		if (! empty($where)){
			$sql = "DELETE FROM $table WHERE $where";
			if (sql_exec($sql)){
				return true;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}else{
		return false;
	}
}

function get_Col_Name($table){
// fonction qui recupere le nom des champs de la table $table
	$sql = "SHOW COLUMNS FROM $table";
	$rec = sql_select($sql);
	$chps = array();
	foreach ($rec as $row){
		$chps[] = $row["Field"];
	}
	return $chps;
}

function encodage($valeur){
	$valeur=stripslashes($valeur);
	$valeur=trim($valeur);
	$valeur=addslashes($valeur);
	return $valeur;
}
function microtime_float(){ // Retourne le timestamp en microseconde
  list($usec, $sec) = explode(" ", microtime());
  return ((float)$usec + (float)$sec);
}
?>