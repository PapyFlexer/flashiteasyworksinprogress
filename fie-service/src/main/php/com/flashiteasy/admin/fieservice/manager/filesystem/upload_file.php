<?php 


$content = new BaseManager;

if ( isset($_POST['folder'])) {
	$url=$content->current_path().$_POST['folder'];
}

if(isset($_FILES['file']) && isset($url)){
	move_uploaded_file($_FILES['file']['tmp_name'], $url."/".$_FILES['file']['name']);
	echo $url."/".$_FILES['file']['name'];
}
?>