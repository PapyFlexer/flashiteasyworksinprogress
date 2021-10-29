/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */



// Copyright (c) 2010 Aaron Hardy
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

package com.flashiteasy.api.core
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
 
	/**
	 * When a display object has cacheAsBitmap set to true and a mask applied to it, a bug appears 
	 * in the Flash Player which prevents the display object from dispatching any mouse events.  The
	 * workaround is to have an outer display object which has cacheAsBitmap set to true and a 
	 * nested display object which has the mask. When we run into this scenario of having both
	 * cacheAsBitmap set to true and a mask, this sprite will create a nested sprite that will 
	 * contain the mask and all children.
	 */

	public class FieSprite extends Sprite
	{
		/**
		 * The nested sprite that will contain the children and the mask when nesting is needed.
		 */
		protected var nestedDisplay:Sprite;
 
		private var _nest:Boolean;
 
		/**
		 * Whether to nest a sprite to support a filter and a mask.
		 */
		protected function get nest():Boolean
		{
			return _nest;
		}
 
		/**
		 * @private
		 */
		protected function set nest(value:Boolean):void
		{
			if (_nest != value)
			{
				value ? doNest() : doUnnest();
				_nest = value;
			}
		}
 
		/**
		 * Moves children and any mask to a nested sprite.
		 */
		protected function doNest():void
		{
			if (nestedDisplay)
			{
				throw new Error('nestedDisplay should not exist.');
			}
 
			addEventSwallowers();
 
			nestedDisplay = new Sprite();
			nestedDisplay.mouseEnabled = false;
 
			var i:int = numChildren - 1;
 
			while (i > -1)
			{
				nestedDisplay.addChildAt(removeChildAt(i), 0);
				i--;
			}
 
			addChild(nestedDisplay);
 
			nestedDisplay.mask = mask;
			super.mask = null;
 
			removeEventSwallowers();
		}
 
		/**
		 * Moves children and mask from the nested sprite to the parent (this sprite).
		 */
		protected function doUnnest():void
		{
			if (!nestedDisplay)
			{
				throw new Error('nestedDisplay should exist.');
			}
 
			addEventSwallowers();
 
			super.mask = nestedDisplay.mask;
			nestedDisplay.mask = null;
 
			var i:int = nestedDisplay.numChildren - 1;
 
			while (i > -1)
			{
				addChildAt(nestedDisplay.getChildAt(i), 0);
				i--;
			}
 
			removeChild(nestedDisplay);
			nestedDisplay = null;
 
			removeEventSwallowers();
		}
 
		/**
		 * Adds listeners for events that will be dispatched while nesting or unnesting.  We don't
		 * want these events to be dispatched because the process should be as transparent as
		 * possible.
		 */
		protected function addEventSwallowers():void
		{
			addEventListener(Event.ADDED, swallowEvent);
			addEventListener(Event.REMOVED, swallowEvent);
			addEventListener(Event.REMOVED_FROM_STAGE, swallowEvent);
			addEventListener(Event.ADDED_TO_STAGE, swallowEvent);
		}
 
		/**
		 * cf #addEventSwallowers()
		 */
		protected function removeEventSwallowers():void
		{
			removeEventListener(Event.ADDED, swallowEvent);
			removeEventListener(Event.REMOVED, swallowEvent);
			removeEventListener(Event.REMOVED_FROM_STAGE, swallowEvent);
			removeEventListener(Event.ADDED_TO_STAGE, swallowEvent);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function set filters(value:Array):void
		{
			super.filters = value; // Filters always go on the outer.
			evaluateForNesting();
		}
 
		/**
		 * @inheritDoc
		 */
		override public function set cacheAsBitmap(value:Boolean):void
		{
			super.cacheAsBitmap = value;
			evaluateForNesting();
		}
 
		/**
		 * @inheritDoc
		 */
		override public function get mask():DisplayObject
		{
			if(enableNesting)
			{
				return nest ? nestedDisplay.mask : super.mask;
			}
			else
			{
				return	super.mask;
			}
		}
 
		/**
		 * @private
		 */		
		override public function set mask(value:DisplayObject):void
		{
			if(enableNesting)
			{
				nest ? nestedDisplay.mask = value : super.mask = value;
				evaluateForNesting();
			}
			else
			{
				super.mask = value;
			}
		}
 		
 		private var _enableNesting : Boolean = true;
 		
 		public function set enableNesting(value : Boolean) : void
 		{
 			_enableNesting = value;
 		}
 		
 		public function get enableNesting() : Boolean
 		{
 			return _enableNesting;
 		}
		/**
		 * Determine whether nesting is needed.
		 */
		protected function evaluateForNesting():void
		{
			nest = graphicsRequested || (cacheAsBitmap && mask);
		}
 
		/**
		 * Whether graphics have been requested at least once. Because graphical drawings can't
		 * be moved to/from the nested sprite, we must always have a nested sprite and use its
		 * graphics once graphics is requested for the first time.
		 */
		protected var graphicsRequested:Boolean = false;
 
		/**
		 * @inheritDoc
		 */
		override public function get graphics():Graphics
		{
			graphicsRequested = true;
			nest = true;
			return nestedDisplay.graphics;
		}
 
		/**
		 * @inheritDoc
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return nest ? nestedDisplay.addChild(child) : super.addChild(child);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return nest ? nestedDisplay.addChildAt(child, index) : super.addChildAt(child, index);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return nest ? nestedDisplay.removeChild(child) : super.removeChild(child);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			return nest ? nestedDisplay.removeChildAt(index) : super.removeChildAt(index);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			return nest ? nestedDisplay.getChildAt(index) : super.getChildAt(index);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function getChildIndex(child:DisplayObject):int
		{
			return nest ? nestedDisplay.getChildIndex(child) : super.getChildIndex(child);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			nest ? nestedDisplay.setChildIndex(child, index) : super.setChildIndex(child, index);
		}
 
		/**
		 * @inheritDoc
		 */
		override public function get numChildren():int
		{
			return nest ? nestedDisplay.numChildren : super.numChildren;
		}
 
		/**
		 * Stops propagation of the event.
		 */
		protected function swallowEvent(event:Event):void
		{
			event.stopImmediatePropagation();
		}


	}
}