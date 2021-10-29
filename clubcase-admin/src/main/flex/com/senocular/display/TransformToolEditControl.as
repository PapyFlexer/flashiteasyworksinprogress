package com.senocular.display
{

	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.senocular.events.TransformEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TransformToolEditControl extends TransformToolControl
	{
		[Embed(source='/assets/transform_tool/edit_page.png')]
		private var edit_ico:Class;
		private var editIco : Sprite = new Sprite;
		public function TransformToolEditControl()
		{
			addEventListener(TransformEvent.CONTROL_INIT, init, false, 0, true);
			
		}
		
		private function init(event:Event):void {
			
			// add event listeners 
			transformTool.addEventListener(TransformEvent.NEW_TARGET, update, false, 0, true);
			transformTool.addEventListener(TransformEvent.TRANSFORM_TOOL, update, false, 0, true);
			transformTool.addEventListener(TransformEvent.CONTROL_TRANSFORM_TOOL, update, false, 0, true);
			addEventListener(MouseEvent.CLICK, startEditMode , false , 0 , true );
			draw();
			// initial positioning
			update();
		}
		
		public function draw(event:Event = null):void {
			
				editIco.addChild(new edit_ico);
				addChild(editIco);
		}
		private function update(event:Event = null):void {
			if (transformTool.target) {
				var scale:Number = 1/Ref.workspaceContainer.scaleX;
				//Distance from boundsTopRigth (reference)
				var controlPadding:int=16*scale;
				var reference:Point = transformTool.boundsTopRight;
				var center:Point = transformTool.boundsCenter;
				var bottom:Point = transformTool.boundsBottomLeft;
				var diff:Point = reference.subtract(bottom);
				var angle:Number = Math.atan2(diff.y, diff.x);
				//Placing control with angle of transformTool
				if (reference) {
					//x = reference.x + controlPadding * Math.cos(angle);
					//y = reference.y + controlPadding * Math.sin(angle);
					//x=reference.x-controlPadding;
					//y = reference.y;
					x=center.x-controlPadding;
					y=center.y-controlPadding;
					
				}
				editIco.scaleX=scale;
				editIco.scaleY=scale;
				//editIco.x=-controlPadding/2;
				//editIco.y=-controlPadding/2;
			}
		}
		
		private function startEditMode( e : MouseEvent ): void 
		{
			VisualSelector.getInstance().editSimple(e);	
		}
		


	}
}