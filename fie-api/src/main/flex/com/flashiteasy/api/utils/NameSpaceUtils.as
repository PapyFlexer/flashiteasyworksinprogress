package com.flashiteasy.api.utils
{
	public class NameSpaceUtils
	{
		public static function getNameSpaceFromPrefix(namespaces: Array , name:String):Namespace
		{
			for each (var ns:Namespace in namespaces)
			{
				if(ns.prefix == name)
				 return ns;
			}
			return null;
		}
		
		public static function getNameSpacePrefixFromUri(namespaces: Array , name:String):String
		{
			for each (var ns:Namespace in namespaces)
			{
				if(ns.uri == name)
				 return ns.prefix;
			}
			return null;
		}
		
		public static function getNameSpaceUriFromPrefix(namespaces: Array , name:String):String
		{
			for each (var ns:Namespace in namespaces)
			{
				if(ns.prefix == name)
				 return ns.uri;
			}
			return null;
		}

	}
}