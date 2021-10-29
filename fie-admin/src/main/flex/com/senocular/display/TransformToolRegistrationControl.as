// ActionScript file

package com.senocular.display
{
	import flash.events.Event;
	import flash.display.BlendMode;
	import flash.display.LineScaleMode;
	
	public class TransformToolRegistrationControl extends TransformToolInternalControl 
	{
			
		function TransformToolRegistrationControl(name:String, interactionMethod:Function, referenceName:String) 
		{
			super(name, interactionMethod, referenceName);
			this.blendMode = BlendMode.INVERT;
		}
	
		override public function draw(event:Event = null):void 
		{
			graphics.clear();
			var size:uint        = _transformTool.controlSize;
			var radius:Number    = size/3;
			var lineWidth:Number = size/3;
			
			if (!_skin) {
				graphics.lineStyle(0, 0x000000, 1, false, LineScaleMode.NONE);
				graphics.beginFill(0xFFFFFF, 0);
				graphics.drawCircle(0, 0, radius);
				
				graphics.moveTo(-radius, 0);
				graphics.lineTo((-radius)-lineWidth, 0);
				
				graphics.moveTo(radius, 0);
				graphics.lineTo((radius) + lineWidth, 0);
				
				graphics.moveTo(0, -radius);
				graphics.lineTo(0,  (-radius)-lineWidth);	
	
				graphics.moveTo(0, radius);
				graphics.lineTo(0, (radius)+lineWidth);
	
				graphics.endFill();
			}
			super.draw();
		}
	}
}