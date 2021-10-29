// ActionScript file
package com.senocular.display
{
	import mx.core.MovieClipAsset;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import mx.core.BitmapAsset;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	public class TransformToolMoveCursor extends TransformToolInternalCursor {
		
		
		[Bindable]
		[Embed(source='/assets/transform_tool/move_cursor.png')]
		private var cursor:Class;
		
		
		public function TransformToolMoveCursor() 
		{
			_mouseOffset = new Point(12, 12);
		}
		
		override public function draw(rot:int = 0):void 
		{
			super.draw();
			icon.graphics.clear();
			
			var c:BitmapAsset = BitmapAsset(new cursor());
			var bmp:BitmapData = new BitmapData(c.width, c.height, true, 0x00FFFFFF);
			bmp.draw(c);
			
			icon.graphics.beginBitmapFill(bmp);
			icon.graphics.drawRect(0, 0, c.width, c.height);
			icon.graphics.endFill();

		}
	}

	
}