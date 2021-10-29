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
	
	/**
	 * The <code><strong>IPauseStoryAction</strong></code> interface defines methods shared by pause story actions
	 */
	public interface IPauseStoryAction
	{
		function setStoriesToTrigger( stories : Array , page : Page  ) : void
		function addStoryNameToStoriesNamesToPause( value : String ) : void 
		function removeStoryNameFromStoriesNamesToPause( value : String ) : void
		
		function get time() : uint;
		function set time( value : uint ) : void;
	}
}