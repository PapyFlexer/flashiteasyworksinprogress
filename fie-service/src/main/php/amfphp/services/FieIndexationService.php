<?php
/*
 * Created on 4 nov. 10 by FIE crew
 *
 * this code is part of FlashIteasy, flash content integrator
 */

   

 
 
 class FieIndexationService extends BaseFieService
 {
 	
 	/**
		===========================
	
		   INDEXATION FUNCTIONS
		
		===========================
	*/
 	public function createHTML( $transfer )
 	{
 		try {
			$file = ADMIN_PATH.'/'.$transfer->files[0];
			$html_file = $transfer->files[1];
 			$transform = new xslTransformer();
 			$contentManager = new ContentManager();
 			
 			$xml = $transform->transform($transfer->content ,"../xsl/HTMLTransform.xsl");
 			//$transfer->content = $xml;
 			$transfer->success = ($xml !="");
 			$transfer->message = dirname($html_file);
 			if(!is_file(ADMIN_PATH."/".$html_file))
 			{
 				$contentManager->makeFile($html_file);
 					
 			}
 			$transfer->content="dir ".dirname($html_file);
 			$bool = $contentManager->save_content($xml,"".$html_file,"w");
 			
 			$transfer->success = ($xml !="" && $bool);
 			return $transfer;
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;	
 	}
 	
 	public function createIndexationSummary( FileDataTO $transfer )
 	{
 		try {
			$indexationManager = new IndexationManager();
			$indexationManager->indexPage($transfer);
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;	 	
 	}
 
 	public function savePageIndexation( FileDataTO $transfer )
 	{
 		try {
			$indexationManager = new IndexationManager();
			$indexationManager->indexPage($transfer);
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;	 	
 	}
 
 	
 }
?>
