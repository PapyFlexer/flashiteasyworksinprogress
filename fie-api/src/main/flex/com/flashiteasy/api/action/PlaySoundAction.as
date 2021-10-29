/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.action.IPlaySoundAction;
	import com.flashiteasy.api.managers.SoundManager;
	
	import flash.events.Event;
	
	/**
	 * The <code><strong>PlaySoundAction</strong></code> class defines an Action that plays a sound
	 */
	public class PlaySoundAction extends Action implements IPlaySoundAction
	{
		/**
		 * 
		 * @default : sound 
		 */
		//protected var _soundMgr : SoundManager;
		/**
		 * 
		 * @default : sound 
		 */
		//protected var _sound : Sound;
		/**
		 * 
		 * @default : String url of the sound
		 */
		protected var _soundToPlayURL : String;
		/**
		 * 
		 * @default = false (Loop sound)
		 */
		protected var _loop : Boolean;
		protected var _beginTime : Number;
		protected var _volume : Number;
		
		//private var _playing:Boolean = false;
		
		/**
		 * 	constructor
		 */
		public function PlaySoundAction()
		{
			super();
		}
		
		/**
		 * 
		 * @param soundURL
		 * @param loop
		 */
		public function setSoundToPlayURL( soundURL : String, loop : Boolean, time : Number, volume : Number):void
		{
			beginTime = time;
			soundToPlayURL = soundURL;
			_loop = loop;
			_volume = volume;
			SoundManager.getInstance(soundToPlayURL).loadAudio(soundToPlayURL, onSoundLoading, onSoundComplete);
			SoundManager.getInstance(soundToPlayURL).setVolume(volume);
			
			var maxTime : Number = SoundManager.getInstance(soundToPlayURL).duration;
			beginTime = beginTime>maxTime ? maxTime : beginTime;
		}

		/**
		 * 
		 * inheritDoc
		 */
		override public function apply( event : Event ):void
		{
			//if (!_playing)
			//{
				beginTime == 0 ? SoundManager.getInstance(soundToPlayURL).play() : SoundManager.getInstance(soundToPlayURL).seek(_beginTime, true);
				SoundManager.getInstance(soundToPlayURL).setVolume(volume);
				//_playing = true;
			//}
		}
		/**
		 * 
		 * inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			//_sound.close();
			SoundManager.getInstance(soundToPlayURL).stop();
			SoundManager.getInstance(soundToPlayURL).unloadAudio();
		}
		/**
		 * 
		 * @param e : event
		 */
		private function onSoundComplete(e:Event):void
		{
			trace("sound "+soundToPlayURL+"has finished playing. Does it loop ?"+_loop);
			if (!_loop)
			{ 
				//_playing = false;
				SoundManager.getInstance(soundToPlayURL).stop();
			}
			else
			{
				SoundManager.getInstance(soundToPlayURL).seek(0, true);
			}
		}
		
		/**
		 * 
		 * @param e : event
		 */
		private function onSoundLoading(e:Event):void
		{
			trace("loading '"+soundToPlayURL+"'...");
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get soundToPlayURL() : String
		{
			return _soundToPlayURL;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set soundToPlayURL( value : String ):void
		{
			_soundToPlayURL = value;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set loop( value : Boolean ) : void
		{
			_loop = value;
		}


		public function get loop() : Boolean
		{
			return _loop;
		}
		/**
		 * The time of the sound to play
		 */
		public function get beginTime():Number
		{
			return _beginTime;
		}

		/**
		 * 
		 * @private
		 */
		public function set beginTime(value:Number):void
		{
			_beginTime=value;
		}	/**
		 * 
		 * Sets the control rotation (around Z axis as usual : 2D like) 
		 */
		public function get volume():Number{
			return _volume;
		}
		/**
		 * 
		 * @private
		 */
		public function set volume(value:Number):void{
			_volume=value;
		}
				
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return PlaySoundAction;
		}
	}
}