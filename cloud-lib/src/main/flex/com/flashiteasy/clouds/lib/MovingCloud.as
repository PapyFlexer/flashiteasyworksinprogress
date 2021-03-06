package com.flashiteasy.clouds.lib
{
	import com.flashiteasy.api.utils.DisplayListUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MovingCloud extends Sprite {
		
		public var numOctaves:int;
		public var skyColor:uint;
		public var cloudsHeight:int;
		public var cloudsWidth:int;
		public var periodX:Number;
		public var periodY:Number;
		public var scrollAmountX:int;
		public var scrollAmountY:int;
		public var maxScrollAmount:int;
		
		private var cloudsBitmapData:BitmapData;
		private var cloudsBitmap:Bitmap;
		private var cmf:ColorMatrixFilter;
		private var blueBackground:Shape = null;
		private var displayWidth:Number;
		private var displayHeight:Number;
		private var seed:int;
		private var offsets:Array;
		private var sliceDataH:BitmapData;
		private var sliceDataV:BitmapData;
		private var sliceDataCorner:BitmapData;
		private var horizCutRect:Rectangle;
		private var vertCutRect:Rectangle;
		private var cornerCutRect:Rectangle;
		private var horizPastePoint:Point;
		private var vertPastePoint:Point;
		private var cornerPastePoint:Point;
		private var origin:Point;
		private var cloudsMask:Shape = null;
		
		public function MovingCloud(w:int = 300, h:int = 200, scX:int = -1, scY:int = 2, useBG:Boolean = false, col:uint = 0x2255aa) {
			
			DisplayListUtils.removeAllChildren(this);
			displayWidth = w;
			displayHeight = h;
			cloudsWidth = Math.floor(1.5*displayWidth);
			cloudsHeight = Math.floor(1.5*displayHeight);
			periodX = periodY = 150;
			
			scrollAmountX = scX;
			scrollAmountY = scY;
			maxScrollAmount = 50;
			
			numOctaves = 5;
			
			skyColor = col;
				
			cloudsBitmapData = new BitmapData(cloudsWidth,cloudsHeight,true);
			cloudsBitmap = new Bitmap(cloudsBitmapData);
				
			origin = new Point(0,0);
			
			cmf = new ColorMatrixFilter([0,0,0,0,255,
										 0,0,0,0,255,
										 0,0,0,0,255,
										 1,0,0,0,0]);
			
			//if(cloudsMask == null)
				cloudsMask = new Shape();
			cloudsMask.graphics.clear();
			cloudsMask.graphics.beginFill(0xFFFFFF);
			cloudsMask.graphics.drawRect(0,0,displayWidth,displayHeight);
			cloudsMask.graphics.endFill(); 
			
			if (useBG) {
				//if(blueBackground == null)
					blueBackground = new Shape();
				blueBackground.graphics.clear();
				blueBackground.graphics.beginFill(skyColor);
				blueBackground.graphics.drawRect(0,0,displayWidth,displayHeight);
				blueBackground.graphics.endFill();
				//if(!this.contains(blueBackground))
					this.addChild(blueBackground);
			}
			//if(!this.contains(cloudsBitmap))
				this.addChild(cloudsBitmap);
			//if(!this.contains(cloudsMask))
				this.addChild(cloudsMask);
			cloudsBitmap.mask = cloudsMask;
							
			makeClouds();
			setRectangles();
			if(!this.hasEventListener(Event.ADDED_TO_STAGE))
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(evt:Event):void {
			trace("i'm a cloud layer and i'm being added to stage!!!");
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			//this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			this.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		public function removedFromStage():void {
			//this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			//this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		public function setRectangles():void {
			//clamp scroll amounts
			scrollAmountX = (scrollAmountX > maxScrollAmount) ? maxScrollAmount : ((scrollAmountX < -maxScrollAmount) ? -maxScrollAmount : scrollAmountX);
			scrollAmountY = (scrollAmountY > maxScrollAmount) ? maxScrollAmount : ((scrollAmountY < -maxScrollAmount) ? -maxScrollAmount : scrollAmountY);
			
			if (scrollAmountX != 0) {
				sliceDataV = new BitmapData(Math.abs(scrollAmountX), cloudsHeight - Math.abs(scrollAmountY), true);
			}
			if (scrollAmountY != 0) {
				sliceDataH = new BitmapData(cloudsWidth, Math.abs(scrollAmountY), true);
			}
			if ((scrollAmountX != 0)&&(scrollAmountY != 0)) {
				sliceDataCorner = new BitmapData(Math.abs(scrollAmountX), Math.abs(scrollAmountY), true);
			}
			horizCutRect = new Rectangle(0, cloudsHeight - scrollAmountY, cloudsWidth - Math.abs(scrollAmountX), Math.abs(scrollAmountY));
			vertCutRect = new Rectangle(cloudsWidth - scrollAmountX, 0, Math.abs(scrollAmountX), cloudsHeight - Math.abs(scrollAmountY));
			cornerCutRect = new Rectangle(cloudsWidth - scrollAmountX, cloudsHeight - scrollAmountY,Math.abs(scrollAmountX), Math.abs(scrollAmountY));
			
			horizPastePoint = new Point(scrollAmountX, 0);
			vertPastePoint = new Point(0, scrollAmountY);
			cornerPastePoint = new Point(0, 0);
			
			if (scrollAmountX < 0) {
				cornerCutRect.x = vertCutRect.x = 0;
				cornerPastePoint.x = vertPastePoint.x = cloudsWidth + scrollAmountX;
				horizCutRect.x = -scrollAmountX;
				horizPastePoint.x = 0;
			}
			if (scrollAmountY < 0) {
				cornerCutRect.y = horizCutRect.y = 0;
				cornerPastePoint.y = horizPastePoint.y = cloudsHeight + scrollAmountY;
				vertCutRect.y = -scrollAmountY;
				vertPastePoint.y = 0;
			}
			
		}
		
		public function makeClouds():void {
			seed = int(Math.random()*0xFFFFFFFF);
			
			//create offsets array:
			offsets = new Array();
			for (var i:int = 0; i<=numOctaves-1; i++) {
				offsets.push(new Point());
			}
		
			//draw clouds
			cloudsBitmapData.perlinNoise(periodX,periodY,numOctaves,seed,true,true,1,true,offsets);
			cloudsBitmapData.applyFilter(cloudsBitmapData, cloudsBitmapData.rect, new Point(), cmf);
			
		}
		
		public function onEnter(evt:Event):void {
			cloudsBitmapData.lock();
			
			//copy to buffers the part that will be cut off
			if (scrollAmountX != 0) {
				sliceDataV.copyPixels(cloudsBitmapData, vertCutRect, origin);
			}
			if (scrollAmountY != 0) {
				sliceDataH.copyPixels(cloudsBitmapData, horizCutRect, origin);
			}
			if ((scrollAmountX != 0)&&(scrollAmountY != 0)) {
				sliceDataCorner.copyPixels(cloudsBitmapData, cornerCutRect, origin);
			}
			
			//scroll
			cloudsBitmapData.scroll(scrollAmountX, scrollAmountY);
			
			//draw the buffers on the opposite sides
			if (scrollAmountX != 0) {
				cloudsBitmapData.copyPixels(sliceDataV, sliceDataV.rect, vertPastePoint);
			}
			if (scrollAmountY != 0) {
				cloudsBitmapData.copyPixels(sliceDataH, sliceDataH.rect, horizPastePoint);
			}
			if ((scrollAmountX != 0)&&(scrollAmountY != 0)) {
				cloudsBitmapData.copyPixels(sliceDataCorner, sliceDataCorner.rect, cornerPastePoint);
			}
			
			cloudsBitmapData.unlock();
		}

		
		//public function get
	}
	
}
