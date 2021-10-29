/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import fl.core.UIComponent;
	
	import flash.display.Stage;
	
	/**
	 * The <code><strong>StageUtils</strong></code> class is
	 * an utility class dealing with Stage
	 */
	public class StageUtil
	{
		private static var stage : Stage;
		
		/**
		 * A reference to the global Stage
		 * @return the project's Stage
		 */
		public static function getStage() : Stage
		{
			if( stage == null )
			{
				stage = (new UIComponent()).stage;
			}
			return stage;
		}

	}
}