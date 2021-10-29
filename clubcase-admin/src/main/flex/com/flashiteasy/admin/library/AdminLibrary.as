package com.flashiteasy.admin.library
{
	import com.flashiteasy.admin.components.FilterEditorImpl;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.library.AbstractLibrary;
	
	public class AdminLibrary extends AbstractLibrary
	{
		//A try of instanciating adminLibrary as customEditor
		//but sprite cannot add UIComponents as children
		override protected function registerTypes() : void
		{
			AbstractParameterSet
			IocContainer.registerSimpleType(FilterEditorImpl);

		}
	}
}