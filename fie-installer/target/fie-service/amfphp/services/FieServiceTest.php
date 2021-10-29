<?php
/*
 * Created on 7 avr. 10
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
 include("FieService.php");
 
 //phpinfo();
 $service = new FieService();
 echo $service->helloFie();
 
 echo "<hr>";
 
 var_dump( $service->testTransferObject() );
 
 
?>


