/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 * 
 */

package com.flashiteasy.api.action
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.action.IFullScreenAction;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * 
	 * The <code><strong>FullScreenElementAction</strong></code> class defines an Action that triggers one element on stage to FullScreen
	 */
	public class FullScreenElementAction extends Action implements IFullScreenAction
	{
		
		private var _element : IUIElementDescriptor;
		private var _elementName : String;
		
		
		private var _isFullScreen : Boolean;


		private var d : FieUIComponent=new FieUIComponent();
		private var currentObject:DisplayObject;
		private var initWidth:int;
		private var initHeight:int;
		private var initX:int;
		private var initY:int;
		private var parent:DisplayObjectContainer;
		private var index:int;
		
		/**
		 * 
		 * @default 
		 */
		public var hiddenControlsArray : Array = [];
		
		/**
		 * 
		 */
		public function FullScreenElementAction()
		{
			super();
		}
		
		/**
		 * 
		 * @param elementUuid : the visible control that will be displayed full screen
		 */
		public function setElementToFullScreen( elementUuid : String ) : void
		{
			//trace ("setElementToFullScreen uuid="+elementUuid);
			this.elementName = elementUuid;
			this.element = ElementList.getInstance().getElement( this.elementName, this.getPage());
		}
		
		
		override public function apply( event : Event ):void
		{
			setFull( event );
		}
		
		private function setFull(e:Event):void
		{
			if (AbstractBootstrap.CLIENT_STAGE.displayState != StageDisplayState.FULL_SCREEN)
			{
				var p : Point = element.getFace().localToGlobal(new Point(0, 0));
				var surfacePleinEcran : Rectangle;
				var m : Matrix = DisplayObject( element.getFace() ).transform.concatenatedMatrix;
				currentObject = DisplayObject( element.getFace() );
				surfacePleinEcran = new Rectangle(p.x, p.y, currentObject.width, currentObject.height);
				//hideElementsOverControl( currentObject )
				AbstractBootstrap.CLIENT_STAGE.fullScreenSourceRect=surfacePleinEcran;
				AbstractBootstrap.CLIENT_STAGE.displayState=StageDisplayState.FULL_SCREEN;
			}
			else
			{
				//showHiddenElements();
				AbstractBootstrap.CLIENT_STAGE.displayState=StageDisplayState.NORMAL;
			}
		}

		private function hideElementsOverControl( subject : DisplayObject ) : void
		{
			var elem : DisplayObject = subject;
			parent=elem.parent;
			index=parent.getChildIndex(elem);
			var l:uint = DisplayObjectContainer(subject.parent).numChildren;
			var i : int = -1;
			while(++i<l)
			{
				if (parent.getChildIndex( parent.getChildAt(i) ) > index)
				{
					parent.getChildAt(i).visible = false;
					hiddenControlsArray.push( parent.getChildAt(i) );
				}
			}
			
		}
		
		private function showHiddenElements():void
		{
			var l:uint = hiddenControlsArray.length;
			var i : int = -1;
			while(++i<l)
			{
				DisplayObject(hiddenControlsArray[i]).visible = true;
			}
		}

		private function fullScreen(e:FullScreenEvent):void
		{
		}

		/**
		 * 
		 * @private 
		 */
		public function get element() : IUIElementDescriptor
		{
			return _element;
		}


		/**
		 * 
		 * @param value
		 */
		public function set element( value : IUIElementDescriptor ) : void
		{
			_element = value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get elementName() : String
		{
			return _elementName;
		}


		/**
		 * 
		 * @param value
		 */
		public function set elementName( value : String ) : void
		{
			_elementName = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get isFullScreen() : Boolean
		{
			return _isFullScreen;
		}

		/**
		 * 
		 * @param value
		 */
		public function set isFullScreen( value : Boolean ) : void
		{
			_isFullScreen = value;
		}
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return FullScreenElementAction;
		}
		
		
	}
}