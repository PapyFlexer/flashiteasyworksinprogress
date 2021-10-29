/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.action.IElementAction;
	import com.flashiteasy.api.core.elements.IPlayableElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;
	
	/**
	 * 
	 * The <code><strong>PlayElementAction</strong></code> class defines an Action that triggers 
	 * one or more "playable" Elements (swfs, videos, ...) on stage
	 */
	public class TogglePlayableElementAction extends Action implements IElementAction
	{
		
		/**
		 * 
		 * @default : the Array of animations to play 
		 */
		protected var _elementList : Array;
		private var elementsPage : Page ;
		
		/**
		 * Constructor
		 */
		public function TogglePlayableElementAction()
		{
			super();
		}
		
		/**
		 * 
		 * @param stories : Array of animations to be triggered
		 * @param page : page from the project where the animations are called
		 * Usually set in the same page as the action.
		 * TODO : make sub and parent pages available
		 */
		public function setElementsToTrigger(elements:Array, page : Page ):void
		{
			_elementList = elements;
			elementsPage = page;
		}

		override public function apply( event : Event ):void
		{
			for each (var uuid : String in _elementList)
			{
				var element : IDescriptor = ElementList.getInstance().getElement(uuid, elementsPage);
				 if (element is IPlayableElementDescriptor)
				 {
				 	IPlayableElementDescriptor(element).toggle();
				 }
			}
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
		 * @param value pushes a new playable element into the array of elements to  be played
		 */
		public function addElementToElementList( value : String ) : void
		{
			var el : IDescriptor = ElementList.getInstance().getElement( value, elementsPage);
			if (el is IPlayableElementDescriptor)
							_elementList.push( value );
		}
		
		/**
		 * 
		 * @param value withdraws an animation uuid from the string array of animations to  be played
		 */
		public function removeElementFromElementList( value : String ) : void
		{
			var el : IDescriptor = ElementList.getInstance().getElement( value, elementsPage);
			if (el is IPlayableElementDescriptor)
				_elementList.splice(_elementList.lastIndexOf(value),1);
		}

		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return TogglePlayableElementAction;
		}
		
	}
}