/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.assets
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.utils.FontLoader;
	import com.flashiteasy.api.utils.LoaderUtil;
	import com.flashiteasy.api.utils.StringUtils;
	import com.flashiteasy.api.xml.StyleParser;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 * The <code><strong>TextManager</strong></code> class extends the EventDispatcher so it can fire custom events when :
	 * <ul><li>fonts are loaded</li>
	 * <li>styles are loaded</li></ul>
	 */
	public class TextManager extends EventDispatcher
	{
		/**
		 * 
		 * @default 
		 */
		public static var COMPLETE : String = "text_manager_complete";
		
		private var fontPath : String ;
		private var stylePath : String ;
		
		/**
		 * Loads text assets
		 * @param fonts
		 * @param styles
		 */
		public function loadTextAssets( fonts : String , styles : String ) : void 
		{
			fontPath = fonts ;
			stylePath = styles;
			loadFonts( fonts );
		}
		
		private function loadFonts(url : String ) : void 
		{
			LoaderUtil.getLoader(this, fontsConfigLoaded ).load(new URLRequest(url));
		}
		
		private var fontsConfig : Array ;
		
		/**
		 * Callback of the fonts loading COMPLETE event
		 * @param e : Event fired when the font list has been loaded.
		 */
		protected function fontsConfigLoaded ( e:Event ) : void
		{
			fontsConfig = e.target.data.split(/\n/);
			var font:FontLoader;
			//var fontUrl:String=AbstractBootstrap.getInstance().getBaseUrl()+"/font"
			FontLoader.unloadFonts();
			for each(var s:String in fontsConfig)
			{
				//font=new FontLoader(AbstractBootstrap.getInstance().getBaseUrl()+"/font");
				font=new FontLoader("/font");
				font.addEventListener(FontLoader.COMPLETE , onFontLoaded);
				font.addEventListener(FontLoader.ERROR,onFontError);
				s=StringUtils.removeWhiteSpace(s);
				font.loadFont(s);
			}
		}
		
		private function onFontError ( e : Event ) : void 
		{
			e.target.removeEventListener(FontLoader.COMPLETE,onFontLoaded);
			e.target.removeEventListener(FontLoader.ERROR,onFontLoaded);
			//loadStyles( stylePath ) ;
			fontsLoaded++;
			if(fontsLoaded == fontsConfig.length)
			{
				loadStyles( stylePath ) ;
			}
		}
		
		private var fontsLoaded : int = 0 ; 
		private function onFontLoaded(event:Event):void
		{
			event.target.removeEventListener(FontLoader.COMPLETE,onFontLoaded);
			event.target.removeEventListener(FontLoader.ERROR,onFontError);
			fontsLoaded++;
			
			if(fontsLoaded == fontsConfig.length)
			{
				loadStyles( stylePath ) ;
			}
			
		}
		
		private function loadStyles ( url : String ) : void 
		{
			LoaderUtil.getLoader(this, stylesLoaded ).load(new URLRequest(url));
		}
		
		private var styleXML : XML ;
		
		private function stylesLoaded( e:Event ) : void 
		{
			styleXML = new XML(e.target.data);
			for each( var xml: XML in styleXML.* )
			{
				StyleList.getInstance().addStyle( StyleParser.parseStyle( xml ));
			}	
			
			dispatchEvent( new Event(COMPLETE));
		}
		

	}
}