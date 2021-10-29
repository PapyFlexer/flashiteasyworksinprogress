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
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	


	/**
	 * The <code><strong>LaterUtils</strong></code> class is
	 * an utility class dealing with methods that must
	 * be called using some delay. 
	 * It instanciates a new timer inside a private queue
	 */
	public class LaterUtils
	{
		private static var _laterQueue:Array = [];
		private static var _laterTimer : Timer = createTimer();
		/**
		 * Constructor
		 */
		public function LaterUtils()
		{
		}
		private static function createTimer() : Timer
		{
			if (!_laterTimer)
			{
				var tim : Timer = new Timer(1, 1);
				tim.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
				return tim;
			}
			return null;
		}
		
		/**
		 * Fires the method passed as argument
		 * @param callback
		 */
		public static function perform(callback:Function) : void
		{
			_laterQueue.push(callback);
			if (!_laterTimer.running) _laterTimer.start();
		}

		/**
		 * @private
		 * Handler fired by the COMPLETE event of each member of the queue 
		 */
		private static function timerCompleteHandler(e : TimerEvent) : void
		{
			var callbackQueue : Array = _laterQueue.concat();
			_laterQueue = [];
			var currentCallback:Function;
			while(currentCallback = callbackQueue.shift() as Function)
			{
				currentCallback();
			}
		}
	}
}
