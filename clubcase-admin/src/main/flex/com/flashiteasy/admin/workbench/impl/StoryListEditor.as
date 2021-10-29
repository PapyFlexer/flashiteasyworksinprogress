package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.clipboard.StoryClipboard;
	import com.flashiteasy.admin.commands.menus.ChangeUuidCommand;
	import com.flashiteasy.admin.commands.menus.PasteStoryCommand;
	import com.flashiteasy.admin.commands.menus.ReverseStoryCommand;
	import com.flashiteasy.admin.commands.menus.StoryDeletionCommand;
	import com.flashiteasy.admin.components.componentsClasses.StoryRenderer;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.event.StoryEvent;
	import com.flashiteasy.admin.popUp.InputStringPopUp;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.admin.utils.DestroyUtils;
	import com.flashiteasy.api.action.Action;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Alert;
	import mx.controls.HorizontalList;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class StoryListEditor
	{
		public function StoryListEditor()
		{
			list=new HorizontalList();
			list.percentWidth=100;
			list.verticalScrollPolicy=ScrollPolicy.OFF;
			//list.labelFunction=setLabel;
			list.variableRowHeight=true;
			list.itemRenderer=new ClassFactory(StoryRenderer);
			list.addEventListener(ListEvent.ITEM_CLICK, selectItem);
			list.addEventListener(StoryEvent.REMOVE_STORY, removeStoryHandler);
			list.addEventListener(FlexEvent.UPDATE_COMPLETE, validateWidth);
			list.addEventListener(ListEvent.ITEM_ROLL_OVER, setIndex);
			initMenu();
		}

		private var actionsToDelete:Array=null;
		private var alert:Alert;
		[Bindable]
		private var cm:ContextMenu;

		[Bindable]
		private var data:XMLList;
		private var lastRollOverIndex:int;

		private var list:HorizontalList;
		private var maxW:int=20;

		private var page:Page;

		public function getUIComponent():HorizontalList
		{
			return list;
		}

		public function removeStory(storyId:String):void
		{

			ApplicationController.getInstance().getCommand().addCommand(new StoryDeletionCommand(StoryList.getInstance().getStory(storyId, page)));
			ApplicationController.getInstance().getElementEditor().clearEditor();
			//StoryList.getInstance().removeStory(storyId, page);
			update();
			//var timeline = Ref.stageTimeLine.initialized;
			if (Ref.stageTimeLine.initialized)
				Ref.stageTimeLine.refreshTimelines();
		}

		public function setMaxWidth(max:int):void
		{
			maxW=Math.max(max, maxW);
		}

		public function update():void
		{
			maxW=20;
			page=BrowsingManager.getInstance().getCurrentPage();
			data=StoryList.getInstance().getXML(Page(page));
			if (data == null)
			{
				ContextMenuItem(cm.customItems[0]).enabled=false;
				ContextMenuItem(cm.customItems[2]).enabled=false;
				ContextMenuItem(cm.customItems[3]).enabled=false;
			}
			else
			{
				ContextMenuItem(cm.customItems[0]).enabled=data.length > 0;
				ContextMenuItem(cm.customItems[2]).enabled=data.length > 0;
				ContextMenuItem(cm.customItems[3]).enabled=data.length > 0;
			}
			list.dataProvider=data;
		}

		public function validateWidth(e:FlexEvent):void
		{
			list.columnWidth=maxW;
		}

		private function contextMenuItem_copySelect(evt:ContextMenuEvent):void
		{
			var obj:Object=list.selectedItem;
			var s:Story=StoryList.getInstance().getStory(obj.@label, BrowsingManager.getInstance().getCurrentPage());
			StoryClipboard.getInstance().clear();
			StoryClipboard.getInstance().addStory(s.clone());

			ContextMenuItem(cm.customItems[1]).enabled=true;
		}

		private function contextMenuItem_pasteSelect(evt:ContextMenuEvent):void
		{
			var obj:Object=list.selectedItem;
			var storedStories:Array=StoryClipboard.getInstance().getStories();
			StoryClipboard.getInstance().clear();
			if (storedStories.length > 0)
			{
				var pasteCommand:PasteStoryCommand=new PasteStoryCommand(storedStories, BrowsingManager.getInstance().getCurrentPage());
				ApplicationController.getInstance().getCommand().addCommand(pasteCommand);
			}
			fillClipBoard(storedStories);
		}
		
		private function contextMenuItem_reverseSelect(evt:ContextMenuEvent):void
		{
			var obj:Object=list.selectedItem;
			var s:Story=StoryList.getInstance().getStory(obj.@label, BrowsingManager.getInstance().getCurrentPage());
			//StoryboardUtils.reverseStorySimple(s);
			var reverseCommand:ReverseStoryCommand=new ReverseStoryCommand([s], BrowsingManager.getInstance().getCurrentPage());
			ApplicationController.getInstance().getCommand().addCommand(reverseCommand);
			/*var storedStories:Array=StoryClipboard.getInstance().getStories();
			StoryClipboard.getInstance().clear();
			if (storedStories.length > 0)
			{
				var pasteCommand:PasteReverseStoryCommand=new PasteReverseStoryCommand(storedStories, BrowsingManager.getInstance().getCurrentPage());
				ApplicationController.getInstance().getCommand().addCommand(pasteCommand);
			}
			fillClipBoard(storedStories);*/
		}

		private function contextMenuItem_editSelect(evt:ContextMenuEvent):void
		{
			var obj:Object=list.selectedItem;

			namePopUp=new InputStringPopUp();
			namePopUp.description=Conf.languageManager.getLanguage("Change_name");
			namePopUp.label=Conf.languageManager.getLanguage("Name") + ": ";
			namePopUp.setInputDefaultValue(obj.@label);
			namePopUp.addEventListener(InputStringPopUp.SUBMIT, editPopUpHandler);
			namePopUp.addEventListener(PopUp.CLOSED, editCancel);

		}

		private var namePopUp:InputStringPopUp;


		private function startEdit():void
		{
		}

		private function editPopUpHandler(e:Event):void
		{
			var uuid:String=namePopUp.getInput();
			var uuidArray:Array=ActionList.getInstance().getActionsId(BrowsingManager.getInstance().getCurrentPage());
			if (ArrayUtils.containsString(uuid, uuidArray))
			{
				namePopUp.setError(Conf.languageManager.getLanguage("The_Id_") + uuid + Conf.languageManager.getLanguage("_is_already_in_use_f"));
			}
			else
			{
				namePopUp.closePopUp();
				namePopUp.removeEventListener(PopUp.CLOSED, editCancel);
				namePopUp.removeEventListener(InputStringPopUp.SUBMIT, editPopUpHandler);
				ApplicationController.getInstance().getCommand().addCommand(new ChangeUuidCommand(uuid, list.selectedItem.@label, BrowsingManager.getInstance().getCurrentPage(), "IStory"));
				/*IUIElementDescriptor(selectedControls[0]).uuid = uuid;
				   ApplicationController.getInstance().addToSaveList(page);
				 this.update(true);*/

			}
		}

		private function editCancel(e:Event):void
		{

			namePopUp.removeEventListener(PopUp.CLOSED, editCancel);
			namePopUp.removeEventListener(InputStringPopUp.SUBMIT, editPopUpHandler);
		}


		private function contextMenu_menuSelect(evt:ContextMenuEvent):void
		{
			list.selectedIndex=lastRollOverIndex;
		}

		private function fillClipBoard(stories:Array):void
		{
			for each (var s:Story in stories)
			{
				StoryClipboard.getInstance().addStory(s.clone());
			}
		}

		private function initMenu():void
		{
			var cmi:ContextMenuItem=new ContextMenuItem(Conf.languageManager.getLanguage("Copy") + " " + Conf.languageManager.getLanguage("story") + "...", true);
			cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_copySelect);
			var cmi1:ContextMenuItem=new ContextMenuItem(Conf.languageManager.getLanguage("Paste") + " " + Conf.languageManager.getLanguage("story") + "...", true);
			var cmi2:ContextMenuItem=new ContextMenuItem(Conf.languageManager.getLanguage("Edit") + " " + Conf.languageManager.getLanguage("story") + "...", true);
			var cmi3:ContextMenuItem=new ContextMenuItem(Conf.languageManager.getLanguage("Reverse") + " " + Conf.languageManager.getLanguage("story") + "...", true);
			cmi1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_pasteSelect);
			cmi3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_reverseSelect);
			cmi.enabled=false;
			cmi1.enabled=false;
			cmi3.enabled=false;
			cmi2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_editSelect);
			cmi2.enabled=false;
			cm=new ContextMenu();
			cm.hideBuiltInItems();
			cm.customItems=[cmi, cmi1, cmi2, cmi3];
			cm.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
			list.contextMenu=cm;
		}

		private function removeStoryAlertHandler(e:CloseEvent):void
		{
			switch (e.detail)
			{
				case Alert.OK:

					break;
				case Alert.YES:

					removeStory(list.selectedItem.@label);
					for each (var action:Action in actionsToDelete)
					{
						ApplicationController.getInstance().getActionEditor().removeAction(action.uuid);
					}
					break;
				case Alert.NO:

					removeStory(list.selectedItem.@label);
					break;
				case Alert.CANCEL:

					break;
			}
			actionsToDelete=null;
		}

		private function removeStoryHandler(event:StoryEvent):void
		{
			page=BrowsingManager.getInstance().getCurrentPage();
			var story:Story=StoryList.getInstance().getStory(list.selectedItem.@label, page);
			actionsToDelete=DestroyUtils.checkStoryDependancies(story.uuid, page);
			if (actionsToDelete.length == 0)
			{
				removeStory(list.selectedItem.@label);
			}
			else
			{
				Alert.okLabel=Conf.languageManager.getLanguage("Ok");
				Alert.yesLabel=Conf.languageManager.getLanguage("Yes");
				Alert.noLabel=Conf.languageManager.getLanguage("No");
				Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
				Alert.show(actionsToDelete.length + " " + Conf.languageManager.getLanguage("actions_use_this_story,_do_you_want_to_delete_them?"), Conf.languageManager.getLanguage("Story_have_dependancies"), Alert.YES | Alert.NO | Alert.CANCEL, mx.core.Application.application as Sprite, removeStoryAlertHandler);

				Alert.okLabel=Conf.languageManager.getLanguage("Ok");
				Alert.yesLabel=Conf.languageManager.getLanguage("Yes");
				Alert.noLabel=Conf.languageManager.getLanguage("No");
				Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
			}
		}

		/**
		 * Handles stories selection and starts editing
		 */
		private function selectItem(e:ListEvent):void
		{
			if (list.selectedItem)
			{
				page=BrowsingManager.getInstance().getCurrentPage();
				ApplicationController.getInstance().getElementEditor().editStory(StoryList.getInstance().getStory(list.selectedItem.@label, page));
			}
		}

		private function setIndex(e:ListEvent):void
		{
			lastRollOverIndex=e.columnIndex;
			trace("lastRollOverIndex" + lastRollOverIndex);
			ContextMenuItem(cm.customItems[0]).enabled=true;
			ContextMenuItem(cm.customItems[2]).enabled=true;
			ContextMenuItem(cm.customItems[3]).enabled=true;
		}

		private function setLabel(item:Object):String
		{

			return item.@uuid;
		}
	}
}