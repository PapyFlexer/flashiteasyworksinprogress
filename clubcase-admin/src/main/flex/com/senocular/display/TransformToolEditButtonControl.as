package com.senocular.display
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.controls.ButtonElementDescriptor;
	import com.senocular.events.TransformEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TransformToolEditButtonControl extends TransformToolControl
	{
		public function TransformToolEditButtonControl()
		{
			addEventListener(TransformEvent.CONTROL_INIT, init, false, 0, true);
			
		}
		
		private function init(event:Event):void {
			
			// add event listeners 
			addEventListener(MouseEvent.CLICK, startEditMode , false , 0 , true );
		}
		
		private function startEditMode( e : Event ): void 
		{
			ApplicationController.getInstance().getWorkbench().openEditMode(VisualSelector.getInstance().getSelectedElement() as ButtonElementDescriptor);	
		}
		
	}
}