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

	import flash.utils.Dictionary;

	/**
	 * The <code><strong>DictionaryUtils</strong></code> class is
	 * an utility class dealing with Dictionaries
	 */
	public class DictionaryUtils
	{

		/**
		*	Returns an Array of all keys within the dictionary argument.	
		* 
		* 	@param d The Dictionary whose keys will be returned.
		* 	@return Array of keys contained within the Dictionary
		*
		*/					
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();

			for (var key:Object in d)
			{
				a.push(key);
			}

			return a;
		}

		/**
		*	Returns an Array of all values within the dictionary argument.		
		* 
		* 	@param d The Dictionary instance whose values will be returned.
		* 	@return Array of values contained within the Dictionary
		*
		*/					
		public static function getValues(d:Dictionary):Array
		{
			var a:Array = new Array();

			for each (var key:Object in d)
			{
				a.push(d[key]);
			}

			return a;
		}
		
		/**
		*	Returns an int for the number of keys within the dictionary 		
		* 
		* 	@param d The Dictionary instance whose length will be returned.
		* 	@return the number of keys
		*
		*/					
		public static function getLength(d:Dictionary):uint
		{
			var n:uint = 0;

			for each (var value:Object in d)
			{
				n++;
			}

			return n;
		}
		
		/**
		*	Returns the key for a given value within the dictionary passed as argument		
		* 
		* 	@param d The Dictionary instance whose length will be returned.
		* 	@param dictValue The dictionary value whose corresponding key we have to get.
 * 		* 	@return the key searched if found, null otherwise
		*
		*/					
		public static function getKey( d : Dictionary, dictValue : *) : *
		{
			var found:Boolean = false;
			var item:*;
			var key : *;
			var values : Array = DictionaryUtils.getValues(d);
			var keys : Array = DictionaryUtils.getKeys(d);
			var i:int = -1;
			while (++i < DictionaryUtils.getLength(d))
			{
				if (values[i] == dictValue)
				{
					found = true;
					item = keys[i];
					break;
				}
			}
			return found ? item : null;
		}
	}
}