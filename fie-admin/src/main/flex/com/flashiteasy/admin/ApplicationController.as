package com.flashiteasy.admin
{
	import com.flashiteasy.admin.build.BuildManager;
	import com.flashiteasy.admin.commands.CommandHistory;
	import com.flashiteasy.admin.components.PageTimeLine;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.popUp.ProjectChooser;
	import com.flashiteasy.admin.uicontrol.menu.XMLContainerList;
	import com.flashiteasy.admin.workbench.IElementEditor;
	import com.flashiteasy.admin.workbench.ITree;
	import com.flashiteasy.admin.workbench.IWorkbench;
	import com.flashiteasy.admin.workbench.impl.ActionListComponent;
	import com.flashiteasy.admin.workbench.impl.ActionListEditor;
	import com.flashiteasy.admin.workbench.impl.ControlList;
	import com.flashiteasy.admin.workbench.impl.DefaultComponentTree;
	import com.flashiteasy.admin.workbench.impl.DefaultElementEditorImpl;
	import com.flashiteasy.admin.workbench.impl.DefaultWorkbenchImpl;
	import com.flashiteasy.admin.workbench.impl.NavigationTree;
	import com.flashiteasy.admin.workbench.impl.StoryListEditor;
	import com.flashiteasy.admin.workbench.impl.ViewElementEditorImpl;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.XMLFile;
	import com.flashiteasy.api.errors.ApiErrorManager;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.utils.Dictionary;

	/**
	 * Main application entry point which handles the global workbench.
	 */

	public class ApplicationController
	{
		private static var instance:ApplicationController=null;
		private static var allowInstantiation:Boolean=false;

		private var editor:IElementEditor;
		private var workbench:IWorkbench;
		private var tree:ITree;
		private var actionEditor:ActionListEditor;
		private var storyEditor:StoryListEditor;
		private var timelineEditor:PageTimeLine;
		private var builder:BuildManager;
		private var navigation:NavigationTree;
		private var controls:ControlList;
		private var actions:ActionListComponent;
		private var projectChooser : ProjectChooser;

		public function ApplicationController()
		{
			//A try of instanciating adminLibrary as customEditor
			//but sprite cannot add UIComponents as children
			//AdminLibrary;
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}

		}
		
		public function reset() : void
		{
			instance = null;
			getWorkbench().destroy();
			//ElementList.getInstance().reset();
			AbstractBootstrap.getInstance().reset();
			//Selection.getInstance().reset();
			delete this;
		}
		

		public static function getInstance():ApplicationController
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new ApplicationController();
				allowInstantiation=false;
			}
			return instance;
		}

		public function getElementEditor():IElementEditor
		{
			if (editor == null)
			{
				// TODO Could be injected using IoC pattern.
				// This will probably be the only implementation
				editor=new DefaultElementEditorImpl();
				editor.setWorkbench(getWorkbench());
			}
			return editor;
		}

		public function changeElementEditor(editor:IElementEditor):void
		{
			if (!(editor is ViewElementEditorImpl))
				removeActionListener();
			else
				addActionListener();
			getWorkbench().setElementEditor(editor);
			this.editor=editor;
			editor.setWorkbench(getWorkbench());
			editor.reset(Ref.editorContainer);
		}

		private function removeActionListener():void
		{
			var pages:Array=PageUtils.getAllDisplayedPage(BrowsingManager.getInstance().getCurrentPage());
			for each (var page:Page in pages)
			{
				
				var actions:Array=ActionList.getInstance().getActions(page);//BrowsingManager.getInstance().getCurrentPage());
				for each (var action:IAction in actions)
				{
					action.removeEvents();
				}
			
			}
		}


		private function addActionListener():void
		{
			var pages:Array=PageUtils.getAllDisplayedPage(BrowsingManager.getInstance().getCurrentPage());
			for each (var page:Page in pages)
			{
			var actions:Array=ActionList.getInstance().getActions(page);//BrowsingManager.getInstance().getCurrentPage());
			for each (var action:IAction in actions)
			{
				action.applyEvents();
			}
			}
		}

		public function addApiErrorListener():void
		{
			ApiErrorManager.getInstance().addEventListener(FieEvent.ERROR_ACTION_NO_TARGET, handleApiErrors);
			ApiErrorManager.getInstance().addEventListener(FieEvent.ERROR_ACTION_NO_TRIGGER, handleApiErrors);
			ApiErrorManager.getInstance().addEventListener(FieEvent.ERROR_STORY_NO_TARGET, handleApiErrors);
		}

		public function removeApiErrorListener( ) : void
		{
			ApiErrorManager.getInstance().removeEventListener(FieEvent.ERROR_ACTION_NO_TARGET, handleApiErrors);
			ApiErrorManager.getInstance().removeEventListener(FieEvent.ERROR_ACTION_NO_TRIGGER, handleApiErrors);
			ApiErrorManager.getInstance().removeEventListener(FieEvent.ERROR_STORY_NO_TARGET, handleApiErrors);
		}
		
		private function handleApiErrors( e : FieEvent) : void
		{
			switch ( e.type )
			{
				case  FieEvent.ERROR_STORY_NO_TARGET :	
					trace ("[FieEvent.ERROR_STORY_NO_TARGET!!!]");
					break;
				case  FieEvent.ERROR_ACTION_NO_TRIGGER :	
					trace ("[FieEvent.ERROR_STORY_NO_TARGET!!!]");
					break;
				case  FieEvent.ERROR_ACTION_NO_TARGET :	
					trace ("[FieEvent.ERROR_STORY_NO_TARGET!!!]");
					break;
				default :
					trace ("[uncaught FieError!!!]");
			}
				
		}

		public function getWorkbench():IWorkbench
		{
			if (workbench == null)
			{
				// TODO Could be injected using IoC pattern.
				// This will probably be the only implementation
				workbench=new DefaultWorkbenchImpl();
				workbench.setElementEditor(getElementEditor());
			}
			return workbench;
		}

		public function getBlockList():ITree
		{
			if (tree == null)
			{
				// TODO Could be injected using IoC pattern.
				// This will probably be the only implementation
				tree=new DefaultComponentTree();
			}
			return tree;
		}

		public function getActionEditor():ActionListEditor
		{
			if (actionEditor == null)
			{
				actionEditor=new ActionListEditor();
			}
			return actionEditor;
		}



		public function getTimelineEditor():PageTimeLine
		{
			if (timelineEditor == null)
			{
				timelineEditor=new PageTimeLine();
			}
			return timelineEditor;
		}




		public function getStoryEditor():StoryListEditor
		{
			if (storyEditor == null)
			{
				storyEditor=new StoryListEditor();
			}
			return storyEditor;
		}

		private var toSave:Dictionary=new Dictionary(true);
		private var toSaveList:Array=[];
		private var commands:Dictionary=new Dictionary(true);

		public function getCommand():CommandHistory
		{
			if (commands[BrowsingManager.getInstance().getCurrentPage()] == null)
			{
				commands[BrowsingManager.getInstance().getCurrentPage()]=new CommandHistory();
			}
			//toSave[BrowsingManager.getInstance().getCurrentPage()]=true;
			addToSaveList(BrowsingManager.getInstance().getCurrentPage());
			return commands[BrowsingManager.getInstance().getCurrentPage()];
		}

		public function getHasToBeSave(p:Page):Boolean
		{
			return toSave[p] == null ? false : toSave[p];
		}

		public function removeFromToSave(p:Page):void
		{
			delete toSave[p];
		}

		public function addToSaveList(p:Page):void
		{
			var index : int = ArrayUtils.getItemIndexInArray(toSaveList, p);
			if(index == -1)
			{
				toSaveList.push(p);
				if(p is XMLFile)
					this.xmls.xmls.invalidateList();
				else
					this.navigation.getTree().invalidateList();//.invalidateDisplayList();
			}
			else
			{
				toSaveList.splice(index, 1, p);
			}
			toSave[p]=true;
		}
		
		
		public function removeFromSaveList(p:Page):void
		{
			var index : int = ArrayUtils.getItemIndexInArray(toSaveList, p);
			if(index != -1)
			{
				toSaveList.splice(index, 1);
				if(p is XMLFile)
					this.xmls.xmls.invalidateList();
				else
					this.navigation.getTree().invalidateList();
			}
		}
		
		public function getIsInSaveList(p:Page):Boolean
		{
			return ArrayUtils.isItemInArray(toSaveList, p);
		}

		public function getBuilder():BuildManager
		{
			if (builder == null)
			{
				builder=BuildManager.getInstance();
			}
			return builder;
		}

		public function getNavigation():NavigationTree
		{
			if (navigation == null)
			{
				navigation=new NavigationTree()
			}
			return navigation;
		}

		public function getControlList():ControlList
		{
			if (controls == null)
			{
				controls=new ControlList();
			}
			return controls;
		}

		public function getActionList():ActionListComponent
		{
			if (actions == null)
			{
				actions=new ActionListComponent();
			}
			return actions;
		}

		private var xmls:XMLContainerList;

		public function getXMLContainerList():XMLContainerList
		{
			if (xmls == null)
			{
				xmls=new XMLContainerList;
			}
			return xmls;
		}
	}
}