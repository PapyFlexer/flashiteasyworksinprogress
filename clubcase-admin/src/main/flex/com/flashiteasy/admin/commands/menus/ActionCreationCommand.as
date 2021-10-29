package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.selection.ActionList;
	
	import flash.events.Event;

	public class ActionCreationCommand extends AbstractCommand
	{
        private var type:String;
        private var name:String;
        private var id:String;
        private var action:IAction;
        private var pSet:IParameterSet;

        
		public function ActionCreationCommand(type:String,name:String,id:String)
		{
            this.type=type;
            this.id=id;
            this.name=name;
		}
		
        public override function execute():void
        {
            action=ApplicationController.getInstance().getBuilder().createAction(BrowsingManager.getInstance().getCurrentPage(),this.type,this.name,this.id);
            dispatchEvent(new Event(Event.COMPLETE));
            pSet=action.getParameterSet();
			action=null;
        }
        
        public override function undo():void
		{
			action=ActionList.getInstance().getAction(this.id,BrowsingManager.getInstance().getCurrentPage());
			// Deselectionne le control si celui ci est deja selectionné
			ActionList.getInstance().removeActionById(action.uuid , action.getPage());
			action.destroy();
			ApplicationController.getInstance().getBlockList().update();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public override function redo():void
		{
			action=ApplicationController.getInstance().getBuilder().createAction(BrowsingManager.getInstance().getCurrentPage(),type,id,name);
			action.setParameterSet(pSet);
			action.applyParameters();

		}
		
	}
}