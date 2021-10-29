package com.flashiteasy.admin.components.filterComponents.factory
{
	
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.api.utils.NumberUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	// ------- Events -------
	[Event(name="change", type="flash.events.Event")]
	
	
	public class ColorMatrixFactory extends EventDispatcher implements IFilterFactory
	{
		// ------- Private vars -------
		private var _filter:ColorMatrixFilter;
		private var _paramString:String;
		
		private var _matrix:Array;
		
		
		// ------- Constructor -------
		public function ColorMatrixFactory(matrix:Array = null)
		{
			if (matrix == null)
			{
				resetMatrix();
			}
			else
			{
				_matrix = matrix;
			}
			
			_filter = new ColorMatrixFilter(_matrix);
		}
		
		
		// ------- IFilterFactory implementation -------
		public function getFilter():BitmapFilter
		{
			return _filter;
		}
		
		
		public function getCode():String
		{
			var result:String = "";
			for (var i:int = 0; i < 20; i++)
			{
				if (i > 0)
				{
					result += ", ";
				}
				result += _matrix[i].toString();
			}
			return result;
		}
		
		
		// ------- Public properties -------
		public function get matrix():Array
		{
			return _matrix;
		}
		
		
		// ------- Public methods -------
		public function modifyFilterBasic(brightness:Number, contrast:Number, saturation:Number, hue:Number):void
		{
			// calculate the combined matrix using the preset values
			//if(hue == 0 && saturation == 0 && contrast == 0 && brightness == 0)
			resetMatrix();
			setHue(hue);
			setSaturation(saturation);
			setContrast(contrast);
			setBrightness(brightness);
			
			_filter = new ColorMatrixFilter(_matrix);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function modifyFilterCustom(matrix:Array = null):void
		{
			if (matrix == null)
			{
				resetMatrix();
			}
			else
			{
				_matrix = matrix;
			}
			
			_filter = new ColorMatrixFilter(_matrix);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public var defaultMatrix : Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		
		// ------- Color adjustments -------
		private function resetMatrix():void
		{
			_matrix = defaultMatrix;
		}
		
		
		// Color matrix algorithms derived from:
		// Haeberli, Paul (1993) "Matrix Operations for Image Processing."
		// Graphica Obscura: http://www.graficaobscura.com/matrix/index.html
		
		// takes a brightness value between -100 and 100
		private function setBrightness(value:Number):void
		{
			// convert the value to a percentage of 255
			var brightness:Number = (value / 100) * 255;
			
			var matrix:Array =  [1, 0, 0, 0, brightness,
								  0, 1, 0, 0, brightness,
								  0, 0, 1, 0, brightness,
								  0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		// get a brightness value between -100 and 100
		public function getBrightness():Number
		{
			var isTint:Boolean = false;
			// convert the value to a percentage of 255
			var mc:Number = 1 - ((_matrix[0] + _matrix[6] + _matrix[12]) / 3); // Brightness as determined by the main channels
			var co:Number = (_matrix[4] + _matrix[9] + _matrix[14]) / 3; // Brightness as determined by the offset channels
			if (isTint) {
				// Tint style
				//return (mc+(co/255))/2;
				return co > 0 ? co / 255 : -mc;
			} else {
				// Native, Flash "Adjust Color" and Photoshop style
				return co / 100;
			}
			
		}
		
		// takes a contrast value between -100 and 100
		private function setContrast(value:Number):void
		{
			var base:Number = value / 100;
			var multiplier:Number = 1 + ((value > 0) ? 4 * base : base);
			var offset:Number = (-128 * base) * ((value > 0) ? 5 : 1);
			var matrix:Array = [multiplier, 0, 0, 0, offset,
								 0, multiplier, 0, 0, offset,
								 0, 0, multiplier, 0, offset,
								 0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		// get a contrast value between -100 and 100
		public function getContrast():Number
		{
			// convert the value to a percentage of 255
			var mc:Number = ((_matrix[0] + _matrix[6] + _matrix[12]) / 3) - 1;		// Contrast as determined by the main channels
			var co:Number = (_matrix[4] + _matrix[9] + _matrix[14]) / 3 / -3840; // low : 128;		// Contrast as determined by the offset channel
			
			return (mc+co)/2;
			
		}
		
		
		// takes a saturation value between -100 and 100
		private function setSaturation(value:Number):void
		{
			var saturation:Number = 1 + ((value > 0) ? 3 * (value / 100) : (value / 100));
			
			// RGB to Luminance conversion constants by Charles A. Poynton:
			// http://www.faqs.org/faqs/graphics/colorspace-faq/
			var rWeight:Number = 0.3086;
			var gWeight:Number = 0.694;
			var bWeight:Number = 0.0820;
			var baseSat:Number = 1 - saturation;
			var rSat:Number = (baseSat * rWeight) + saturation;
			var r:Number = (baseSat * rWeight);
			var gSat:Number = (baseSat * gWeight) + saturation;
			var g:Number = (baseSat * gWeight);
			var bSat:Number = (baseSat * bWeight) + saturation;
			var b:Number = (baseSat * bWeight);
			
			var matrix:Array = [rSat, g, b, 0, 0,
								 r, gSat, b, 0, 0,
								 r, g, bSat, 0, 0,
								 0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		
		// get a saturation value between -100 and 100
		public function getSaturation():Number
		{
			var rWeight:Number = 0.3086;
			var gWeight:Number = 0.694;
			var bWeight:Number = 0.0820;
			var mc:Number = ((_matrix[0]-rWeight)/(1-rWeight) + (_matrix[6]-gWeight)/(1-gWeight) + (_matrix[12]-bWeight)/(1-bWeight)) / 3;					// Color saturation as determined by the main channels
			var cc:Number = 1 - ((_matrix[1]/gWeight + _matrix[2]/bWeight + _matrix[5]/rWeight + _matrix[7]/bWeight + _matrix[10]/rWeight + _matrix[11]/gWeight) / 6);	// Color saturation as determined by the other channels
			return (mc + cc) / 2;
			
		}
		
		// takes a hue value (an angle) between -180 and 180 degrees
		private function setHue(value:Number):void
		{
			var angle:Number = value * Math.PI / 180;
			
			var c:Number = Math.cos(angle);
            var s:Number = Math.sin(angle);
			
            var lumR:Number = 0.3086;
            var lumG:Number = 0.694;
            var lumB:Number = 0.0820;
            var r0:Number=lumR + (c * (1 - lumR)) + (s * (-lumR));
            var g0:Number=lumG + (c * (-lumG)) + (s * (-lumG));
            var b0:Number=lumB + (c * (-lumB)) + (s * (1 - lumB));
            var r1:Number=lumR + (c * (-lumR)) + (s * 0.143);
            var g1:Number=lumG + (c * (1 - lumG)) + (s * 0.14);
            var b1:Number=lumB + (c * (-lumB)) + (s * (-0.283));
            var r2:Number=lumR + (c * (-lumR)) + (s * (-(1 - lumR)));
            var g2:Number=lumG + (c * (-lumG)) + (s * lumG);
            var b2:Number=lumB + (c * (1 - lumB)) + (s * lumB);
            
			
            var matrix:Array = [ r0, g0, b0, 0, 0,
								 r1, g1, b1, 0, 0,
								 r2, g2, b2, 0, 0,
								 0, 0, 0, 1, 0];
			
			_matrix = mMultiply(_matrix, matrix);
		}
		/**
		 * _hue
		 * Hue of an object: -180 -> [0] -> 180
		 */
		public function getHue ():Number {

			var mtx:Array = _matrix;

			// Find the current Hue based on a given matrix.
			// This is a kind of a brute force method by sucessive division until a close enough angle is found.
			// Reverse-engineering the hue equation would be is a better choice, but it's hard to find material
			// on the correct calculation employed by Flash.
			// This code has to run only once (before the tween starts), so it's good enough.

			var hues:Array = [];
			var i:Number;

			hues[0] = {angle:-179.9, matrix:getHueMatrix(-179.9)};
			hues[1] = {angle:180, matrix:getHueMatrix(180)};
		
			for (i = 0; i < hues.length; i++) {
				hues[i].distance = getHueDistance(mtx, hues[i].matrix);
			}

			var maxTries:Number = 15;	// Number o maximum divisions until the hue is found
			var angleToSplit:Number;

			for (i = 0; i < maxTries; i++) {
				// Find the nearest angle
				if (hues[0].distance < hues[1].distance) {
					// First is closer
					angleToSplit = 1;
				} else {
					// Second is closer
					angleToSplit = 0;
				}
				hues[angleToSplit].angle = (hues[0].angle + hues[1].angle)/2;
				hues[angleToSplit].matrix = getHueMatrix(hues[angleToSplit].angle)
				hues[angleToSplit].distance = getHueDistance(mtx, hues[angleToSplit].matrix);
			}

			return hues[angleToSplit].angle;
		}
		
		private function getHueDistance (mtx1:Array, mtx2:Array): Number {
			return (Math.abs(mtx1[0] - mtx2[0]) + Math.abs(mtx1[1] - mtx2[1]) + Math.abs(mtx1[2] - mtx2[2]));
		}

		private function getHueMatrix (hue:Number): Array {
			var ha:Number = hue * Math.PI/180;		// Hue angle, to radians



			var rl:Number = 0.3086;
			var gl:Number =0.694;
			var bl:Number = 0.0820;

			var c:Number = Math.cos(ha);
			var s:Number = Math.sin(ha);

			var mtx:Array = [
				(rl + (c * (1 - rl))) + (s * (-rl)),
				(gl + (c * (-gl))) + (s * (-gl)),
				(bl + (c * (-bl))) + (s * (1 - bl)),
				0, 0,

				(rl + (c * (-rl))) + (s * 0.143),
				(gl + (c * (1 - gl))) + (s * 0.14),
				(bl + (c * (-bl))) + (s * -0.283),
				0, 0,

				(rl + (c * (-rl))) + (s * (-(1 - rl))),
				(gl + (c * (-gl))) + (s * gl),
				(bl + (c * (1 - bl))) + (s * bl),
				0, 0,

				0, 0, 0, 1, 0
			];
			
			return mtx;
		}
		
		// Performs matrix multiplication between two 4x5 matrices
		private static function mMultiply(m1:Array, m2:Array):Array
		{
			var result:Array = new Array(20);
			
			for (var row:int = 0; row < 19; row += 5)
			{
				for (var col:int = 0; col < 5; col++)
				{
					var cell:Number = (m1[row] * m2[col]) + (m1[row + 1] * m2[col + 5]) + (m1[row + 2] * m2[col + 10]) + (m1[row + 3] * m2[col + 15]);
					if (col == 4)
					{
						cell += m1[row + 4];
					}
					result[row + col] = NumberUtils.roundDecimalToPlace(cell,2);
				}
			}
			trace("result " + result );
			return result;
		}
		public function getType():String
		{
			return "ColorMatrixFilter";
		}
	}
}