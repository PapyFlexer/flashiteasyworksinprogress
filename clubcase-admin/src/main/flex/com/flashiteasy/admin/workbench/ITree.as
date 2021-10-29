package com.flashiteasy.admin.workbench
{
	import com.flashiteasy.admin.components.CustomTree;
	import com.flashiteasy.admin.components.FileManipulationBar;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import mx.core.UIComponent;
	
	public interface ITree
	{

		function update( expand : Boolean = false ):void;
		function addSelection(descriptor:IUIElementDescriptor,multipleSelect:Boolean=false):void;
		function removeSelection(descriptor:IUIElementDescriptor):void;
		function isSelected(elem:IUIElementDescriptor):Boolean;
		function getUIComponent():UIComponent;
		function getTree():CustomTree;
		function getToolBar():FileManipulationBar;
		function clearSelection():void;
	}
}