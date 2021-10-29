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
	import com.flashiteasy.api.utils.PreciseTimer;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * The <code><strong>TimeTrigger</strong></code> 
	 * defines triggers set by an inner Timer.
	 */
	public class TimerTrigger extends AbstractTrigger
	{
		private var _delay : Number;
		private var _timer : PreciseTimer;
		
		/**
		 * 
		 */
		public function TimerTrigger()
		{
			super();
		}
		
		override public function prepare( targets : Array, action : IAction ):void
        {
        	_timer = new PreciseTimer(delay, 1);
        	_timer.addEventListener(TimerEvent.TIMER_COMPLETE, action.apply, false, 0, true);
        	// Add repeatCount to TimerTrigger configuration
        	//_timer.repeatCount = 1;
        	_timer.start();
        }
        
        override public function unload(targets:Array, action:IAction):void
        {
        	if(_timer != null)
        	{
        	_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, action.apply);
        	_timer.stop();
        	_timer = null;
        	}
        }
        
        /**
         * 
         * Sets a delay before triggering
         */
        public function get delay() : Number
        {
        	return _delay;
        }
		
        /**
         * @private
         */
        public function set delay( value : Number ) :void
        {
        	_delay = value;
        }
        
	}
}