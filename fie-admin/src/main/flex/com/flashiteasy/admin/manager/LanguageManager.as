package com.flashiteasy.admin.manager
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	public class LanguageManager
	{
		//public static var resourceManager:ResourceManager=new ResourceManager;
		
        private var resourceManager:IResourceManager;
		[ResourceBundle("i18n")]
		public function LanguageManager(s:String = "en_US")
		{
			resourceManager = ResourceManager.getInstance();
			init(s);
		}
		public function init(s:String = "en_US"):void
		{
			
			var localeString:String = s;
			resourceManager.localeChain=[localeString];
			resourceManager.update();
		}
		
		public function getLanguage(s:String, len:int = -1):String
		{
			var translatedString:String = resourceManager.getString('i18n', s);
			if(translatedString == null)
			{
				//trace(s+"=");
				translatedString = s.split("_").join(" ");
			}
			
			var stringToReturn : String = len>0 ? translatedString.substr(0,len) : translatedString;
			return stringToReturn;
		}
		
		public function getDateString():String
		{
			var now : Date = new Date();
			var year:String = now.getFullYear().toString();
			var month:String = now.getMonth()<9 ? "0"+String(now.getMonth()+1) : String(now.getMonth()+1);
			var day:String = now.getDate()<10 ? "0"+now.getDate().toString() : now.getDate().toString();
			return (resourceManager.localeChain == ["fr_FR"]) ? day+"/"+month+"/"+year : month+"/"+day+"/"+year;
			
		}
	}
}