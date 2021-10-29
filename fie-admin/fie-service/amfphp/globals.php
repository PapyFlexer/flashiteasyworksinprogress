<?php

	//This file is intentionally left blank so that you can add your own global settings
	//and includes which you may need inside your services. This is generally considered bad
	//practice, but it may be the only reasonable choice if you want to integrate with
	//frameworks that expect to be included as globals, for example TextPattern or WordPress

	//Set start time before loading framework
	list($usec, $sec) = explode(" ", microtime());
	$amfphp['startTime'] = ((float)$usec + (float)$sec);
	
	$servicesPath = "services/";
	$voPath = "../";
	
	define("ADMIN_PATH" ,"./../../../fie-admin" ); 
	
	require_once("./services/BaseFieService.php");
	require_once("./../com/flashiteasy/api/fieservice/transfer/tr/TransferObject.php");
	require_once("./../com/flashiteasy/admin/fieservice/transfer/tr/FileDataTO.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/BaseManager.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/BaseManager.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/filesystem/FileManager.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/content/ContentManager.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/media/FontManager.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/indexation/IndexationManager.php");
	require_once("./../com/flashiteasy/admin/fieservice/manager/xslt/xslTransformer.php");
	//As an example of what you might want to do here, consider:
	
	/*
	if(!PRODUCTION_SERVER)
	{
		define("DB_HOST", "localhost");
		define("DB_USER", "root");
		define("DB_PASS", "");
		define("DB_NAME", "amfphp");
	}
	*/
	
?>