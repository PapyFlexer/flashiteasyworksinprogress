/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	/**
	 * The <code><strong>NumberUtils</strong></code> class is
	 * an utility class dealing with numbers
	 */
	public class NumberUtils
	{
		
		/**
			Creates a random integer within the defined range.
			@param min: The minimum value the random integer can be.
			@param min: The maximum value the random integer can be.
			@return Returns a random integer within the range.
		*/
		public static function randomIntegerWithinRange(min:int, max:int):int 
		{
			return Math.round(NumberUtils.randomWithinRange(min, max));
		}
		
		public static function numberToHexadecimalString( n : Number ) : String
		{
			var hexa : String = n.toString(16);
			if( hexa.length <6 ) 
			{
				var missingNumbers : int = 6-hexa.length;
				for(var i : int= 0 ; i < missingNumbers ; i++ )
				{
					hexa = "0" + hexa;
				}
			}
			return hexa;
		}
		
		
		public static function hexadecimalToRgbString( n : Number ) : String
		{
			var hexa : Number = Number(numberToHexadecimalString(n));
			var r : Number = n >> 16 & 0xFF;
      		var g : Number  = n >> 8 & 0xFF;
      		var b : Number  = n & 0xFF;
			return r+","+g+","+b;
		}
			
		/**
			Creates a random number within the defined range.
			
			@param min: The minimum value the random number can be.
			@param min: The maximum value the random number can be.
			@return Returns a random number within the range.
		*/
		public static function randomWithinRange(min:Number, max:Number):Number 
		{
			return min + (Math.random() * (max - min));
		}

		/**
			Determines if the number is even.
			
			@param value: A number , the function checks if it is divisible by <code>2</code>.
			@return Returns <code>true</code> if the number is even, <code>false</code> otherwise.
		*/

		public static function isEven(value:Number):Boolean {
			return (value & 1) == 0;
		}
		
		/**
			Determines if the number is odd.
			
			@param value: A number , the function checks if it is not divisible by <code>2</code>.
			@return Returns <code>true</code> if the number is odd, <code>false</code> otherwise.
		*/
		public static function isOdd(value:Number):Boolean {
			return !NumberUtils.isEven(value);
		}
		
		/**
			Determines if the number is prime.
			
			@param value: A number, the function checks if it is only divisible by 1 and itself.
			@return Returns <code>true</code> if the number is prime, <code>false</code> otherwise.
		*/
		public static function isPrime(value:Number):Boolean {
			if (value == 1 || value == 2)
				return true;
			
			if (NumberUtils.isEven(value))
				return false;
			
			var s:Number = Math.sqrt(value);
			for (var i:Number = 3; i <= s; i++)
				if (value % i == 0)
					return false;
			
			return true;
		}
		
		/**
			Rounds a number's decimal value to a decimal with n significative numbers.
			
			@param value: The number to round.
			@param place: The decimal place to round.
			@return Returns the value rounded to the defined place. 
		*/
		public static function roundDecimalToPlace(value:Number, place:uint):Number {
			var p:Number = Math.pow(10, place);
			
			return Math.round(value * p) / p;
		}
		
		/**
			Rounds a number's decimal value to a decimal with n significative numbers.
			
			@param value: The number to round.
			@param place: The decimal place to round.
			@return Returns the value rounded to the defined place. 
		*/
		public static function radians(n:Number):Number
		{
			return(Math.PI/180*n);
		}

	}
}