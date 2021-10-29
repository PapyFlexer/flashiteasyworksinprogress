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
	import com.flashiteasy.api.core.IAction;
	
	import flash.events.Event;
	
	
	/**
	 * The <code><strong>TimeTrigger</strong></code> 
	 * defines triggers set by an inner Timer.
	 */
	public class AutoStartTrigger extends AbstractTrigger
	{
		
		/**
		 * 
		 */
		public function AutoStartTrigger()
		{
			super();
		}
		
		override public function prepare( targets : Array, action : IAction ):void
        {
        	action.apply(new Event(Event.INIT));
        }
        
        override public function unload(targets:Array, action:IAction):void
        {
        	
        }
        
        
        
	}
}