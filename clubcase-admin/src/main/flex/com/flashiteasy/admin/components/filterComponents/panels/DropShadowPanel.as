package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.FieColorPicker;
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.DropShadowFactory;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.events.ColorPickerEvent;
	import mx.events.FlexEvent;
	
	public class DropShadowPanel extends Canvas implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:DropShadowFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:NumericStepper;
		public var blurYValue:NumericStepper;
		public var strengthValue:NumericStepper;
		public var qualityValue:ComboBox;
		public var colorValue:FieColorPicker;
		public var alphaValue:advancedSlider;
		public var angleValue:advancedSlider;
		public var distanceValue:NumericStepper;
		public var knockoutValue:CheckBox;
		public var innerValue:CheckBox;
		public var hideObjectValue:CheckBox
		
		private var panel : _DropShadowPanel= new _DropShadowPanel;
		
		// ------- Constructor -------
		public function DropShadowPanel()
		{
			// create the filter factory
			_filterFactory = new DropShadowFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE , setupChildren);
			blurXValue=panel.blurXValue;
			blurYValue=panel.blurYValue;
			strengthValue=panel.strengthValue;
			qualityValue=panel.qualityValue;
			colorValue=panel.colorValue;
			alphaValue=panel.alphaValue;
			angleValue=panel.angleValue;
			distanceValue=panel.distanceValue;
			knockoutValue=panel.knockoutValue;
			innerValue=panel.innerValue;
			hideObjectValue=panel.hideObjectValue;
		}
		
		
		// ------- Public Properties -------
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}
		
		
		// ------- Public methods -------
		public function resetForm():void
		{
			blurXValue.value = 4;
			blurYValue.value = 4;
			strengthValue.value = 1;
			qualityValue.selectedIndex = 0;
			colorValue.selectedColor = 0x000000;
			alphaValue.value = 1;
			angleValue.value = 45;
			distanceValue.value = 4;
			knockoutValue.selected = false;
			innerValue.selected = false;
			hideObjectValue.selected = false;
			
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilter();
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
			angleValue.addEventListener(Event.CHANGE, changeFilterValue);
			distanceValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			innerValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			hideObjectValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			initFilter();
		}
		
		
		private function changeFilterValue(event:Event):void
		{
			// verify that the values are valid
			if (isNaN(distanceValue.value)) { return; }
			
			// update the filter
			updateFilter();
		}
		
		private var dropShadowFilter:DropShadowFilter;
		public function setValues( filter : * ):void
		{
			if(filter is DropShadowFilter)
			{
				dropShadowFilter = DropShadowFilter(filter);
			}
		}
		
		private function initFilter():void
		{
			if(dropShadowFilter != null )
			{
				panel.blurXValue.value = dropShadowFilter.blurX;
				panel.blurYValue.value = dropShadowFilter.blurY;
				panel.strengthValue.value = dropShadowFilter.strength;
				panel.qualityValue.selectedIndex = dropShadowFilter.quality-1;
				panel.colorValue.selectedColor = dropShadowFilter.color;
				panel.alphaValue.value = dropShadowFilter.alpha;
				panel.angleValue.value = dropShadowFilter.angle;
				panel.distanceValue.value = dropShadowFilter.distance;
				panel.knockoutValue.selected = dropShadowFilter.knockout;
				panel.innerValue.selected = dropShadowFilter.inner;
				panel.hideObjectValue.selected = dropShadowFilter.hideObject;
				updateFilter();
			}
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
			var angle:Number = angleValue.value;
			var distance:Number = distanceValue.value;
			var knockout:Boolean = knockoutValue.selected;
			var inner:Boolean = innerValue.selected;
			var hideObject:Boolean = hideObjectValue.selected;
			
			_filterFactory.modifyFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		}
	}
}