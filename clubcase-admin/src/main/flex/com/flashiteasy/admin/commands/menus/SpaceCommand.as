package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.parameters.AlignParameterSet;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class SpaceCommand extends AbstractCommand
	{
		private var controls:Array=[];
		private var positions:Dictionary=new Dictionary();
		private var aligns:Dictionary=new Dictionary();
		private var _alignType:String;
		private var refElement:IUIElementDescriptor;
		private var refPoint:Point;
		private var page:Page;
		private var maxW:Number=0;
		private var maxH:Number=0;
		private var xSpaceBetween:Number;
		private var ySpaceBetween:Number;
		private var isXUpsideDown:Boolean=false;
		private var isYUpsideDown:Boolean=false;

		public function SpaceCommand(controls:Array, alignType:String)
		{
			var control:IUIElementDescriptor;
			var controlsId:Array=[];
			page=BrowsingManager.getInstance().getCurrentPage();
			for each (control in controls)
			{
				controlsId.push(control.uuid);
				var currentElement:IUIElementDescriptor=ElementList.getInstance().getElement(control.uuid, page);
				maxW+=currentElement.getFace().width;
				maxH+=currentElement.getFace().height;
			}
			this.controls=controlsId;
			var divider:int=this.controls.length - 1;
			_alignType=alignType;
			// use the first selected control as reference
			refElement=ElementList.getInstance().getElement(this.controls[0], page);

			var lastRefElement:IUIElementDescriptor=ElementList.getInstance().getElement(this.controls[divider], page);

			refPoint=refElement.getFace().localToGlobal(new Point);
			var lastRefPoint:Point=lastRefElement.getFace().localToGlobal(new Point());
			var xSpace:Number;
			if (lastRefPoint.x < refPoint.x)
			{
				xSpace=refPoint.x + refElement.getFace().width - lastRefPoint.x;
				isXUpsideDown=true;
			}
			else
			{
				xSpace=lastRefPoint.x + lastRefElement.getFace().width - refPoint.x;
			}
			var ySpace:Number;

			if (lastRefPoint.y < refPoint.y)
			{
				ySpace=refPoint.y + refElement.getFace().height - lastRefPoint.y;
				isYUpsideDown=true;

			}
			else
			{
				ySpace=lastRefPoint.y + lastRefElement.getFace().height - refPoint.y;
			}
			xSpaceBetween=(xSpace - maxW) / divider;
			ySpaceBetween=(ySpace - maxH) / divider;

		}

		public override function execute():void
		{
			var control:IUIElementDescriptor
			var id:String;
			var selectedIndex:int=-1;
			var spaceBetween:Number;
			var previousControl:IUIElementDescriptor=null;
			var previousGlobalPoint:Point;
			var hBetween:Number=0;
			var vBetween:Number=0;
			for each (id in controls)
			{
				if (previousControl != null)
				{
					previousControl=ElementList.getInstance().getElement(controls[selectedIndex], page);
					var pX:Number=isXUpsideDown ? 0 : previousControl.getFace().width;
					var pY:Number=isYUpsideDown ? 0 : previousControl.getFace().height;
					//var fromPoint:Point = isXUpsideDown ? new Point() : new Point(previousControl.getFace().width,previousControl.getFace().height);
					previousGlobalPoint=previousControl.getFace().localToGlobal(new Point(pX, pY));
					hBetween=xSpaceBetween;
					vBetween=ySpaceBetween;
				}
				else
				{
					previousControl=refElement;
					previousGlobalPoint=refPoint;
				}
				selectedIndex++;
				control=ElementList.getInstance().getElement(id, page);
				// Change the position of the control
				storeControlPosition(control);

				var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), control) as PositionParameterSet;
				var parent:IUIElementContainer=control.getParent();
				var referenceContainer:Sprite;
				if (parent == null)
				{
					referenceContainer=AbstractBootstrap.getInstance();
				}
				else
				{
					referenceContainer=parent.getFace();
				}
				var point:Point=referenceContainer.globalToLocal(previousGlobalPoint);
				positionParameter.is_percent_x=false;
				positionParameter.is_percent_y=false;

				switch (_alignType)
				{
					case "h":
						if (!isXUpsideDown || selectedIndex == 0)
						{
							positionParameter.x=point.x + hBetween;
						}
						else
						{
							positionParameter.x=point.x - hBetween - control.getFace().width;
						}
						break;

					case "v":
						if (!isYUpsideDown || selectedIndex == 0)
						{
							positionParameter.y=point.y + vBetween;
						}
						else
						{
							positionParameter.y=point.y- vBetween - control.getFace().height;
						}
						break;
				}

				var alignParameter:AlignParameterSet=ParameterIntrospectionUtil.retrieveParameter(new AlignParameterSet, control) as AlignParameterSet;
				alignParameter.h_align="left";
				alignParameter.v_align="top";
				// Redraw control
				positionParameter.apply(control);
				alignParameter.apply(control);
				control.invalidate();
				if(VisualSelector.getInstance().isSelected(control))
				{
					VisualSelector.getInstance().refresh();
					/*if (panel != null && VisualSelector.getInstance().getSelectedElements()[0]==control)
					{
						panel.reset(paramEditor, ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param));
					}*/
				}
			}
		}



		private function storeControlPosition(control:IUIElementDescriptor):void
		{
			var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet, control) as PositionParameterSet;
			var alignParameter:AlignParameterSet=ParameterIntrospectionUtil.retrieveParameter(new AlignParameterSet, control) as AlignParameterSet;
			positions[control.uuid]={x: positionParameter.x, y: positionParameter.y, is_percent_x: positionParameter.is_percent_x, is_percent_y: positionParameter.is_percent_y, h_align: alignParameter.h_align, v_align: alignParameter.v_align};
		}

		public override function undo():void
		{
			var control:IUIElementDescriptor;
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			var parent:IUIElementContainer;
			for (var id:String in positions)
			{
				control=ElementList.getInstance().getElement(id, page);
				var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet, control) as PositionParameterSet;
				var alignParameter:AlignParameterSet=ParameterIntrospectionUtil.retrieveParameter(new AlignParameterSet, control) as AlignParameterSet;
				positionParameter.x=positions[id].x;
				positionParameter.y=positions[id].y;
				positionParameter.is_percent_x=positions[id].is_percent_y;
				positionParameter.is_percent_y=positions[id].is_percent_y;
				alignParameter.h_align=positions[id].h_align;
				alignParameter.v_align=positions[id].v_align;
				positionParameter.apply(control);
				alignParameter.apply(control);
				control.invalidate();
				if(VisualSelector.getInstance().isSelected(control))
				{
					VisualSelector.getInstance().refresh();
					/*if (panel != null && VisualSelector.getInstance().getSelectedElements()[0]==control)
					{
						panel.reset(paramEditor, ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param));
					}*/
				}
			}
		}

		public override function redo():void
		{
			execute();
		}
	}
}