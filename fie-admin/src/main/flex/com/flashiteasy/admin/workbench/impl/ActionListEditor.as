package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.clipboard.ActionClipboard;
	import com.flashiteasy.admin.commands.menus.ActionDeletionCommand;
	import com.flashiteasy.admin.commands.menus.ChangeUuidCommand;
	import com.flashiteasy.admin.commands.menus.PasteActionCommand;
	import com.flashiteasy.admin.components.componentsClasses.ActionRenderer;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.event.ActionEvent;
	import com.flashiteasy.admin.popUp.InputStringPopUp;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.api.action.Action;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.NameUtils;
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.HorizontalList;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	public class ActionListEditor
	{
		private var list:HorizontalList;
		
        [Bindable]
        private var data:XMLList;
		private var lastRollOverIndex : int;
		[Bindable]
           private var cm:ContextMenu;
		
		public function ActionListEditor()
		{
			list = new HorizontalList();
			list.percentWidth = 100;
			list.verticalScrollPolicy = ScrollPolicy.OFF;
			list.labelFunction=setLabel;
			list.itemRenderer = new ClassFactory(ActionRenderer);
            list.addEventListener(ListEvent.ITEM_CLICK, selectItem);
            list.addEventListener(ActionEvent.REMOVE_ACTION, removeActionHandler);
           	list.addEventListener(FlexEvent.UPDATE_COMPLETE, validateWidth);
           	
			list.addEventListener(ListEvent.ITEM_ROLL_OVER, setIndex);
			initMenu();
		}
		private var maxW:int=20;
		public function setMaxWidth(max:int):void
		{
			maxW = Math.max(max, maxW);
		}
		public function validateWidth(e:FlexEvent):void
		{
			list.columnWidth = maxW;
		}
		
		
		private function contextMenuItem_copySelect(evt:ContextMenuEvent):void 
		{
			var obj:Object = list.selectedItem;
			var a : IAction = ActionList.getInstance().getAction(obj.@label, BrowsingManager.getInstance().getCurrentPage());
			ActionClipboard.getInstance().clear();
			ActionClipboard.getInstance().addAction(a.clone(true));
			ContextMenuItem(cm.customItems[1]).enabled = true;
			
		}
		
		private function contextMenuItem_editSelect(evt:ContextMenuEvent):void 
		{
			var obj:Object = list.selectedItem;
			var a : IAction = ActionList.getInstance().getAction(obj.@label, BrowsingManager.getInstance().getCurrentPage());
			
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
			var uuidArray:Array=NameUtils.getAllNames(BrowsingManager.getInstance().getCurrentPage());
			if (ArrayUtils.containsString(uuid, uuidArray))
			{
				namePopUp.setError(Conf.languageManager.getLanguage("The_Id_") + uuid + Conf.languageManager.getLanguage("_is_already_in_use_f"));
			}
			else
			{
				namePopUp.closePopUp();
				namePopUp.removeEventListener(PopUp.CLOSED, editCancel);
				namePopUp.removeEventListener(InputStringPopUp.SUBMIT, editPopUpHandler);
				ApplicationController.getInstance().getCommand().addCommand(new ChangeUuidCommand(uuid, list.selectedItem.@label, BrowsingManager.getInstance().getCurrentPage(), "IAction"));
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

		
		
		private function contextMenuItem_pasteSelect(evt:ContextMenuEvent):void
		{
			var obj:Object = list.selectedItem;
			var storedActions : Array = ActionClipboard.getInstance().getActions();
			ActionClipboard.getInstance().clear();
			if (storedActions.length > 0)
			{
				var pasteCommand : PasteActionCommand = new PasteActionCommand(storedActions, BrowsingManager.getInstance().getCurrentPage());
				ApplicationController.getInstance().getCommand().addCommand(pasteCommand);
			}
			fillClipBoard(storedActions);
		}
            
		private function contextMenu_menuSelect(evt:ContextMenuEvent):void 
		{
			list.selectedIndex = lastRollOverIndex;
		}
		
		private function fillClipBoard(actions : Array) :void
		{
			for each(var a:Action in actions)
			{
				ActionClipboard.getInstance().addAction(a.clone(true));
			}
		}
		
		
		
		private function initMenu():void 
		{
			
			var cmi:ContextMenuItem = new ContextMenuItem(Conf.languageManager.getLanguage("Copy")+" "+Conf.languageManager.getLanguage("action")+"...", true);
			cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_copySelect);
			var cmi1:ContextMenuItem = new ContextMenuItem(Conf.languageManager.getLanguage("Paste")+" "+Conf.languageManager.getLanguage("action")+"...", true);
			var cmi2:ContextMenuItem = new ContextMenuItem(Conf.languageManager.getLanguage("Edit")+" "+Conf.languageManager.getLanguage("action")+"...", true);

			cmi.enabled = false;
			cmi1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_pasteSelect);
			cmi1.enabled = false;
			cmi2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuItem_editSelect);
			cmi2.enabled = false;
			cm = new ContextMenu();
			cm.hideBuiltInItems();
			cm.customItems = [cmi,cmi1,cmi2];
			
			cm.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelect);
			list.contextMenu = cm;
		}
		
		/**
		 * Handles action selection and starts editing
		 */
        private function selectItem(e:ListEvent):void
        {
        	if ( list.selectedItem )
        	{
	            ApplicationController.getInstance().getElementEditor().editAction(ActionList.getInstance().getAction(list.selectedItem.@label,page));
        	}
        }
		
		private function setIndex(e:ListEvent) : void
		{
			lastRollOverIndex = e.columnIndex;
			ContextMenuItem(cm.customItems[0]).enabled = true;
			ContextMenuItem(cm.customItems[2]).enabled = true;
			trace("lastRollOverIndex"+lastRollOverIndex);
		}
		
        private function setLabel(item:Object):String{
            return item.@label; // + " " + item.@type ;
        }
        
        private var page:PageList;
        public function update():void
        {
            page=BrowsingManager.getInstance().getCurrentPage();
            data=ActionList.getInstance().getXML(Page(page));
            
			if(data == null)
			{
				ContextMenuItem(cm.customItems[0]).enabled = false;
				ContextMenuItem(cm.customItems[2]).enabled = false;
			}
			else
			{
				ContextMenuItem(cm.customItems[0]).enabled = data.length > 0;
				ContextMenuItem(cm.customItems[2]).enabled = data.length > 0;
			}
            list.dataProvider=data;
        }
        
        public function getUIComponent():HorizontalList
        {
            return list;
        }
        
        private function removeActionHandler( event : ActionEvent ) : void
        {
            removeAction(list.selectedItem.@label);
        }
        
        public function removeAction(actionId:String) : void
        {
        	
            page=BrowsingManager.getInstance().getCurrentPage();
        	ApplicationController.getInstance().getCommand().addCommand( new ActionDeletionCommand(ActionList.getInstance().getAction(actionId,page)) );
            ApplicationController.getInstance().getElementEditor().clearEditor();
           // ActionList.getInstance().removeAction(actionId, Page(page));
            update();
        }
	}
}