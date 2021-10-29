<?php
   


 
class FieFileUploadService extends BaseFieService
{

	public function testFileUpload()
 	{
 		return "test fileUpload";
 	}
 	
		
 	public function upload( FileDataTO $transfer )
	{
		$temp = $transfer->bites;
		$adata = $temp->data;
		$folder = $transfer->directory;
		$filename = $transfer->files[0];
		$toToreturn = new FileDataTO;
		$fileToUpload = $_SERVER['DOCUMENT_ROOT'] . $folder . $filename;
		$numbytes = file_put_contents($fileToUpload, $adata);
		if($numbytes == 0)
		{
 			$toToreturn->code = 1;
 			$toToreturn->message = "[" . $numbytes . "]" . "upload not ok=>" . $folder . $filename ;
		}
		else
		{
 			$toToreturn->code = 0;
 			$toToreturn->message = "[" . $numbytes . "]" . "upload ok=>" . $folder . $filename ;
		}
 		return $toToreturn; 	
	}
}

?>