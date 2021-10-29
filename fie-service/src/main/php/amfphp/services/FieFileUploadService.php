<?php
   


 
class FieFileUploadService extends BaseFieService
{

	public function testFileUpload()
 	{
 		return "test fileUpload";
 	}
 	
 	public function current_path() 
	{
		return ADMIN_PATH ;
	}
		
 	public function upload( FileDataTO $transfer )
	{
		try {
			$temp = $transfer->bites;
			$adata = $temp->data;
			$folder = $transfer->directory;
			//$folder = "http://localhost:8888/fie-admin/fie-projects/fie-app/media/lalala/";
			$filename = $transfer->files[0];
			$toToreturn = new FileDataTO;
			
	 		$fileToUpload = $this->current_path()."/". $folder . $filename;
			//$fileToUpload = $_SERVER['DOCUMENT_ROOT'] . $folder . $filename;
			$numbytes = file_put_contents($fileToUpload, $adata);
			if($numbytes == 0)
			{
	 			$toToreturn->code = 1;
	 			$toToreturn->success = false;
	 			$toToreturn->message = "[" . $numbytes . "]" . "upload not ok=>" . $folder . $filename ;
			}
			else
			{
	 			$toToreturn->code = 0;
	 			$toToreturn->success = true;
	 			$toToreturn->message = "[" . $numbytes . "]" . "upload ok=>" . $folder . $filename ;
			}
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}	
 		return $toToreturn; 	
	}
}

?>