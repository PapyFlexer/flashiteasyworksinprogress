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

	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 * @private
	 */
	public class FullScreenParameterSet extends AbstractParameterSet
	{

		private var _enable:Boolean=false;
		private var _resize:Boolean=true;
		private var d:UIComponent=new UIComponent();
		private var currentObject:DisplayObject;
		private var initWidth:int;
		private var initHeight:int;
		private var initX:int;
		private var initY:int;
		private var parent:DisplayObjectContainer;
		private var index:int;

		override public function apply(target:IDescriptor):void
		{
			super.apply(target);

			if (enable)
			{
				trace("FullScreen Enable :: " + enable);
				IUIElementDescriptor(target).getFace().addEventListener(MouseEvent.CLICK, setFull);
				AbstractBootstrap.CLIENT_STAGE.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreen);

			}

		}

		private function fullScreen(e:FullScreenEvent):void
		{
			if (!e.fullScreen)
			{
				//fie_test.GLOBAL_STAGE.displayState=StageDisplayState.NORMAL;
				/*if (currentObject != null)
				{
					currentObject.scaleX=1;
					currentObject.scaleY=1;
					currentObject.width=initWidth;
					currentObject.height=initHeight;
					currentObject.x=initX;
					currentObject.y=initY;
				}
				if (AbstractBootstrap.getInstance().contains(d))
				{
					AbstractBootstrap.getInstance().removeChild(d);
					AbstractBootstrap.getInstance().removeChild(currentObject);
					parent.addChildAt(currentObject, index);
				}*/

			}
		}

		private function setFull(e:Event):void
		{

			trace("SetFullScreen Event :: " + String(e));
			if (AbstractBootstrap.CLIENT_STAGE.displayState != StageDisplayState.FULL_SCREEN)
			{
				var p:Point=e.target.localToGlobal(new Point(0, 0));
				var surfacePleinEcran:Rectangle;
				var m:Matrix=DisplayObject(e.target).transform.concatenatedMatrix;
				currentObject=DisplayObject(e.target);
				/*if (e.target.width * m.a < 600 || 600 - e.target.height * m.d < 600)
				{

					if (resize)
					{
						initWidth=e.target.width;
						initHeight=e.target.height;
						initX=e.target.x;
						initY=e.target.y;
						if (e.target.width > e.target.height)
						{

							currentObject.width=500 / m.a;
							e.target.height*=(500 / initWidth) / m.d;

						}
						else
						{
							currentObject.height=500 / m.d;
							e.target.width*=(500 / initHeight) / m.a;

						}
					}

					parent=e.target.parent;
					index=parent.getChildIndex(e.target as DisplayObject);

					e.target.parent.removeChild(e.target as DisplayObject);
					AbstractBootstrap.getInstance().addChild(d);
					AbstractBootstrap.getInstance().addChild(e.target as DisplayObject);
					d.width=600;
					d.height=600;
					d.x=p.x - ((600 - e.target.width * m.a) / 2);
					d.y=p.y - ((600 - e.target.height * m.d) / 2);

					d.graphics.clear();
					//d.graphics.beginFill(fie_test.bc, 1);
					d.graphics.beginFill(0xFFFFFF, 1)
					d.graphics.moveTo(0, 0);
					d.graphics.lineTo(600, 0);
					d.graphics.lineTo(600, 600);
					d.graphics.lineTo(0, 600);
					d.graphics.lineTo(0, 0);
					d.graphics.moveTo((600 - e.target.width * m.a) / 2, (600 - e.target.height * m.d) / 2);
					d.graphics.lineTo((600 - e.target.width * m.a) / 2, ((600 - e.target.height * m.d) / 2) + e.target.height * m.d);
					d.graphics.lineTo(((600 - e.target.width * m.a) / 2) + e.target.width * m.a, ((600 - e.target.height * m.d) / 2) + e.target.height * m.d);
					d.graphics.lineTo(((600 - e.target.width * m.a) / 2) + e.target.width * m.a, ((600 - e.target.height * m.d) / 2));
					d.graphics.lineTo(((600 - e.target.width * m.a) / 2), ((600 - e.target.height * m.d) / 2));
					d.graphics.endFill();
					//e.target.parent.addChild(d);

					//e.target.x=e.target.localToGlobal(new Point(0,0)).x;
					currentObject.x=p.x
					currentObject.scaleX=m.a;
					currentObject.scaleY=m.d;
					//e.target.y=e.target.localToGlobal(new Point(0,0)).y;
					currentObject.y=p.y;
					surfacePleinEcran=new Rectangle(d.x, d.y, d.width, d.height);
				}
				else
				{
					surfacePleinEcran=new Rectangle(p.x, p.y, e.target.width * m.a, e.target.height * m.d);
				}*/
				//var surfacePleinEcran:Rectangle = new Rectangle ( p.x, p.y, d.width, d.height );
				//surfacePleinEcran.width=525;
				//surfacePleinEcran.height=525;
				// la zone est spécifiée
				surfacePleinEcran=new Rectangle(p.x, p.y, e.target.width, e.target.height);

				AbstractBootstrap.CLIENT_STAGE.fullScreenSourceRect=surfacePleinEcran;
				AbstractBootstrap.CLIENT_STAGE.displayState=StageDisplayState.FULL_SCREEN;
			}
			else
			{

				AbstractBootstrap.CLIENT_STAGE.displayState=StageDisplayState.NORMAL;
			}
		}

		/**
		 * 
		 * @return 
		 */
		public function get enable():Boolean
		{
			return _enable;
		}

		/**
		 * 
		 * @param value
		 */
		public function set enable(value:Boolean):void
		{
			_enable=value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get resize():Boolean
		{
			return _resize;
		}

		/**
		 * 
		 * @param value
		 */
		public function set resize(value:Boolean):void
		{
			_resize=value;
		}
	}
}