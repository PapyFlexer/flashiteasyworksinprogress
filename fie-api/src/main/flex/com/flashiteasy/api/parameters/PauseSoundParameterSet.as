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
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.action.IPauseSoundAction;
	import com.flashiteasy.api.managers.SoundManager;
	// metadata
    [ParameterSet(description="Pause_Sound",type="Reflection", groupname="Sound")]
	public class PauseSoundParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		

		private var _soundToPause:String;
		private var _loop : Boolean;
		private var _beginTime : Number;
		
        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            //super.apply( target );
            if ( target is IPauseSoundAction )
            { 
                IPauseSoundAction( target ).setSoundToPause( soundToPause );
            }
        }
 
        [Parameter(type="List", labelField = "url" ,label="Sound")]
		/**
		 * The source of the sound to play
		 */
		public function get soundToPause():String
		{
			return _soundToPause;
		}

		/**
		 * 
		 * @private
		 */
		public function set soundToPause(value:String):void
		{
			_soundToPause=value;
		}

       /**
         * Lists availables sounds on stage using their names
         * @param name
         * @return 
         */
        public function getPossibleValues(name:String):Array
        {
            return SoundManager.listAllManagers();
        }		
				
 				
	}
}