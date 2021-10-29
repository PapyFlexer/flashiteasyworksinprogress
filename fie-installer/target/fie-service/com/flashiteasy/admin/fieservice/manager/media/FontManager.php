<?php
/*
 * Created on 21 mai 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

require_once("com/flashiteasy/admin/fieservice/manager/BaseManager.php");
 
class FontManager extends BaseManager
{ 
 	function compileFont(FileDataTO $transfer)
 	{
 		$font = $transfer->files[0];
 		$directory = $transfer->directory ;
 		$path = $this->current_path().$directory."/";
	 	if(!file_exists($path.$font.".swf")){
		
		if(file_exists($path.$font.".ttf"))
			$type="ttf";
		elseif(file_exists($path.$font.".otf"))
			$type="otf";
		else
			return false;
		if(!isset($erreur)){
		touch($path.$font.".as");
		$myFile = $path.$font.".as";
		$fh = fopen($myFile, 'w');
		
			$file=
			'package {
		
				import flash.display.MovieClip;
		
				public class '.$font.' extends MovieClip
				{
		     		[Embed(source="'.$font.'.'.$type.'", fontName="_'.$font.'", fontWeight="normal", mimeType="application/x-font-truetype")]
		      		public static var _'.$font.':Class;  
		     	}
			}
			';
			fwrite($fh, $file);
			fclose($fh);
			chdir($this->current_path()."fie-admin/bin-debug/sdk/bin");
			$cmd="./mxmlc -managers flash.fonts.AFEFontManager -o ../../../../fie-app/bin-debug/font/$font.swf ../../../../fie-app/bin-debug/font/$font.as" ;
			exec($cmd ,$output = array());
			}
	}
 		return true;
 	}	
} 
?>
