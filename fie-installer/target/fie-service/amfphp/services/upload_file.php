<?php 

if ( isset($_POST['folder'])) {
	$url=$_SERVER['DOCUMENT_ROOT']."/".$_POST['folder'];
}

if(isset($_FILES['file']) && isset($url)){
	move_uploaded_file($_FILES['file']['tmp_name'], $url."/".$_FILES['file']['name']);
}
?>