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
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.selection.ElementList;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * The <code><strong>TargetParameterSet</strong></code> is the parameterSet
	 * that handles the targetting of a control by another one on stage. It is
	 * mostly used in actions.
	 * One of its notable use is in conjonction with a control containing a SWF animation.
	 * When targeted, one call call functions or methods embedded in the SWF using the
	 * <code>apply_function</code> property.
	 */

	public class TargetParameterSet extends AbstractParameterSet
	{
		/**
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			super.apply(target);
			if (targets != "" && target is IUIElementDescriptor)
			{
				page=IUIElementDescriptor(target).getPage();

				if (trigger == "" || trigger == null)
				{
					IUIElementDescriptor(target).getFace().addEventListener(MouseEvent.MOUSE_UP, startFunction);
				}
				else
				{
					IUIElementDescriptor(target).getFace().addEventListener(trigger, startFunction);
				}
			}
		}

		private var page:PageList;

		private function startFunction(e:Event):void
		{
			if (params == "")
				ElementList.getInstance().getElement(targets, page)[apply_function].apply(ElementList.getInstance().getElement(targets, page));
			else
				ElementList.getInstance().getElement(targets, page)[apply_function].apply(ElementList.getInstance().getElement(targets, page), params.split(","));

		}
		private var _targets:String="";

		/**
		 * Sets the uuid of the targeted control
		 */
		public function get targets():String
		{
			return _targets;
		}

		/**
		 * 
		 * @private
		 */
		public function set targets(value:String):void
		{
			_targets=value;
		}

		private var _apply_function:String;


		/**
		 * Sets the method/function name to apply in target
		 * 		 
		 **/
		public function get apply_function():String
		{
			return _apply_function;
		}

		/**
		 * 
		 * @private
		 */
		public function set apply_function(value:String):void
		{
			_apply_function=value;
		}

		private var _params:String="";

		/**
		 * Sets the arguments of the function to apply in a string separated by commas
		 */
		public function get params():String
		{
			return _params;
		}

		/**
		 * 
		 * @private
		 */
		public function set params(value:String):void
		{
			_params=value;
		}
		private var _trigger:String="";

		/**
		 * Sets the trigger of the targeted control
		 */
		public function get trigger():String
		{
			return _trigger;
		}

		/**
		 * 
		 * @private
		 */
		public function set trigger(value:String):void
		{
			_trigger=value;
		}
	}
}
