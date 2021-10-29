/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 *
 */

package com.flashiteasy.api.controls
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.ICloneElementDescriptor;
	import com.flashiteasy.api.core.elements.IResizableElementDescriptor;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.NumberUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class CloneElementDescriptor extends SimpleUIElementDescriptor implements ICloneElementDescriptor, IResizableElementDescriptor
	{
		private var _mode:String;
		private var isResizable:Boolean
		private var _bm:Bitmap;
		private var _src:Sprite
		private var _bmd:BitmapData
		private var _target:IUIElementDescriptor;
		private var _applyEnterFrame:Boolean=false;
		
		private var _applyReflection : Boolean = false;

		private var _effectType:String;

		public function CloneElementDescriptor()
		{
			super();
		}

		public function cloneTarget(source:String, enterFrame:Boolean, applyReflection : Boolean):void
		{

			if (source != null && _target != null)
			{
				if (source != _target.uuid)
				{
					mustRefresh=true;
				}
			}
			_target=ElementList.getInstance().getElement(source, this.getPage());
			_applyEnterFrame=enterFrame;
			_applyReflection=applyReflection;

			if (_target != null)
			{
				if (SimpleUIElementDescriptor(_target).isLoaded())
				{
					setClone(new FieEvent(FieEvent.COMPLETE));
				}
				else
				{
					_target.addEventListener(FieEvent.COMPLETE, setClone);
				}
			}
		}

		private var mustRefresh:Boolean=false;
		private var cloneBitmapRef:DisplayObject;

		public function setClone(e:Event):void
		{


			if (_target != null)
			{
				_target.removeEventListener(FieEvent.COMPLETE, setClone);
				_src=Sprite(IUIElementDescriptor(_target).getFace());

				if (mustRefresh)
				{
					getFace().removeEventListener(Event.ENTER_FRAME, redrawMe);
					_bmd.fillRect(_bmd.rect, 0);
						//				_bmd.dispose();
				}

				var bmsource:IBitmapDrawable=IBitmapDrawable(_src); //, matrix, ct, blendMode, clipRect, smoothing
				//_bm.name = "cloneBitmap";

				trace("face have enterframeListener ? : " + getFace().hasEventListener(Event.ENTER_FRAME));
				if (_applyEnterFrame == true)
				{
					getFace().addEventListener(Event.ENTER_FRAME, redrawMe);
					trace("enterFrame is active : we should redraw");
				}
				else
				{
					getFace().removeEventListener(Event.ENTER_FRAME, redrawMe);
				}

				trace("face have enterframeListener after apply ? : " + getFace().hasEventListener(Event.ENTER_FRAME));
				drawContent();
				end();
			}
			else
			{
			}

		}

		private function redrawMe(e:Event):void
		{
			drawContent()
		}

		override protected function initControl():void
		{

		}

		override protected function onSizeChanged():void
		{
			drawContent();
		}

		override protected function drawContent():void
		{
			if (isResizable && _src != null)
			{

				var ratioW:Number=NumberUtils.roundDecimalToPlace((Math.abs(w) / _src.width), 2);
				var ratioH:Number=NumberUtils.roundDecimalToPlace((Math.abs(h) / _src.height), 2);
				var ratioMin:Number=NumberUtils.roundDecimalToPlace((Math.min(Math.abs(ratioH), Math.abs(ratioW))), 2);
				var ratioMax:Number=NumberUtils.roundDecimalToPlace((Math.max(Math.abs(ratioH), Math.abs(ratioW))), 2);
				var matrix:Matrix=new Matrix();
				var bmsource:IBitmapDrawable=IBitmapDrawable(_src);
				var scaleXMultiplier:int=w < 0 ? -1 : 1;
				var scaleYMultiplier:int=h < 0 ? -1 : 1;
				var ratioXMultiplier:int=_src.width < 0 ? -1 : 1;
				var ratioYMultiplier:int=_src.height < 0 ? -1 : 1;
				
				if (_bmd != null)
					_bmd.dispose();

				if (_mode == "scale")
				{
					matrix.scale(ratioMin * ratioXMultiplier, ratioMin * ratioYMultiplier);
					if (_src.width != 0 && _src.height != 0 && ratioMin != 0)
					{
						_bmd=new BitmapData(Math.abs(_src.width * ratioMin), Math.abs(_src.height * ratioMin), true, 0x00000000);

						_bmd.fillRect(_bmd.rect, 0);
						_bmd.draw(bmsource, matrix, null, null, null, true);
					}

				}
				else if (_mode == "fit")
				{

					matrix.scale(ratioW, ratioH);
					if (w != 0 && h != 0 && ratioW != 0 && ratioH != 0)
					{
						_bmd=new BitmapData(Math.abs(w), Math.abs(h), true, 0x00000000);

						_bmd.fillRect(_bmd.rect, 0);
						_bmd.draw(bmsource, matrix, null, null, null, true);
					}
				}
				else
				{
					if (_src.width != 0 && _src.height != 0)
					{
						matrix.scale(ratioXMultiplier, ratioYMultiplier);
						_bmd=new BitmapData(Math.abs(_src.width), Math.abs(_src.height), true, 0x00000000);
						_bmd.fillRect(_bmd.rect, 0);
						_bmd.draw(bmsource, matrix, null, null, null, true);
					}
				}
				var bitmapClipExist:Boolean=cloneBitmapRef != null ? getFace().contains(cloneBitmapRef) : false;
				if (bitmapClipExist)
				{
					_bm.bitmapData=_bmd;
				}
				else
				{
					_bm=new Bitmap(_bmd, PixelSnapping.ALWAYS, true);
					cloneBitmapRef=getFace().addChild(_bm);
				}
				if (ratioXMultiplier < 0)
				{
					cloneBitmapRef.x=scaleXMultiplier * cloneBitmapRef.width;
				}
				else
				{
					cloneBitmapRef.x=0;
				}
				if (ratioYMultiplier < 0)
				{
					cloneBitmapRef.y=scaleYMultiplier * cloneBitmapRef.height;
				}
				else
				{
					cloneBitmapRef.y=0;
				}
				cloneBitmapRef.scaleX=scaleXMultiplier * ratioXMultiplier;
				cloneBitmapRef.scaleY=scaleYMultiplier * ratioYMultiplier;
				
				
				if (applyReflection)
				{
					cloneBitmapRef.scaleY = -1;
					cloneBitmapRef.y = - cloneBitmapRef.height
					var maskingShape : Shape=new Shape();
					 
					getFace().addChild(maskingShape);
					maskingShape.scaleY=-1;
					maskingShape.x=0;
					maskingShape.y=cloneBitmapRef.y;
		
					var mat:Matrix= new Matrix();
					var colors:Array=[0xFF0000,0xFF0000];
					var alphas:Array=[0,0.7];
					var ratios:Array=[10,255];
					mat.createGradientBox(_src.width,_src.height,90*(Math.PI/180));
					maskingShape.graphics.lineStyle();
					maskingShape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
					maskingShape.graphics.drawRect(0,0,_src.width,_src.height);
					maskingShape.graphics.endFill();
					
					cloneBitmapRef.cacheAsBitmap=true;
					maskingShape.cacheAsBitmap=true;
					cloneBitmapRef.mask=maskingShape;
					
				}
			}
			else
			{
				end();
			}
			
		}

		/**
		 *
		 * @param resize
		 * @param mode
		 */
		public function setResize(resize:Boolean, mode:String):void
		{
			isResizable=resize;
			_mode=mode;
		}
		public function get applyEnterFrame():Boolean
		{
			return _applyEnterFrame;
		}

		public function set applyEnterFrame(value:Boolean):void
		{
			_applyEnterFrame=value;
		}


		public function get applyReflection():Boolean
		{
			return _applyReflection;
		}

		public function set applyReflection(value:Boolean):void
		{
			_applyReflection=value;
		}

		public function get src():Sprite
		{
			return _src;
		}

		public function set src(value:Sprite):void
		{
			_src=value;
		}

		public function get effectType():String
		{
			return _effectType;
		}

		public function set effectType(value:String):void
		{
			_effectType=value;
		}

		//public var maskingShape:Shape
		private function setReflection(myBitmapData : BitmapData):void
		{
			if (_src != null)
			{
			var picWidth:Number=_src.width;
			var picHeight:Number=_src.height;
			var gap:Number=1;
			var imgBD:BitmapData=BitmapData(_bmd);
			var topImg:Bitmap=new Bitmap(imgBD);
			var reflImg:Bitmap=new Bitmap(imgBD);
			//getFace().addChild(topImg);
			getFace().addChild(reflImg);			
			reflImg.scaleY=-1;
			//topImg.x=_src.x-picWidth/2;
			//topImg.y=220-picHeight/2-80;
			reflImg.x=0;
			reflImg.y=0;
			var maskingShape : Shape=new Shape();
			 
			getFace().addChild(maskingShape);
			maskingShape.scaleY=-1;
			maskingShape.x=0;
			maskingShape.y=reflImg.y;

			var mat:Matrix= new Matrix();
			var colors:Array=[0xFF0000,0xFF0000];
			var alphas:Array=[0,0.7];
			var ratios:Array=[10,255];
			mat.createGradientBox(_src.width,_src.height,90*(Math.PI/180));
			maskingShape.graphics.lineStyle();
			maskingShape.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
			maskingShape.graphics.drawRect(0,0,_src.width,_src.height);
			maskingShape.graphics.endFill();
			
			reflImg.cacheAsBitmap=true;
			maskingShape.cacheAsBitmap=true;
			reflImg.mask=maskingShape;
			}
		}



		override public function getDescriptorType():Class
		{

			return CloneElementDescriptor;
		}

		private function removeClone():void
		{
			getFace().removeEventListener(Event.ENTER_FRAME, redrawMe);
			var bitmapClipExist:Boolean=cloneBitmapRef != null ? getFace().contains(cloneBitmapRef) : false;
			if (bitmapClipExist)
				getFace().removeChild(cloneBitmapRef);
			cloneBitmapRef=null;
			if (_bmd != null)
				_bmd.dispose();
			_bmd=null;
			_src=null;
			_bm=null;
		}

		override public function destroy():void
		{
			removeClone();
			super.destroy();
		}

		override public function remove(e:Event):void
		{
			super.remove(e);
			removeClone();
		}

	}
}