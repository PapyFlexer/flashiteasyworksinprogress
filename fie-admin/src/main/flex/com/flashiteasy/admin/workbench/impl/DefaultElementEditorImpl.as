package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.CommandBatch;
	import com.flashiteasy.admin.commands.ICommand;
	import com.flashiteasy.admin.commands.menus.ChangeParameterCommand;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.edition.IElementEditorPanel;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.event.FieAdminEvent;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.uicontrol.DelegateEditorPanel;
	import com.flashiteasy.admin.uicontrol.GroupEditorPanel;
	import com.flashiteasy.admin.uicontrol.ReflectionEditorPanel;
	import com.flashiteasy.admin.uicontrol.story.StoryEditor;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.admin.workbench.IElementEditor;
	import com.flashiteasy.admin.workbench.IWorkbench;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.container.DynamicListElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.CloneUtils;
	import com.flashiteasy.api.utils.ControlUtils;
	import com.flashiteasy.api.utils.ElementDescriptorFinder;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	import mx.core.Container;

	public class DefaultElementEditorImpl extends EventDispatcher implements IElementEditor
	{

		private var editorPanelsContainer:Container;
		private var workbench:IWorkbench;

		protected var descriptors:Array=[];
		private var parameterSets:Array=[];
		private var sharedParameters:Array=[];

		/**
		 * Starts editing a visual component
		 */
		public function editIfFace(face:DisplayObject, multipleSelect:Boolean=false):void
		{
			// Look for the descriptor using the selected face
			var descriptor:IUIElementDescriptor=ElementDescriptorFinder.findUIElementDescriptor(face, BrowsingManager.getInstance().getCurrentPage());
 			
			if (descriptor != null)
			{
				if(descriptor.getParent() is DynamicListElementDescriptor)
	 			{
	 				descriptor = descriptor.getParent();
	 			}
	 			
				if (multipleSelect)
				{
					addSelection(descriptor, true);
				}
				else
				{
					addSelection(descriptor, false);
				}

			}
			else
			{
				if (!(face is AbstractBootstrap))
				{
					editIfFace(face.parent, multipleSelect);
				}
			}
		}

		/**
		 * Starts editing an action
		 */
		public function editAction(action:IAction):void
		{
			if (descriptors[0] != action)
			{
				//On change of selected Elements we verify if change of parameters have been done
				Ref.adminManager.checkForCommitParameterChange();
				clearParameters();
				VisualSelector.getInstance().flushElements();
				ApplicationController.getInstance().getStoryEditor().getUIComponent().selectedIndex=-1;
				descriptors[descriptors.length]=action;
				parameterSets.push(ParameterIntrospectionUtil.retrieveParameterSets(action));
				sharedParameters=parameterSets[0].slice(0);
				actionParameterSets();

			}
		}

		public function editStory(s:Story):void
		{
			if (descriptors[0] != s)
			{
				//On change of selected Elements we verify if change of parameters have been done
				Ref.adminManager.checkForCommitParameterChange();
				clearParameters();
				VisualSelector.getInstance().flushElements();
				ApplicationController.getInstance().getActionEditor().getUIComponent().selectedIndex=-1;
				descriptors[descriptors.length]=s;
				//parameterSets.push(ParameterIntrospectionUtil.retrieveParameterSets(s));
				//sharedParameters=parameterSets[0].slice(0);
				storyParameterSets();
			}
		}

		private function addSelection(elem:IUIElementDescriptor, multipleSelect:Boolean):void
		{
			//On change of selected Elements we verify if change of parameters has been done
			Ref.adminManager.checkForCommitParameterChange();
			// Deselect items in action and story editors
			ApplicationController.getInstance().getActionEditor().getUIComponent().selectedIndex=-1;
			ApplicationController.getInstance().getStoryEditor().getUIComponent().selectedIndex=-1;

			if (multipleSelect)
			{
				// if the element is already selected , deselect it
				if (descriptors.indexOf(elem) != -1)
				{
					workbench.removeIndicator(descriptors.indexOf(elem));
					parameterSets.splice(descriptors.indexOf(elem), 1);
					descriptors.splice(descriptors.indexOf(elem), 1);
					ApplicationController.getInstance().getBlockList().removeSelection(elem);

				}
				// otherwise select it
				else
				{
					descriptors[descriptors.length]=elem;
					VisualSelector.getInstance().addElement(elem);
					parameterSets.push(ParameterIntrospectionUtil.retrieveParameterSets(elem));
					ApplicationController.getInstance().getBlockList().addSelection(elem, true);
				}
			}

			// it is a simple selection
			else
			{
				// deselect everything
				if (descriptors[0] != elem)
				{
					clearParameters();
					VisualSelector.getInstance().flushElements();
					VisualSelector.getInstance().addElement(elem);
					descriptors[descriptors.length]=elem;
					ApplicationController.getInstance().getBlockList().addSelection(elem, false);
					parameterSets.push(ParameterIntrospectionUtil.retrieveParameterSets(elem));
				}
				// Element already selected , do nothing
				else
				{
					return;
				}

			}
			triggerElementEdition();
		}


		public function setWorkbench(workbench:IWorkbench):void
		{
			this.workbench=workbench;
		}



		public function getParameterList(pSet:IParameterSet):Array
		{
			var typeDesc:XML=describeType(pSet);
			var accessors:XMLList=typeDesc..accessor;
			var members:Array=[];
			for each (var accessor:XML in accessors)
			{
				members.push(String(accessor.@name));
			}
			return members;
		}


		/**
		 * init values necessary to create parameter panels ;
		 */

		protected function triggerElementEdition():void
		{

			if (descriptors.length == 0)
			{
				clearParameters();
			}
			else
			{

				clearEditor();

				/*
				 * definit la liste des parametres en commun pour la
				 * liste des blocs selectionnés
				 */

				var hasParam:Boolean;
				var param:IParameterSet;
				var i:int=1;

				// initialize shared parameters to the parameters of the first selected control
				sharedParameters=parameterSets[0].slice(0);

				// Loop trough the parameters
				for (var j:int=0; j < sharedParameters.length; j++)
				{

					hasParam=false;
					// Loop trough the parameters of each selected control
					for (i=0; i < parameterSets.length; i++)
					{
						// Check if each each control share one parameter
						hasParam=false;
						if (ArrayUtils.contains(parameterSets[i], sharedParameters[j]))
						{
							hasParam=true;
						}
						// If one control doesn t have the parameter , then it is not a shared parameter
						else
						{
							break;
						}
					}
					// if the parameter is not contained in one control , then it is not a shared parameter and is removed from the list
					if (hasParam == false)
					{
						sharedParameters.splice(sharedParameters.indexOf(sharedParameters[j]), 1);
						j--;
					}
				}

				// --------------------------

				layoutParameterSets();
			}

		}


		public function reset(container:Container):void
		{
			editorPanelsContainer=container;
		}

		public function clearEditor():void
		{
			if (editorPanelsContainer != null)
			{
				editorPanelsContainer.removeAllChildren();
			}
		}
		
		public function clearElementEditor():void
		{
			clearParameters();
		}

		protected function clearParameters():void
		{
			descriptors=[];
			parameterSets=[];
			sharedParameters=[];
			clearEditor();
		}

		protected function actionParameterSets():void
		{
			var groupArray:Object={};
			for each (var pSet:IParameterSet in sharedParameters)
			{
				var editionDescriptor:ParameterSetEditionDescriptor=ParameterIntrospectionUtil.getParameterSetEditionDescriptor(pSet);
				var groupname:String=editionDescriptor.getGroupName();
				var groupPanel:GroupEditorPanel;
				if (groupArray[groupname] == undefined && groupname != null)
				{
					groupPanel=new GroupEditorPanel();
					groupPanel.name=groupname;
					if (!editorPanelsContainer.contains(DisplayObject(groupPanel)))
					{
						groupArray[groupname]=editorPanelsContainer.addChild(DisplayObject(groupPanel));
					}
					groupPanel.reset(editionDescriptor);
				}
				if (editionDescriptor.isEditable())
				{
					var panel:IElementEditorPanel=editionDescriptor.isReflection() ? new ReflectionEditorPanel() : new DelegateEditorPanel();
					if (!groupArray[groupname].contains(panel))
					{
						groupArray[groupname].addChild(panel);
					}
					panel.reset(this, editionDescriptor);
				}
			}
		}

		protected function storyParameterSets():void
		{
			var editor:StoryEditor=new StoryEditor;
			editor.setStory(descriptors[0] as Story);
			editorPanelsContainer.addChild(editor);
		}

		protected function layoutParameterSets():void
		{
			var groupArray:Object={};
			for each (var pSet:IParameterSet in sharedParameters)
			{
				var editionDescriptor:ParameterSetEditionDescriptor=ParameterIntrospectionUtil.getParameterSetEditionDescriptor(pSet);
				var groupname:String=editionDescriptor.getGroupName();
				var groupPanel:GroupEditorPanel;
				if (groupArray[groupname] == undefined && groupname != null)
				{
					groupPanel=new GroupEditorPanel();
					groupPanel.name=groupname;
					if (!editorPanelsContainer.contains(DisplayObject(groupPanel)))
					{
						groupArray[groupname]=editorPanelsContainer.addChild(DisplayObject(groupPanel));
					}
					groupPanel.reset(editionDescriptor);
				}
				if (editionDescriptor.isEditable())
				{
					var panel:IElementEditorPanel=editionDescriptor.isReflection() ? new ReflectionEditorPanel() : new DelegateEditorPanel();
					if (!groupArray[groupname].contains(panel))
					{
						groupArray[groupname].addChild(panel);
					}
					panel.reset(this, editionDescriptor);
				}

			}

			//==========
			VisualSelector.getInstance().bind();
		}


		public function getSelection():Array
		{
			return descriptors;
		}

		private var _parameterChangeBatchCommand:CommandBatch=new CommandBatch();

		public function get parameterChangeBatchCommand():CommandBatch
		{
			return _parameterChangeBatchCommand;
		}

		public function resetParameterChangeBatchCommand():void
		{
			_parameterChangeBatchCommand=new CommandBatch();
		}

		public function notifyParameterChange(propertyList:Array, editionDescriptor:ParameterSetEditionDescriptor, valueList:Object, oldValueList:Object):void
		{
			var descriptorsQueueCommand:CommandBatch=new CommandBatch();
			for each (var descriptor:IDescriptor in descriptors)
			{
				var parameterDescriptor:IParameterSet=ControlUtils.retrieveParameter(editionDescriptor.getParameterSet(), descriptor);
				//In case of invalid values ::
				if (valueList[descriptor.uuid] == null)
				{
					valueList[descriptor.uuid]=parameterDescriptor;
				}
				if (oldValueList[descriptor.uuid] == null)
				{
					oldValueList[descriptor.uuid]=parameterDescriptor;
				}
				var command:ICommand=new ChangeParameterCommand(descriptor, parameterDescriptor, propertyList, valueList[descriptor.uuid], oldValueList[descriptor.uuid], this);
				descriptorsQueueCommand.addCommand(command);
			}
			_parameterChangeBatchCommand.addAndRemoveCommand(descriptorsQueueCommand);
		}

		/*
		 * return a parameter value object for all selected blocs
		 *
		 */
		public function getParameterValueList(parameterList:Array, editionDescriptor:ParameterSetEditionDescriptor):Object
		{
			var valuesObject:Object=new Object;
			for each (var descriptor:IDescriptor in descriptors)
			{
				var descriptorName:String=descriptor.uuid;
				var parameterDescriptor:IParameterSet=ControlUtils.retrieveParameter(editionDescriptor.getParameterSet(), descriptor);
				var valueList:Array=new Array;
				for (var i:int=0; i < parameterList.length; i++)
				{
					if(parameterDescriptor[parameterList[i]] is Array)
					{
						valueList.push(CloneUtils.cloneArray(parameterDescriptor[parameterList[i]]));
					}
					else
					{
						valueList.push(CloneUtils.clone(parameterDescriptor[parameterList[i]]));
					}
				}
				valuesObject[descriptorName]=valueList;
			}
			return valuesObject;
		}

		public function parameterSetUpdated(pSet:IParameterSet):void
		{
			var members:Array=[];
			var processUIDescriptor:Boolean=false;

			for each (var descriptor:IDescriptor in descriptors)
			{
				var param:IParameterSet=ParameterIntrospectionUtil.retrieveParameter(pSet, descriptor);
				//Changed to only get one change
				for each (var prop:String in Ref.adminManager.changedParameterList)
				{
					param[prop]=pSet[prop];
				}
				//param[Ref.adminManager.changedParameter]=pSet[Ref.adminManager.changedParameter];
				param.apply(descriptor);

				if (descriptor is IUIElementDescriptor)
				{
					IUIElementDescriptor(descriptor).invalidate();
					processUIDescriptor=true;
				}
			}
			if (processUIDescriptor)
			{
				VisualSelector.getInstance().refresh();
				VisualSelector.getInstance().bind();
				dispatchEvent(new Event(FieAdminEvent.PARAMETER_UPDATED));
			}
		}

	}
}