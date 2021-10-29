package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.BlurFactory;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.events.FlexEvent;
	
	public class BlurPanel extends Canvas implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:BlurFactory;
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		public var blurXValue:NumericStepper;
		public var blurYValue:NumericStepper;
		public var qualityValue:ComboBox;
		
		private var panel:_BlurPanel;
		
		// ------- Constructor -------
		public function BlurPanel()
		{
			
			panel = new _BlurPanel;
			// create the filter factory
			_filterFactory = new BlurFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE , setupChildren);
			
			blurXValue = panel.blurXValue;
			blurYValue = panel.blurYValue
			qualityValue = panel.qualityValue;
			
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
			qualityValue.selectedIndex = 0;
			
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
			qualityValue.addEventListener(Event.CHANGE, changeFilterValue);
			initFilter();
		}
		
		
		
		private function changeFilterValue(event:Event):void
		{
			// update the filter
			updateFilter();
		}
		
		private var blurFilter :BlurFilter ;
		
		public function setValues( filter : * ):void
		{
			if(filter is BlurFilter)
			{
				blurFilter= BlurFilter( filter );
			}
		}
		
		private function initFilter():void
		{
			if(blurFilter != null )
			{
				panel.blurXValue.value=blurFilter.blurX;
				panel.blurYValue.value=blurFilter.blurY;
				panel.qualityValue.selectedIndex=blurFilter.quality-1;
				updateFilter();
			}
		}
		
		// ------- Private methods -------
		private function updateFilter():void
		{
			var blurX:Number = blurXValue.value;
			var blurY:Number = blurYValue.value;
			var quality:int = qualityValue.selectedItem.data;
			
			_filterFactory.modifyFilter(blurX, blurY, quality);
		}
		
	}
}