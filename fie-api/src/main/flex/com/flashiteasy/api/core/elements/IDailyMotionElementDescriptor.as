package com.flashiteasy.api.core.elements
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	public interface IDailyMotionElementDescriptor extends IUIElementDescriptor
	{	
		function setImage( source:String ) : void;
		function setDomain( url:String ) : void;
	}
}