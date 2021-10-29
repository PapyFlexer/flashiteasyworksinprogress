/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.library
{
	import flash.text.Font;
	
	/**
	 * The <code><strong>AbstractLibrary</strong></code> is a pseudo abstract class 
	 * that defines the loading of internal and external libraries 
	 * at run-time.
	 * Components made with this API are loaded this way.
	 * @see com.flashiteasy.api.library.LibraryLoader
	 */
	public class AbstractLibrary implements ILibrary
	{
		/**
		 * Initializes the Library
		 */
		public function init() : void
		{
			registerTypes();
			registerFonts();
		}
		
		/**
		 * Registers decriptors and parameterSets. 
		 * Must be overridden in extending classes.
		 */
		protected function registerTypes() : void
		{
			// must be overridden
		}
		
		/**
		 * Registers fonts available in the project
		 * (in admin mode, new fonts can be added at runtime
		 * via an online compiler). 
		 */
		protected function registerFonts() : void
		{
			var fonts : Array = getFonts();
			var f : Class;
			for( var i :int = 0; f != null && i < f.length; i++ )
			{
				f = Class( f[i] );
				Font.registerFont( f );
			}
		}
		
		/**
		 * Returns the array of available fonts 
		 * Must be overridden in extending classes.
		 */
		protected function getFonts() : Array
		{
			return [];
		}
	}
}