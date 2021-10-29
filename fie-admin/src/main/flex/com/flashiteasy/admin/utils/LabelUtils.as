package com.flashiteasy.admin.utils
{
	import com.flashiteasy.admin.conf.Conf;
	
	public class LabelUtils
	{
		public function LabelUtils()
		{
		}
		public static function setClassLabel(item:Object):String
		{
			return getLang(String(item).split(" ")[1].toString().substr(0,-1));
		}
			
		public static function getClassLabel(item:Object):String
		{
			return String(item).split(" ")[1].toString().substr(0,-1);
		}
		
		public static function setLabel(item:Object):String
		{
			return getLang(String(item));
		}
		
		public static function setParameterLabel(item:Object):String
		{
			return getLang(String(item).split("ParameterSet")[0]);
		}
		
		
		public static function getParameterLabel(item:Object):String
		{
			return String(item)+"ParameterSet";
		}
			
		public static function getLang(s:String):String
		{
				
			return Conf.languageManager.getLanguage(s);
		}
			
			
	}
}