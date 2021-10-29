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
 		$options=array('folderPermission'=>0755,'filePermission'=>0755);
 		$fileToCopy=$transfer->files;
 		$newName=$transfer->copiedFiles;
 		
		$findme = 'http';
		$directory=$this->current_path()."/";
		
 		$errorArray = array();
		$copiedArray = array();
		
		for ($i=0;$i<count($fileToCopy); $i++) {
			$pos = strpos($fileToCopy[$i], $findme);
			if($pos === false)
			{
				$copieddirectory = $this->current_path()."/";
			}
			else
			{
				$copieddirectory = "";
			}
			if(is_dir($copieddirectory.$fileToCopy[$i])) {
				$bool =  $this->copy_dir($fileToCopy[$i], $newName[$i],$transfer);
			} else if(is_file($copieddirectory.$fileToCopy[$i])){
				$newDir = substr($newName[$i],0,strrpos($newName[$i],"/")) ;
				if(!is_dir($directory.$newDir))
				{
					$this->makeDirectory($newDir, $options['folderPermission']);
				}
				
				$bool = @copy($copieddirectory.$fileToCopy[$i], $directory.$newName[$i]);
				chmod($directory.$newName[$i],$options['filePermission']);
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
 		$directory = dirname($path);
 		if(is_file($path))
 		{
			return true;
			//return true;
 		}	
 		else 
 		{
 			if(!is_dir($directory))
 			{
 				if(!$this->make_directory($directory))
 				{
 					throw new Exception('impossible de creer le dossier '.$directory);
 				}
 			}
 			if($handle=fopen($path,"w"))
 			{
	 			if($content != "")
	 			{ 
	 				fwrite($handle,$content);
	 			}
				return true;
 			}
 			else
 			{
 				return false;
 				//throw new Exception('cannot open file ' . $path);
 			}
		}
 	}
 	
 	public function createDirectory(FileDataTO $transfer)
 	{
 		$transfer->success = $this->makeDirectory($transfer->directory);
 		return $transfer;
 	} 	
 	
 	public function make_directory($directory, $mode = 0777)
 	{
 		clearstatcache() ;
		$s=str_replace(" ","_" ,$directory);
		if( is_dir($s))
		{
			return true;
		}
		else{
			if (! mkdir($s,$mode,true)) {
				throw new Exception('impossible de creer le dossier  '.$s);
				return false;
			}
			else
				return true;
		}
 	}
 	
  	public function saveBitmap(FileDataTO $transfer)
 	{
 		
 		$transfer->success = $this->writeBitmap( $transfer );
 		$transfer->message="";
 		return $transfer;
 	}
 	
 	public function writeBitmap( FileDataTO $transfer )
 	{
 		$path = $this->current_path()."/".$transfer->directory;
 		$fileName = $transfer->files[0]; 
 		$ba = $transfer->content;
 		$imgpath = $path.$fileName;
 		$directory = $transfer->directory;
 		$binaryData = base64_decode($ba);
 		// sauvegarde de l'image
		if(!is_dir($path))
		{
			$this->makeDirectory($directory,0755);
		}
		$fp = @fopen($imgpath, 'wb');
		if ( @fwrite($fp, $binaryData))
		{
			@fclose($fp);
			return true;
		}
		else
		{
			return false;
		}	
	}
 	
 	public function makeDirectory($directory, $mode = 0777)
 	{
 		clearstatcache() ;
		$s=str_replace(" ","_" ,$directory);
		$s=$this->current_path()."/".$s;
		if( is_dir($s))
		{
			return true;
		}
		else{
			if (! mkdir($s,$mode)) {
				throw new Exception('impossible de creer le dossier  '.$s);
				return false;
			}
			else
				return true;
		}
 	} 	
 	
 	public function updateFiles(FileDataTO $transfer) 	 			
	{
		
		$filesToCopy = $transfer->files;
		$pathsToFiles = $transfer->copiedFiles;
		$errorArray = array();
		$copiedFiles = array();
		
		
		for ($i=0; $i<count($filesToCopy); $i++)
		{
			if (is_dir($filesToCopy[$i]))
			{
				$bool =  $this->copy_dir($filesToCopy[$i], $pathsToFiles[$i],$transfer);
				if (!$bool)
				{
					array_push($errorArray, $filesToCopy[$i]);
				}
				else
				{
					array_push($copiedFiles, $filesToCopy[$i]);
				}
			}
			else 
			{
				if(!@copy($filesToCopy[$i],$this->current_path()."/".$pathsToFiles[$i]))
				{
					array_push($errorArray, $filesToCopy[$i]);
				}
				else
				{
					array_push($copiedFiles, $filesToCopy[$i]);
				}
			}
		}
 		$transfer->copiedFiles =  $copiedFiles;
		$transfer->errorFiles = $errorArray ;
		
		return $transfer;
	}	
} 
 
?>
