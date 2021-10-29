package com.flashiteasy.admin.utils
{
	import com.flashiteasy.api.action.Action;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.action.IElementAction;
	import com.flashiteasy.api.core.action.IStoryAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * Flash'Iteasy
	 * Fie team is
	 * dany, didier, gilles
	 * & many thanks to alexis, ghazi, jean-françois
	 */
	public class DestroyUtils
	{
		/**
		 * Static utility class to use when removing a control (by its uuid) from the page.
		 * It checks all stories, action and controls that are targetting thegiven control
		 * and returns them in a global object of this structure :
		 * <code>
		 * o.actions=[action1, action2, action3, ...];
		 * o.stories=[story1, story2, story3, ...];
		 * o.controls=[control1, control2, control3, ...];
		 * </code>
		 * As a static class, must be implemented like this :
		 * <code>
		 * import com.flashiteasy.admin.utils.DestroyUtils;
		 * DestroyUtils.checkControlDependancies ("myControl", homePage);
		 * </code>
		 * @param uuid the uuid of the control whose dependancies we have to check
		 * @param page the page element where the control to check is displayed
		 * @return the object containing arrays of stories, actions, and controls
		 */

		public static function checkControlDependancies(uuidList:Array, page:Page, addActions:Boolean=true):Object
		{
			var o:Object=new Object;
			o.actions=[];
			//o.controls = [];
			o.stories=[];
			for (var i:int=0; i < uuidList.length; i++)
			{
				var control:IUIElementDescriptor=ElementList.getInstance().getElement(uuidList[i], page);
				//check actions
				var actions:Array=ActionList.getInstance().getActions(page);
				for each (var action:Action in actions)
				{
					if(action is IElementAction)
					{
						for each (var id:String in IElementAction(action).elementList)
						{
							if (id == uuidList[i])
							{
								if (!ArrayUtils.isItemInArray(o.actions, action))
									o.actions.push(action);
							}
						}
					}
					
					for each (var name:String in action.targets)
					{
						//trace("name=" + name + "/uuid=" + uuidList[i])
						if (name == uuidList[i])
						{
							if (!ArrayUtils.isItemInArray(o.actions, action))
								o.actions.push(action);
						}
					}
					
				}
				// check stories
				var stories:Array=StoryList.getInstance().getStories(page);
				var storiesToRemove:Array=new Array;
				for each (var s:Story in stories)
				{
					if (s.getElementDescriptor() == control)
					{

						if (!ArrayUtils.isItemInArray(o.stories, s))
						{
							o.stories.push(s);
							if (addActions)
							{
								var StoryActionList:Array=checkStoryDependancies(s.uuid, page);
								for each (var a:Action in StoryActionList)
								{

									if (!ArrayUtils.isItemInArray(o.actions, a))
										o.actions.push(a);
								}
							}
						}
					}
				}
			}

			return o;
		}

		/**
		 * Static utility class to use when removing a story (by its name) from the page.
		 * It checks all actions targetting the given story
		 * and returns them in an Array of story names :
		 *
		 * @param storyName the name of the story whose dependancies we have to check
		 * @param page the page element where the control to check is displayed
		 * @return the array of actions targetting the story
		 */

		public static function checkStoryDependancies(storyName:String, page:Page):Array
		{
			var actionsToRemove:Array=new Array;
			//var actions : Array = page.getPageItems().pageActions;
			var actions:Array=ActionList.getInstance().getActions(page);
			for each (var action:Action in actions)
			{
				//var isStoryAction : Boolean = getQualifiedClassName(action).indexOf("Story") != -1;
				if (action is IStoryAction)
				//if(isStoryAction)
				{
					//if (ArrayUtils.contains(PlayStoryAction(action).storiesNameToPlay, storyName))
					if (ArrayUtils.isItemInArray(IStoryAction(action).storyList, storyName))
					{
						if (!ArrayUtils.isItemInArray(actionsToRemove, action))
							actionsToRemove.push(action);
					}
				}
			}
			return actionsToRemove;
		}


		public function iterate(func:Function, dispObjContainer:DisplayObjectContainer):void
		{
			for (var i:int; i < dispObjContainer.numChildren; i++)
			{
				var dispObj:DisplayObject=dispObjContainer.getChildAt(i);

				func(dispObj);

				if (dispObj is DisplayObjectContainer)
					this.iterate(func, dispObj as DisplayObjectContainer);
			}
		}

	}
}