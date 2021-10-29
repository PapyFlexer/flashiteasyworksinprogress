<?php
/*
 * Created on 7 avr. 10
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

 
//require_once("./BaseFieService.php");
 class FieService extends BaseFieService
 {
 	
 	public function helloFie()
 	{
 		return "hello FIE2";
 	}
 	
 	public function testTransferObject()
 	{
 		$to = new TransferObject();
 		$to->code = 0;
 		$to->message = "un message de test";
 		return $to; 		
 	}
 	
 	public function getRemoteParameterList( RemoteParameterListTO $transfer )
 	{
 		try {
	 		$transfer->code = 0;
	 		foreach ( $transfer->remoteParameterList as $param )
	 		{
	 			$resolver = $this->getParameterSetResolver($param);
	 			$param->response = $resolver->resolve();
	 		}
 		} catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}
 		
 		return $transfer;
 	}
 	
 	public function getParameterSetResolver( RemoteParameterSet $param ) 
 	{
 		if ( strpos( $param->request, 'XMLList' ) )
 		{
 			$resolver = new XMLListParameterSetResolver();
 			$resolver->setParameterSet( $param );
 			return $resolver;
 		}
 		else if ( strpos( $param->request, 'XML' ) )
 		{
 			$resolver = new XMLParameterSetResolver();
 			$resolver->setParameterSet( $param );
 			return $resolver;
 		}
 		else if ( strpos( $param->request, 'JSON' ) )
 		{
 			$resolver = new JSONParameterSetResolver();
 			$resolver->setParameterSet( $param );
 			return $resolver;
 		}
 	}
 	
 }
?>
