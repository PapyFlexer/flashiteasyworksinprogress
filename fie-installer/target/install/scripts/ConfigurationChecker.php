<?php
/*
 * Created on 29 nov. 10
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
 
 /*
  * y'a t'il deja une version d'installé ?
  * version de php ( requis 5+ )
  * structure de ce qui est uploadé, presence de fie-admin, etc...
  * est-ce qu'on a les droits d'ecriture dur le repertoire parent
  * est-ce qu'on a le droit d'ecrire du htaccess
  * est-ce qu'on a les droits d'ecriture sur fie-projects
  * 
  * actions :
  * modifier le htaccess de fie-service
  * modifier dans fie-projects/fie-sample-app/xml/project.xml @@AMF_ENDPOINT@@ par current-url /fie-admin/amfphp/gateway.php?
  * 
  */
  class ConfigurationChecker
  {
  	
  		public function ConfigurationChecker()
  		{
  			
  		}
  		
  		public function checkPhpVersion()
  		{
  			if ( phpversion() < 5 )
  			{
  				$this->dieYesYouGonnaDie ("your php version is bad : ". phpversion() );
  			}
  			else
  			{
  				$this->displayResult(" php version " . phpversion() . " - ok");
  			}
  		}
  		
  		public function checkDirectoryStructure()
  		{
  			$directory = array("fie-admin","fie-projects","fie-projects/fie-sample-app","fie-service");
  			foreach ( $directory as $dir)
  			{
  				if ( !file_exists( '../' . $dir ) )
  				{
  					$this->dieYesYouGonnaDie("Missing directory " . $dir . "check your FIE installation ");
  				}
  			}
  			$this->displayResult("directories - ok");
  		}
  		
  		public function checkRights()
  		{
  			if ( !is_writable( "../") )
  			{
  				$this->dieYesYouGonnaDie(" parent directory must be writable ");
  			}
  			else
  			{
  				$this->displayResult("parent directory is writable - ok");
  			}
  		}
  		
  		public function checkAllowOverrideAll()
  		{
  			try {
  				$initial_error_value = ini_get("display_errors");
  				ini_set("display_errors","true");
  				ini_set("display_errors",$initial_error_value);
  			} 
  			catch (Exception $e )
  			{
  				$this->dieYesYouGonnaDie(" You should set AllowOverride to All in your httpd.conf for using FIE ");
  			}
  			$this->displayResult("Allow Override is possible - ok");
  			$this->editApplicationHtaccess();
  		}

		private function editApplicationHtaccess()
		{
			$htaccess_template = "../fie-service/.htaccess-template";
			$htaccess = "../fie-service/.htaccess";
			
			$content = file_get_contents( $htaccess_template );
			
			$currentPath = $_SERVER['SCRIPT_FILENAME'];
			$serviceIncludePath = str_replace( "install/fie.php", "fie-service/", $currentPath ); 
			//echo $serviceIncludePath ;
			
			$htaccessContent = str_replace( "@@php-include-path@@", $serviceIncludePath , $content );
			fwrite( fopen($htaccess,"w"), $htaccessContent );
			$this->displayResult("include path in [fie-service/.htaccess] has been set to<br><b> [" . $serviceIncludePath . "]</b> - ok" );
		}
		
		public function setAmfEndPoint() 
		{
			
			$sampleAppProjectFileTemplate = "../fie-projects/fie-sample-app/xml/project.xml.template";
			$sampleAppProjectFile = "../fie-projects/fie-sample-app/xml/project.xml";
			
			$currentPath = $this->curPageURL();
			$amfEndpoint = str_replace( "install/fie.php", "fie-service/amfphp/gateway.php", $currentPath);
			
			
			$content = file_get_contents( $sampleAppProjectFileTemplate );
			$projectContent = str_replace( "@@AMF_ENDPOINT@@", $amfEndpoint , $content );
			fwrite( fopen($sampleAppProjectFile,"w"), $projectContent );
			$this->displayResult("AMF-ENDPOINT has been set to <br><b>[" . $amfEndpoint . "]</b> - ok" );
		}
		
		public function setSampleApplicationRealPath()
		{
			$resFileTemplate = "../fie-admin/res/projects.xml.template";
			$resFile = "../fie-admin/res/projects.xml";
			
			//$currentPath = $_SERVER['SCRIPT_FILENAME'];
			$currentPath = $_SERVER['PHP_SELF'];
			$realPath = str_replace( "install/fie.php", "fie-projects/fie-sample-app", $currentPath);
			//$realPath = "/fie-admin/fie-projects/fie-sample-app";
			$content = file_get_contents( $resFileTemplate );
			$resFileContent = str_replace( "@@SAMPLE_APP_REAL_PATH@@", $realPath , $content );
			fwrite( fopen($resFile,"w"), $resFileContent );
			
			$this->displayResult("SAMPLE_APP_REAL_PATH has been set to <br><b>[" . $realPath . "]</b> - ok" );
			
		}
		
		public function showAdminURL()
		{
			$currentPath = $this->curPageURL();
			$adminURL = str_replace( "install/fie.php" ,"fie-admin/index.html", $currentPath);
			$this->displayResult("Flash'iteasy has been successfully installed . You can access admin from this URL : <a href='$adminURL'>" . $adminURL ."</a>" );
			
		}
		
		public function curPageURL() {
			 $pageURL = 'http';
			 if ( isset($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] == "on")
			 {
			 	$pageURL .= "s";
			 }
			 $pageURL .= "://";
			 if ($_SERVER["SERVER_PORT"] != "80")
			 {
			 	$pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
			 } else
			 {
			 	$pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
			 }
			 return $pageURL;
		}
  		
  		public function displayResult( $value )
  		{
  			echo "<li>" . $value . "</li>";
  		}
  		
  		public function dieYesYouGonnaDie( $value )
  		{
  			die("<li> <font color='#FF0000'>". $value . '</font></li>');
  		}
  		
  }
  
?>
