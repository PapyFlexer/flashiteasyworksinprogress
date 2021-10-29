/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.text
{
	import com.flashiteasy.api.utils.NumberUtils;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * The <code><strong>Style</strong></code> class is the
	 * class that manages all dynamic Styles used by the 
	 * projects text contents
	 * 
	 *  
	 */
	public class Style
	{

		/**
		 * Text Alignment
		 * @default TextFormatAlign.LEFT
		 */
		public var align:String=TextFormatAlign.LEFT;
		/**
		 * Block indent
		 * @default int 0
		 */
		public var blockIndent:int=0;
		/**
		 * Font Bold
		 * @default false
		 */
		public var bold:Boolean=false;
		/**
		 * Font Bullet
		 * @default false
		 */
		public var bullet:Boolean=false;
		/**
		 * Font color
		 * @default 0x000000
		 */
		public var color:uint=0;
		/**
		 * Base Font
		 * @default Arial
		 */
		public var font:String="_Arial";
		/**
		 * Paragraph indent
		 * @default 
		 */
		public var indent:int=0;
		/**
		 * Font italic
		 * @default false
		 */
		public var italic:Boolean=false;
		/**
		 * Kerning
		 * @default false 
		 */
		public var kerning:Boolean=false;
		/**
		 * Font Underline
		 * @default false
		 */
		public var underline:Boolean=false;
		/**
		 * Font size
		 * @default 10
		 */
		public var size:int=10;

		/**
		 * Style name
		 * @default ""
		 */
		public var name:String="styleName";

		private var styleXML:XML;

		/**
		 * EmptyConstructor
		 */
		public function Style()
		{
		}

		/**
		 * Returns Style Description as XML
		 * @return the style expressed in XML
		 */
		public function getStyleXML():XML
		{
				var style : XML = new XML("<style></style>");
				style.* += new XML("<name>"+name+"</name>");
				style.* += new XML("<align>"+align+"</align>");
				style.* += new XML("<blockIndent>"+blockIndent+"</blockIndent>");
				style.* += new XML("<bold>"+bold+"</bold>");
				style.* += new XML("<color>0x"+NumberUtils.numberToHexadecimalString(color)+"</color>");
				style.* += new XML("<font>"+font+"</font>");
				style.* += new XML("<indent>"+indent+"</indent>");
				style.* += new XML("<italic>"+italic+"</italic>");
				style.* += new XML("<kerning>"+kerning+"</kerning>");
				style.* += new XML("<underline>"+underline+"</underline>");
				style.* += new XML("<size>"+size+"</size>");
				return style;
		}

		/**
		 * Returns the TextFormat equivalent to the Style
		 * @return 
		 */
		public function getTextFormat():TextFormat
		{

			var format:TextFormat=new TextFormat;
			format.align=align;
			format.blockIndent=blockIndent;
			format.bold=bold;
			format.bullet=bullet;
			format.color=color;
			format.font=font;
			format.indent=indent;
			format.italic=italic;
			format.kerning=kerning;
			format.underline=underline;
			format.size=size;
			return format;
		}

		private function parseValues():void
		{
			var xml:XML;
			for each (xml in styleXML.style.*)
			{
				var format:TextFormat=new TextFormat();
				format[xml.name()]=xml.children()[0];
				/*
				   switch(xml.name())
				   {

				   case "font":
				   break;
				   case "align":
				   break;
				   case "bold":
				   break;
				   case "blockIndent":
				   break;
				   case "bullet":
				   break;
				   case "color":
				   break;
				   case "indent":
				   break;
				   case "italic":
				   break;
				   case "kerning":
				   break;
				   case "leading":
				   break;
				   case "leftMargin":
				   break;
				   case "letterSpacing":
				   break;
				   case "rightMargin":
				   break;
				   case "size":
				   break;
				   case "tabStop":
				   break;
				   case "target":
				   break;
				   case "underline":
				   break;
				   case "url":
				   break;

				   }
				 */
			}
		}
	}
}