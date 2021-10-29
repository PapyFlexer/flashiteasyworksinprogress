package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.edition.IElementEditorPanel;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.utils.EditorUtil;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.admin.workbench.IElementEditor;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.ControlUtils;

	public class ChangeParameterCommand extends AbstractCommand
	{

		private var parameter:IParameterSet;
		private var property:Array;
		private var uuid:String;
		private var page:Page;
		private var value:Array;
		private var oldValue:Array;
		private var paramEditor:IElementEditor;
		private var editionDescriptor:ParameterSetEditionDescriptor;
		private var elementType:String;

		public function ChangeParameterCommand(elem:IDescriptor, editionDescriptor:IParameterSet, property:Array, value:Array, oldValue:Array, elEditor:IElementEditor)
		{
			this.page=elem.getPage();
			this.uuid=elem.uuid;
			this.elementType=(elem is IUIElementDescriptor) ? "element" : "action";
			this.property=property;
			this.parameter=editionDescriptor;
			this.value=value;
			this.oldValue=oldValue;
			this.paramEditor=elEditor;
		}

		public override function execute():void
		{
		}

		public override function undo():void
		{

			var elem:IDescriptor=elementType == "element" ? ElementList.getInstance().getElement(uuid, page) : ActionList.getInstance().getAction(uuid, page);

			var panel:IElementEditorPanel=EditorUtil.retrieveEditor(parameter);
			var param:IParameterSet=ControlUtils.retrieveParameter(parameter, elem);
			for (var i:int=0; i < property.length; i++)
			{
				param[property[i]]=oldValue[i];
			}
			param.apply(elem);
			if (elem is IUIElementDescriptor)
			{
				IUIElementDescriptor(elem).invalidate();
				if (VisualSelector.getInstance().isSelected(IUIElementDescriptor(elem)))
				{
					VisualSelector.getInstance().refresh();
					if (panel != null && VisualSelector.getInstance().getSelectedElements()[0] == elem)
					{
						panel.reset(paramEditor, ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param));
					}
				}
			}
			else
			{
				if (panel != null)
				{
					ApplicationController.getInstance().getElementEditor().clearEditor();
					//panel.reset(paramEditor, ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param));
				}
			}
		}

		public override function redo():void
		{
			//execute();

			var elem:IDescriptor=elementType == "element" ? ElementList.getInstance().getElement(uuid, page) : ActionList.getInstance().getAction(uuid, page);
			var panel:IElementEditorPanel=EditorUtil.retrieveEditor(parameter);
			var param:IParameterSet=ControlUtils.retrieveParameter(parameter, elem);

			for (var i:int=0; i < property.length; i++)
			{
				param[property[i]]=value[i];
			}
			param.apply(elem);
			if (elem is IUIElementDescriptor)
			{
				IUIElementDescriptor(elem).invalidate();

				if (VisualSelector.getInstance().isSelected(IUIElementDescriptor(elem)))
				{
					VisualSelector.getInstance().refresh();
					if (panel != null && VisualSelector.getInstance().getSelectedElements()[0] == elem)
					{
						panel.reset(paramEditor, ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param));
					}
				}
			}

			else
			{
				//ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param).
				if (panel != null)
				{
					ApplicationController.getInstance().getElementEditor().clearEditor();
					//panel.reset(paramEditor, ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param));
				}
			}
		}

	}
}