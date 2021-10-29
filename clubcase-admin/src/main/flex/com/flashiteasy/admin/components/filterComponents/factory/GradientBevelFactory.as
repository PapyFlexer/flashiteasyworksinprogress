package com.flashiteasy.admin.components.filterComponents.factory
{
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.GradientBevelFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class GradientBevelFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:GradientBevelFilter;
		private var _paramString:String;
		private var _colorsString:String;
		private var _alphasString:String;
		private var _ratiosString:String;
		
		private var defaultColors:Array = [0xFFFFFF,0xFF0000,0x000000];
		private var defaultAlphas:Array=[1,.25,1];
		private var defaultRatios:Array=[0,128,255];
		
		
		// ------- Constructor -------
		public function GradientBevelFactory(distance:Number = 4,
											   angle:Number = 45,
											   //combinedColors:Array = null,
											   colors:Array = null,
											   alphas:Array = null,
											   ratios:Array = null,
											   blurX:Number = 4,
											   blurY:Number = 4,
											   strength:Number = 1,
											   quality:int = 1,
											   type:String = "inner",
											   knockout:Boolean = false)
		{
			if (colors == null)
			{
				colors=defaultColors;
			}
			if (alphas == null)
			{
				alphas=defaultAlphas;
			}
			if (ratios == null)
			{
				ratios=defaultRatios;
			}
			/*if (combinedColors == null)
			{
				combinedColors = getDefaultColors();
			}
			var colors:Array = new Array(combinedColors.length);
			var alphas:Array = new Array(combinedColors.length);
			var ratios:Array = new Array(combinedColors.length);
			
			separateColorParts(combinedColors, colors, alphas, ratios);
			*/
			_filter = new GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
			_paramString = buildParamString(distance, angle, blurX, blurY, strength, quality, type, knockout);
			_colorsString = buildArrayString(colors, true);
			_alphasString = buildArrayString(alphas);
			_ratiosString = buildArrayString(ratios);
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
		public function modifyFilter(distance:Number = 4,
									   angle:Number = 45,
									   //combinedColors:Array = null,
									   colors:Array = null,
									   alphas:Array = null,
									   ratios:Array = null,
									   blurX:Number = 4,
									   blurY:Number = 4,
									   strength:Number = 1,
									   quality:int = 1,
									   type:String = "inner",
									   knockout:Boolean = false):void
		{
			if (colors == null)
			{
				colors=defaultColors;
			}
			if (alphas == null)
			{
				alphas=defaultAlphas;
			}
			if (ratios == null)
			{
				ratios=defaultRatios;
			}
			/*if (combinedColors == null)
			{
				combinedColors = getDefaultColors();
			}
			var colors:Array = new Array(combinedColors.length);
			var alphas:Array = new Array(combinedColors.length);
			var ratios:Array = new Array(combinedColors.length);
			
			separateColorParts(combinedColors, colors, alphas, ratios);
			*/
			_filter = new GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
			_paramString = buildParamString(distance, angle, blurX, blurY, strength, quality, type, knockout);
			_colorsString = buildArrayString(colors, true);
			_alphasString = buildArrayString(alphas);
			_ratiosString = buildArrayString(ratios);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		// ------- Private methods -------
		private function getDefaultColors():Array
		{
			return [new GradientColor(0xFFFFFF, 1, 0),
					 new GradientColor(0xFF0000, .25, 128),
					 new GradientColor(0x000000, 1, 255)];
		}
		
		
		// takeas an array of GradientColor objects and splits it into three arrays of colors, alphas, and ratios
		// the destination arrays must be instantiated and sized before calling this method.
		private function separateColorParts(source:Array, colorsDest:Array, alphasDest:Array, ratiosDest:Array):void
		{
			var numColors:int = source.length;
			
			for (var i:int = 0; i < numColors; i++)
			{
				var gradientColor:GradientColor = source[i];
				
				colorsDest[i] = gradientColor.color;
				alphasDest[i] = gradientColor.alpha;
				ratiosDest[i] = gradientColor.ratio;
			}
		}
		
		
		private function buildParamString(distance:Number,
											angle:Number,
											blurX:Number,
											blurY:Number,
											strength:Number,
											quality:int,
											type:String,
											knockout:Boolean):String
		{
			var result:String = distance.toString() + "," + angle.toString() + ",";
			result += "["+ _colorsString+"],";
			result += "["+ _alphasString+"],";
			result += "["+ _ratiosString+"],";
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
			result += quality.toString()+ ",";
			/*
			switch (type)
			{
				case "inner":
					result += "BitmapFilterType.INNER";
					break;
				case "outer":
					result += "BitmapFilterType.OUTER";
					break;
				case "full":
					result += "BitmapFilterType.FULL";
					break;
			}
			*/
			result += type.toString()+"," + knockout.toString();
			
			return result;
		}
		
		
		private function buildArrayString(arr:Array, formatColor:Boolean = false):String
		{
			var len:int = arr.length;
			var result:String = "";
			
			for (var i:int = 0; i < len; i++)
			{
				if (i != 0)
				{
					result += ", ";
				}
				if (formatColor)
				{
					result += ColorStringFormatter.formatColorHex24(arr[i]);
				}
				else
				{
					result += arr[i].toString();
				}
			}
			
			return result;
		}
		
		public function getType():String
		{
			return "GradientBevelFilter";
		}
	}
}