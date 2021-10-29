<?php
/*
 * Created on 1 juin 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

 
class ContentManager extends FileManager
{

	public $xml="";
	
 	public function getFolderTree( FileDataTO &$transfer)
 	{
 		$directory= $transfer->directory;
 		$path = $this->current_path()."/".$directory;
 		//début de scan et d'écriture du fichier
		$this->xml .=  "<?xml version='1.0' encoding='UTF-8' ?>\n";
		$this->xml .=  "<root>\n";
		
		$this->recursivescandir($path,$path);
		$this->xml .=  "</root>";
 		
 		$transfer->content = $this->xml;
 		$transfer->code = 0;
 		return $transfer;
 		
 	}
 	
 	public function saveContent( FileDataTO &$transfer , $mode )
 	{
 		$content= $transfer->content;
 		$file= $transfer->files[0];
		$content= stripslashes($content);
		//if($handle=fopen($_SERVER['DOCUMENT_ROOT'].$file,"w"))
		if($handle=fopen($this->current_path()."/".$file,$mode))
		{
			fwrite($handle,$content);
			return true;
		}
		else
		{
			return false;
		}
 	} 	


 	public function deletePage( FileDataTO &$transfer)
 	{
 		$directory = $transfer->directory ;
 		$file = $transfer->files[0];
 		$errorArray = array();
		$deleteArray = array();
 		if(is_dir($this->current_path()."/".$directory."/".$file)){
 			$this->removeFile($directory ,array( $file ));
 		}
 		$this->removeFile($directory , array($file.".xml"),$errorArray,$deleteArray );
 		$transfer->deletedFiles =  $deleteArray;
		$transfer->errorFiles = $errorArray ;
 		return $transfer;
 	}
 	
 	public function pastePage(FileDataTO &$transfer)
 	{
 		$directory = $transfer[0]->directory ;
 		$file = $transfer[0]->files[0] ;
 	} 	
 	
 	public function createFile(FileDataTO &$transfer)
 	{
 		$file = $transfer->files[0];
 		$content = $transfer->content;
 		$transfer->code = $this->makeFile($file , $content );
 		return $transfer;
 	}
 	
 	public function createNewPage(FileDataTO &$transfer)
 	{
 		$directory = $transfer->directory ;
 		$file = $transfer->files[0];
 		$content = '<page></page>';
 		if($this->makeDirectory($directory) != 1 ) 
 		{
 			if($this->makeFile($directory."/".$file,$content) != 1)
 			{
 				$transfer->code=0;
 			}
 			else
 			{
 				$transfer->code=2;
 			}
 		}
 		else
 		{
 			$transfer->code=1;	
 		}
 		
 		return $transfer;
 	}
 	 	
 	
}
?>
