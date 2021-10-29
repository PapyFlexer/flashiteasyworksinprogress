/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils {
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.setTimeout;

	/**
	 * The <code><strong>FontLoader</strong></code> class is
	 * an utility class dealing with Fonts management
	 */
	public class FontLoader extends EventDispatcher{

		/**
		 * 
		 * @default 
		 */
		public static const COMPLETE:String = "font_complete";
 	 	/**
 	 	 * 
 	 	 * @default 
 	 	 */
 	 	public static const ERROR:String = "error loading font";
 	 	
 	 	private var loader:Loader = new Loader();
 	 	private var _fontsDomain:ApplicationDomain;
 	 	private var _fontName:String;
 	 	private var path: String;
 	 	
 	 	private static var fontList:Array=new Array;
 	 	
 	 	/**
 	 	 * 
 	 	 * @param path
 	 	 */
 	 	public function FontLoader(path:String=""):void {
 	 		this.path=path;
 	 	}
 	 	
 	 	//=======================================
 	 	// Load une font a partir d un ttf 
 	 	// fontName : nom du fichier TTF
 	 	//=======================================
 	 	
 	 	/**
 	 	 * 
 	 	 * @param fontName
 	 	 */
 	 	public function loadFont(fontName:String):void
 	 	{
 	 		_fontName = fontName;
 	 		loadSWF(fontName);
 	 		
 	 	}
 	 	
 	 	 	 	// Load un SWF contenant une font 
 	 	
 	 	/**
 	 	 * 
 	 	 * @param fontName
 	 	 */
 	 	public function loadSWF(fontName:String):void{
 	 		_fontName=fontName;
 	 		loader=new Loader();
 	 		var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
 	 		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorSWFLoad);
 	 	 	loader.contentLoaderInfo.addEventListener(  ProgressEvent.PROGRESS, SWFLoaded, false, 0, true );
 	 	 	loader.load(new URLRequest(path+"/"+fontName+".swf"),ldrContext);
 	 	 	trace(path+"/"+fontName+".swf");
 	 	}
 	 	
 	 	private function errorSWFLoad(e:IOErrorEvent):void{
 	 		trace("couldn t load SWF :(");
 	 		dispatchEvent(new Event(FontLoader.ERROR));
 	 	}
 	 	
 	 	private function SWFLoaded(e:Event):void
 	 	{
 	 		var info : LoaderInfo = LoaderInfo(e.target);
			if( info.bytesLoaded == info.bytesTotal )
			{
				setTimeout( loadComplete, 500);
			}
 	 	}
 	 	
 	 	private function loadComplete():void
 	 	{
 	 		_fontsDomain = loader.contentLoaderInfo.applicationDomain;
 	 		trace("loading font from swf : " + _fontName);
 	 		FontLoader.fontList.push(_fontName);
 	 		registerFonts([_fontName]);
 	 		dispatchEvent(new Event(FontLoader.COMPLETE));
 	 	}
 	 	
		 // Verifie qu une font a ete chargee 
 	 	
 	 	/**
 	 	 * 
 	 	 * @param fontName
 	 	 * @return 
 	 	 */
 	 	public  static function hasFont(fontName:String):Boolean{
 	 		var f:String;
 	 		trace("fontName :: "+fontName);
 	 		for each(f in FontLoader.fontList ){
 	 		trace("fontName :: "+fontName+" f :: "+f);
 	 			if(f == fontName)
 	 				return true;
 	 		}
 	 		return false;
 	 	}
 	 	
 	 	
 	 	/**
 	 	 * 
 	 	 * @param fontName
 	 	 * @return 
 	 	 */
 	 	public  static function removeFont(fontName:String) : void
 	 	{
 	 		var f:String;
 	 		trace("fontName :: "+fontName);
 	 		var i : int = -1;
 	 		
 	 		for each(f in FontLoader.fontList ){
 	 			i++;
 	 			trace("fontName :: "+fontName+" f :: "+f);
 	 			if(f == fontName)
 	 			{
 	 				FontLoader.fontList.splice(i,1);
 	 				break;
 	 			}
 	 		}
 	 	}
 	 	/**
 	 	 * 
 	 	 * @return 
 	 	 */
 	 	public static function getFonts(): Array 
 	 	{
 	 		var fonts : Array= [];
 	 		for each ( var font : String in fontList)
 	 		{
 	 			fonts.push("_"+font);
 	 		}
 	 		return fonts;
 	 	}
 	 	
 	 	public static function getFontList(): Array 
 	 	{
 	 		
 	 		return fontList;
 	 	}
 	 	
 	 	public static function getFontFamilies(): Array 
 	 	{
 	 		
				var fontLoadedList:Array = Font.enumerateFonts();
				var fontProvider:Array = [];
				for each(var font:Font in fontLoadedList)
				{
					var fontString : String = String(font).split(" ")[1].split("_")[0];
					if(!ArrayUtils.isItemInArray(fontProvider, font.fontName) && ArrayUtils.isItemInArray(fontList,fontString))
					fontProvider.push(font.fontName);
				}
				return fontProvider;
 	 	}
 	 	
 	 	
 	 	public static function getFont(fontName:String): Font 
 	 	{
 	 		
				var fontLoadedList:Array = Font.enumerateFonts();
				for each(var font:Font in fontLoadedList)
				{
					var fontString : String = String(font).split(" ")[1].split("_")[0];
					if(fontName == fontString)
					return font;
				}
				return null;
 	 	}
 	 	
 	 	 // Charge les font contenu dans fontList
 	 	 
 	 	/**
 	 	 * 
 	 	 * @param fontList
 	 	 */
 	 	public function registerFonts(fontList:Array):void {
 	 	 	for (var i:uint = 0; i < fontList.length; i++)
 	 	 	{
 	 	 		var clazz : Class = getFontClass(fontList[i]) 
 	 	 	 	Font.registerFont( clazz );
 	 	 	}
 	 	}
 	 	
 	 	
 	 	public static function unloadFonts():void
 	 	{
 	 		fontList = [];
 	 		//var toto:
 	 	}
 	 	 
 	 	 // retourne une font a partir de son nom
 	 	 
 	 	/**
 	 	 * 
 	 	 * @param id
 	 	 * @return 
 	 	 */
 	 	public function getFont(id:String):Font 
 	 	{
 	 	 	var fontClass:Class = getFontClass(id);
 	 	 	return new fontClass as Font;
 	 	}
 	 	

 	 	
 	 	
 	 	

 	 	
 	 	// Recupere la class embeddant une font 
 	 	
 	 	 private function getFontClass(id:String):Class 
 	 	 {
 	 		return loader.contentLoaderInfo.applicationDomain.getDefinition(id)["_"+id] as Class;
 	 	 }
 	 	
 	 	//==============================================================
 	 	// Load une font a partir d une URL de swf et du nom de la font
 	 	//==============================================================
 	 	
 	 	/**
 	 	 * 
 	 	 * @param url
 	 	 * @param fontName
 	 	 */
 	 	public function load (url:String,fontName:String):void{
 	 	 	this._fontName = fontName;
 	 	 	loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, font_ioErrorHandler);
 	 	 	loader.contentLoaderInfo.addEventListener(Event.COMPLETE,finished);
 	 	 	loadAsset(url);
 	 	}
 	 	
 	 	private function loadAsset(url:String):void {
 	 	 	var request:URLRequest = new URLRequest(url);
 	 	 	loader.load(request);
 	 	 }
 	 	private function finished(evt:Event):void {

			trace("finished");
 	 	 	_fontsDomain = loader.contentLoaderInfo.applicationDomain;
 	 	 	
 	 	 	registerFonts([_fontName]);
 	 	 	dispatchEvent(new Event(FontLoader.COMPLETE));
 	 	}
 	 	
 	 	private function font_ioErrorHandler(evt:Event):void {
 	 	 	dispatchEvent(new Event(FontLoader.ERROR));
 	 	}
 	 	
 	 	public function get fontName() : String
 	 	{
 	 		return _fontName;
 	 	}
		
		
	}
}
