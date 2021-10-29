<?php
/*
 * Created on 7 avr. 10
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
//echo $_SERVER['SCRIPT_FILENAME'];
 class FileDataTO extends TransferObject
 {
  
    var $_explicitType = "com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO";	
  	public $files ;
	public $fileManagerService ; 
	public $directory ;
	public $deletedFiles ;
	public $errorFiles ;
	public $success;
	public $content;
	public $contentArray;
  	
 }
?>