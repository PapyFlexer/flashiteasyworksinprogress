package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.NameUtils;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;

	public class GroupCommand extends AbstractCommand
	{
		private var controls:Array=[];
		private var group:IUIElementContainer;
		private var groupId:String;
		private var positions:Dictionary=new Dictionary();
		private var index : Dictionary = new Dictionary ();
		private var wrapper:UIComponent;
		private var wrapperProperties : Object;

		public function GroupCommand(controls:Array)
		{
			var control : IUIElementDescriptor;
			var controlsId : Array = [];
			for each ( control in controls )
			{
				controlsId.push(control.uuid);
			}
			this.controls=controlsId;
		}

		// Group selected controls
		
		public override function execute():void
		{
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			// use the first selected control parent as the group container parent
			var parent:IUIElementContainer=ElementList.getInstance().getElement(controls[0],page).getParent();
			var referenceContainer:Sprite;
			// since all elements to group are multi selected , use the visual selector wrapper to get proper size and position
			if(wrapper == null)
			{
				wrapper=VisualSelector.getInstance().selectionBox;
				//wrapper=VisualSelector.getInstance().tool;
			}
			
			// Create a group container
			group=ApplicationController.getInstance().getBuilder().createElement(page, "container", NameUtils.findUniqueName("container", NameUtils.getAllNames(page)), "BlockElementDescriptor", parent) as IUIElementContainer;
			
			// if the first selected control as no parent , set the proper target container
			if (parent == null)
			{
				referenceContainer=AbstractBootstrap.getInstance();
			}
			else
			{
				referenceContainer=parent.getFace();
			}
			
			// Set size and position of the group container
			
			var containerPositionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), group) as PositionParameterSet;
			if(wrapperProperties == null ){
				var wrapperPoint:Point = new Point();
				var AbstractPoint: Point = AbstractBootstrap.getInstance().localToGlobal(new Point);
				//We add AbstractPoint because
				containerPositionParameter.x=referenceContainer.globalToLocal(wrapper.localToGlobal(wrapperPoint)).x+AbstractPoint.x;
				containerPositionParameter.y=referenceContainer.globalToLocal(wrapper.localToGlobal(wrapperPoint)).y+AbstractPoint.y;
			}
			else
			{
				containerPositionParameter.x=wrapper.x;
				containerPositionParameter.y=wrapper.y;
			}
			var containerSizeParameter:SizeParameterSet=ParameterIntrospectionUtil.retrieveParameter(new SizeParameterSet, group) as SizeParameterSet;
			containerSizeParameter.width=wrapper.width;
			containerSizeParameter.height=wrapper.height;
			group.applyParameters();
			
			// Start adding controls in the group container
			var point:Point=new Point;
			var control : IUIElementDescriptor
			var id :String ;
			for each (id in controls)
			{
				control = ElementList.getInstance().getElement(id , page);
				
				// Store the old position of the control to be able to undo
				storeControlPosition(control);
				
				// Change the position of the control
				
				var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), control) as PositionParameterSet;
				point=control.getFace().localToGlobal(new Point);
				point=group.getFace().globalToLocal(point);
				positionParameter.x=point.x;
				positionParameter.y=point.y;
				
				// move the control to the group container
				
				control.removeFromParent();
				group.layoutElement(control);
				
				// Redraw control
				positionParameter.apply(control);
				control.invalidate();
			}
			
			// Store wrapper properties of the visual selector to be able to undo/redo the group without the visual selector
			wrapperProperties = { x:wrapper.x,y:wrapper.y,width : wrapper.width , height : wrapper.height } ;
			// Deselect all elements
			VisualSelector.getInstance().flushElements();
			// Select the group container
			ApplicationController.getInstance().getElementEditor().editIfFace(group.getFace());
			ApplicationController.getInstance().getBlockList().update();
			this.groupId= group.uuid;
		}

		private function storeControlPosition(control:IUIElementDescriptor):void
		{
			var positionParameterSet : PositionParameterSet = ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet , control ) as PositionParameterSet;
			var face: FieUIComponent = control.getFace();
			if (control.getParent() == null)
				positions[control.uuid]={parent : null , index : control.getIndex(),x:face.x,y:face.y};
			else
			{
				positions[control.uuid]={parent : control.getParent().uuid , index : control.getIndex() ,x:face.x,y:face.y};
			}
		}

		public override function undo():void
		{
			var control : IUIElementDescriptor;
			var page : Page = BrowsingManager.getInstance().getCurrentPage();
			var parent : IUIElementContainer ;
			// Get the group container
			this.group = ElementList.getInstance().getElement(groupId,page) as IUIElementContainer;
			// Move all elements back to the initial container
			for(var id:String in positions)
			{
				control = ElementList.getInstance().getElement(id,page);
				// change all controls position to their old one
				var pSet : PositionParameterSet = ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet , control ) as PositionParameterSet;
				pSet.x = positions[id].x;
				pSet.y = positions[id].y;
				control.removeFromParent();
				if(positions[id].parent== null)
				{
					AbstractBootstrap.getInstance().addChildAt(control.getFace(),positions[id].index);
				}
				else
				{
					parent = ElementList.getInstance().getElement(positions[id].parent,page) as IUIElementContainer;
					parent.layoutElement(control);
					parent.swapChildAt(control,positions[id].index);
				}
				pSet.apply(control);
				control.invalidate();
				if(VisualSelector.getInstance().isSelected(control))
				{
					ApplicationController.getInstance().getElementEditor().editIfFace(control.getFace(),true);
				}
			}
			
			// Deselect and destroy the group
			
			if(VisualSelector.getInstance().isSelected(group))
			{
				ApplicationController.getInstance().getElementEditor().editIfFace(group.getFace(),true);
			}
			group.destroy();
			group = null;
			ApplicationController.getInstance().getBlockList().update();
		}

		public override function redo():void
		{
			wrapper = new UIComponent();
			wrapper.x=wrapperProperties.x;
			wrapper.y=wrapperProperties.y;
			wrapper.width = wrapperProperties.width;
			wrapper.height = wrapperProperties.height;
			execute();
		}
	}
}