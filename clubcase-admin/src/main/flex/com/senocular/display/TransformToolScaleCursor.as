// ActionScript file

package com.senocular.display
{
	import flash.events.Event;
	import flash.geom.Point;
	import mx.core.BitmapAsset;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	

	public class TransformToolScaleCursor extends TransformToolInternalCursor {

		
		[Bindable]
		[Embed(source='/assets/transform_tool/scale_cursor_horizontal.png')]
		private var cursor1:Class;	
		
		[Bindable]
		[Embed(source='/assets/transform_tool/scale_cursor_vertical.png')]
		private var cursor2:Class;	

		[Bindable]
		[Embed(source='/assets/transform_tool/scale_cursor_se_no.png')]
		private var cursor3:Class;	

		[Bindable]
		[Embed(source='/assets/transform_tool/scale_cursor_so_ne.png')]
		private var cursor4:Class;									
		
		private var cursorBmp:BitmapData;
		private var cursorCont1:Bitmap;
		private var cursorCont2:Bitmap;
		private var cursorCont3:Bitmap;
		private var cursorCont4:Bitmap;
		
		public function TransformToolScaleCursor() 
		{
			_mouseOffset = new Point(12, 12);
			cursorCont1 = BitmapAsset(new cursor1());
			cursorCont2 = BitmapAsset(new cursor2());
			cursorCont3 = BitmapAsset(new cursor3());
			cursorCont4 = BitmapAsset(new cursor4());

			icon.addChild(cursorCont1);
			icon.addChild(cursorCont2);
			icon.addChild(cursorCont3);
			icon.addChild(cursorCont4);
			
			cursorCont1.visible = false;
			cursorCont2.visible = false;
			cursorCont3.visible = false;
			cursorCont4.visible = false;
		}
	
		override public function draw(rot:int = 0):void 
		{
			super.draw();

			cursorCont1.visible = false;
			cursorCont2.visible = false;
			cursorCont3.visible = false;
			cursorCont4.visible = false;
			
			switch(rot)
			{
				case 1:
					cursorCont1.visible = true;
					break;
				case 2:
					cursorCont2.visible = true;
					break;
				case 4:
					cursorCont4.visible = true;
					break;
				case 3:
					cursorCont3.visible = true;
					break;
			}
		}
	
	override public function updateVisible(event:Event = null):void {
		super.updateVisible(event);
		if (event) {
			var reference:TransformToolScaleControl = event.target as TransformToolScaleControl;
			if (reference) {
				switch(reference) {
					case _transformTool.scaleTopLeftControl:
					case _transformTool.scaleBottomRightControl:
						//draw((getGlobalAngle(new Point(0,100)) + getGlobalAngle(new Point(100,0)))/2);
						draw(3);
						break;
					case _transformTool.scaleTopRightControl:
					case _transformTool.scaleBottomLeftControl:
						//draw((getGlobalAngle(new Point(0,-100)) + getGlobalAngle(new Point(100,0)))/2);
						draw(4);
						break;
					case _transformTool.scaleTopControl:
					case _transformTool.scaleBottomControl:
						//draw(getGlobalAngle(new Point(0,100)))
						draw(2);
						break;
					default:
						//draw(getGlobalAngle(new Point(100,0)));
						draw(1);
						break;
				}
			}
		}
	}
}

	
}