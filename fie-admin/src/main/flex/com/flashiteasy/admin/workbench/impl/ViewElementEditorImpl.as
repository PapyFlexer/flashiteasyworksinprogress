package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.commands.CommandBatch;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	
	import flash.display.DisplayObject;

	public class ViewElementEditorImpl extends DefaultElementEditorImpl
	{
		

		public override function parameterSetUpdated(pSet:IParameterSet):void
		{
			//Do Nothing here ?
			

		}
		
		
		public override function editIfFace(face:DisplayObject, multipleSelect:Boolean=false):void
		{
			//Do Nothing here ?
		}
		public override function notifyParameterChange(propertyList:Array, editionDescriptor:ParameterSetEditionDescriptor, valueList:Object, oldValueList:Object):void
		{

		}


		private var _parameterChangeBatchCommand:CommandBatch=new CommandBatch();

		public override function get parameterChangeBatchCommand():CommandBatch
		{
			return _parameterChangeBatchCommand;
		}

		public override function resetParameterChangeBatchCommand():void
		{
			 
		}

	}
}