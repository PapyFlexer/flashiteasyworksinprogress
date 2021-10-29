<?php

header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT");    // Date in the past
header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); // always modified
header ("Cache-Control: no-store, no-cache, must-revalidate");  // HTTP/1.1
header ("Pragma: no-cache");                          // HTTP/1.0
header ("Cache-Control: pre-check=0,post-check=0,max-age=0");
   

//require_once("./BaseFieService.php");
class FieBrowserService extends BaseFieService
{
	
	public function testBrowser()
 	{
 		return "test browser";
 	}
 	
 	function compileFont(FileDataTO $transfer)
 	{
 		$fontManager = new FontManager();
 		return $fontManager->compileFont( $transfer );
 	}

	/**
		===========================
	
		TRANSFER FUNCTIONS
		
		===========================
	*/
	
	/**
		@func	renameFile
		@descr	Rename a file
		@param	$transfer the object containing the names
	*/
 	public function renameFile(FileDataTO $transfer) {
 		try {
	 		$transfer->code = 0;
			$fileManager = new FileManager();
			$fileManager->renameFile($transfer);
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;
	}
	
 	/**
		@func	copyFile
		@descr	Copy an array of file
		@param	$transfer the object containing the names and newNames
	*/
 	public function copyFile( FileDataTO $transfer) {
 		try {
	 		$fileManager = new FileManager();
			$fileManager->copyFile($transfer);
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;		
	}
	
 	public function copy_directory (FileDataTO $transfer) {
 		try {
			$fileManager = new FileManager();
			$fileManager->copy_directory($transfer);
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;			
 	}
 	
 	public function getFolderTree( FileDataTO $transfer)
 	{
 		try {
			$contentManager = new ContentManager();
			$contentManager->getFolderTree( $transfer );
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;	
 	}
 	
 	public function saveContent( FileDataTO $transfer)
 	{
 		try {
			$contentManager = new ContentManager();
			$transfer->success = $contentManager->saveContent( $transfer ,"w" );
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;				
 	}
 	
 	public function appendContent( FileDataTO $transfer)
 	{
 		try {
			$contentManager = new ContentManager();
			$transfer->success = $contentManager->saveContent( $transfer ,"a" );
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;				
 	}
 	
 	public function deletePage(FileDataTO $transfer)
 	{
 		try {
			$contentManager = new ContentManager();
			$contentManager->deletePage( $transfer );	
		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;						
 	}
 	
 	public function pastePage(FileDataTO $transfer)
 	{
 		try {
			$contentManager = new ContentManager();
			$contentManager->pastePage( $transfer );
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;	 		
 	}
 	
 	public function createNewFile(FileDataTO $transfer)
 	{
		$contentManager = new ContentManager();
		$contentManager->createFile( $transfer );
		return $transfer;
 		
 	}
 	
 	public function createNewPage(FileDataTO $transfer)
 	{
 		try{
			$contentManager = new ContentManager();
			$contentManager->createNewPage( $transfer );
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		//return $contentManager;
		return $transfer;	 		
 	}
 	
 	public function createDirectory(FileDataTO $transfer)
 	{
 		try{
			$fileManager = new FileManager();
			$fileManager->createDirectory($transfer);		
 		} 
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer; 	 		
 	}
 	
 	public function deleteFile(FileDataTO $transfer) 
 	{
 		try {
			$fileManager = new FileManager();
			$fileManager->deleteFile($transfer);
 		}
		catch ( Exception $e)
 		{
 			$this->handleError( $transfer, $e );
 		}		
		return $transfer;	 	
 	}
 	
}
?>