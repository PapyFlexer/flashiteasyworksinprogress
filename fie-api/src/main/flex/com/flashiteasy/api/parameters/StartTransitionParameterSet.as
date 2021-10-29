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
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IStartTransitionElementDescriptor;
	import com.flashiteasy.api.events.FieEvent;
	import com.gskinner.motion.GTween;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @private
	 * 
	 * The <code><strong>StartTransitionParameterSet</strong></code> is the parameterSet
	 * that handles transitions
	 */

	public class StartTransitionParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{

		private var mask:UIComponent=new UIComponent();
		private var face:FieUIComponent;
		private var oldMask:DisplayObject;

		/**
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			super.apply(target);
			if ( target is IStartTransitionElementDescriptor )
			{
				IStartTransitionElementDescriptor(target).getFace().addEventListener(Event.ADDED_TO_STAGE, appear, false, 0, true);
				IStartTransitionElementDescriptor(target).getFace().addEventListener(FieEvent.SCALE, scaleMask, false, 0, true);
			}
		}

		private function calculateMask():void
		{
			var m:Matrix=(face as DisplayObject).transform.concatenatedMatrix;

			mask.height=face.height * m.d;
			mask.width=(face.width) * (m.a);
			mask.x=(face.localToGlobal(new Point(0, 0)).x);
			mask.y=(face.localToGlobal(new Point(0, 0)).y);
			mask.graphics.clear();
			mask.graphics.beginFill(0x000000, 1);
			mask.graphics.drawRect(0, 0, mask.width, mask.height);
			mask.graphics.endFill();
		}

		private function scaleMask(e:Event):void
		{
			face=e.target as FieUIComponent;
			calculateMask();
		}

		private function appear(e:Event):void
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE, appear);
			face=e.target as FieUIComponent;
			calculateMask();
			oldMask=e.target.mask;
			if (st != null)
			{

				var tmp:Number;
				var tween:GTween;
				switch (st)
				{
					case "left":
						trace("mask size " + mask.height + " " + mask.width + " " + mask.x + " " + mask.y + " " + e.target.x + " " + e.target.localToGlobal(new Point(0, 0)).x);
						tmp=e.target.x;
						e.target.mask=mask;

						AbstractBootstrap.CLIENT_STAGE.addChild(mask);
						tween=new GTween(e.target, 1, {x: tmp - 1000}, {swapValues: true});
						tween.onComplete=function():void
					{
						e.target.mask=oldMask;
						AbstractBootstrap.CLIENT_STAGE.removeChild(mask);
					};
						break;
					case "right":
						e.target.mask=mask;
						tmp=e.target.x;
						AbstractBootstrap.CLIENT_STAGE.addChild(mask);
						tween=new GTween(e.target, 1, {x: tmp + 1000}, {swapValues: true});
						tween.onComplete=function():void
					{
						e.target.mask=oldMask;
						AbstractBootstrap.CLIENT_STAGE.removeChild(mask);
					};
						break;
					case "top":
						e.target.mask=mask;
						tmp=e.target.y;
						AbstractBootstrap.CLIENT_STAGE.addChild(mask);
						tween=new GTween(e.target, 1, {y: tmp - 1000}, {swapValues: true});
						tween.onComplete=function():void
					{
						e.target.mask=oldMask;
						AbstractBootstrap.CLIENT_STAGE.removeChild(mask);
					};
						break;
					case "bottom":
						e.target.mask=mask;
						tmp=e.target.y;
						AbstractBootstrap.CLIENT_STAGE.addChild(mask);
						tween=new GTween(e.target, 1, {y: tmp + 1000}, {swapValues: true});
						tween.onComplete=function():void
					{
						e.target.mask=oldMask;
						AbstractBootstrap.CLIENT_STAGE.removeChild(mask);
					};
						break;
					case "alpha":
						tween=new GTween(e.target, 1, {alpha: 0}, {swapValues: true});

				}
			}
		}


		private function deleteMask(e:*):void
		{
			AbstractBootstrap.CLIENT_STAGE.removeChild(mask);
		}

		private function change(e:*):void
		{
			trace("on change tween");
		}

		private function complete(e:*):void
		{
			trace("complete tween");
		}
		private var st:String;

		/**
		 * 
		 * @return 
		 */
		public function get StartTransition():String
		{
			return st;
		}

		/**
		 * 
		 * @param value
		 */
		public function set StartTransition(value:String):void
		{
			st=value;
		}

		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return ["left", "top", "bottom", "right", "alpha"];
		}
	}
}