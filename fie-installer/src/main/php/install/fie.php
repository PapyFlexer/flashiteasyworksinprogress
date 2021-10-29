<?php
ini_set('display_errors','1');
require "scripts/ConfigurationChecker.php";
/*
 * Created on 29 nov. 10
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
?>
<h1>FIE installer -- v4</h1>
<hr>
<h2>Configuration check</h2>
<body background="#efefef">
<?php
	$configurationChecker = new ConfigurationChecker();
	$configurationChecker->checkPhpVersion();
	$configurationChecker->checkDirectoryStructure();
	$configurationChecker->checkRights();
	//$configurationChecker->checkAllowOverrideAll();
	$configurationChecker->setAmfEndPoint();
	//$configurationChecker->setSampleApplicationRealPath();
	$configurationChecker->showAdminURL();
?>
</body>