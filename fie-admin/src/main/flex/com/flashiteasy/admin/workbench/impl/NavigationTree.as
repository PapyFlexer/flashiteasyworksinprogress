package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.browser.FileManager;
	import com.flashiteasy.admin.clipboard.PageClipboard;
	import com.flashiteasy.admin.components.CustomTree;
	import com.flashiteasy.admin.components.FileManipulationBar;
	import com.flashiteasy.admin.components.componentsClasses.ToSaveRenderer;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.fieservice.FileManagerService;
	import com.flashiteasy.admin.popUp.NewPagePopUp;
	import com.flashiteasy.admin.utils.EditorUtil;
	import com.flashiteasy.admin.xml.ProjectSerializer;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.core.project.Project;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.Tree;
	import mx.controls.buttonBarClasses.ButtonBarButton;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;


	/**
	 * Flash'Iteasy
	 * Fie team is
	 * dany, didier, gilles
	 * & many thanks to alexis, ghazi, jean-françois
	 */public class NavigationTree
	{
		/**
		 * Create a navigation tree based on the project
		 * Permit to move, copy rename branches using FileManagerService
		 * @see com.flashiteasy.api.fieservice.filemanager
		 */
		private var title:Label;
		private var tree:CustomTree;
		private var pages:PageList;
		private var provider:XMLList;
		private var contentBox:VBox;
		private var toolBar:FileManipulationBar;
		private var baseURL:String;
		//variables to use later using rename instead of delete for keeping a copy of deleted pages
		private var _deletedNameList:Array;
		private var _garbageUrl:String;

		[Bindable]
		private var data:XMLListCollection=new XMLListCollection();

		private var inputName:NewPagePopUp;
		private var browserAction:FileManager;
		private var fms:FileManagerService=new FileManagerService();
		private var itemId:String;
		private var _newXML:XML;

		/**
		 * Create the tree and add listener to FileManagerService
		 *
		 */
		public function NavigationTree()
		{
			fms.addEventListener(FileManagerService.ERROR, error);
			contentBox=new VBox();
			contentBox.percentHeight = 100;
			title=new Label;
			title.width=200;
			title.setStyle("fontWeight", "bold");
			title.text=Conf.languageManager.getLanguage("Project_Pages");
			toolBar=new FileManipulationBar();
			tree=new CustomTree();
			tree.dataProvider=data;
			browserAction=new FileManager();
			tree.addEventListener(ListEvent.ITEM_CLICK, selectItem);
			tree.addEventListener( Event.CHANGE , listChanged ) ;
			tree.itemRenderer = new ClassFactory(ToSaveRenderer);
			tree.width=200;
			tree.percentHeight = 100;
			//Navigation tree
			contentBox.addChild(tree);
			//file manipulation
			contentBox.addChild(toolBar);
			
			toolBar.callLater(initToolBar);
		}
		
		private var _changedFromList:Boolean = false;
		
		
		/**
		 * Used on page change for refreshing the selection
		 * make nothing if changedFromList is set to true
		 * @param e
		 */
		public function updateSelection(e:Event) : void
		{
			if(!_changedFromList)
			{
				var pageUrl:String = BrowsingManager.getInstance().getCurrentPage().getPageUrl();
				tree.openItems = [];
				setSelectedPage(pageUrl);
				
			}
			_changedFromList = false;
		}
		
		/**
		 * Select a page on the tree
		 * @param p is the path to the page
		 */
		public function setSelectedPage(p:String):void
		{
			if (p != null)
			{
				var items:Array=p.split("/");
				var l:int=items.length;
				var index:int=-1;
				var expandList:Array=[];
				var itemList:XMLList=data.source;
				var item:XML;
				while (++index < l)
				{
					item=getNodeByLabel(items[index], itemList);
					expandList.push(item);
					itemList=item.children();
				}
				tree.callLater(expandAndSelect, [expandList]);
			}
			else
			{
				tree.selectedIndex=-1
			}

		}

		private function expandAndSelect(expandList:Array):void
		{
			//Where it's length -1 because we don't want to open the selectedPage
			for (var i:int=0; i < expandList.length - 1; i++)
			{
				tree.expandItem(expandList[i], true);
			}
			//due to a bug where multiple Items can be selected if they share the same name
			//we use selectedIndex instead
			//selectedItem = expandList[expandList.length-1];
			tree.selectedIndex=selectedPageIndex;
			tree.callLater(tree.scrollToIndex, [selectedPageIndex]);
			selectedPageIndex=-1;
		}
		
		private var selectedPageIndex:int=-1;

		private function getNodeByLabel(label:String, data:XMLList):XML
		{
			for each (var parentNode:XML in data)
			{
				selectedPageIndex+=1;
				if (parentNode.@label == label)
				{
					return parentNode;
				}
			}
			return null;
		}
		
		
		private function initToolBar():void
		{
			toolBar.disableAll();
			toolBar.callLater(enableAdd);
			toolBar.hideEdit();
			toolBar.addEventListener( ItemClickEvent.ITEM_CLICK , selectButton ) ;
		}
		
		
		private function enableAdd() : void
		{
			toolBar.addButton.enabled = true ;
		}
		
		
		private function listChanged( e : Event ) : void 
		{
			if( tree.selectedItems.length == 0 )
			{
				toolBar.disableAll();
				contentBox.callLater(enableAdd);
			}
			else
			{
				toolBar.enableAll();
				
			}
			if(PageClipboard.getInstance().isEmpty())
			{
				toolBar.disablePaste();	
			}
			else
			{
				toolBar.enablePaste();
			}
			
		}
		
		/**
		 * Get the all component
		 *
		 * @return contentBox
		 */
		public function getUIComponent():VBox
		{
			return contentBox;

		}
		
		
		/**
		 * 
		 * @return 
		 */
		public function getTree():Tree
		{
			return tree;

		}
		
		/**
		 * 
		 * @param tree
		 */
		public function setTree(tree:Tree):void
		{
			//this.tree=tree;
			//tree.addEventListener(ListEvent.ITEM_CLICK, selectItem);

		}

		/**
		 * Get pages from Project
		 *
		 * @return PageList
		 */

		public function getPageList():PageList
		{
			return pages;
		}

		/**
		 * 
		 * @param pages
		 */
		public function setPageList(pages:PageList):void
		{
			this.pages=pages;
		}

		/**
		 * Build the tree based on serviceURL
		 */
		public function update(expand:Boolean=false):void
		{
			baseURL=Conf.APP_ROOT;
			buildTree();
			if (expand)
			{
				tree.callLater(tree.expandAll);
				tree.callLater(selectFirstIndex);
			}
		}
		
		private function selectFirstIndex():void
		{
			var pageUrl:String = BrowsingManager.getInstance().getCurrentPage().getPageUrl();
			tree.openItems = [];
			setSelectedPage(pageUrl);
		}
		//Listener for the toolBar
		private function selectButton(e:ItemClickEvent):void
		{
			var item:ButtonBarButton=toolBar.getChildAt(e.index) as ButtonBarButton;
			var currentPage:Page=BrowsingManager.getInstance().getCurrentPage();
			itemId=toolBar.dataProvider[e.index].id;
			switch (itemId)
			{
				case "delete":
					removePage();
					break;
				case "cut":
					PageClipboard.getInstance().isCut = true;
					copy();
					break;
				case "copy":
					//When copiing removing _cutedPage
					
					PageClipboard.getInstance().isCut = false;
					copy();
					break;
				case "paste":
					//used with copy and cut
					
					var storedPages:Array=PageClipboard.getInstance().getPages();
					//PageClipboard.getInstance().clear();
					pasteNamePopUp(storedPages);
					//fillClipboard(storedPages);
					break;
				case "add":
					createNamePopUp();
					break;
			}
		}
		
		
		private function copy():void
		{
			
				var pages:Array=[BrowsingManager.getInstance().getCurrentPage()];
				PageClipboard.getInstance().clear();
				fillClipboard(pages);
				tree.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function fillClipboard(pages:Array) : void
		{
			
				for each (var page:Page in pages)
				{
					PageClipboard.getInstance().addPage(page);
				}
		}
		
		private function createNamePopUp():void
		{
			inputName=new NewPagePopUp(mx.core.Application.application as DisplayObject, true);
			inputName.description=Conf.languageManager.getLanguage("New_Page_Name");
			inputName.label=Conf.languageManager.getLanguage("Name") + ": ";
			inputName.setInputDefaultValue(EditorUtil.findUniqueName("page", PageUtils.getPagesLink(BrowsingManager.getInstance().getCurrentPage())));
			inputName.addEventListener(NewPagePopUp.SUBMIT, checkName);
		}

		private function checkName(e:Event):void
		{
			inputName.closePopUp();
			addNewPageXML(inputName.getInput(), inputName.isSubPage(), inputName.isOnStage(), inputName.pageContainer());
			inputName.removeEventListener(NewPagePopUp.SUBMIT, checkName);
		}

		//Listener for the tree
		private function selectItem(e:ListEvent):void
		{
			ApplicationController.getInstance().getXMLContainerList().getList().selectedIndex = -1;
			//In case the selected page is deselect with command or shift
			//we force a reselection
			_changedFromList = true;
			if (e.target.selectedItem == null)
			{
				e.target.selectedIndex=e.rowIndex;
			}
			else
			{
				var s:String=createUrlFromItem(e.target.selectedItem);
				BrowsingManager.getInstance().showUrl(s);
			}
		}

		private function buildTree():void
		{
			data.source=buildDataProvider();
			tree.labelField="@label";
		}


		private function pasteNamePopUp(pages:Array):void
		{
			var pageParent:PageList=BrowsingManager.getInstance().getCurrentPage().getParent();
			var uuid:String=EditorUtil.findUniqueName(pages[0].link, PageUtils.getPagesLink(pageParent));
			var container:String = Page(pages[0]).container;
			inputName=new NewPagePopUp(mx.core.Application.application as DisplayObject, true);
			inputName.description=Conf.languageManager.getLanguage("Paste_Page_Name");
			inputName.label=Conf.languageManager.getLanguage("Name") + ": ";
			//trace(""+);
			inputName.setIsOnStage(!Page(pages[0]).hasContainer());
			if(Page(pages[0]).hasContainer())
			{
				inputName.setPageContainer(container);
				if(pageParent is Project)
				{
					uuid=EditorUtil.findUniqueName(uuid, PageUtils.getPagesLink(BrowsingManager.getInstance().getCurrentPage()));
					inputName.setIsSubPage(true);
				}
			}
			
			inputName.setInputDefaultValue(uuid);
			inputName.addEventListener(NewPagePopUp.SUBMIT, checkPaste);
		}

		//paste a page on the project at the level of the tree selectedItem
		private function checkPaste(e:Event):void
		{
			inputName.closePopUp();
			var pageParent:PageList;
			if (inputName.isSubPage())
			{
				pageParent=BrowsingManager.getInstance().getCurrentPage();
			}
			else
			{
				pageParent=BrowsingManager.getInstance().getCurrentPage().getParent();
			}
			var newPage:Page=PageClipboard.getInstance().getPages()[0].clone();
			newPage.link=inputName.getInput();
			//Workaround for pages at the first level cannot be cast as Page
			var pasteUrl:String=pageParent is Project ? baseURL + "/xml/" + inputName.getInput() : baseURL + "/xml/" + Page(pageParent).getPageUrl() + "/" + inputName.getInput();
			var pagesToCopy:Array=[baseURL + "/"+PageClipboard.getInstance().type+"/" + PageClipboard.getInstance().getPages()[0].getPageUrl() + ".xml"]
			var pagesToPaste:Array=[pasteUrl + ".xml"];

			//if the page have children we should add the directory of the subPages
			if (newPage.getPages().length > 0)
			{
				pagesToCopy.push(baseURL + "/xml/" + Page(PageClipboard.getInstance().getPages()[0]).getPageUrl());/*_copiedPage//newPage.getPageUrl())*/;
				pagesToPaste.push(pasteUrl);
			}

			fms.addEventListener(FileManagerService.COPY_FILE, complete);
			if (!PageClipboard.getInstance().isCut)
			{
				//we haven't cut so copying file
				fms.copyFiles(pagesToCopy, pagesToPaste);
			}
			else
			{
				//we have cut so Moving the file
				fms.renameFile(pagesToCopy, pagesToPaste);
			}
			inputName.addEventListener(NewPagePopUp.SUBMIT, checkPaste);
		}


		private function removePage():void
		{
			//TODO : we could move the files to a garbage URL for using undo redo action

			/*var pageToRemove:Page=BrowsingManager.getInstance().getCurrentPage();
			   baseURL + "/xml/" + pageToRemove.getPageUrl() + ".xml"];
			   var garbageArray:Array=["fie-admin/bin-debug/garbage/" + pageToRemove.getPageUrl() + ".xml"];
			   if (pageToRemove.getPages().length > 0)
			   {
			   removeArray.push(baseURL + "/xml/" + pageToRemove.getPageUrl());
			   garbageArray.push("fie-admin/bin-debug/garbage/" + pageToRemove.getPageUrl());
			   }

			   fms.addEventListener(FileManagerService.COPY_FILE, complete);
			   fms.renameFile(removeArray, garbageArray);
			 */

			var pageParent:PageList=BrowsingManager.getInstance().getCurrentPage().getParent();
			var pageToRemove:Page=BrowsingManager.getInstance().getCurrentPage();
			var removeArray:Array=[pageToRemove.getPageUrl() + ".xml"];

			//If pageParent have only one child directory should be remove
			if (!(pageParent is Project) && Page(pageParent).getPages().length == 1)
			{
				removeArray.push(Page(pageParent).getPageUrl());
			}

			//if the page have children we should add the directory of the subPages
			if (pageToRemove.getPages().length > 0)
			{
				removeArray.push(pageToRemove.getPageUrl());
			}
			fms.addEventListener(FileManagerService.DELETE_FILE, complete);
			fms.deleteFiles(baseURL + "/xml", removeArray);
		}

		private function complete(e:Event):void
		{
			var pageParent:PageList;
			var newPage:Page;
			var pageToRemove:Page;
			switch (itemId)
			{
				case "delete":
					fms.removeEventListener(FileManagerService.DELETE_FILE, complete);
					pageParent=BrowsingManager.getInstance().getCurrentPage().getParent();
					pageParent.removePage(BrowsingManager.getInstance().getCurrentPage());
					saveProjectPagesXML();
					BrowsingManager.getInstance().getCurrentPage().hide();
					break;
				case "paste":
					fms.removeEventListener(FileManagerService.COPY_FILE, complete);
					
					if (inputName.isSubPage())
					{
						pageParent=BrowsingManager.getInstance().getCurrentPage();
					}
					else
					{
						pageParent=BrowsingManager.getInstance().getCurrentPage().getParent();
					}
					newPage=PageClipboard.getInstance().getPages()[0].clone();
					newPage.link=inputName.getInput();
					newPage.container = inputName.pageContainer();
					newPage.setParent(pageParent);
					pageParent.addPage(newPage);
					if (PageClipboard.getInstance().isCut && PageClipboard.getInstance().type != "xml_library")
					{
						pageToRemove=PageClipboard.getInstance().getPages()[0];
						pageParent=PageClipboard.getInstance().getPages()[0].getParent();
						pageParent.removePage(pageToRemove);
					} // else {
					PageClipboard.getInstance().isCut=false;
					saveProjectPagesXML();
					//}
					break;
				case "add":
					fms.removeEventListener(FileManagerService.PAGE_CREATED, complete);
					if (inputName.isSubPage())
					{
						pageParent=BrowsingManager.getInstance().getCurrentPage();
					}
					else
					{
						pageParent=BrowsingManager.getInstance().getCurrentPage().getParent();
					}
					newPage=new Page(pageParent);
					newPage.link=inputName.getInput();
					newPage.container=inputName.pageContainer();
					pageParent.addPage(newPage);
					saveProjectPagesXML();

					break;
			}
		}


		private function addNewPageXML(name:String, isSubpage:Boolean, isOnStage:Boolean, container:String):void
		{
			var pageParent:Page;
			fms.addEventListener(FileManagerService.PAGE_CREATED, complete);
			if (isSubpage)
			{
				pageParent=BrowsingManager.getInstance().getCurrentPage();
				fms.createPage(baseURL + "/xml/" + pageParent.getPageUrl(), name);
			}
			else
			{
				if (BrowsingManager.getInstance().getCurrentPage().parentIsPage)
				{
					pageParent=Page(BrowsingManager.getInstance().getCurrentPage().getParent());
					fms.createPage(baseURL + "/xml/" + pageParent.getPageUrl(), name);
				}
				else
				{
					fms.createPage(baseURL + "/xml", name);
				}
			}
		}


		private function saveProjectPagesXML():void
		{
			_newXML=AbstractBootstrap.getInstance().getXML();
			
			_newXML.replace("pages", getPagesXml());
			fms.addEventListener(FileManagerService.FILE_SAVED, saveSuccess, false, 0, true);
			fms.saveContent(baseURL + "/xml/project.xml", _newXML);
		}

		private function error(e:Event):void
		{
			trace("error with fileManager");
		}


		private function saveError(e:IOErrorEvent):void
		{
			trace("couldn t find php");
		}

		private function saveSuccess(e:Event):void
		{
			trace("XML saved");
			update();
		}

		/*
		 * UTILITIES Functions
		 *
		 */
		//Return the list ofUUID at the same level

		private function getUuidArray(pgs:Array):Array
		{
			var Ar:Array=[];
			for (var i:int=0; i < pgs.length; i++)
			{
				Ar.push(pgs[i].link);
			}
			return Ar;
		}

		//Return real URL from a selectedItem
		public function createUrlFromItem(item:Object):String
		{
			//var item:Object=tree.selectedItem;
			var Ar:Array=[item.@label];
			var parent:Object=tree.getParentItem(item);
			while (parent != null)
			{
				Ar.unshift(parent.@label);
				item=parent;
				parent=tree.getParentItem(item);
			}
			return Ar.join("/");
		}

		//Return a XMLList base on Project
		/**
		 * 
		 * @return 
		 */
		public function buildDataProvider():XMLList
		{
			var pageList:Array=pages.getPages();
			var page:Page;
			var pageNode:String="<root>";

			for each (page in pageList)
			{
				pageNode+=ProjectSerializer.getPageXMLForProject(page);
			}
			pageNode+="</root>";
			provider=new XMLList(new XML(pageNode).children());
			return provider;
		}

		//return XML String for each page

		//Rebuild the pages portion of the project.xml
		private function getPagesXml():XMLList
		{
			var pageList:Array=pages.getPages();
			var page:Page;
			var pageNode:String="<root>";

			pageNode+="<pages>";
			for each (page in pageList)
			{

				pageNode+=ProjectSerializer.serializePageForProject(page);
			}
			pageNode+="</pages></root>";
			var pagesXML:XMLList=new XMLList(new XML(pageNode).children());
			return pagesXML;

		}

		
		/**
		 * 
		 * @return 
		 */
		public function get changedFromList() : Boolean
		{
			return _changedFromList;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set changedFromList(value:Boolean) : void
		{
			_changedFromList = value;
		}

	}
}