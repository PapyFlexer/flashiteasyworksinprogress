<?php
/*
 * Created on 4 juin 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */


class BaseFieService
{
	
	public function BaseFieService()
	{
	}
	
	public function handleError ( TransferObject &$transfer , Exception $e)
	{
		$transfer->success = false ;
		$transfer->code = 1;
		$transfer->message .= $e->getMessage() ."\n". $e->getTraceAsString();
		return $transfer;
	}
}
?>
