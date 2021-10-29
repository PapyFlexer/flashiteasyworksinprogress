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
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.IAction;
	import flash.events.KeyboardEvent;
	/**
	 * The <code><strong>KeyboardTrigger</strong></code> 
	 * defines triggers set by user-interaction
	 * on keyboard.
	 */
	public class KeyBoardTrigger extends AbstractTrigger
	{
		
		// TODO : Must add keymap
		
		/**
		 * 
		 */
		public function KeyBoardTrigger()
		{
			super();
		}
        private var _action : IAction;
        
        private var _altKey : Boolean;
        private var _key : String;
        private var _keyPressed : Boolean;
        private var _shiftKey : Boolean;
        
        
        /**
         * 
         * Sets a triggering key
         */
        public function get key() : String
        {
        	return _key;
        }
		
        /**
         * @private
         */
        public function set key( value : String ) :void
        {
        	_key = value;
        }
		
		override public function prepare( targets : Array, action : IAction ):void
		{
			_action = action;
			
            var event : String;
			for each ( event in this.events )
            {
				AbstractBootstrap.getInstance().getStage().addEventListener(event, displayKey, true);
            }
           // AbstractBootstrap.getInstance().getStage().focus=AbstractBootstrap.getInstance().getStage();
		}
		
		 override public function unload(targets:Array, action:IAction):void
        {
        	
            var event : String;
			for each ( event in this.events )
            {
        		AbstractBootstrap.getInstance().getStage().removeEventListener(event, displayKey, true);
            }
        }
        
		private function displayKey(keyEvent:KeyboardEvent) : void
		{
			var multipleKey : Boolean = key.indexOf("+") != -1;
			_keyPressed = false;
			var keyCode : String ; 
			if(multipleKey)
			{
				keyCode = key.split("+")[1];
				if(keyEvent[key.split("+")[0]])
				{
					_keyPressed = true;
				}
			}
			else
			{
				keyCode = key;
				_keyPressed = true;
			}
			
			if(keyEvent.keyCode.toString() == keyCode && _keyPressed)
			{
				
				_action.apply(keyEvent);
			}
			
		}
	}
}