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
	import com.flashiteasy.api.core.CompositeParameterSet;
	
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code><strong>ArrayUtils</strong></code> class is
	 * an utility class dealing with Arrays
	 */
	public class ArrayUtils
	{

		/**
		 * Makes a clone of the array passed as argument and returns it
		 * @param source the array to be cloned
		 * @return the cloned array instance
		 */
		public static function clone(source:Array) : Array 
		{
			var array : Array = [];
			for each ( var ob:* in source)
			{
				if (ob is CompositeParameterSet)
				{
					var clonedPset:CompositeParameterSet = CloneUtils.clone(ob);
					var params:Array=CompositeParameterSet(ob).getParametersSet();
					var _array : Array = [];
					for each ( var _ob : Object in params)
					{
						_array.push(CloneUtils.clone(_ob));	
					}
					clonedPset.setParameterSet(_array);
					array.push(clonedPset); 
				}
				else 
				{ 
					array.push(CloneUtils.clone(ob));
				}
			}
			return array ;

		}
		
		/**
		 * Compares strictly 2 arrays
		 * @param a first Array
		 * @param b second Array
		 * @return boolean true / false
		 */
		public static function compareArrays( a:Array, b:Array ) : Boolean
		{
			if(a == null || b==null) return false;
			var l:uint = a.length;
			if (b.length != l) return false;
			for (var i:uint = 0; i<l; i++)
			{
				if ( a[i] !== b[i] ) return false;
			}
			return true;
		}
		
		/**
		 * Get the index of a given item in a given array
		 * @param a the array where to search
		 * @param value the object to search for 
		 * @return the index of the found object in the array, or -1 when unfound
		 */
		public static function getIndex( a:Array , value:Object ) : int
		{
			var i:int;
			for(i=0;i<a.length;i++){
				if(a[i] == value )
					return i;
			}
			return -1;
		}
		
		/**
		 * Checks if an item exists in an array 
		 * @param a the array where to search
		 * @param item the element to find
		 * @return a boolean true if found, false otherwise.
		 */
		public static function isItemInArray(a : Array, item : *) : Boolean
		{
			return a.lastIndexOf(item) != -1;
		}
		
		/**
		 * Tests a string existence in an array
		 * @param a the array where to search
		 * @param value the object to search for 
		 * @return 
		 */
		public static function containsString ( value : String , a:Array ) : Boolean
		{
			var test:String ;
			for each( test in a ) 
			{
				if(test == value)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Checks strictly the presence of an object in an array
		 * @param a the array where to search
		 * @param value the object to search for 
		 * @return boolean
		 */
		public static function contains ( a:Array , value:Object):Boolean {
			var o : Object 
			for each (o in a ){
				if( getQualifiedClassName(o) == getQualifiedClassName(value) ){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Checks for an item index in an array
		 * @param a the array where to search
		 * @param value the object to search for 
		 * @return int
		 */
		public static function getItemIndexInArray(a : Array, item : *) : int
		{
			return a.indexOf(item);
		}
		
		/**
		 * Remove an object for an array
		 * @param elements
		 * @param ob
		 */
		public static function removeElement(elements:Array,ob:*):void{
			var i:int;
			var length:int=elements.length;
			for(i=0; i < length ; i++)
			{

				if (elements[i] == ob)
				{
					elements.splice(i, 1);
					return ;
				}
			}
		}
		
		/**
		 * Transfors an array into an array where each item is unique
		 * @param originalArray
		 * @return 
		 */
		public static function removeDuplicate( originalArray : Array ) : Array {
			var lookup : Array = new Array();
			var uniqueArr : Array = new Array();
			var num : int;
			for(var idx:int=0;idx < originalArray.length;idx++)
			{
				num = originalArray[idx];
				if (!lookup[num] )
				{
					var obj:Object=new Object();
					obj.id=num;
			 		obj.count=0;
					uniqueArr.push(num);
					lookup[num]=true;
				}
			}
			return(uniqueArr);
		}
		
		/**
		 * Takes a Class and returns its constants in an Array
		 * @param name
		 * @return 
		 */
		public static function getConstant(name:Class):Array{
			var a:Array= [];
			var typeXML:XML=describeType(name);
			for each (var constant:XML in typeXML.constant)
			{
				a.push(name[constant.@name]);
			}
			return a;//.sort(Array.NUMERIC);
		}

	}
}