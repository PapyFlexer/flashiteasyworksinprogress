package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class DegroupCommand extends AbstractCommand
	{
		private var container : IUIElementContainer;
		private var clone : IUIElementContainer ;
		private var controls : Array = [];
		private var parent : String ;
		private var oldIndex : int ; 
		
		public function DegroupCommand( container : IUIElementContainer)
		{
			this.container=container;
			if(container.getParent()!=null)
			{
				parent = container.getParent().uuid;
			}
			
		}
		
		public override function execute():void
		{
			
			controls = container.getChildren();
			var control : IUIElementDescriptor ;
			var parent : IUIElementContainer = container.getParent();
			var point : Point ; 
			var children : Array = [];
			
			// Storing container index
			
			oldIndex = container.getIndex();
			
			for each ( control in controls )
			{
				
				// Calculate new coordinate of the control so it keeps the same place
				
				var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), control) as PositionParameterSet;
				point=control.getFace().localToGlobal(new Point);
				if(parent == null )
				{
					point=AbstractBootstrap.getInstance().globalToLocal(point);
				}
				else
				{
					point=	parent.getFace().globalToLocal(point);
				}
				positionParameter.x=point.x;
				positionParameter.y=point.y;
				
				// Remove from container
				control.removeFromParent();
				// move the control to the parent of the degrouped container
				if(parent == null)
				{
					AbstractBootstrap.getInstance().addChild(control.getFace());
				}
				else
				{
					parent.layoutElement(control);
				}
				// Apply new position and redraw
				positionParameter.apply(control);
				control.invalidate();
				// Add the uuid to a new list to be able to retrieve the control for an undo
				children.push(control.uuid);
			}
			// Deselect container
			if(VisualSelector.getInstance().isSelected(container))
			{
				VisualSelector.getInstance().deselect(container);
			}
			// Make a clone of the container to be able to undo
			this.clone = container.clone(true) as IUIElementContainer;
			// trash container coz it s useless
			container.destroy();
			controls = children;
			ApplicationController.getInstance().getBlockList().update();
		}
		
		public override function undo():void
		{
			var page : Page = BrowsingManager.getInstance().getCurrentPage();
			var point : Point ;
			var control : IUIElementDescriptor;
			var id:String ;
			var containerParent : IUIElementContainer = ElementList.getInstance().getElement(parent , page ) as IUIElementContainer;
			
			this.clone.setPage( page );
			
			if(containerParent !=null ) 
			{
				containerParent.layoutElement(clone);
				containerParent.swapChildAt(clone , oldIndex );
			}
			else
			{
				clone.addEventListener(FieEvent.COMPLETE , replaceAtIndex ) ;
			}
			clone.setPage(page);
			clone.applyParameters();
			for each( id in controls ) 
			{
				control = ElementList.getInstance().getElement(id,page);
				
				// Give proper coordinates to the control so they don t move
				var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), control) as PositionParameterSet;
				point=control.getFace().localToGlobal(new Point);
				point=clone.getFace().globalToLocal(point);
				positionParameter.x=point.x;
				positionParameter.y=point.y;
				
				// Add control to the container
				control.removeFromParent();
				clone.layoutElement(control);
				
				// redraw control
			
				positionParameter.apply(control);
				control.invalidate();
			}
			
			this.parent = clone.uuid;
			clone=null;
			ApplicationController.getInstance().getBlockList().update();
		}
		
		// IF the container was on the stage , give it the proper index
		private function replaceAtIndex(e:Event ) : void
		{
			var el:IUIElementDescriptor = e.target as IUIElementDescriptor;
			el.removeEventListener(FieEvent.COMPLETE , replaceAtIndex);
			el.getFace().parent.addChildAt(el.getFace(),oldIndex);
			ElementList.getInstance().moveElementOnStageToIndex(el , oldIndex );	
			ApplicationController.getInstance().getBlockList().update();
		}
		
		public override function redo():void
		{
			this.container = ElementList.getInstance().getElement(parent , BrowsingManager.getInstance().getCurrentPage()) as IUIElementContainer;
			parent = null;
			if(container.getParent()!=null)
			{
				parent = container.getParent().uuid;
			}
			execute();
		}
	}
}