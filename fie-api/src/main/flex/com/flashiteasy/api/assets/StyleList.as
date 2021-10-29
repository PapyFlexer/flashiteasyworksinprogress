/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.assets
{
	import com.flashiteasy.api.text.Style;
	
	import flash.text.TextFormat;
	
	/**
	 * The <code><strong>StyleList</strong></code> class manages the dynamic styles applied to text instances on stage
	 * It comes in a singleton-like flavour so must be called using StyleList.getInstance()
	 */
	public class StyleList
	{
		private var stylesXML : XML = new XML(<styles></styles>); 
		private var styles : Array = [] ; 
		private static var instance : StyleList;
		/**
		 * 
		 * @default : Boolean that prevents instanciation to be made twice 
		 */
		protected static var allowInstantiation : Boolean = false;
		
		/**
		 * 
		 */
		public function StyleList()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		/**
		 * 
		 * @return the StyleList object instance
		 */
		public static function getInstance() : StyleList
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new StyleList();
				allowInstantiation = false;
			}
			return instance;
		}
		
		/**
		 * 
		 * @param xml : the xml describing the style applied
		 */
		public function setXML( xml : XML ) : void 
		{
			stylesXML = xml;
		}
		
		/**
		 * 
		 * @return  the xml describing the style applied
		 */
		public function getXML(): XML 
		{
			return stylesXML;
		}
		
		/**
		 * 
		 * generateXML methods writes the global project style object in xml
		 * 
		 */
		public function generateXML():void
		{
			var xml : XML = new XML(<styles></styles>);
			for each( var style : Style in styles )
			{
				xml.* += style.getStyleXML();
			}
			stylesXML = xml;
		}
		
		/**
		 * 
		 * @param name : this methods checks if the name given to a new style is available as a unique name
		 * @return 
		 */
		public function checkName( name : String ) : Boolean 
		{
			var s : Style ;
			for each( s in styles ) 
			{
				if(s.name == name )
					return false;
			}
			return true;
		}
		
		/**
		 * 
		 * @param name : the name of the style to describe
		 * @return  : the Style object asked for
		 */
		public function getStyle( name : String ) : Style 
		{
			for each( var style : Style in styles )
			{
				if( style.name==name)
					return style;
			}
			return null ;
		}
		/**
		 * 
		 * @param style adds a new style to the StyleList instance
		 */
		public function addStyle( style : Style ) : void
		{
			styles.push(style);
			stylesXML.* += style.getStyleXML();
		}
		/**
		 * 
		 * @return lists the Array of styles used i the global project
		 */
		public function getStyles() : Array 
		{
			return styles;
		}
		
		/**
		 * 
		 * @param style : XMLParser thats takes the xml saved and parses it  so the style objects are correctly created.
		 */
		public  function parseStyle( style : XML ) : void 
		{
			var xml : XML ;
			for each ( xml in style.style )
			{
				var format : TextFormat = new TextFormat();
				if( xml.font != null ) 
					format.font = xml.font;
			}
		}
		
		/**
		 * 
		 * @param style removes a given style from the StyleList instance
		 */
		public function removeStyle( style : Style ) : void 
		{
			var i:int;
			label1 : for(i=0; i < styles.length; i++)
			{

				if (styles[i] == style)
				{
					styles.splice(i, 1);
					break label1 ;
				}
			}
			generateXML();
		}

	}
}