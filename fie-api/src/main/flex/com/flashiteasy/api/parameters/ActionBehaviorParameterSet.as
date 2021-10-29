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
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import flash.events.Event;
	
	
	/**
	 * The <code><strong>ActionBehaviorParameterSet</strong></code> is a pseudo-abstract
	 * class handling generic actions on stage.
	 * As a pseudo-abstract, this ParameterSet class does not
	 * directly own any metadata.
	 */
	public class ActionBehaviorParameterSet extends AbstractParameterSet 
	{
		
		private var target:SimpleUIElementDescriptor;
	
	
		/**
		 * @inheritDoc
		 */
		override public function apply( target : IDescriptor ) : void
		{
			super.apply( target );
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().useHandCursor=true;
				IUIElementDescriptor(target).getFace().addEventListener(trigger, doAction );
			}
			
		}
		
		private function doAction( event : Event ) : void
		{
			this.target.changeXML(xml);
		}
		
		/*
		================================
		    GETTERS & SETTERS
		================================
		*/
		
		private var _xml : String;
		
		/**
		 * the xml describing the Action (non-visual control)
		 */
		public function get xml() : String
		{
			
			return _xml;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set xml( value : String ) : void
		{
			_xml = value;
			
		}
		
		private var _trigger : String;
		
		/**
		 * the trigger of the action, as a string
		 */
		public function get trigger() : String
		{
			return _trigger;
		}
		
		/**
		 * 
		 * @privatee
		 */
		public function set trigger( value : String ) : void
		{
			_trigger = value;
		}
		
	}
}