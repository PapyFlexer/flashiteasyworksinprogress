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
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import flash.events.Event;
	
	//import mx.controls.Alert;
	
	/**
	 * @private
	 * 
	 * The <code><strong>TraceBehaviorParameterSet</strong></code> is a parameterSet
	 * used for debugging purposes, piping traces into a debugging panel.
	 */

	public class TraceBehaviorParameterSet extends AbstractParameterSet
	{
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target : IDescriptor ) : void
		{
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().addEventListener(trigger, showTrace );
			}
		}
		
		private function showTrace( event : Event ) : void
		{
			trace( message );
		}
		
		private var _m : String;
		
		/**
		 * 
		 * @return 
		 */
		public function get message() : String
		{
			
			return _m;
		}
		
		/**
		 * 
		 * @param m
		 */
		public function set message( m : String ) : void
		{
			_m = m;
			
		}
		
		private var _trigger : String;
		
		/**
		 * 
		 * @return 
		 */
		public function get trigger() : String
		{
			return _trigger;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set trigger( value : String ) : void
		{
			_trigger = value;
		}
	}
}