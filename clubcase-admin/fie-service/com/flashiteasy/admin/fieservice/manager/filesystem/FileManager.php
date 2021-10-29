<?php
/*
 * Created on 1 juin 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

 
class FileManager extends BaseManager
{

	/**
		@func	renameFile
		@descr	Rename a file
		@param	$transfer the object containing the names
	*/	
 	public function renameFile(FileDataTO &$transfer) {
 		$fileToRename=$transfer->files;
 		$newName=$transfer->deletedFiles;
		$directory=$this->current_path()."/";
		$errorArray = array();
		$deleteArray = array();
		for ($i=0;$i<count($fileToRename); $i++) {
			$bool = rename($directory.$fileToRename[$i],$directory.$newName[$i]);
		
			if ($bool) {
				array_push($deleteArray, $newName[$i]);
			} else {
				$error=true;
				array_push($errorArray,	$fileToRename[$i]);
			}
		}
			
 		$transfer->deletedFiles =  $deleteArray;
		$transfer->errorFiles = $errorArray ;
		
		return $transfer;
		
	}
	
	/**
		@func	copyFile
		@descr	Copy an array of file
		@param	$transfer the object containing the names and newNames
	*/
	
 	public function copyFile( FileDataTO &$transfer) {
 		$fileToCopy=$transfer->files;
 		$newName=$transfer->copiedFiles;
		$directory=$this->current_path();
		
 		$errorArray = array();
		$copiedArray = array();
		
		for ($i=0;$i<count($fileToCopy); $i++) {
			if(is_dir($directory.$fileToCopy[$i])) {
				$bool =  $this->copy_dir($directory.$fileToCopy[$i], $directory.$newName[$i].'/');
			} else if(is_file($directory.$fileToCopy[$i])){
				$bool = @copy($directory.$fileToCopy[$i], $directory.$newName[$i]);
			}
			if ($bool) {
				array_push($copiedArray, $newName[$i]);
			} else {
				$error=true;
				array_push($errorArray,	$fileToCopy[$i]);
			}
		}
		
 		$transfer->copiedFiles =  $copiedArray;
		$transfer->errorFiles = $errorArray ;
		
		return $transfer;
		
	}
	
 	public function copy_directory ( FileDataTO $transfer) {
 		$dir2copy=$transfer->directory;
 		$dir_paste=$transfer->files[0];
       	$transfer->success = $this->copy_dir($dir2copy , $dir_paste , $transfer);
        return $transfer;
 	}
 	
 	public function deleteFile(FileDataTO $transfer) 
 	{
 		$files=$transfer->files;
 		$directory=$transfer->directory;
 		$errorArray = array();
		$deleteArray = array();
 		$this->removeFile($directory , $files , $errorArray , $deleteArray );
 		$transfer->deletedFiles =  $deleteArray;
		$transfer->errorFiles = $errorArray ;

		return $transfer;
 	}
 	
 	public function makeFile($file,$content="")
 	{
 		$path = $this->current_path()."/".$file;
 		if(is_file($path))
 		{
			return 2;
 		}	
 		else if($handle=fopen($path,"w"))
 		{
 			if($content != "")
 			{ 
 				fwrite($handle,$content);
 			}
			return 0;
		}
		else
		{
			return 1;
 		}
 	}
 	
 	public function createDirectory(FileDataTO $transfer)
 	{
 		$transfer->code = $this->makeDirectory($transfer->directory);
 		return $transfer;
 	} 	
 	
 	public function makeDirectory($directory)
 	{
		$s=str_replace(" ","_" ,$directory);
		$s=$this->current_path()."/".$s;
		if( is_dir($s)){
			return 2;
		}
		else{
			if (! mkdir($s,0777)) {
				return 1;
			}
			else
				return 0;
		}
 	} 	 	 			
		
} 
 
?>
