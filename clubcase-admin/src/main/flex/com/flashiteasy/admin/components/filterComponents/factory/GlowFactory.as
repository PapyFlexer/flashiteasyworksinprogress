package com.flashiteasy.admin.components.filterComponents.factory
{
	
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class GlowFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:GlowFilter;
		private var _paramString:String;
		
		
		// ------- Constructor -------
		public function GlowFactory(color:uint = 0xFF0000,
									  alpha:Number = 1,
									  blurX:Number = 6,
									  blurY:Number = 6,
									  strength:Number = 2,
									  quality:int = 1,
									  inner:Boolean = false,
									  knockout:Boolean = false)
		{
			_filter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			_paramString = buildParamString(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			return _paramString ;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(color:uint = 0xFF0000,
									   alpha:Number = 1,
									   blurX:Number = 6,
									   blurY:Number = 6,
									   strength:Number = 2,
									   quality:int = 1,
									   inner:Boolean = false,
									   knockout:Boolean = false):void
		{
			_filter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			_paramString = buildParamString(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function buildParamString(color:uint,
											alpha:Number,
											blurX:Number,
											blurY:Number,
											strength:Number,
											quality:int,
											inner:Boolean,
											knockout:Boolean):String
		{
			var result:String = ColorStringFormatter.formatColorHex24(color) + "," + alpha.toString() + ",";
			result += blurX.toString() + "," + blurY.toString() + "," + strength.toString() + ",";
			/*
			switch (quality)
			{
				case 1:
					result += "BitmapFilterQuality.LOW";
					break;
				case 2:
					result += "BitmapFilterQuality.MEDIUM";
					break;
				case 3:
					result += "BitmapFilterQuality.HIGH";
					break;
			}
			*/
			result +=quality.toString()+ ",";
			
			result += inner.toString() + "," + knockout.toString();
			
			return result;
		}
		public function getType():String
		{
			return "GlowFilter";
		}
	}
}