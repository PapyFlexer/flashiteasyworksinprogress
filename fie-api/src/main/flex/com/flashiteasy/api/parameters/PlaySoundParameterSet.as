/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.action.IPlaySoundAction;

	/**
	 * The <code><strong>PlaySoundParameterSet</strong></code> is the parameterSet
	 * that handles the playing of a given sound in the page.
	 * It can be looped.
	 */

	// metadata
    [ParameterSet(description="Play_Sound",type="Reflection", groupname="Sound")]
	public class PlaySoundParameterSet extends AbstractParameterSet
	{
		

		private var _soundToPlay:String;
		private var _loop : Boolean;
		private var _beginTime : Number = 0;
		private var _volume : Number = 1;
		
        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            //super.apply( target );
            if ( target is IPlaySoundAction )
            { 
                IPlaySoundAction( target ).setSoundToPlayURL( _soundToPlay, _loop, _beginTime, _volume ); 
            }
        }
 
       [Parameter(type="Source", defaultValue="null", row="0", sequence="0", label="Source")]
		/**
		 * The source of the sound to play
		 */
		public function get soundToPlay():String
		{
			return _soundToPlay;
		}

		/**
		 * 
		 * @private
		 */
		public function set soundToPlay(value:String):void
		{
			_soundToPlay=value;
		}
				
       [Parameter(type="Number", defaultValue="0", min="0", max="50000", interval="100", row="1", sequence="1", label="Source")]
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
		}
				
      [Parameter(type="Boolean", defaultValue="false", row="1", sequence="2", label="Loop")]
		/**
		 * Sets the loop property of the sound to be triggered
		 */
		public function get loop() : Boolean
		{
			return _loop; 
		}

		/**
		 * 
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			_loop=value;
		}
		
		[Parameter(type="Slider",defaultValue="0", min="0", max="1", interval="0.1", row="3", sequence="3", label="Volume")]
		/**
		 * 
		 * Sets the control rotation (around Z axis as usual : 2D like) 
		 */
		public function get volume():Number
		{
			return _volume;
		}
		/**
		 * 
		 * @private
		 */
		public function set volume(value:Number):void{
			_volume=value;
		}
				
	}
}