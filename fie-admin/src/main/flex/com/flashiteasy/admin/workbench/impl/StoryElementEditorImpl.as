package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.commands.CommandBatch;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	
	import flash.utils.Dictionary;

	public class StoryElementEditorImpl extends DefaultElementEditorImpl
	{
		private var overridesMap:Dictionary=new Dictionary(true);
		private var overridesProperty:Dictionary=new Dictionary(true);
		private var overridesBeginValue:Dictionary=new Dictionary(true);
		private var changedParameter:String=null;
		private var changedPSet:IParameterSet=null;

		public override function parameterSetUpdated(pSet:IParameterSet):void
		{
			super.parameterSetUpdated(pSet);

			setOverride(pSet);
			

		}
		
		public function emptyOverrideMap():void
		{
			overridesMap=new Dictionary(true);
			overridesProperty=new Dictionary(true);
			overridesBeginValue=new Dictionary(true);
			changedParameter=null;
			changedPSet=null;
			
		}
		
		public function setOverride(pSet:IParameterSet):void
		{
			for(var i:uint=0; i< super.descriptors.length; i++)
			{
			if (overridesMap[super.descriptors[i].uuid] == null)
			{
				overridesMap[super.descriptors[i].uuid]=new Array();

			}

			//if (Ref.adminManager.changedParameterList.length == 1)
			//{
				for ( var j:uint = 0; j<Ref.adminManager.changedParameterList.length; j++)
				{
				//Maybe not the best check but this condition avoid creation of to much update
				//because we play this fonction on each update of parameter
				//
				//var j:uint = 0
				if (Ref.adminManager.changedParameterList[j] != changedParameter || pSet != changedPSet)
				{
					var o:Object={param: pSet, prop: Ref.adminManager.changedParameterList[j]};
					changedPSet=pSet;
					changedParameter=Ref.adminManager.changedParameterList[j];
					if (!verifyPsetExist(super.descriptors[i].uuid))
					{
						overridesMap[super.descriptors[i].uuid].push(o);
						overridesBeginValue[o]=Ref.adminManager.previousValueList[super.descriptors[i].uuid];

					}

				}

			}
			}
			
		}
		
		
		
		private function verifyPsetExist(descriptorName:String):Boolean
		{
			var exist:Boolean=false;
			var parameters:Array=overridesMap[descriptorName];
			var updateNumber:int=0;

			for each (var o:Object in parameters)
			{
				if (o.param == changedPSet && o.prop == changedParameter)
				{
					exist=true;
					break;
				}
			}
			return exist;
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

		public function getOverridesMap():Dictionary
		{
			return overridesMap;
		}

		public function getChangedParameter(pSet:IParameterSet):String
		{
			return overridesProperty[pSet];
		}

		public function getBeginValue(o:Object):*
		{
			return overridesBeginValue[o];
		}
	}
}