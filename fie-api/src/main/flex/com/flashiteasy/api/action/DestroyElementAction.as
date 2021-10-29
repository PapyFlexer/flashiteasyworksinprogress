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
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.action.IDestroyElementAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;
	
	/**   @private **/

	public class DestroyElementAction extends Action implements IDestroyElementAction
	{	
		protected var _elementList : Array;
		private var elementsPage : Page ;
		private var target : IDescriptor;
		private var triggerControl : IDescriptor;
		
		/**
		 * 
		 * @param target
		 * @param parameterSet
		 * @param property
		 * @param value
		 */
		/**
		 * 
		 * @param stories : Array of animations to be triggered, here destroyed.
		 * @param page : page from the project where the actions are called
		 * Usually set in the same page as the action.
		 * TODO : make sub and parent pages available
		 */
		public function setElementsToDestroy(elements:Array, page : Page ):void
		{
			_elementList = elements;
			elementsPage = page;
		}

		
		override public function apply( event : Event ):void
		{
			for each (var uuid : String in elementList)
			{
				var controlToDestroy : IUIElementDescriptor = ElementList.getInstance().getElement( uuid, elementsPage );
				controlToDestroy.destroy();
			}
			trace ("controls destroyed, remaining controls :: "+elementList.toString());
		}

		/**
		 * 
		 * @return the Array of animations names to play (String)
		 * Getter
		 */
		public function get elementList() : Array
		{
			return _elementList;
		}
		
		/**
		 * 
		 * @param value the Array of animations names to play (String)
		 * Setter
		 */
		public function set elementList( value : Array ):void
		{
			_elementList = value;
		}
		
		/**
		 * 
		 * @param value pushes a new descriptor element uuid into the array of elements to  be destroyed
		 */
		public function addElementToElementList( value : String ) : void
		{
			var el : IDescriptor = ElementList.getInstance().getElement(value, elementsPage);
			if (el is IUIElementDescriptor)
						_elementList.push( value );
		}
		
		/**
		 * 
		 * @param value withdraws a control uuid from the string array of descriptors to  be destroyed
		 */
		public function removeElementFromElementList( value : String ) : void
		{
			var element : IDescriptor = ElementList.getInstance().getElement(value, elementsPage);
			if (element is IUIElementDescriptor)
				_elementList.splice(_elementList.lastIndexOf(value),1);
		}


		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return DestroyElementAction;
		}
	}
}