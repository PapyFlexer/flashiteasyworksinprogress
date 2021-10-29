<?php

/*
 * Created on 21 mai 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

class FontManager extends BaseManager
{ 
 	function compileFont(FileDataTO $transfer)
 	{
 		$font = $transfer->files[0];
 		$fontoutput = preg_replace("/[^A-Za-z0-9]/","",$font);
 		$fontfamily = $transfer->files[1];
 		if(!isset($fontfamily))
 			$fontfamily=$font;
 		$weight = $transfer->files[2];
 		if(!isset($weight))
 			$weight="normal";
 		$style = $transfer->files[3];
 		if(!isset($style))
 			$style="normal";
 		$directory = $transfer->directory ;
  		if (substr($directory, -1) == "/")
 		{
 			$directory = substr($directory, 0, -1);
 		}
 		$path = $this->current_path()."/".$directory."/";
	 	if(!file_exists($path."../".$fontoutput.".swf"))
	 	{
			if(file_exists($path.$font.".ttf"))
				$type="ttf";
			elseif(file_exists($path.$font.".TTF"))
				$type="TTF";
			elseif(file_exists($path.$font.".otf"))
				$type="otf";
			elseif(file_exists($path.$font.".OTF"))
				$type="OTF";
			else 
			{
				$transfer->success = false;
				return $transfer;
			}
			
			if(!isset($erreur)){
			touch($path.$fontoutput.".as");
			$myFile = $path.$fontoutput.".as";
			$fh = fopen($myFile, 'w');		
			$file=

			'package {
				import flash.display.MovieClip;
				public class '.$fontoutput.' extends MovieClip
				{
		     		[Embed(source="'.$font.'.'.$type.'", fontName="_'.$fontfamily.'", fontWeight="'.$weight.'", fontStyle="'.$style.'", mimeType="application/x-font-truetype")]
		      		public static var _'.$fontoutput.':Class;  
		     	}
			}
			';
			
			fwrite($fh, $file);
			fclose($fh);
			chdir($this->current_path()."/fonts/sdk/bin");
			$cmd="export DYLD_LIBRARY_PATH='';./mxmlc -managers flash.fonts.AFEFontManager -o ./../../../".$directory."/../$fontoutput.swf ./../../../".$directory."/$fontoutput.as" ;
			exec($cmd ,$output = array());
			unlink("./../../../".$directory."/$fontoutput.as");
			}
		}
		$transfer->success = true;
		$transfer->content = $fontoutput;
 		return $transfer;
 	}	
} 
?>