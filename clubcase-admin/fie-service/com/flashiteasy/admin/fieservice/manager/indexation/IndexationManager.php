<?php
/*
 * Created on 2 nov. 10 by FIE crew
 *
 * this code is part of FlashIteasy, flash content integrator
 */

 
class IndexationManager extends FileManager
{

	public $xml="";
	
 	public function indexPage( FileDataTO &$transfer)
 	{
 		$indexation_directory = "../indexation";
 		$directory = $transfer->directory;
 		$path = $this->current_path().$directory;
 		$page = $transfer->files[0];
 		
 		$transform = new xslTransformer();
 		$xml = $transform->singlePageIndexation($page);
 		$filemanager = new FileManager();
 		//$transfer->success = $filemanager->makeFile("http://localhost:8888/fie-app/bin-debug/indexation/".$page. ".xml", $xml);
		//$transfer->code = 0;
		$transfer->success = ($xml !="");
		return $transfer;
 	}
 	
 	public function savePagesInfos( FileDataTO &$transfer)
 	{
 		$directory = $transfer->directory;
 		$path = $this->current_path().$directory;
 		$filename = "indexation.xml";
 		//début de scan et d'écriture du fichier
		$this->content .= "<?xml version='1.0' encoding='UTF-8' ?>\n";
		$this->content .= "<indexation>\n";
		$this->content .= $transfer->content;
		$this->content .= "</indexation>";
		
		$filemanager = new FileManager();
		$transfer->success = $filemanager->makeFile($path . $filename, $this->content);

		return $transfer;
 	}
}
 	
?>
