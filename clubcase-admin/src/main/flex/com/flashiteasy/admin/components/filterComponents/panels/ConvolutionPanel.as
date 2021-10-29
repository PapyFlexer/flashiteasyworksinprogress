package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.FieColorPicker;
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.ConvolutionFactory;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ConvolutionFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.ColorPickerEvent;
	import mx.events.FlexEvent;
	
	public class ConvolutionPanel extends Canvas implements IFilterPanel
	{
		// ------- Constants -------
		public const matrixXValue:Number = 3;
		public const matrixYValue:Number = 3;
		
		// --- Presets ---
		private static const NONE:String = "none";
		private static const SHIFT_LEFT:String = "shiftLeft";
		private static const SHIFT_UP:String = "shiftUp";
		private static const BLUR:String = "blur";
		private static const ENHANCE:String = "enhance";
		private static const SHARPEN:String = "sharpen";
		private static const CONTRAST:String = "contrast";
		private static const EMBOSS:String = "emboss";
		private static const EDGE_DETECT:String = "edge";
		private static const HORIZONTAL_EDGE:String = "hEdge";
		private static const VERTICAL_EDGE:String = "vEdge";
		
		
		// ------- Private vars -------
		private var _filterFactory:ConvolutionFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var presetChooser:ComboBox;
		public var matrixTL:TextInput;
		public var matrixTC:TextInput;
		public var matrixTR:TextInput;
		public var matrixML:TextInput;
		public var matrixMC:TextInput;
		public var matrixMR:TextInput;
		public var matrixBL:TextInput;
		public var matrixBC:TextInput;
		public var matrixBR:TextInput;
		public var divisorValue:TextInput;
		public var colorValue:FieColorPicker;
		public var alphaValue:advancedSlider;
		public var biasValue:TextInput;
		public var clampValue:CheckBox;
		public var preserveAlphaValue:CheckBox;
		
		private var panel : _ConvolutionPanel = new _ConvolutionPanel;
		
		// ------- Constructor -------
		public function ConvolutionPanel()
		{
			// create the filter factory
			_filterFactory = new ConvolutionFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE , setupChildren);
			presetChooser=panel.presetchooser;
			matrixTL=panel.matrixTL;
			matrixTC=panel.matrixTC;
			matrixTR=panel.matrixTR;
			matrixML=panel.matrixML;
			matrixMC=panel.matrixMC;
			matrixMR=panel.matrixMR;
			matrixBL=panel.matrixBL;
			matrixBC=panel.matrixBC;
			matrixBR=panel.matrixBR;
			divisorValue=panel.divisorValue;
			colorValue=panel.colorValue;
			alphaValue=panel.alphaValue;
			biasValue=panel.biasValue;
			clampValue=panel.clampValue;
			preserveAlphaValue=panel.preserveAlphaValue;
		}
		
		
		// ------- Public Properties -------
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}
		
		
		// ------- Public methods -------
		public function resetForm():void
		{
			setPreset("0", "0", "0", "0", "1", "0", "0", "0", "0", "1", "0", true);
			alphaValue.value = 0;
			clampValue.selected = true;
			colorValue.selectedColor = 0x000000;
			presetChooser.selectedIndex = -1;
			
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilter();
			}
		}
		
		private var convolutionFilter:ConvolutionFilter;
		public function setValues( filter : * ):void
		{
			if(filter is ConvolutionFilter)
			{
				convolutionFilter = ConvolutionFilter(filter);
			}
		}
		
		
		private function initFilter():void
		{
			if(convolutionFilter != null )
			{
				
				//setPreset("0", "0", "0", "0", "1", "0", "0", "0", "0", "1", "0", true);
				panel.alphaValue.value = convolutionFilter.alpha;
				panel.clampValue.selected = convolutionFilter.clamp;
				panel.colorValue.selectedColor = convolutionFilter.color;
				panel.biasValue.text = String(convolutionFilter.bias);
				panel.divisorValue.text = String(convolutionFilter.divisor);
				panel.preserveAlphaValue.selected = convolutionFilter.preserveAlpha;
				panel.matrixTL.text = convolutionFilter.matrix[0];
				panel.matrixTC.text = convolutionFilter.matrix[1];
				panel.matrixTR.text = convolutionFilter.matrix[2];
				panel.matrixML.text = convolutionFilter.matrix[3];
				panel.matrixMC.text = convolutionFilter.matrix[4];
				panel.matrixMR.text = convolutionFilter.matrix[5];
				panel.matrixBL.text = convolutionFilter.matrix[6];
				panel.matrixBC.text = convolutionFilter.matrix[7];
				panel.matrixBR.text = convolutionFilter.matrix[8];
				panel.presetchooser.selectedIndex = -1;
				updateFilter();
			}
		}
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, setupChildren);
			
			// populate the preset chooser combo box
			var presetData:Array = [{label:Conf.languageManager.getLanguage("None"), data:NONE},{label:Conf.languageManager.getLanguage("Shift_pixels_left"), data:SHIFT_LEFT},{label:Conf.languageManager.getLanguage("Shift_pixels_up"), data:SHIFT_UP},{label:Conf.languageManager.getLanguage("Blur"), data:BLUR},{label:Conf.languageManager.getLanguage("Enhance"), data:ENHANCE},{label:Conf.languageManager.getLanguage("Sharpen"), data:SHARPEN},{label:Conf.languageManager.getLanguage("Add_Contrast"), data:CONTRAST},{label:Conf.languageManager.getLanguage("Emboss"), data:EMBOSS},{label:Conf.languageManager.getLanguage("Edge_detect"), data:EDGE_DETECT},{label:Conf.languageManager.getLanguage("Horizontal_edge_detect"), data:HORIZONTAL_EDGE},{label:Conf.languageManager.getLanguage("Vertical_edge_detect"), data:VERTICAL_EDGE}];
			var presetList:ArrayCollection = new ArrayCollection(presetData);
			presetChooser.dataProvider = presetList;
			
			// add event listeners for child controls
			presetChooser.addEventListener(Event.CHANGE, choosePreset);
			
			matrixTL.addEventListener(Event.CHANGE, changeFilterValue);
			matrixTC.addEventListener(Event.CHANGE, changeFilterValue);
			matrixTR.addEventListener(Event.CHANGE, changeFilterValue);
			matrixML.addEventListener(Event.CHANGE, changeFilterValue);
			matrixMC.addEventListener(Event.CHANGE, changeFilterValue);
			matrixMR.addEventListener(Event.CHANGE, changeFilterValue);
			matrixBL.addEventListener(Event.CHANGE, changeFilterValue);
			matrixBC.addEventListener(Event.CHANGE, changeFilterValue);
			matrixBR.addEventListener(Event.CHANGE, changeFilterValue);
			divisorValue.addEventListener(Event.CHANGE, changeFilterValue);
			biasValue.addEventListener(Event.CHANGE, changeFilterValue);
			colorValue.addEventListener(ColorPickerEvent.CHANGE, changeNonPresetValue);
			alphaValue.addEventListener(Event.CHANGE, changeNonPresetValue);
			clampValue.addEventListener(MouseEvent.CLICK, changeNonPresetValue);
			preserveAlphaValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			initFilter();
		}
		
		
		private function choosePreset(event:Event):void
		{
			// populate the form values according to the selected preset
			switch (presetChooser.selectedItem.data)
			{
				case NONE:
					setPreset("0", "0", "0", "0", "1", "0", "0", "0", "0", "1", "0", preserveAlphaValue.selected);
					break;
				case SHIFT_LEFT:
					setPreset("0", "0", "0", "0", "0", "1", "0", "0", "0", "1", "0", preserveAlphaValue.selected);
					break;
				case SHIFT_UP:
					setPreset("0", "0", "0", "0", "0", "0", "0", "1", "0", "1", "0", preserveAlphaValue.selected);
					break;
				case BLUR:
					setPreset("0", "1", "0", "1", "1", "1", "0", "1", "0", "5", "0", preserveAlphaValue.selected);
					break;
				case ENHANCE:
					setPreset("0", "-2", "0", "-2", "20", "-2", "0", "-2", "0", "10", "-40", preserveAlphaValue.selected);
					break;
				case SHARPEN:
					setPreset("0", "-1", "0", "-1", "5", "-1", "0", "-1", "0", "1", "0", preserveAlphaValue.selected);
					break;
				case CONTRAST:
					setPreset("0", "0", "0", "0", "2", "0", "0", "0", "0", "1", "-255", preserveAlphaValue.selected);
					break;
				case EMBOSS:
					setPreset("-2", "-1", "0", "-1", "1", "1", "0", "1", "2", "1", "0", preserveAlphaValue.selected);
					break;
				case EDGE_DETECT:
					setPreset("0", "-1", "0", "-1", "4", "-1", "0", "-1", "0", "1", "0", true);
					break;
				case HORIZONTAL_EDGE:
					setPreset("0", "0", "0", "-1", "1", "0", "0", "0", "0", "1", "0", true);
					break;
				case VERTICAL_EDGE:
					setPreset("0", "-1", "0", "0", "1", "0", "0", "0", "0", "1", "0", true);
					break;
			}
			
			updateFilter();
		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// verify that the values are valid
			if (matrixTL.text.length <= 0) { return; }
			if (matrixTC.text.length <= 0) { return; }
			if (matrixTR.text.length <= 0) { return; }
			if (matrixML.text.length <= 0) { return; }
			if (matrixMC.text.length <= 0) { return; }
			if (matrixMR.text.length <= 0) { return; }
			if (matrixBL.text.length <= 0) { return; }
			if (matrixBC.text.length <= 0) { return; }
			if (matrixBR.text.length <= 0) { return; }
			if (divisorValue.text.length <= 0) { return; }
			if (biasValue.text.length <= 0) { return; }
			
			// clear the presets drop-down
			presetChooser.selectedIndex = -1;
			
			// update the filter
			updateFilter();
		}
		
		
		private function changeNonPresetValue(event:Event):void
		{
			// update the filter, but don't clear the preset
			updateFilter();
		}
			
			
		// ------- Private methods -------
		private function updateFilter():void
		{
			var alpha:Number = alphaValue.value;
			var bias:Number = Number(biasValue.text);
			var clamp:Boolean = clampValue.selected;
			var color:uint = colorValue.selectedColor;
			var divisor:Number = Number(divisorValue.text);
			var matrix:Array = [Number(matrixTL.text), Number(matrixTC.text), Number(matrixTR.text),
								 Number(matrixML.text), Number(matrixMC.text), Number(matrixMR.text),
								 Number(matrixBL.text), Number(matrixBC.text), Number(matrixBR.text)];
			var matrixX:Number = matrixXValue;
			var matrixY:Number = matrixYValue;
			var preserveAlpha:Boolean = preserveAlphaValue.selected;
			
			_filterFactory.modifyFilter(matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
		}
		
		
		private function setPreset(tl:String, tc:String, tr:String,
									 ml:String, mc:String, mr:String,
									 bl:String, bc:String, br:String,
									 divisor:String,
									 bias:String,
									 preserveAlpha:Boolean):void
		{
			matrixTL.text = tl;
			matrixTC.text = tc;
			matrixTR.text = tr;
			matrixML.text = ml;
			matrixMC.text = mc;
			matrixMR.text = mr;
			matrixBL.text = bl;
			matrixBC.text = bc;
			matrixBR.text = br;
			divisorValue.text = divisor;
			biasValue.text = bias;
			preserveAlphaValue.selected = preserveAlpha;
		}
	}
}