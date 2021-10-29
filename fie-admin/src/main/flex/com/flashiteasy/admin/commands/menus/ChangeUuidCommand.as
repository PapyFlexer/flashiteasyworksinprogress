package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.utils.DestroyUtils;
	import com.flashiteasy.api.action.Action;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.action.IElementAction;
	import com.flashiteasy.api.core.action.IStoryAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.parameters.ToggleStoryParameterSet;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.StoryList;

	public class ChangeUuidCommand extends AbstractCommand
	{
		private var id:String;
		private var oldId:String;
		private var page:Page;
		private var actionsToChange:Array=null;
		private var type:String;

		public function ChangeUuidCommand(id:String, oldId:String, page:Page, type:String = "IUIElementDescriptor")
		{
			this.id=id;
			this.oldId=oldId;
			this.page=page;
			this.type=type;
		}

		public override function execute():void
		{
			if(type == "IAction")
			{
				var actionToRename:IAction = ActionList.getInstance().getAction(oldId, page);
				actionToRename.uuid = id;
				ApplicationController.getInstance().getActionEditor().update();
			}
			else if(type=="IStory")
			{
				actionsToChange = DestroyUtils.checkStoryDependancies(oldId,page);
				var story:Story = StoryList.getInstance().getStory(oldId, page);
				if (actionsToChange.length == 0)
				{
					story.uuid=id;
					ApplicationController.getInstance().getStoryEditor().update();
				}
				else
				{
					for each (var actionToChange:Action in actionsToChange)
					{
						if(actionToChange is IStoryAction)
						{
							var parameterSet: IParameterSet = Action(actionToChange).getParameterSet();
							IStoryAction(actionToChange).removeStoryFromStoryList(oldId);
							IStoryAction(actionToChange).addStoryToStoryList(id);
							for each(var param:IParameterSet in CompositeParameterSet(parameterSet).getParametersSet())
							{
								if(param is ToggleStoryParameterSet)
								{
									ToggleStoryParameterSet(param).storyList = IStoryAction(actionToChange).storyList;
									param.apply(actionToChange);
									
								}
							}
							
						}
					}
					//ApplicationController.getInstance().getActionEditor().update();
					story.uuid=id;
					ApplicationController.getInstance().getStoryEditor().update();
				}
			}
			else
			{
			var dependanciesObject:Object=DestroyUtils.checkControlDependancies([oldId], page, false);
			actionsToChange=dependanciesObject.actions;
			var elem:IUIElementDescriptor=ElementList.getInstance().getElement(oldId, page);
			if (actionsToChange.length == 0)
			{
				elem.uuid=id;

				ApplicationController.getInstance().getBlockList().update(true);
			}
			else
			{
				for each (var action:Action in actionsToChange)
				{
					if(action is IElementAction)
					{
						for each (var elementName:String in IElementAction(action).elementList)
						{
							if (elementName == oldId)
							{
								IElementAction(action).removeElementFromElementList(elementName);
								IElementAction(action).elementList.push(id);
								//IElementAction(action).addElementToElementList(id);
							}
						}
					}
					var index:int = -1;
					for each (var name:String in action.targets)
					{
						index++;
						if (name==oldId)
						{
							action.targets[index]=id;
						}
					}
				}
				elem.uuid=id;

				ApplicationController.getInstance().getBlockList().update(true);

			}
			}

		}

		public override function undo():void
		{
			if(type == "IAction")
			{
				var actionToRename:IAction = ActionList.getInstance().getAction(id, page);
				actionToRename.uuid = oldId;
				ApplicationController.getInstance().getActionEditor().update();
			}
			else if(type=="IStory")
			{
				actionsToChange = DestroyUtils.checkStoryDependancies(id,page);
				var story:Story = StoryList.getInstance().getStory(id, page);
				if (actionsToChange.length == 0)
				{
					story.uuid=oldId;
					ApplicationController.getInstance().getStoryEditor().update();
				}
				else
				{
					for each (var actionToChange:Action in actionsToChange)
					{
						if(actionToChange is IStoryAction)
						{
							var parameterSet: IParameterSet = Action(actionToChange).getParameterSet();
							IStoryAction(actionToChange).removeStoryFromStoryList(id);
							IStoryAction(actionToChange).addStoryToStoryList(oldId);
							for each(var param:IParameterSet in CompositeParameterSet(parameterSet).getParametersSet())
							{
								if(param is ToggleStoryParameterSet)
								{
									ToggleStoryParameterSet(param).storyList = IStoryAction(actionToChange).storyList;
									param.apply(actionToChange);
									
								}
							}
						}
					}
					story.uuid=oldId;
					ApplicationController.getInstance().getStoryEditor().update();
				}
			}
			
			else
			{
			var dependanciesObject:Object=DestroyUtils.checkControlDependancies([id], page, false);
			actionsToChange=dependanciesObject.actions;
			var elem:IUIElementDescriptor=ElementList.getInstance().getElement(id, page);
			if (actionsToChange.length == 0)
			{
				elem.uuid=oldId;
				ApplicationController.getInstance().getBlockList().update(true);
			}
			else
			{
				for each (var action:Action in actionsToChange)
				{
					if(action is IElementAction)
					{
						for each (var elementName:String in IElementAction(action).elementList)
						{
							if (elementName == id)
							{
								IElementAction(action).removeElementFromElementList(elementName);
								
								IElementAction(action).elementList.push(oldId);
								//IElementAction(action).addElementToElementList(oldId);
							}
						}
					}
					var index:int = -1;
					for each (var name:String in action.targets)
					{
						index++;
						if (name==id)
						{
							action.targets[index]=oldId;
						}
					}
				}
				elem.uuid=oldId;
				ApplicationController.getInstance().getBlockList().update(true);
			}
			}
		}

		public override function redo():void
		{
			execute();

		}

	}
}