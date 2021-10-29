// ActionScript file
package com.senocular.display
{
	import flash.events.Event;
	import flash.display.BlendMode;
	
	public class TransformToolScaleControl extends TransformToolInternalControl 
	{
	
		function TransformToolScaleControl(name:String, interactionMethod:Function, referenceName:String) {
			super(name, interactionMethod, referenceName);
			this.blendMode = BlendMode.INVERT;
		}

		override public function draw(event:Event = null):void {
			super.draw();
			graphics.clear();
			graphics.lineStyle(.25, 0x000000);
			graphics.beginFill(0x0066FF, 0);
			var size:Number  = _transformTool.controlSize/1.5;
			var size2:Number = size/2;
			graphics.drawRect(-size2, -size2, size, size);
			graphics.endFill();
		}
}


	
}