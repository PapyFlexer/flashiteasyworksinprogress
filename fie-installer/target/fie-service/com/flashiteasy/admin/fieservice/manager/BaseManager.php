<?php
/*
 * Created on 21 mai 2010
 * 
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */

require_once("com/flashiteasy/admin/fieservice/transfer/tr/FileDataTO.php"); 
 
class BaseManager
{ 
	
	public function current_path() 
	{
		// Must end with a /
		return "";
		//return $_SERVER['DOCUMENT_ROOT'] . "/";
	}

 	public function removeFile($directory , $files , &$errorArray=Array() , &$deleteArray=Array() ) 
 	{
		for ($i=0;$i<count($files); $i++) {
			$path=$this->current_path().$directory."/";
			$bool=false;
			
			if (strlen($files[$i])>0) {
				if (is_dir($path.$files[$i])) {
					$bool = $this->recursive_remove_directory($path.$files[$i]);
				} elseif ( is_file($path.$files[$i])) {
					$bool = unlink ($path.$files[$i]);
				}
				else { $bool = false; }
			}
			if ($bool) {
				array_push($deleteArray,$files[$i]);
			} else {
				$error=true;
				array_push($errorArray,	$path.$files[$i]);
			}
		}
	}
	
	public function recursive_remove_directory($directory, $empty=FALSE)
	{
		// on checke la presence du '/' en fin de chaine et si oui on supprime
		if(substr($directory,-1) == '/')
		{
			$directory = substr($directory,0,-1);
		}
		// si le repertoire existe et est bien un repertoire
		if(!file_exists($directory) || !is_dir($directory))
		{
			return FALSE;
	
		} elseif(is_readable($directory)) // si on peut le lire
		{
			// on ouvre le repertoire
			$handle = opendir($directory);
			//on liste les fichiers
			while (FALSE !== ($item = readdir($handle)))
			{
				// on vire les fichiers qui chient
				if($item != '.' && $item != '..')
				{
					$path = $directory.'/'.$item;
					// si on tombe sur un repertoire, on recurse...
					if(is_dir($path)) 
					{
						$this->recursive_remove_directory($path);
					} else {
						// sinon on supprime le fichier
						unlink($path);
					}
				}
			}
			// on ferme le repertoire
			closedir($handle);
			// on traite la condition : vider le rep ou supprimer le rep
			if($empty == FALSE)
			{
				if(!rmdir($directory))
				{
					return FALSE;
				}
			}
		}
		return TRUE;
	}	
	
	public function recursivescandir($dir,$url){
	//global $xml;
		//boucle pour les dossiers
		$dossier=opendir($dir);
		while ($fichier=readdir($dossier)){
			
			if( $fichier != "." && $fichier != ".." && $fichier{0} != "."){
				if (is_dir($dir."/".$fichier)){
					$this->xml .= "<folder isBranch='true' name='".$fichier."' url='".$this->remove_url($dir,$url).$fichier."/'>\n";
					$this->recursivescandir($dir."/".$fichier,$url) ;
				}
			}
		}
		//boucle pour les fichiers
	
		$dossier=opendir($dir);
		while($fichier=readdir($dossier)){
			if($fichier != "." && $fichier != ".." && $fichier{0} != "."){
				 if(!is_dir($dir."/".$fichier)){
					$this->xml .= "<file name=".'"'.$fichier.'"'." url=".'"'.$this->remove_url($dir,$url).'"'."/>\n";
				}
			}
		}
		if ($this->cut($dir) != $this->cut($url)){
			//$this->xml .="</".$this->cut($dir).">\n";
			$this->xml .="</folder>";
		}
		
	
	}
	
	public function copy_dir($dir2copy , $dir_paste)
 	{
 		$test=true;
 		 // On vérifie si $dir2copy est un dossier
        if (is_dir($dir2copy)) {
                // Si oui, on l'ouvre
                if ($dh = opendir($dir2copy)) {     
						$directory_name = basename($dir2copy);
                        // On liste les dossiers et fichiers de $dir2copy
                        while (($file = readdir($dh)) !== false) {
                        	
                                // Si le dossier dans lequel on veut coller n'existe pas, on le créé
                                if (!is_dir($dir_paste."/".$directory_name )) mkdir ($dir_paste.$directory_name, 0777);
                       
                                // S'il s'agit d'un dossier, on relance la fonction rÃ©cursive
                                if(is_dir($dir2copy.$file) && $file != '..'  && $file != '.') {
                                	if (!$this->copy_dir( $dir2copy.$file.'/' , $dir_paste.$directory_name."/".$file.'/' ))
                                	{
                                		$test=false;
                                	}
                                }
                                     
                                // S'il sagit d'un fichier, on le copie simplement
                                elseif($file != '..'  && $file != '.') {
                                	if (! @copy ( $dir2copy.$file , $dir_paste.$directory_name."/".$file ))
                                	{
                                		$test=false;
                                	}
                                	
                                }           
                        }
                // On ferme $dir2copy
                closedir($dh);
                }
        }
        else { return false; }
        return $test;
 	}
 	
	/**
		===========================
	
		UTILITIES FUNCTIONS
		
		===========================
		
	*/
 	public function cut($str){
		$i=strlen($str);
		while(@($str{$i} != "/")){
			$i=$i-1;
		}
		return substr($str, $i+1);
	} 

	public function remove_url($str,$url){
		if ($str == $url){
			return "";
		} else {
			$i=0;
			while(@($str{$i}==$url{$i})){
				$i=$i+1;
			}
			return substr($str, $i+1)."/";
		}
	}
	
	public function makeDirectory($directory)
 	{
 		$fileManager = new FileManager();
		return $fileManager->makeDirectory($directory);
 	}
			
	
}
?>
