<?php

header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT");    // Date in the past
header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); // always modified
header ("Cache-Control: no-store, no-cache, must-revalidate");  // HTTP/1.1
header ("Pragma: no-cache");                          // HTTP/1.0
header ("Cache-Control: pre-check=0,post-check=0,max-age=0");
   

//require_once("./BaseFieService.php");
class FieFormService extends BaseFieService
{
	
	public function testFormService()
 	{
 		return "test Form service";
 	}
 	
 	function sendForm(FormDataTO $transfer)
 	{
 		try {
 			$formManager = new FormManager();
 			$formManager->getFormInfos( $transfer );
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;
 	}

}
?>