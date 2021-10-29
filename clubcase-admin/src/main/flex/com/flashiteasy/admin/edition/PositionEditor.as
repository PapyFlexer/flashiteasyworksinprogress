package com.flashiteasy.admin.edition
{
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class PositionEditor extends DisplayObject
	{
		
		private var elem:IUIElementDescriptor;
		private var positionParameter:PositionParameterSet;
		private var selection:Canvas = new Canvas();
		
		public function PositionEditor()
		{
			this.addEventListener( MouseEvent.MOUSE_DOWN , beginSelection );
		}
		
		public function register( elem: IUIElementDescriptor):void{
			this.elem=elem;
			positionParameter=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), elem ) as PositionParameterSet;
		}
		
		private function beginSelection(e:MouseEvent):void{
			this.addEventListener(MouseEvent.MOUSE_MOVE,selectionMove);
			this.addEventListener(MouseEvent.MOUSE_UP,selectionEnd);
		}
		
		private function selectionMove(e:MouseEvent):void{
			
		}
		
		private function selectionEnd(e:MouseEvent):void{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,selectionMove);
			this.removeEventListener(MouseEvent.MOUSE_UP,selectionEnd);
		}

	}
}