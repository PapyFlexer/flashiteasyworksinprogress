package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.FieColorPicker;
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.BevelFactory;
	import com.flashiteasy.admin.conf.Conf;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.events.ColorPickerEvent;
	import mx.events.FlexEvent;
	
	public class BevelPanel extends Canvas implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:BevelFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:NumericStepper;
		public var blurYValue:NumericStepper;
		public var strengthValue:NumericStepper;
		public var qualityValue:ComboBox;
		public var shadowColorValue:FieColorPicker;
		public var shadowAlphaValue:advancedSlider;
		public var highlightColorValue:FieColorPicker;
		public var highlightAlphaValue:advancedSlider;
		public var angleValue:advancedSlider;
		public var distanceValue:NumericStepper;
		public var knockoutValue:CheckBox;
		public var typeValue:ComboBox;
		
		private var panel : _BevelPanel ;
		
		// ------- Constructor -------
		public function BevelPanel()
		{
			panel = new _BevelPanel();
			// create the filter factory
			_filterFactory = new BevelFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE , setupChildren);
			blurXValue=panel.blurXValue;
			blurYValue=panel.blurYValue;
			strengthValue=panel.strengthValue;
			qualityValue=panel.qualityValue;
			shadowColorValue=panel.shadowColorValue;
			shadowAlphaValue= panel.shadowAlphaValue;
			highlightColorValue=panel.highlightColorValue;
			highlightAlphaValue=panel.highlightAlphaValue;
			angleValue=panel.angleValue;
			distanceValue=panel.distanceValue;
			knockoutValue=panel.knockoutValue;
			typeValue=panel.typeValue;
			
		}
		
		// ------- Public Properties -------
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}
		
		private var bevelFilter :BevelFilter ;
		
		public function setValues( filter : * ):void
		{
			if(filter is BevelFilter)
			{
				bevelFilter= BevelFilter( filter );
			}
		}
		
		// ------- Public methods -------
		public function resetForm():void
		{
			blurXValue.value = 4;
			blurYValue.value = 4;
			strengthValue.value = 1;
			qualityValue.selectedIndex = 0;
			shadowColorValue.selectedColor = 0x000000;
			shadowAlphaValue.value = 1;
			highlightColorValue.selectedColor = 0xFFFFFF;
			highlightAlphaValue.value = 1;
			angleValue.value = 45;
			distanceValue.value = 4;
			knockoutValue.selected = false;
			typeValue.selectedIndex = 0;
			
			if (_filterFactory != null)
			{
				_filterFactory.modifyFilter();
			}
		}
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			trace("setup panel");
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
			shadowColorValue.addEventListener(ColorPickerEvent.CHANGE, changeFilterValue);
			shadowAlphaValue.addEventListener(Event.CHANGE, changeFilterValue);
			highlightColorValue.addEventListener(ColorPickerEvent.CHANGE, changeFilterValue);
			highlightAlphaValue.addEventListener(Event.CHANGE, changeFilterValue);
			angleValue.addEventListener(Event.CHANGE, changeFilterValue);
			distanceValue.addEventListener(Event.CHANGE, changeFilterValue);
			knockoutValue.addEventListener(MouseEvent.CLICK, changeFilterValue);
			typeValue.addEventListener(Event.CHANGE, changeFilterValue);
			initFilter();
		}
		
		private function initFilter():void
		{
			if(bevelFilter != null )
			{
				panel.blurXValue.value=bevelFilter.blurX;
				panel.blurYValue.value=bevelFilter.blurY;
				panel.strengthValue.value=bevelFilter.strength;
				panel.qualityValue.selectedIndex=bevelFilter.quality-1;
				panel.shadowColorValue.selectedColor=bevelFilter.shadowColor;
				panel.shadowAlphaValue.value=bevelFilter.shadowAlpha;
				panel.highlightColorValue.selectedColor=bevelFilter.highlightColor;
				panel.highlightAlphaValue.value=bevelFilter.highlightAlpha;
				panel.angleValue.value=bevelFilter.angle;
				panel.distanceValue.value=bevelFilter.distance;
				panel.knockoutValue.selected=bevelFilter.knockout;
				switch(bevelFilter.type)
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
		
		private function changeFilterValue(event:Event):void
		{
			// verify that the values are valid
			if (isNaN(distanceValue.value)) { return; }
			
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
			var shadowColor:uint = shadowColorValue.selectedColor;
			var shadowAlpha:Number = shadowAlphaValue.value;
			var highlightColor:uint = highlightColorValue.selectedColor;
			var highlightAlpha:Number = highlightAlphaValue.value;
			var angle:Number = angleValue.value;
			var distance:Number = distanceValue.value;
			var knockout:Boolean = knockoutValue.selected;
			var type:String = typeValue.selectedItem.data;
			
			_filterFactory.modifyFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
		
	}
}