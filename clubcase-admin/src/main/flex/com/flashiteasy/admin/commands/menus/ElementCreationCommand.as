package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;

	public class ElementCreationCommand extends AbstractCommand
	{
		
		private var type:String;
		private var id:String;
		private var name:String;
		private var parentId:String;
		private var parent:IUIElementContainer;
		private var control:IUIElementDescriptor;
		private var x:Number ; 
		private var y:Number ; 
		private var pSet:IParameterSet;
		//private var page : Page;
		private var parentPage : Page ;
		
		public function ElementCreationCommand(type:String,name:String,id:String,parent:IUIElementContainer=null,x:Number = 0 , y : Number = 0 )
		{
			this.type=type;
			this.id=id;
			this.name=name;
			if(parent != null )
			{
				parentId=parent.uuid
				this.parentPage = parent.getPage();
			}
			this.x=x;
			this.y=y;
			
			//this.page=BrowsingManager.getInstance().getCurrentPage();
			
		}
		
		public override function execute():void
		{
			if(parentId != null )
			{
				this.parent=ElementList.getInstance().getElement(parentId , parentPage ) as IUIElementContainer;
			}
			else
			{
				parent = null;
			}
			control=ApplicationController.getInstance().getBuilder().createElement(BrowsingManager.getInstance().getCurrentPage(),this.type, this.id,this.name,parent);
			pSet=control.getParameterSet();
			control=null;
			//ElementList.getInstance().addElement(control,control.getPage());
		}
		
		// Detruit l element cree
		
		public override function undo():void
		{
			control=ElementList.getInstance().getElement(this.id,BrowsingManager.getInstance().getCurrentPage());
			// Deselectionne le control si celui ci est deja selectionné
			if(ApplicationController.getInstance().getBlockList().isSelected(control)){
				ApplicationController.getInstance().getElementEditor().editIfFace(control.getFace(),true);
			}
			ElementList.getInstance().removeElementById(control.uuid , control.getPage());
			control.destroy();
			ApplicationController.getInstance().getBlockList().update();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public override function redo():void
		{
			this.parent=ElementList.getInstance().getElement(parentId , parentPage ) as IUIElementContainer;
			control=ApplicationController.getInstance().getBuilder().createElement(BrowsingManager.getInstance().getCurrentPage(),type,id,name,parent);
			control.setParameterSet(pSet);
			control.applyParameters();

		}
		
	}
}