/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.action.IPauseSoundAction;
	import com.flashiteasy.api.managers.SoundManager;
	
	import flash.events.Event;

	public class PauseSoundAction extends Action implements IAction, IPauseSoundAction
	{
		
		private var _pausePosition : Number;
		private var _soundToPause : String;
		
		public function PauseSoundAction()
		{
			//TODO: implement function
			super();
		}
		
		/**
		 * 
		 * @param soundURL
		 * @param loop
		 */
		public function setSoundToPause( soundName : String ):void
		{
			soundToPause = soundName;
			pausePosition = SoundManager.getInstance(soundToPause).audioLastPosition;
			
		}

		override public function apply(event:Event):void
		{
			SoundManager.getInstance(soundToPause).pause();
		}
		
		public function get pausePosition() : Number
		{
			return _pausePosition;
		}
		
		public function set pausePosition( value : Number ) : void
		{
			_pausePosition = value;
		}
		
		public function get soundToPause() : String
		{
			return _soundToPause;
		}
		
		public function set soundToPause( value : String ) : void
		{
			_soundToPause = value;
		}
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return PauseSoundAction;
		}
		
	}
}