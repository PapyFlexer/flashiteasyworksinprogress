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
 		$directory = $transfer->directory;
 		$page = $transfer->files[0];
 		
 		$transform = new xslTransformer();
 		$xml = $transform->singlePageIndexation($directory."/xml/".$page. ".xml");
 		$contentmanager = new ContentManager();
 		$transfer->files[0] = $directory."/indexation/".$page. ".html";
 		$transfer->content = $xml;
 		$transfer->success = $contentmanager->saveContent($transfer, "w");
		$transfer->code = 0;
		$transfer->success = ($xml !="");
		return $transfer;
 	}
 	
 	public function saveIndexationObject( FileDataTO &$transfer)
 	{
 		$directory = $transfer->directory;
 		$filename = $transfer->files[0];
 		$xml = $transfer->content;
		$transfer->content = $xml;
		$contentmanager = new ContentManager();
		$transfer->files[0] = $directory."/indexation/info.xml";
 		$transfer->success = $contentmanager->saveContent($transfer,"w");

		return $transfer;
 	}
 	
 	public function createIndexationIndexPage( FileDataTO &$transfer )
 	{
 		$directory = $transfer->directory;
 		$transfer->files[0] = $directory."/indexation/index.html";
 		$transfer->content = "";
 		//foreach ($)
 	}
}
 	
?>
