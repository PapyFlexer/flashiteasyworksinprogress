package com.senocular.display
{
	
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.senocular.events.TransformEvent;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class TransformToolDeleteControl extends TransformToolControl
	{
		
		public function TransformToolDeleteControl () {
			addEventListener(TransformEvent.CONTROL_INIT, init, false, 0, true);
		}
		
		public function init(event:Event):void {
			
			// add event listeners 
			transformTool.addEventListener(TransformEvent.NEW_TARGET, update, false, 0, true);
			transformTool.addEventListener(TransformEvent.TRANSFORM_TOOL, update, false, 0, true);
			transformTool.addEventListener(TransformEvent.CONTROL_TRANSFORM_TOOL, update, false, 0, true);
			addEventListener(MouseEvent.CLICK, deleteClick , false , 0 , true );
			draw();
			// initial positioning
			update();
		}
		
		private function update(event:Event = null):void {
			if (transformTool.target) {
				var scale:Number = 1/Ref.workspaceContainer.scaleX;
				//Distance from boundsTopRigth (reference)
				var controlPadding:int=16*scale;
				var reference:Point = transformTool.boundsTopRight;
				var bottom:Point = transformTool.boundsBottomLeft;
				var diff:Point = reference.subtract(bottom);
				var angle:Number = Math.atan2(diff.y, diff.x);
				//Placing control with angle of transformTool
				if (reference) {
					x = reference.x + controlPadding * Math.cos(angle);
					y = reference.y + controlPadding * Math.sin(angle);
				}
				deleteIco.scaleX=scale;
				deleteIco.scaleY=scale;
				deleteIco.x=-controlPadding/2;
				deleteIco.y=-controlPadding/2;
			}
		}
		
		private function deleteClick(event:MouseEvent):void 
		{
			VisualSelector.getInstance().destroyElement();

		}
		private var deleteIco : Sprite = new Sprite;
		public function draw(event:Event = null):void {
				var shape1:Shape = new Shape();
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(16, 16, (Math.PI/180)*90, 0, 00);
				var colors:Array = [ 0xffffff, 0xCC0000];
				var crosscolors:Array = [ 0xffffff, 0xdddddd];
				var alphas:Array = [ 0.8, 1.0];
				var crossalphas:Array = [ 1.0, 1.0];
				var ratios:Array = [ 0, 255];
				shape1.graphics.lineStyle(1,0xa1b0b6);
				shape1.graphics.beginGradientFill(GradientType.RADIAL,colors, alphas, ratios, matrix);
				shape1.graphics.drawEllipse(0,0,14,14);
				shape1.graphics.endFill();
				deleteIco.addChild(shape1);
				var shape2:Shape = new Shape();
				shape2.graphics.beginFill(0xFFFFFF,0xFF);
				//shape2.graphics.lineStyle(0.5, 0xFFFFFF,0xFF,true);
				shape2.graphics.beginFill(0xFFFFFF,0xFF);
				shape2.graphics.drawRect(0,4,10,2);
				shape2.graphics.endFill();
				shape2.graphics.beginFill(0xFFFFFF,0xFF);
				shape2.graphics.drawRect(4,0,2,10);
				shape2.graphics.endFill();
				shape2.rotation = 45;
				shape2.x = 7;
				shape2.y = 0;
				deleteIco.addChild(shape2);
				addChild(deleteIco);
			}
		
		
		
	}
}