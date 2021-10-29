package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.FieColorPicker;
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.GlowFactory;
	import com.flashiteasy.admin.conf.Conf;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.events.ColorPickerEvent;
	import mx.events.FlexEvent;
	
	public class GlowPanel extends Canvas implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:GlowFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:NumericStepper;
		public var blurYValue:NumericStepper;
		public var strengthValue:NumericStepper;
		public var qualityValue:ComboBox;
		public var colorValue:FieColorPicker;
		public var alphaValue:advancedSlider;
		public var knockoutValue:CheckBox;
		public var innerValue:CheckBox;
		
		private var panel : _GlowPanel = new _GlowPanel;
		
		
		// ------- Constructor -------
		public function GlowPanel()
		{
			// create the filter factory
			_filterFactory = new GlowFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE , setupChildren);
			blurXValue=panel.blurXValue;
			blurYValue=panel.blurYValue;
			strengthValue=panel.strengthValue;
			qualityValue=panel.qualityValue;
			colorValue=panel.colorValue;
			alphaValue=panel.alphaValue;
			knockoutValue=panel.knockoutValue;
			innerValue=panel.innerValue;
		}
		
		
		// ------- Public Properties -------
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}
		
		
		// ------- Public methods -------
		public function resetForm():void
		{
			blurXValue.value = 6;
			blurYValue.value = 6;
			strengthValue.value = 2;
			qualityValue.selectedIndex = 0;
			colorValue.selectedColor = 0xFF0000;
			alphaValue.value = 1;
			knockoutValue.selected = false;
			innerValue.selected = false;
			
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilter();
			}
		}
		
		private var glowFilter :GlowFilter ;
		
		public function setValues( filter : * ):void
		{
			if(filter is GlowFilter)
			{
				glowFilter= GlowFilter( filter );
			}
		}
		
		private function initFilter():void
		{
			if(glowFilter != null )
			{
					
				panel.blurXValue.value = glowFilter.blurX;
				panel.blurYValue.value = glowFilter.blurY;
				panel.strengthValue.value = glowFilter.strength;
				panel.qualityValue.selectedIndex = glowFilter.quality-1;
				panel.colorValue.selectedColor = glowFilter.color;
				panel.alphaValue.value = glowFilter.alpha;
				panel.knockoutValue.selected = false;
				panel.innerValue.selected = false;
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
			
			// add event listeners for child controls
			blurXValue.addEventListener(Event.CHANGE, changeFilterValue);
			blurYValue.addEventListener(Event.CHANGE, changeFilterValue);
			strengthValue.addEventListener(Event.CHANGE, changeFilterValue);
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
			colorValue.addEventListener(ColorPickerEvent.CHANGE, changeFilterValue);
			alphaValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			innerValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			initFilter();

		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// update the filter
			updateFilter();
		}
		
		
		// ------- Private methods -------
		private function updateFilter():void
		{
			var blurX:Number = blurXValue.value;
			var blurY:Number = blurYValue.value;
			var strength:Number = strengthValue.value;
			var quality:int = qualityValue.selectedItem.data;
			var color:uint = colorValue.selectedColor;
			var alpha:Number = alphaValue.value;
			var knockout:Boolean = knockoutValue.selected;
			var inner:Boolean = innerValue.selected;
			
			_filterFactory.modifyFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
	}
}