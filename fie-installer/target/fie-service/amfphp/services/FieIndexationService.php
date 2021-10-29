<?php
/*
 * Created on 4 nov. 10 by FIE crew
 *
 * this code is part of FlashIteasy, flash content integrator
 */

   
require_once("com/flashiteasy/api/fieservice/transfer/tr/TransferObject.php");
require_once("com/flashiteasy/admin/fieservice/transfer/tr/FileDataTO.php");
require_once("com/flashiteasy/admin/fieservice/manager/indexation/IndexationManager.php");
require_once("amfphp/services/BaseFieService.php");
 
 
 class FieIndexationService extends BaseFieService
 {
 	public function testIndexation()
 	{
		$indexationManager = new IndexationManager();
		$indexationManager->indexPage($transfer);
 		return "test Indexation";
 	}
 	
 	/**
		===========================
	
		   INDEXATION FUNCTIONS
		
		===========================
	*/
 	
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
