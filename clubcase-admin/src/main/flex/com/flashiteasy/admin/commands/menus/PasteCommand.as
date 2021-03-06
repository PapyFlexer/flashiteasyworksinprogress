package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.commands.IRedoableCommand;
	import com.flashiteasy.admin.commands.IUndoableCommand;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.container.BlockElementDescriptor;
	import com.flashiteasy.api.container.XmlElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;
	public class PasteCommand extends AbstractCommand implements IUndoableCommand, IRedoableCommand
	{
		
		public function PasteCommand( controls : Array , page :Page , parent : IUIElementContainer = null )
		{
			this.controls = controls.slice(0);
			this.parent = parent ;
			if( parent != null )
			{
				parentId= parent.uuid;
				parentPage = parent.getPage();
			}
			this.page = page ;
		}
		private var controls : Array = [];
		
		private var count:int=0;
		private var id:Array = [];
		private var page : Page ;
		private var parent :IUIElementContainer ;
		private var parentId : String = "" ;
		private var parentPage : Page ;
		
		private var pastedControls : Array = [];
		
		override public  function execute():void
		{
			count=0;
			var tmpControls : Array = [];
			var control :IUIElementDescriptor;
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			parent = ElementList.getInstance().getElement(parentId ,parentPage) as IUIElementContainer;
				
			for each ( control in controls )
			{
				control.addEventListener(FieEvent.COMPLETE , countBlock , false , 0 , true ) ;
				// if controls are pasted in a different page , set the page to the current one
				/*control.addEventListener(FieEvent.CONTROLNAME_CHANGE, nameHaveChange, false , 0 , true ) ;
				if(!(control is XmlElementDescriptor) && (control is BlockElementDescriptor))
				{
					for each (var child:IUIElementDescriptor in BlockElementDescriptor(control).getChildren())
					{
						child.addEventListener(FieEvent.CONTROLNAME_CHANGE, nameHaveChange, false , 0 , true ) ;
					}
				}*/
				control.setPage(page);
				//control.dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
				if(parent !=null ) 
				{
					parent.layoutElement(control);
				}
				control.applyParameters();
				
				pastedControls.push(control.uuid);
				
			}
			ApplicationController.getInstance().getBlockList().update();
			// load remote parameter stack in case copied controls contains remote parameterSets
			
			AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack( page );
		}
		
		override public  function redo():void
		{
			execute();
		}
		
		override public  function undo():void
		{	
			var tmpControls : Array = [];
			//var control :;
			var controlId : String ;
			var control : IUIElementDescriptor;
			for each ( controlId in pastedControls )
			{	
				control =ElementList.getInstance().getElement(controlId , page );
				//Clone copied controls to redo
				tmpControls.push(control.clone(true));
				if(VisualSelector.getInstance().isSelected(control))
					ApplicationController.getInstance().getElementEditor().editIfFace(control.getFace(),true);
				control.destroy();
			}
			controls = tmpControls.slice(0);
			ApplicationController.getInstance().getBlockList().update();
			pastedControls = [];
		}
		
		// Function used to refresh the tree only when all copied controls are loaded
		
		private function countBlock(e:Event):void
		{
			count++ ;
			
			if(count == controls.length)
			{
				ApplicationController.getInstance().getBlockList().update();
				dispatchEvent(new Event(Event.COMPLETE));
				count=0;
			}
		}
		// Function used to refresh the tree only when all copied controls are loaded
		
		private function nameHaveChange(e:FieEvent):void
		{	
			
			trace("NAMEHAVECHANGE :: "+e.target.uuid+ "old : "+e.info.oldId);
			
			ApplicationController.getInstance().getCommand().addCommand(new ChangeUuidCommand(e.target.uuid, e.info.oldId, page));

		}
	}
}