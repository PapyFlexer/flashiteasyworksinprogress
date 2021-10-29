package com.flashiteasy.admin.components.filterComponents.factory
{
	
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class DropShadowFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:DropShadowFilter;
		private var _paramString:String;
		
		
		// ------- Constructor -------
		public function DropShadowFactory(distance:Number = 4,
											angle:Number = 45,
											color:uint = 0x000000,
											alpha:Number = 1,
											blurX:Number = 4,
											blurY:Number = 4,
											strength:Number = 1,
											quality:int = 1,
											inner:Boolean = false,
											knockout:Boolean = false,
											hideObject:Boolean = false)
		{
			_filter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
			_paramString = buildParamString(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			return _paramString;
		}
		
		
		// ------- Public methods -------
		public function modifyFilter(distance:Number = 4,
									   angle:Number = 45,
									   color:uint = 0x000000,
									   alpha:Number = 1,
									   blurX:Number = 4,
									   blurY:Number = 4,
									   strength:Number = 1,
									   quality:int = 1,
									   inner:Boolean = false,
									   knockout:Boolean = false,
									   hideObject:Boolean = false):void
		{
			_filter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
			_paramString = buildParamString(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function buildParamString(distance:Number,
											angle:Number,
											color:uint,
											alpha:Number,
											blurX:Number,
											blurY:Number,
											strength:Number,
											quality:int,
											inner:Boolean,
											knockout:Boolean,
											hideObject:Boolean):String
		{
			var result:String = distance.toString() + "," + angle.toString() + ",";
			result += ColorStringFormatter.formatColorHex24(color) + "," + alpha.toString() + ",";
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
			result += quality.toString()+",";
			
			result += inner.toString() + "," + knockout.toString() + "," + hideObject.toString();
			
			return result;
		}
		public function getType():String
		{
			return "DropShadowFilter";
		}
	}
}