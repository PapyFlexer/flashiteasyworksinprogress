package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ActionList;
	
	import flash.events.Event;

	public class ActionDeletionCommand extends AbstractCommand
	{
		private var actionId:String;
		private var page:Page;
		private var actionCopy : IAction ;
		
		public function ActionDeletionCommand( action : IAction )
		{
			actionId = action.uuid;
			page = action.getPage();
		}
		
		public override function execute():void
        {
        	var action : IAction =  ActionList.getInstance().getAction(actionId,page);
        	// FIXME : add cloning
        	actionCopy =action.clone(true);
        	action.destroy();
			ApplicationController.getInstance().getActionEditor().update();
			dispatchEvent(new Event(Event.COMPLETE));
        }
        
        public override function undo():void
		{
			actionCopy.setPage(page);
			//controlCopy.dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
			
			actionCopy.applyParameters();
			AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack( page );
			ApplicationController.getInstance().getActionEditor().update();
		}
		
		public override function redo():void
		{
			
			execute();
			
			
		}
		
	}
}