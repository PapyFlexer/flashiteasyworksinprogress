package com.flashiteasy.clouds.lib
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	public interface ICloudableElementDescriptor extends IUIElementDescriptor
	{
		function setMovingClouds( horizontalSpeed : int, verticalSpeed : int ) : void
	}
}