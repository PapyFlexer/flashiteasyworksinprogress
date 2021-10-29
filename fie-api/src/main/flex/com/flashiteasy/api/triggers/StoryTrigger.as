/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.triggers
{
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	
	/**
	 * @private
	 * The <code><strong>KeyboardTrigger</strong></code> 
	 * defines triggers set by stories on stage at beginning, end or loop events.
	 */
	public class StoryTrigger extends AbstractTrigger
	{
		/**
		 * 
		 */
		public function StoryTrigger()
		{
			type="keyframe";
			super();
		}
		override public function prepare( targets : Array, action : IAction):void
		{
			var p : Page = action.getPage() == null ? BrowsingManager.getInstance().getCurrentPage() : action.getPage();			
			p.addEventListener( FieEvent.STORY_ENDED, action.apply, false, 0, true );
		}
		
		override public function unload( targets : Array, action : IAction ) : void
		{
			var p : Page = action.getPage() == null ? BrowsingManager.getInstance().getCurrentPage() : action.getPage();			
			p.removeEventListener( FieEvent.STORY_ENDED, action.apply, false );
		} 
	}
}