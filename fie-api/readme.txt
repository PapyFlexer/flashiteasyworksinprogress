compiler argument : -locale=en_US,fr_FR -allow-source-path-overlap=true -keep-as3-metadata+=Parameter,ParameterSet
api fieservice AbstractBusinessDelegate initializeNetConnection:- didier "http://localhost:8888/FIE/amfphp/gateway.php?XDEBUG_SESSION_START=fie"
																- gilles "http://localhost:8888/FIE/amfphp/gateway.php?XDEBUG_SESSION_START=fie"
																- dany "http://localhost/FIE/amfphp/gateway.php?XDEBUG_SESSION_START=fie"

																- online "http://www.flashiteasy.com/FIE/amfphp/gateway.php?XDEBUG_SESSION_START=fie"



fie-service src main php htaccess : -didier php_value include_path ".:/Users/didierreyt/Documents/WorkspaceMaven/fie/fie-service/src/main/php/"
									-gilles php_value include_path ".:/Users/gillesroquefeuil/Documents/WorkspaceMaven/fie/fie-service/src/main/php/"
									-dany php_value include_path "C:/Users/hanne/Documents/workspaceMaven/fie/fie-service/src/main/php"
		
Redefinir le chemin des actions php					
fie-service : class BaseManager->current_path()  : -didier Gilles : "/Applications/MAMP/htdocs/";
				  								 : -dany : //

project output folder : -dany C:\wamp\www\fie-admin\bin-debug
debug options : -dany http://localhost/fie-aapp/bin-debug/FieApp.html
									
Penser à inclure le dossier libs dnas le projet admin en cas de "mvn flex:eclipse"

