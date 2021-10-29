package com.flashiteasy.admin.uicontrol.controlmapper
{
	import com.flashiteasy.admin.parameter.Parameter;
	
	import flash.events.Event;
	
	import mx.core.IUIComponent;
	
	public interface IControlMapper
	{
		public function createControl(p:Parameter):IUIComponent;
		public function itemChanged(e:Event):void;
	}
}