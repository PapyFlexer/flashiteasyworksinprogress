package com.flashiteasy.api.managers
{
	
	import flash.external.ExternalInterface;
	public class SWFSize
	{
		public function SWFSize()
		{
			throw Error('this is a static class and should not be instantiated.');
		}
		
		public static function getBrowserWidth() :int
		{
			return ExternalInterface.call("getWidth");
		}

		public static function getBrowserHeight() :int
		{
			return ExternalInterface.call("getHeight");
		}
		
		public static function resizeSWFW(w:*) : void
		{
			ExternalInterface.call("resizeSWFW", w);
		}
		
		public static function resizeSWFH(h:*) : void
		{
			ExternalInterface.call("resizeSWFH", h);
		}
	}
}