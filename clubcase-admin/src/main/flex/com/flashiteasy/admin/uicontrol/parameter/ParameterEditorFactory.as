package com.flashiteasy.admin.uicontrol.parameter
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.components.DataGridDefiner;
	import com.flashiteasy.admin.components.EventEditor;
	import com.flashiteasy.admin.components.FieColorPicker;
	import com.flashiteasy.admin.components.FilePicker;
	import com.flashiteasy.admin.components.MaskType;
	import com.flashiteasy.admin.components.RemoteEditor;
	import com.flashiteasy.admin.components.ValidatorType;
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.FilterWorkbench;
	import com.flashiteasy.admin.components.playStory.PlayStoryEditor;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.parameter.Parameter;
	import com.flashiteasy.admin.uicontrol.FormComboBox;
	import com.flashiteasy.admin.uicontrol.PageTree;
	import com.flashiteasy.admin.uicontrol.RichTextEditorPanel;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	import com.flashiteasy.api.parameters.ChangeValueParameterSet;
	import com.flashiteasy.api.parameters.FilterParameterSet;
	import com.flashiteasy.api.parameters.TextParameterSet;
	import com.flashiteasy.api.parameters.ToggleStoryParameterSet;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.PageUtils;

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.HSlider;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.NumericStepper;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.*;

	public class ParameterEditorFactory
	{
		public function ParameterEditorFactory()
		{
		}

		private var control:DisplayObject;
		private var pset:IParameterSet;

		public function getEditor(p:Parameter, pset:IParameterSet=null):DisplayObject
		{
			//trace ("factory sets the editor to get" + p.getType() + "Control() with "+ParameterIntrospectionUtil.getParameterSetName(pset));
			var method:Function=this["get" + p.getType() + "Control"];
			if (pset != null)
			{
				this.pset=pset;
			}
			method.apply(this, [p]);
			control.name=p.getName();
			return control;
		}


		public function getEditorValue(editor:DisplayObject):*
		{
			var value:*;
			switch (getQualifiedClassName(editor).split("::")[1])
			{
				case "NumericStepper":
					value=NumericStepper(editor).value;
					break;
				/* petit probleme sur le mask ...
				   case "MaskType":
				   param["enable"]=true;//MaskType(editor).
				   CompositeParameterSet(param).setParameterSet( MaskType(editor).getParameter());
				   break;
				 */
				case "CheckBox":
					value=CheckBox(editor).selected;
					break;
				case "ComboList":
					break;
				case "List":
					value=List(editor).selectedItems;
					break;
				case "ComboBox":
					value=ComboBox(editor).selectedItem;
					break;
				case "HSlider":
					value=HSlider(editor).value;
					break;
				case "advancedSlider":
					value=advancedSlider(editor).value;
					break;
				case "FieColorPicker":
					value=FieColorPicker(editor).getColorValue();
					break;
				case "TextInput":
					value=TextInput(editor).text;
					break;
				case "FilePicker":
					value=FilePicker(editor).selectedFile;
					break;
				case "EventEditor":
					value=EventEditor(editor).triggers;
					break;
				case "PageTree":
					value=PageTree(editor).getSelectedLink();
					break;
				case "FormComboBox":
					value=FormComboBox(editor).getSelectedFormName();
					break;
				case "Validator":
				case "ValidatorType":
					//trace ("setting the validator to "+ValidatorType(editor).type.selectedItem);
					value=ValidatorType(editor).type.selectedItem;
					break;
			}
			return value;
		}

		public function updateParameterWithEditorValue(editor:DisplayObject, param:IParameterSet):void
		{

			var targetName:String=editor.name;

			// TODO Replace the if...else if statements with a clean mapping class


			switch (getQualifiedClassName(editor).split("::")[1])
			{
				case "RemoteEditor":
					//param[targetName]=RemoteEditor(editor).getRemoteParameterSet();

					param=RemoteEditor(editor).getParameter();
					break;
				case "NumericStepper":
					param[targetName]=NumericStepper(editor).value;
					break;
				case "MaskType":
					param["enable"]=MaskType(editor).getEnable(); //MaskType(editor).
					CompositeParameterSet(param).setParameterSet(MaskType(editor).getParameter());
					break;
				case "ValidatorType":
					param["enable"]=ValidatorType(editor).getEnable();
					CompositeParameterSet(param).setParameterSet(ValidatorType(editor).getParameter());
					break;
				case "Validator":
					param["enable"]=ValidatorType(editor).getEnable(); //MaskType(editor).
					param[targetName]=ValidatorType(editor).type.selectedItem;
					break;
				case "CheckBox":
					param[targetName]=CheckBox(editor).selected;
					break;
				case "List":
					param[targetName]=List(editor).selectedItems;
					break;
				case "ComboBox":
					param[targetName]=ComboBox(editor).selectedItem;
					break;
				case "HSlider":
					param[targetName]=HSlider(editor).value;
					break;
				case "advancedSlider":
					param[targetName]=advancedSlider(editor).value;
					break;
				case "FieColorPicker":
					param[targetName]=FieColorPicker(editor).getColorValue();
					break;
				case "TextInput":
					param[targetName]=TextInput(editor).text;
					break;
				case "FilePicker":
					param[targetName]=FilePicker(editor).selectedFile;
					break;
				case "EventEditor":
					param[targetName]=EventEditor(editor).triggers;
					break;
				case "PageTree":
					param[targetName]=PageTree(editor).getSelectedLink();
					break;
				case "FormComboBox":
					param[targetName]=FormComboBox(editor).getSelectedFormName();
					break;
				case "PlayStoryEditor":
					param=PlayStoryEditor(editor).getParameter();
					break;
				case "RichTextEditorPanel":
					param=RichTextEditorPanel(editor).getParameter();
					break;
			}
		}

		private function getParameterEditorControl(p:Parameter):void
		{
			control=new ChangeParameterEditor;
			ChangeParameterEditor(control).setParameter(ChangeValueParameterSet(pset));
		}


		/**
		 * Returns a ComboBox containing the list of pages.
		 */

		private function getPageComboControl(p:Parameter):void
		{
			control=new PageTree();
			var provider:XMLList=ApplicationController.getInstance().getNavigation().buildDataProvider();
			PageTree(control).dataProvider=provider;
			PageTree(control).setSelectedPage(p.getDefaultValue() as String);
		}

		/**
		 * Returns a ComboBox containing the list of Forms in a Page.
		 */
		private function getFormComboBoxControl(p:Parameter):void
		{
			control=new FormComboBox();
			var provider:Array=PageUtils.getPageForms(BrowsingManager.getInstance().getCurrentPage());
			FormComboBox(control).dataProvider=provider;
			FormComboBox(control).setSelectedForm(p.getDefaultValue());
		}

		/**
		 * Returns an EventEditor as editor
		 */
		private function getEventControl(p:Parameter):void
		{
			control=new EventEditor();
			if (p.getDefaultValue() != null)
			{
				var o:*=p.getDefaultValue();
				EventEditor(control).initValues(pset, o);
			}
		}

		/**
		 * Returns a advancedSlider as editor
		 */
		private function getSliderControl(p:Parameter):void
		{
			control=new advancedSlider();
			advancedSlider(control).minimum=new Number(p.getMin());
			advancedSlider(control).maximum=new Number(p.getMax());
			advancedSlider(control).interval=new Number(p.getInterval());
			if (p.getDefaultValue() != null)
			{
				advancedSlider(control).value=new Number(p.getDefaultValue());
			}
		}

		/**
		 * Returns a default Label as editor
		 */
		private function getControl(p:Parameter):void
		{
			control=new Label();
			Label(control).text="-";
		}

		/**
		 * Returns a TextInput control
		 */
		private function getTextInputControl(p:Parameter):void
		{
			control=new TextInput();
			TextInput(control).text=p.getDefaultValue();
		}

		/**
		 * Returns a TextInput as editor
		 */
		private function getTextControl(p:Parameter):void
		{
			control=new RichTextEditorPanel;
			RichTextEditorPanel(control).setText(String(p.getDefaultValue()));
			RichTextEditorPanel(control).setTextParameter(TextParameterSet(pset));
		}

		/**
		 * Returns a TextInput as editor
		 */
		private function getStringControl(p:Parameter):void
		{
			control=new TextInput();
			TextInput(control).width=224;
			TextInput(control).maxWidth=224;
			if (p.getDefaultValue() != null)
			{
				TextInput(control).text=new String(p.getDefaultValue());
			}
		}


		private function getMaskTypeControl(p:Parameter):void
		{
			control=new MaskType();
			MaskType(control).init(p.getDefaultValue(), pset);
		}

		private function getValidatorTypeControl(p:Parameter):void
		{
			control=new ValidatorType();
			ValidatorType(control).init(p.getDefaultValue(), pset);
		}

		private function getValidatorControl(p:Parameter):void
		{
			control=new ValidatorType();
			ValidatorType(control).init(p.getDefaultValue(), pset);
		}

		/**
		 *
		 * Returns a NumericStepper as editor
		 */
		private function getNumberControl(p:Parameter):void
		{
			control=new NumericStepper();
			if (p.getDefaultValue() != null)
			{
				NumericStepper(control).minimum=new Number(p.getMin());
				NumericStepper(control).maximum=new Number(p.getMax());
				NumericStepper(control).value=new Number(p.getDefaultValue());
				NumericStepper(control).stepSize=new Number(p.getInterval());
			}
			NumericStepper(control).maxWidth=79;
		}

		/**
		 * Returns a FilePicker as editor
		 */
		private function getSourceControl(p:Parameter):void
		{
			control=new FilePicker();
			if (p.getDefaultValue() != null)
			{
				FilePicker(control).selectedFile=p.getDefaultValue();
			}
		}

		private function getFilterControl(p:Parameter):void
		{
			control=new FilterWorkbench;
			FilterWorkbench(control).setFilters(FilterParameterSet(pset));
		}

		/**
		 * Returns a CheckBox as editor
		 */
		private function getBooleanControl(p:Parameter):void
		{
			control=new CheckBox();
			if (p.getDefaultValue() != null)
			{
				CheckBox(control).selected=p.getDefaultValue().toString() == "true" ? true : false;
			}
		}

		private function getComboListControl(p:Parameter):void
		{
			control=new PlayStoryEditor;
			//if (p.getDefaultValue() != null)
			//{
			PlayStoryEditor(control).setPlayStoryParameter(ToggleStoryParameterSet(pset));
			var url:String=BrowsingManager.getInstance().getCurrentPage().getPageUrl();
			if (url != null)
			{
				PlayStoryEditor(control).setComboDataProvider(url.split("/"));

			}
			PlayStoryEditor(control).setListDataProvider(IParameterSetStaticValues(pset).getPossibleValues(p.getName()));

			if (p.getDefaultValue() != null)
			{
				PlayStoryEditor(control).setSelectedStories(ToggleStoryParameterSet(pset).pageURL, p.getDefaultValue());
			}
			//}
		}

		private function getListControl(p:Parameter):void
		{
			control=new List();
			{
				List(control).dataProvider=IParameterSetStaticValues(pset).getPossibleValues(p.getName());
				List(control).allowMultipleSelection=true;
				List(control).labelField=p.getLabelField();
				List(control).percentWidth=100;
				if (p.getDefaultValue() != null)
				{
					if (p.getDefaultValue() is Array)
						List(control).selectedItems=p.getDefaultValue();
					else
						List(control).selectedItem=p.getDefaultValue();
				}
			}
		}


		/**
		 * Returns a ColorPicker as editor
		 */
		private function getColorControl(p:Parameter):void
		{
			control=new FieColorPicker();
			if (p.getDefaultValue() != null)
			{
				FieColorPicker(control).setColorValue(Number(p.getDefaultValue()));
			}
		}

		/**
		 * Returns a ComboBox as editor
		 */
		private function getComboControl(p:Parameter):void
		{
			control=new ComboBox();

			var values:Array=IParameterSetStaticValues(pset).getPossibleValues(p.getName());
			ComboBox(control).maxWidth=224;
			ComboBox(control).dataProvider=values;
			ComboBox(control).labelFunction=translateLabel;
			if (p.getDefaultValue() != null)
			{
				var index:int=ArrayUtils.getIndex(values, p.getDefaultValue());
				ComboBox(control).selectedIndex=index;
			}
			else
			{
				ComboBox(control).selectedIndex=-1;
			}
		}

		private function getRemoteControl(p:Parameter):void
		{
			control=new RemoteEditor;
			RemoteEditor(control).initEditor(RemoteParameterSet(pset));
		}

		/**
		 * Returns an editable DataGrid as editor
		 */
		private function getEditableDataGridControl(p:Parameter):void
		{
			control=new DataGridDefiner();
			DataGridDefiner(control).buildEditor(pset);
		}

		private function translateLabel(item:Object):String
		{
			return Conf.languageManager.getLanguage(String(item));
		}

	}
}