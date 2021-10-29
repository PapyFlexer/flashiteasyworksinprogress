<?php

header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT");    // Date in the past
header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); // always modified
header ("Cache-Control: no-store, no-cache, must-revalidate");  // HTTP/1.1
header ("Pragma: no-cache");                          // HTTP/1.0
header ("Cache-Control: pre-check=0,post-check=0,max-age=0");
$_SERVER['DOCUMENT_ROOT'] = "/Applications/MAMP/htdocs/";
   
require_once("com/flashiteasy/api/fieservice/transfer/tr/TransferObject.php");
require_once("com/flashiteasy/admin/fieservice/transfer/tr/FileDataTO.php");
require_once("com/flashiteasy/admin/fieservice/manager/content/ContentManager.php");
require_once("com/flashiteasy/admin/fieservice/manager/filesystem/FileManager.php");
require_once("com/flashiteasy/admin/fieservice/manager/media/FontManager.php");
require_once("amfphp/services/BaseFieService.php");
 
class FieFileUploadService extends BaseFieService
{
	
	public function testFileUpload()
 	{
 		return "test fileUpload";
 	}
 	
 	public function upload( FileDataTO $transfer )
	{
		$content = $transfer->content; 		
		$filename = $transfer->filename;
		$directory=$this->current_path()."/";
		$temp = $transfer->bites;
		$adata = $byteArray->data;
		$folder = $folderPath;
		if(file_put_contents($folder . '/' . $fileName. '' , $adata))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
?>



