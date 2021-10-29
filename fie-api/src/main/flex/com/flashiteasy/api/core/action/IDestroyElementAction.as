package com.flashiteasy.api.core.action
{
	import com.flashiteasy.api.core.project.Page;
	
	public interface IDestroyElementAction
	{
		function setElementsToDestroy(elements:Array, page : Page ):void
	}
}