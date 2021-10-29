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

	public class AlignCommand extends AbstractCommand
	{
		private var controls:Array=[];
		private var positions:Dictionary=new Dictionary();
		private var aligns:Dictionary=new Dictionary();
		private var _alignType:String;
		private var refElement:IUIElementDescriptor;
		private var refPoint:Point;
		private var page:Page;

		public function AlignCommand(controls:Array, alignType:String)
		{
			var control:IUIElementDescriptor;
			var controlsId:Array=[];
			for each (control in controls)
			{
				controlsId.push(control.uuid);
			}
			this.controls=controlsId;
			_alignType=alignType;
			// use the first selected control as reference
			page=BrowsingManager.getInstance().getCurrentPage();
			refElement=ElementList.getInstance().getElement(this.controls[0], page);


			refPoint=refElement.getFace().localToGlobal(new Point);
		}

		public override function execute():void
		{
			var control:IUIElementDescriptor
			var id:String;
			for each (id in controls)
			{
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
				var point:Point=referenceContainer.globalToLocal(refPoint);
				positionParameter.is_percent_x=false;
				positionParameter.is_percent_y=false;
				switch (_alignType)
				{
					case "left":
						positionParameter.x=point.x;
						break;
					case "right":
						positionParameter.x=point.x + refElement.getFace().width - control.getFace().width;

						break;
					case "centerh":

						positionParameter.x=point.x + (refElement.getFace().width - control.getFace().width) / 2;
						break;

					case "top":
						positionParameter.y=point.y;
						break;
					case "bottom":
						positionParameter.y=point.y + refElement.getFace().height - control.getFace().height;

						break;
					case "centerv":

						positionParameter.y=point.y + (refElement.getFace().height - control.getFace().height) / 2;
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