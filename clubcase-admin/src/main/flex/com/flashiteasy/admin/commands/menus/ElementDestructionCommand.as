package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.commands.IRedoableCommand;
	import com.flashiteasy.admin.commands.IUndoableCommand;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;

	public class ElementDestructionCommand extends AbstractCommand implements IUndoableCommand,IRedoableCommand
	{
		private var elementId:String;
		private var controlCopy : IUIElementDescriptor ;
		private var parent : IUIElementContainer ;
		private var parentId : String ;
		private var page:Page ;
		private var oldIndex : int ;
		private var parentPage : Page ;
		
		public function ElementDestructionCommand( el : IUIElementDescriptor )
		{
			elementId=el.uuid;
			page=el.getPage();
		}
		
		public override function execute():void
		{
			
			var control : IUIElementDescriptor =  ElementList.getInstance().getElement(elementId,page);
			// Deselect control if selected
			if(VisualSelector.getInstance().isSelected(control))
				ApplicationController.getInstance().getElementEditor().editIfFace(control.getFace(),true);
			controlCopy =control.clone(true);
			if(control.getParent()!=null)
			{
				parentId= control.getParent().uuid;
				parentPage = control.getParent().getPage();
			}
			oldIndex = control.getIndex();
			control.destroy();
			ApplicationController.getInstance().getBlockList().update();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		
		public override function undo():void
		{
			controlCopy.setPage(page);
			//controlCopy.dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
			
			if(parentId !=null ) 
			{
				parent = ElementList.getInstance().getElement(parentId ,parentPage) as IUIElementContainer;
				parent.layoutElement(controlCopy);
				parent.swapChildAt(controlCopy , oldIndex );
			}
			else
			{
				controlCopy.addEventListener(FieEvent.COMPLETE , replaceAtIndex ) ;
			}
			controlCopy.applyParameters();
			AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack( page );
			ApplicationController.getInstance().getBlockList().update();
		}
		
		private function replaceAtIndex(e:Event):void
		{
			var el:IUIElementDescriptor = e.target as IUIElementDescriptor;
			el.removeEventListener(FieEvent.COMPLETE , replaceAtIndex);
			el.getFace().parent.addChildAt(el.getFace(),oldIndex);
			ElementList.getInstance().moveElementOnStageToIndex(el , oldIndex );	
			ApplicationController.getInstance().getBlockList().update();
		}
		
		public override function redo():void
		{
			
			execute();
			
			
		}
		
	}
}