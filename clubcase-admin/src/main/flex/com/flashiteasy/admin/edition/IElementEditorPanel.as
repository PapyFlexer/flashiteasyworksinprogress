package com.flashiteasy.admin.edition
{
	import com.flashiteasy.admin.workbench.IElementEditor;
	
	import mx.core.IUIComponent;
	
	public interface IElementEditorPanel extends IUIComponent
	{
		function reset( editor : IElementEditor, descriptor : ParameterSetEditionDescriptor ) : void;
		function getDescriptor():ParameterSetEditionDescriptor;
	}
}