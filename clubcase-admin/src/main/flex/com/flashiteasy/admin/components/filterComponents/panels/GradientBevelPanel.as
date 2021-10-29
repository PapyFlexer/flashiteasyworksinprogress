package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.GradientEditor;
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.*;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.GradientBevelFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.events.FlexEvent;
	
	public class GradientBevelPanel extends Canvas implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:GradientBevelFactory;
		
		private var _editValue:Number;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:NumericStepper;
		public var blurYValue:NumericStepper;
		public var strengthValue:NumericStepper;
		public var qualityValue:ComboBox;
		public var angleValue:advancedSlider;
		public var distanceValue:NumericStepper;
		public var knockoutValue:CheckBox;
		public var typeValue:ComboBox;
		public var selectedAlpha:advancedSlider;
		public var gradientEditor:GradientEditor;
		
		private var panel : _GradientBevelPanel = new _GradientBevelPanel;
		
		// ------- Constructor -------
		public function GradientBevelPanel()
		{
			// create the filter factory
			_filterFactory = new GradientBevelFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE , setupChildren);
			blurXValue=panel.blurXValue;
			blurYValue=panel.blurYValue;
			strengthValue=panel.strengthValue;
			qualityValue=panel.qualityValue;
			angleValue=panel.angleValue;
			distanceValue=panel.distanceValue;
			knockoutValue=panel.knockoutValue;
			typeValue=panel.typeValue;
			gradientEditor=panel.gradientEditor;
			selectedAlpha=panel.selectedAlpha;
		}
		
		
		// ------- Public Properties -------
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}
		
		private var defaultColors:Array = [0xFFFFFF,0xFF0000,0x000000];
		private var defaultAlphas:Array=[1,.25,1];
		private var defaultRatios:Array=[0,128,255];
		// ------- Public methods -------
		public function resetForm():void
		{
			blurXValue.value = 4;
			blurYValue.value = 4;
			strengthValue.value = 1;
			qualityValue.selectedIndex = 0;
			angleValue.value = 45;
			distanceValue.value = 4;
			knockoutValue.selected = false;
			typeValue.selectedIndex = 0;
			gradientEditor.colors = defaultColors;
			gradientEditor.alphas = defaultAlphas;
			gradientEditor.ratios = defaultRatios;
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilter();
			}
		}
		
		private var gradientBevelFilter:GradientBevelFilter;
		public function setValues( filter : * ):void
		{
			if(filter is GradientBevelFilter)
			{
				gradientBevelFilter = GradientBevelFilter(filter);
			}
		}
		
		
		private function initFilter():void
		{
			if(gradientBevelFilter != null )
			{
				
				panel.blurXValue.value = gradientBevelFilter.blurX;
				panel.blurYValue.value = gradientBevelFilter.blurY;
				panel.strengthValue.value = gradientBevelFilter.strength;
				panel.qualityValue.selectedIndex = gradientBevelFilter.quality - 1;
				panel.angleValue.value = gradientBevelFilter.angle;
				panel.distanceValue.value = gradientBevelFilter.distance;
				panel.knockoutValue.selected = gradientBevelFilter.knockout;
				panel.gradientEditor.colors = gradientBevelFilter.colors;
				panel.gradientEditor.alphas = gradientBevelFilter.alphas;
				panel.gradientEditor.ratios = gradientBevelFilter.ratios;
				//panel.typeValue.selectedIndex = 0;
				
				switch(gradientBevelFilter.type)
				{
					case BitmapFilterType.INNER :
						panel.typeValue.selectedIndex=0;
					break;
					case BitmapFilterType.OUTER :
						panel.typeValue.selectedIndex=1;
					break;
					case BitmapFilterType.FULL :
						panel.typeValue.selectedIndex=2;
					break;
				}
				updateFilter();
			}
		}
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, setupChildren);
			
			// populate the quality combo box
			var datas : Array = [{label:Conf.languageManager.getLanguage("Low"), data:BitmapFilterQuality.LOW},{label:Conf.languageManager.getLanguage("Medium"), data:BitmapFilterQuality.MEDIUM},{label:Conf.languageManager.getLanguage("High"), data:BitmapFilterQuality.HIGH}];
			var qualityList:ArrayCollection= new ArrayCollection(datas);
			qualityValue.dataProvider = qualityList;
			
			// populate the type combo box
			var typeDatas : Array = [{label:Conf.languageManager.getLanguage("Inner"), data:BitmapFilterType.INNER},{label:Conf.languageManager.getLanguage("Outer"), data:BitmapFilterType.OUTER},{label:Conf.languageManager.getLanguage("Full"), data:BitmapFilterType.FULL}]
			var typeList:ArrayCollection = new ArrayCollection(typeDatas);
			typeValue.dataProvider = typeList;
			
			// add event listeners for child controls
			blurXValue.addEventListener(Event.CHANGE, changeFilterValue);
			blurYValue.addEventListener(Event.CHANGE, changeFilterValue);
			strengthValue.addEventListener(Event.CHANGE, changeFilterValue);
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
			angleValue.addEventListener(Event.CHANGE, changeFilterValue);
			distanceValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			typeValue.addEventListener(Event.CHANGE, changeFilterValue);
			selectedAlpha.addEventListener(Event.CHANGE, changeAlphaValue);
			
			gradientEditor.addEventListener("colorsChange", changeFilterValue);
			gradientEditor.addEventListener("alphasChange", changeFilterValue);
			gradientEditor.addEventListener("ratiosChange", changeFilterValue);
			gradientEditor.addEventListener("selectedColorChange", changeFilterValue);
			gradientEditor.addEventListener("selectedAlphaChange", changeFilterValue);
			gradientEditor.addEventListener("selectedRatioChange", changeFilterValue);
			
			initFilter();
		}
		
		private function changeAlphaValue(event:Event):void
		{
			gradientEditor.selectedAlpha = advancedSlider(event.target).value
		}
		
		private function changeFilterValue(event:Event):void
		{
			// update the filter
			updateFilter();
		}
		
		
		
		// ------- DataGrid utility methods -------
		private function colorFormatter(data:Object):String
		{
			var c:GradientColor = data as GradientColor;
			if (c != null)
			{
				return ColorStringFormatter.formatColorHex24(c.color);
			}
			else
			{
				return "";
			}
		}
		
		
		
		// ------- Private methods -------
		private function updateFilter():void
		{
			var blurX:Number = blurXValue.value;
			var blurY:Number = blurYValue.value;
			var strength:Number = strengthValue.value;
			var quality:int = qualityValue.selectedItem.data;
			var angle:Number = angleValue.value;
			var distance:Number = distanceValue.value;
			var knockout:Boolean = knockoutValue.selected;
			var type:String = typeValue.selectedItem.data;
			//var colors:Array = gradientValues.dataProvider.toArray();
			var colors:Array = gradientEditor.colors;
			var alphas:Array = gradientEditor.alphas;
			var ratios:Array = gradientEditor.ratios;
			_filterFactory.modifyFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
		}
		
	}
}