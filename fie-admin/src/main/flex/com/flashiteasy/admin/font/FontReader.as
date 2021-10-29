package com.flashiteasy.admin.font
{
	import com.flashiteasy.admin.fieservice.FileManagerService;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class FontReader extends EventDispatcher
	{
		public static const COMPLETE:String="fontreader_complete";
		public static const ERROR:String="fontreader_error";

		public static var fontDictionnary:Dictionary=new Dictionary;

		private var path:String; // chemin ou se trouve le dossier font
		private var fms:FileManagerService;
		private var _fontName:String;

		public function FontReader(path:String="")
		{
			this.path=path;
			fms=new FileManagerService();
			fms.addEventListener(FileManagerService.ERROR, readError);
			fms.addEventListener(FileManagerService.FONT_READ, readFinish);
		}

		public function readFont(fontName:String):void
		{
			_fontName=fontName;
			if (FontReader.fontDictionnary[fontName] == null)
			{
				fms.getFontInfo(path, fontName);
			}
		}

		//------- event handler ---------------

		private function readError(e:Event):void
		{
			trace("couldn t find readFontAS3");
			dispatchEvent(new Event(ERROR));
		}

		// SWF cree , demarre le loading 

		private function readFinish(e:Event):void
		{
			FontReader.fontDictionnary[_fontName]=fms.contentArray;
			for (var s:*in fms.contentArray)
			{
				trace("font read" + s + "/" + fms.contentArray[s]);
			}

			dispatchEvent(new Event(COMPLETE));


		}

		public static function getFontInfo(font:String):Object
		{
			return fontDictionnary[font];
		}

		public function get fontName():String
		{
			return _fontName;
		}

	}
}