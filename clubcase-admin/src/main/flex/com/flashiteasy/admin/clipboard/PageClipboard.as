package com.flashiteasy.admin.clipboard
{
	import com.flashiteasy.api.core.project.Page;
	
	public class PageClipboard
	{
		private var pages : Array = [] ;
		private static var instance:PageClipboard;
		private static var allowInstantiation:Boolean=false;
		
		public function PageClipboard()
		{
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}

		}

		public static function getInstance():PageClipboard
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new PageClipboard();
				allowInstantiation=false;
			}
			return instance;
		}
		
		public function isEmpty():Boolean
		{
			return (pages.length == 0 );
		}
		
		private var _type:String = "xml";
		private var _isCut:Boolean = false;
		public function addPage ( page : Page , type:String = "xml") : void
		{
			pages.push( page ) ;
			_type = type;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get isCut():Boolean
		{
			return _isCut;
		}
		
		
		public function set isCut(isCut:Boolean):void
		{
			_isCut = isCut;
		}
		
		public function getPages() : Array 
		{
			return pages;
		}
		
		public function clear():void
		{
			pages = [];
		}

	}
}