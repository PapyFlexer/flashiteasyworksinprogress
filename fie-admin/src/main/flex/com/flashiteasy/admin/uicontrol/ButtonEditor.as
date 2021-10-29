package com.flashiteasy.admin.uicontrol
{
	import com.flashiteasy.api.controls.ButtonElementDescriptor;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ItemClickEvent;

	public class ButtonEditor extends Canvas
	{
		
		private var button : ButtonElementDescriptor ;
		
		public function ButtonEditor( button : ButtonElementDescriptor)
		{
			this.button=button;
			var wrapper:UIComponent=new UIComponent();
			addChild(wrapper);
			wrapper.addChild(button.getNormalState().getFace());
			super();
		}
	}
}