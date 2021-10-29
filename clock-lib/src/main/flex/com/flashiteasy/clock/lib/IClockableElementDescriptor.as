package com.flashiteasy.clock.lib
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	public interface IClockableElementDescriptor extends IUIElementDescriptor
	{
		function setClock( type : String ) : void
	}
}