<?php
	echo 'SERVER_NAME' . $_SERVER['SERVER_NAME'] . "<br>";
	echo 'DOCUMENT_ROOT' . $_SERVER['DOCUMENT_ROOT'] . "<br>";
	echo 'SCRIPT_FILENAME' .  $_SERVER['SCRIPT_FILENAME'] . "<br>";
	echo 'PATH_TRANSLATED' . $_SERVER['PATH_TRANSLATED'] . "<br>";
	echo 'HTTP_HOST' . $_SERVER['HTTP_HOST'] . "<br>";
	echo 'PHP_SELF' . $_SERVER['PHP_SELF'] . "<br>";
	echo '__FILE__' . __FILE__ . "<br>" . "<br>";
	phpinfo();
?>