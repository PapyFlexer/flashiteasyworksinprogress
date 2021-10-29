package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.commands.IRedoableCommand;
	import com.flashiteasy.admin.commands.IUndoableCommand;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;
	public class PasteActionCommand extends AbstractCommand implements IUndoableCommand, IRedoableCommand
	{
		
		public function PasteActionCommand( actions : Array , page :Page , parent : IUIElementContainer = null )
		{
			this.actions = actions.slice(0);
			this.parent = parent ;
			if( parent != null )
			{
				parentId= parent.uuid;
				parentPage = parent.getPage();
			}
			this.page = page ;
		}
		private var actions : Array = [];
		
		private var count:int=0;
		private var id:Array = [];
		private var page : Page ;
		private var parent :IUIElementContainer ;
		private var parentId : String = "" ;
		private var parentPage : Page ;
		
		private var pastedActions : Array = [];
		
		override public  function execute():void
		{
			count=0;
			var tmpControls : Array = [];
			var action : IAction;
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			parent = ElementList.getInstance().getElement(parentId ,parentPage) as IUIElementContainer;
				
			for each ( action in actions )
			{
				action.addEventListener(FieEvent.COMPLETE , countAction , false , 0 , true ) ;
				// if controls are pasted in a different page , set the page to the current one
				action.setPage(page);
				//control.dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
				if(parent !=null ) 
				{
					//parent.layoutElement(action);
				}
				action.applyParameters();
				
				pastedActions.push(action.uuid);
				
			}
			ApplicationController.getInstance().getActionEditor().update();
			// load remote parameter stack in case copied controls contains remote parameterSets
			
			AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack( page );
		}
		
		override public  function redo():void
		{
			execute();
		}
		
		override public  function undo():void
		{	
			var tmpActions : Array = [];
			//var control :;
			var actionId : String ;
			var action : IAction;
			for each ( actionId in pastedActions )
			{	
				action =ActionList.getInstance().getAction(actionId , page );
				//Clone copied controls to redo
				tmpActions.push(action.clone(true));
				//if(VisualSelector.getInstance().isSelected(control))
					//ApplicationController.getInstance().getElementEditor().editAction(action);
				action.destroy();
			}
			actions = tmpActions.slice(0);
			ApplicationController.getInstance().getActionEditor().update();
			pastedActions = [];
		}
		
		// Function used to refresh the tree only when all copied controls are loaded
		
		private function countAction(e:Event):void
		{
			count++ ;
			
			if(count == actions.length)
			{
				ApplicationController.getInstance().getActionEditor().update();
				dispatchEvent(new Event(Event.COMPLETE));
				count=0;
			}
		}
	}
}