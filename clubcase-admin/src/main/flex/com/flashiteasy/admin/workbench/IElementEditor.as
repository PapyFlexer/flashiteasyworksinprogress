package com.flashiteasy.admin.workbench
{
	import com.flashiteasy.admin.commands.CommandBatch;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import mx.core.Container;

	public interface IElementEditor extends IEventDispatcher
	{
		function editIfFace(face:DisplayObject, multipleSelect:Boolean=false):void;

		function editAction(action:IAction):void;

		function editStory(s:Story):void;

		/**
		 * Initialize the editor using a specific container to host the edition components.
		 */
		function reset(container:Container):void;

		function setWorkbench(workbench:IWorkbench):void;

		/**
		 * Callback used by other components to notify the editor the parameter set
		 * for a given component has been updated.
		 */
		function parameterSetUpdated(pSet:IParameterSet):void;

		function clearEditor():void;
		function clearElementEditor():void;
		function notifyParameterChange(propertyList:Array, editionDescriptor:ParameterSetEditionDescriptor, valueList:Object, oldValueList:Object):void;
		function getParameterList(pSet:IParameterSet):Array
		function getParameterValueList(parameterList:Array, editionDescriptor:ParameterSetEditionDescriptor):Object;
		function get parameterChangeBatchCommand():CommandBatch;
		function resetParameterChangeBatchCommand():void;
	}
}