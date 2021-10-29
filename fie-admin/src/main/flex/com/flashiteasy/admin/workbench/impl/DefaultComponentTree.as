package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.clipboard.ControlClipboard;
	import com.flashiteasy.admin.commands.CommandBatch;
	import com.flashiteasy.admin.commands.CommandQueue;
	import com.flashiteasy.admin.commands.menus.ActionDeletionCommand;
	import com.flashiteasy.admin.commands.menus.ChangeUuidCommand;
	import com.flashiteasy.admin.commands.menus.ElementDestructionCommand;
	import com.flashiteasy.admin.commands.menus.PasteActionCommand;
	import com.flashiteasy.admin.commands.menus.PasteCommand;
	import com.flashiteasy.admin.commands.menus.PasteStoryCommand;
	import com.flashiteasy.admin.commands.menus.StoryDeletionCommand;
	import com.flashiteasy.admin.commands.menus.SwapDepthCommand;
	import com.flashiteasy.admin.components.CustomTree;
	import com.flashiteasy.admin.components.FileManipulationBar;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.popUp.InputStringPopUp;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.admin.utils.DestroyUtils;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.admin.workbench.ITree;
	import com.flashiteasy.api.action.Action;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ElementDescriptorUtils;
	import com.flashiteasy.api.utils.NameUtils;

	import flash.display.Sprite;
	import flash.events.Event;

	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.buttonBarClasses.ButtonBarButton;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;

	public class DefaultComponentTree implements ITree
	{

		private var tree:CustomTree;
		private var selection:Array=[];

		private var contentBox:VBox;
		private var toolBar:FileManipulationBar;
		private var title:Label;
		private var pasteAllowed:Boolean=false;
		private var currentAction:String;
		[Bindable]
		private var data:XMLListCollection=new XMLListCollection();

		private var selectedControls:Array=[];
		private var provider:XML;

		public function DefaultComponentTree()
		{
			contentBox=new VBox();
			contentBox.percentHeight=100;
			/*title = new Label;
			   title.width =200;
			   title.setStyle("fontWeight","bold");
			   title.text="Page Blocks";
			 */
			toolBar=new FileManipulationBar();
			toolBar.disableAll();
			toolBar.hideAdd();
			toolBar.disablePaste();

			// Initializing tree

			tree=new CustomTree();
			tree.addEventListener(ListEvent.ITEM_CLICK, selectItem);
			tree.addEventListener(ListEvent.CHANGE, treeChanged);
			tree.width=200;
			tree.allowMultipleSelection=true;
			tree.dataProvider=data;
			tree.labelFunction=setLabel;
			tree.allowDragFunctions=true;
			tree.addEventListener(DragEvent.DRAG_DROP, handleDragComplete);
			tree.addEventListener(DragEvent.DRAG_START, handleDragStart);
			tree.percentHeight=100;
			// ======================

			toolBar.addEventListener(ItemClickEvent.ITEM_CLICK, selectButton);
			//contentBox.addChild(title);
			contentBox.addChild(tree);
			contentBox.addChild(toolBar);
		}

		private function treeChanged(e:Event):void
		{
			if (tree.selectedItems.length == 0)
			{
				toolBar.disableAll();
			}
			else
			{
				toolBar.enableAll();

			}
			if (ControlClipboard.getInstance().isEmpty())
			{
				toolBar.disablePaste();
			}
			else
			{
				toolBar.enablePaste();
			}
			if (tree.selectedItems.length == 0)
			{
				VisualSelector.getInstance().flushElements();
			}
		}

		public function getToolBar():FileManipulationBar
		{
			return toolBar;
		}


		public function getTree():CustomTree
		{
			return tree;
		}

		public function getUIComponent():UIComponent
		{
			return contentBox;
		}

		public function expandTree():void
		{
			tree.callLater(tree.expandAll);
		}

		private var draggedItems:Array=[];

		private function handleDragStart(e:DragEvent):void
		{
			draggedItems=[];
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			for (var i:int=0; i < tree.selectedItems.length; i++)
			{
				draggedItems.push(ElementList.getInstance().getElement(tree.selectedItems[i].@label, page));
			}
		}

		private function handleDragComplete(e:DragEvent):void
		{
			var control:IUIElementDescriptor
			var controlsToPaste:Array=[]; // Item to drop
			var parent:IUIElementContainer; // parent of dropped item
			var dropData:Object=tree.getDropData();
			var droppingNode:*=tree.getDropParent(e);
			var queue:CommandQueue=new CommandQueue();
			/*
			   Change the presentation order on the tree
			   to have the higher element on top so we have to add the number of children
			   to dropData.index, checking if we are on a node or at the root of the tree
			 */
			var totalIndex:int=droppingNode != null ? XML(droppingNode).children().length() - 1 : tree.dataProvider.length - 1; //dropData.rowIndex;//da.rowCount;
			var index:int=totalIndex < dropData.index ? 0 : totalIndex - dropData.index;
			try
			{
				//Index of dropped item in it s parent don't add totalIndex if you want lower element on top
				//see ElementList in API
				// Block where to paste controls
				parent=getContainerFromNode(droppingNode);
				//var totalIndex:int = parent.getChildren().length-1;
				// Starting drop functions
				if (e.action == "copy")
				{
					for each (control in draggedItems)
					{
						controlsToPaste.push(control.clone());
					}
					queue.addCommand(new PasteCommand(controlsToPaste, BrowsingManager.getInstance().getCurrentPage(), parent));
					VisualSelector.getInstance().flushElements();
				}
				else
				{
					for each (control in draggedItems)
					{
						controlsToPaste.push(control.clone(true));
						queue.addCommand(new ElementDestructionCommand(control));


					}
					queue.addCommand(new PasteCommand(controlsToPaste, BrowsingManager.getInstance().getCurrentPage(), parent));
					VisualSelector.getInstance().flushElements();

					for each (control in draggedItems)
					{
						queue.addCommand(new SwapDepthCommand(control, "" + index, parent));
					}
				}
				queue.addEventListener(Event.COMPLETE, queueEnded);
				ApplicationController.getInstance().getCommand().addCommand(queue);
				toolBar.disableAll();
			}
			catch (e:Error)
			{

			}
			tree.dispatchEvent(new Event(ListEvent.CHANGE));

			tree.callLater(setSelectedItem);
		}

		private function queueEnded(e:Event):void
		{
			update(true);
		}

		private function setLabel(item:Object):String
		{
			return item.@label; // + " " + item.@type ;
		}

		private function selectItem(e:ListEvent):void
		{
			if (tree.selectedItems.length > 1)
			{
				ApplicationController.getInstance().getElementEditor().editIfFace(ElementList.getInstance().getElement(tree.selectedItem.@label, page).getFace(), true);
			}
			else if (tree.selectedItems.length == 1)
			{
				ApplicationController.getInstance().getElementEditor().clearElementEditor();
				ApplicationController.getInstance().getElementEditor().editIfFace(ElementList.getInstance().getElement(tree.selectedItem.@label, page).getFace());
			}
		}

		public function addSelection(descriptor:IUIElementDescriptor, multipleSelect:Boolean=false):void
		{
			if (multipleSelect)
			{
				selection.push(descriptor.uuid);
				selectedControls.push(descriptor);
			}
			else
			{
				selection.splice(0);
				selection.push(descriptor.uuid);
				selectedControls.splice(0);
				selectedControls.push(descriptor);
			}
			tree.callLater(setSelectedItem);
		}

		private function setSelectedItem():void
		{
			tree.selectedItems=[];
			var item:String;
			var items:Array=[];
			var data:XMLList=this.data.source;
			var nodeXml:XMLList;

			for each (item in selection)
			{

				if (data.(@label == item).toXMLString().length > 1)
				{
					items.push(data.(@label == item)[0]);
				}
				else
				{
					items.push(data..*.(@label == item)[0]);
				}
			}

			for each (var node:XML in items)
			{
				if (node != null)
				{
					if (node.parent() != null)
					{
						tree.expandParents(node.parent());
					}
				}
			}
			tree.selectedItems=items;
			tree.scrollToIndex(getTopIndex(tree.selectedIndices));
			tree.invalidateDisplayList();
			tree.dispatchEvent(new Event(ListEvent.CHANGE));
		}

		private function getTopIndex(indices:Array):int
		{
			var topIndex:int=0;
			for each (var index:int in indices)
			{
				topIndex=Math.max(topIndex, index);
			}
			return topIndex;
		}

		public function removeSelection(descriptor:IUIElementDescriptor):void
		{
			selection.splice(tree.selectedItems.indexOf(descriptor.uuid), 1);
			tree.selectedItems.splice(tree.selectedItems.indexOf(descriptor.uuid), 1); //selection;
			tree.dispatchEvent(new Event(ListEvent.CHANGE));
		}

		public function clearSelection():void
		{
			if (tree.selectedItems.length > 0 && selection.length > 0)
			{
				selection=[];
				tree.selectedItems=selection;
				tree.dispatchEvent(new Event(ListEvent.CHANGE));
			}
		}
		private var page:Page;

		public function update(expand:Boolean=false):void
		{
			page=BrowsingManager.getInstance().getCurrentPage();
			data.source=ElementList.getInstance().getXML(page).children();
			if (expand)
			{
				expandTree();
			}
			selection=[];
			tree.selectedItems=[];
			tree.dispatchEvent(new Event(ListEvent.CHANGE));
		}

		public function isSelected(elem:IUIElementDescriptor):Boolean
		{
			return ArrayUtils.containsString(elem.uuid, this.selection);
		}

		private function getUuidList():Array
		{
			var controls:Array=selectedControls.slice(0);
			var uuidList:Array=ElementDescriptorUtils.deepList(controls, false, []);
			return uuidList;
		}

		private var actionsToDelete:Array=null;
		private var storiesToDelete:Array=null;

		private function selectButton(e:ItemClickEvent):void
		{
			var item:ButtonBarButton=toolBar.getChildAt(e.index) as ButtonBarButton;
			var itemId:String=toolBar.dataProvider[e.index].id;

			var uuidlist:Array=getUuidList();
			var dependanciesObject:Object=DestroyUtils.checkControlDependancies(uuidlist, BrowsingManager.getInstance().getCurrentPage());
			actionsToDelete=dependanciesObject.actions;
			storiesToDelete=dependanciesObject.stories;
			switch (itemId)
			{
				case "delete":




					if (actionsToDelete.length == 0 && storiesToDelete.length == 0)
					{

						var queue:CommandQueue=new CommandQueue();
						for (var i:int=0; i < tree.selectedItems.length; i++)
						{
							queue.addCommand(new ElementDestructionCommand(ElementList.getInstance().getElement(tree.selectedItems[i].@label, page)));
						}
						ApplicationController.getInstance().getCommand().addCommand(queue);
					}
					else
					{

						var alertString:String=(actionsToDelete.length != 0 && storiesToDelete.length != 0) ? Conf.languageManager.getLanguage("Actions_and_stories") : actionsToDelete.length != 0 ? Conf.languageManager.getLanguage("Some_actions") : Conf.languageManager.getLanguage("Some_animations");
						Alert.okLabel=Conf.languageManager.getLanguage("Delete_All");
						Alert.yesLabel=Conf.languageManager.getLanguage("Delete_Actions");
						Alert.noLabel=Conf.languageManager.getLanguage("No");
						Alert.buttonWidth=150;
						Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
						Alert.show(alertString + " " + Conf.languageManager.getLanguage("use_this_element,_do_you_want_to_delete_them?"), Conf.languageManager.getLanguage("Elements_have_dependancies"), Alert.OK | Alert.YES | Alert.CANCEL, mx.core.Application.application as Sprite, removeStoryAlertHandler);

						Alert.okLabel=Conf.languageManager.getLanguage("Ok");
						Alert.yesLabel=Conf.languageManager.getLanguage("Yes");
						Alert.noLabel=Conf.languageManager.getLanguage("No");
						Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
					}
					break;
				case "cut":
					cut();
					break;
				case "copy":
					copy();
					break;
				case "paste":
					var storedControls:Array=ControlClipboard.getInstance().getControls();
					var storedActions:Array=ControlClipboard.getInstance().getActions();
					var storedStories:Array=ControlClipboard.getInstance().getStories();
					ControlClipboard.getInstance().clear();
					//ActionClipboard.getInstance().clear();
					if (tree.selectedItems.length == 0)
					{
						if (page.hasContainer())
						{
							paste(storedControls, storedActions, storedStories, ElementList.getInstance().getElement(page.container, page.getParent()) as IUIElementContainer);
						}
						else
						{
							paste(storedControls, storedActions, storedStories, null);
						}
					}
					else
					{
						paste(storedControls, storedActions, storedStories, getContainerFromLabel(tree.selectedItems[0].@label));
					}
					actionsToDelete=storedActions;
					storiesToDelete=storedStories;
					fillClipboard(storedControls);
					break;
				case "edit":
					if (tree.selectedItems.length == 1)
						startEdit();
					break;
			}
		}


		private var namePopUp:InputStringPopUp;


		private function startEdit():void
		{
			namePopUp=new InputStringPopUp();
			namePopUp.description=Conf.languageManager.getLanguage("Change_name");
			namePopUp.label=Conf.languageManager.getLanguage("Name") + ": ";
			namePopUp.setInputDefaultValue(tree.selectedItem.@label);
			namePopUp.addEventListener(InputStringPopUp.SUBMIT, editPopUpHandler);
			namePopUp.addEventListener(PopUp.CLOSED, editCancel);
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
				ApplicationController.getInstance().getCommand().addCommand(new ChangeUuidCommand(uuid, IUIElementDescriptor(selectedControls[0]).uuid, page));
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

		private var isCut:Boolean=false;

		private function cut():void
		{
			if (selectedControls.length > 0)
			{
				isCut=true;
				ControlClipboard.getInstance().clear();
				var controls:Array=selectedControls.slice(0);

				//var uuidlist:Array=getUuidList();
				//var dependanciesObject:Object=DestroyUtils.checkControlDependancies(uuidlist, BrowsingManager.getInstance().getCurrentPage());
				//actionsToDelete=dependanciesObject.actions;
				//storiesToDelete=dependanciesObject.stories;
				if (actionsToDelete.length == 0 && storiesToDelete.length == 0)
				{
					var queue:CommandQueue=new CommandQueue();
					for each (var control:IUIElementDescriptor in controls)
					{
						ControlClipboard.getInstance().addControl(control.clone(true));
						//ApplicationController.getInstance().getCommand().addCommand(new ElementDestructionCommand(control));
						queue.addCommand(new ElementDestructionCommand(control));
					}
					ApplicationController.getInstance().getCommand().addCommand(queue);
					update();
					VisualSelector.getInstance().flushElements();
					isCut=false;
				}
				else
				{
					var alertString:String=(actionsToDelete.length != 0 && storiesToDelete.length != 0) ? Conf.languageManager.getLanguage("Actions_and_stories") : actionsToDelete.length != 0 ? Conf.languageManager.getLanguage("Actions") : Conf.languageManager.getLanguage("Stories");
					Alert.okLabel=Conf.languageManager.getLanguage("Delete_All");
					Alert.yesLabel=Conf.languageManager.getLanguage("Delete_Actions");
					Alert.noLabel=Conf.languageManager.getLanguage("No");
					Alert.buttonWidth=150;
					Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
					Alert.show(alertString + " " + Conf.languageManager.getLanguage("use_this_element,_do_you_want_to_delete_them?"), Conf.languageManager.getLanguage("Elements_have_dependancies"), Alert.OK | Alert.YES | Alert.CANCEL, mx.core.Application.application as Sprite, removeStoryAlertHandler);

					Alert.okLabel=Conf.languageManager.getLanguage("Ok");
					Alert.yesLabel=Conf.languageManager.getLanguage("Yes");
					Alert.noLabel=Conf.languageManager.getLanguage("No");
					Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");

				}
				tree.dispatchEvent(new Event(ListEvent.CHANGE));

			}
		}


		private function removeStoryAlertHandler(e:CloseEvent):void
		{
			var queue:CommandQueue=new CommandQueue();
			var controls:Array=selectedControls.slice(0);
			var control:IUIElementDescriptor;
			var action:Action;
			var story:Story;
			var i:int=0;
			switch (e.detail)
			{
				case Alert.OK:
					for each (action in actionsToDelete)
					{
						//ApplicationController.getInstance().getActionEditor().removeAction(action.uuid);
						queue.addCommand(new ActionDeletionCommand(action));
					}
					for each (story in storiesToDelete)
					{

						//ApplicationController.getInstance().getStoryEditor().removeStory(story.uuid);
						queue.addCommand(new StoryDeletionCommand(story));
					}
					for each (control in controls)
					{
						//if (isCut)
						//ControlClipboard.getInstance().addControl(control.clone(true));
						queue.addCommand(new ElementDestructionCommand(control));
					}
					if (isCut)
					{
						fillClipboard(controls);
					}
					ApplicationController.getInstance().getCommand().addCommand(queue);
					//ApplicationController.getInstance().getActionEditor().update();
					//ApplicationController.getInstance().getStoryEditor().update();
					break;
				case Alert.YES:
					this.storiesToDelete=null;
					for each (action in actionsToDelete)
					{

						ApplicationController.getInstance().getActionEditor().removeAction(action.uuid);
							//queue.addCommand( new ActionDeletionCommand(action));
					}
					for each (control in controls)
					{
						//if (isCut)
						//ControlClipboard.getInstance().addControl(control.clone(true));
						queue.addCommand(new ElementDestructionCommand(control));
					}

					if (isCut)
					{
						fillClipboard(controls);
					}
					ApplicationController.getInstance().getCommand().addCommand(queue);
					//ApplicationController.getInstance().getActionEditor().update();
					break;
				case Alert.NO:

					break;
				case Alert.CANCEL:

					break;
			}
			actionsToDelete=null;
			storiesToDelete=null;
			isCut=false;
		}

		private function copy():void
		{
			if (selectedControls.length > 0)
			{
				var controls:Array=selectedControls.slice(0);
				var actions:Array=actionsToDelete.slice(0);
				var stories:Array=storiesToDelete.slice(0);
				//ActionClipboard.getInstance().clear();
				ControlClipboard.getInstance().clear();
				fillClipboard(controls);
				tree.dispatchEvent(new Event(ListEvent.CHANGE));
			}
		}

		private function fillClipboard(controls:Array):void
		{

			for each (var control:IUIElementDescriptor in controls)
			{
				ControlClipboard.getInstance().addControl(control.clone(true));
			}
			for each (var action:IAction in actionsToDelete)
			{
				ControlClipboard.getInstance().addAction(action.clone(true));
			}
			for each (var story:Story in storiesToDelete)
			{
				ControlClipboard.getInstance().addStory(story.clone());
			}
		}

		private function getContainerFromNode(node:Object):IUIElementContainer
		{
			if (node == null)
			{
				if (page.hasContainer())
				{
					return ElementList.getInstance().getElement(page.container, page.getParent()) as IUIElementContainer;
				}
				return null;
			}
			return getContainerFromLabel(node.@label);
		}

		private function getContainerFromLabel(label:String):IUIElementContainer
		{

			var targetControl:IUIElementDescriptor;
			var parent:IUIElementContainer;

			// looking for container 

			if (label != null && label != "")
			{
				targetControl=ElementList.getInstance().getElement(label, page);
				if (targetControl is IUIElementContainer)
				{
					// Container is selected
					parent=IUIElementContainer(targetControl);
				}
				else
				{
					// Control is selected
					if (targetControl.hasParent())
					{
						// parent is the target
						parent=IUIElementContainer(targetControl.getParent());
					}
					else
					{
						// if the control has no parent return null or the container of the subpage
						if (page.parentIsPage)
						{
							parent=ElementList.getInstance().getElement(page.container, page.getParent()) as IUIElementContainer;
						}
						else
							parent=null;
					}
				}
			}
			return parent;

		}

		private function paste(controls:Array, storedActions:Array, storedStories:Array, parent:IUIElementContainer):void
		{
			var queue:CommandBatch=new CommandBatch();
			if (controls.length > 0)
			{

				queue.addCommand(new PasteCommand(controls, BrowsingManager.getInstance().getCurrentPage(), parent));
				queue.addCommand(new PasteActionCommand(storedActions, BrowsingManager.getInstance().getCurrentPage(), parent));
				queue.addCommand(new PasteStoryCommand(storedStories, BrowsingManager.getInstance().getCurrentPage(), parent));
				ApplicationController.getInstance().getCommand().addCommand(queue);
				VisualSelector.getInstance().flushElements();
			}
			tree.selectedItems=[];
			selection=[];
			tree.dispatchEvent(new Event(ListEvent.CHANGE));
		}

	}
}