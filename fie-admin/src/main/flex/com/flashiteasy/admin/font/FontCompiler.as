package com.flashiteasy.admin.font
{
	import com.flashiteasy.admin.fieservice.FileManagerService;
	import com.flashiteasy.api.utils.FontLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class FontCompiler extends EventDispatcher
	{
		public static const COMPLETE:String = "fontcompiler_complete";
 	 	public static const ERROR:String = "fontcompiler_error";
 	 	
		private var path:String; // chemin ou se trouve le dossier font
		private var fms:FileManagerService;
		private var loader:FontLoader;
		private var _fontName:String;
		
		public function FontCompiler(path:String="")
		{
			loader=new FontLoader(path+"..");
 	 		this.path=path;
			fms=new FileManagerService();
			loader.addEventListener(FontLoader.COMPLETE,loadComplete);
			loader.addEventListener(FontLoader.ERROR,loadError);
 	 		fms.addEventListener(FileManagerService.ERROR, compileError );
 	 		fms.addEventListener(FileManagerService.FONT_COMPILED , compileFinish);
 	 		
		}
		
		public function compileFont(fontName:String,fontfamily:String,fontweight:String="normal",fontstyle:String="normal"):void
		{
			_fontName=fontName;
			fms.compileFont(path,fontName,fontfamily,fontweight,fontstyle);
		}
		
		//------- event handler ---------------
 	 	
 	 	private function compileError(e:Event):void{
 	 		trace("couldn t find compileAS3");
 	 		dispatchEvent(new Event(ERROR));
 	 	}
 	 	
 	 	// SWF cree , demarre le loading 
 	 	
 	 	private function compileFinish(e:Event):void
 	 	{
 	 			trace("font compiled");
 	 			
 	 			loader.addEventListener(FontLoader.ERROR, loadError );
 	 			loader.addEventListener(FontLoader.COMPLETE , loadComplete ) ;
 	 			_fontName = fms.content;
 	 			loader.loadSWF(_fontName);
 	 	}
 	 	
 	 	private function loadError(e:Event):void
 	 	{
 	 		loader.removeEventListener(FontLoader.ERROR, loadError );
 	 		dispatchEvent(new Event(ERROR));
 	 	}
 	 	
 	 	private function loadComplete(e:Event) :void
 	 	{
 	 		loader.removeEventListener(FontLoader.COMPLETE , loadComplete ) ;
 	 		//moved in FontInfoComponent
 	 		//fms.appendToFile(Conf.APP_ROOT + "/config/fonts.txt", "\n" + _fontName);
 	 		
 	 		dispatchEvent(new Event(COMPLETE));
 	 	}
 	 	
 	 	public function get fontName():String
 	 	{
 	 		return _fontName;
 	 	}

	}
}