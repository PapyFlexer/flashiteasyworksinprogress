/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.selection {
	import flash.text.Font;

	import com.flashiteasy.api.core.IUIElementDescriptor;

	/**
	 * The <code><strong>FontLibrary</strong></code> is the class
	 * that handles fonts available in the project. 
	 * It also takes care of font embedding.
	 */
	public class FontLibrary {
		private static var fonts:Array=new Array();
		

		/**
		 * Emebds the font whose name is passed as argument
		 * @param font the font name
		 */
		public static function embedFont(font:String):void{
			
			//[Embed(source="com/flashiteasy/api/font/"+font+".ttf", fontName=font, fontWeight="normal", mimeType="application/x-font-truetype")]
			var _font:Class;
			Font.registerFont(_font);
			fonts.push(_font as String);
		}
		/**
		 * Checks if a font is available, based on its name
		 * @param font the font name
		 * @return a boolean, true if the font checks, false otherwise
		 */
		public static function hasFont(font:String):Boolean{
			var el:String;
			for each ( el in fonts ) {
				if( el == font ) 
					return true;
			}
			return false;
		}
	}
}
