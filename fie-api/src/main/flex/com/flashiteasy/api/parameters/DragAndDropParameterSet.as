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
	
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @private
	 * this ParameterSet has not been implemented yet
	 */
	public class DragAndDropParameterSet extends AbstractParameterSet
	{
		private var _enable:Boolean;
		private var _trigger:String;
		
		override public function apply( target : IDescriptor ) : void
		{
			super.apply( target );
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().addEventListener(MouseEvent.MOUSE_DOWN, Drag );
				IUIElementDescriptor(target).getFace().addEventListener(MouseEvent.MOUSE_UP, Drop );
			}
		}
		
		private function Drag( event : MouseEvent ) : void
		{
			event.stopPropagation(); 
			if( enable )
			{
				event.currentTarget.startDrag();
			}
		}
		private function Drop( event : MouseEvent ) : void
		{
			event.stopPropagation(); 
			event.currentTarget.stopDrag();
			
		}
		/**
		 * 
		 * @return 
		 */
		public function get enable():Boolean{
			return _enable;
		}
		/**
		 * 
		 * @param value
		 */
		public function set enable(value:Boolean):void{
			_enable=value;
		}
		/*public function get trigger():String{
			return _trigger;
		}
		public function set trigger(value:String):void{
			_trigger=value;
		}*/
	}
}