/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core.action
{
	import com.flashiteasy.api.core.project.Page;
	
	public interface IPlayableElementAction
	{
		function setElementsToTrigger( elements : Array , page : Page  ) : void
		function set time( time : uint ) : void;
		function get time() : uint;
		function addElementToElementsToPlay( value : String ) : void
		function removeElementFromElementsToPlay( value : String ) : void
	}
}