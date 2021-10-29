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
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code><strong>CloneUtils</strong></code> class is
	 * an utility class dealing with Clones,
	 * mostly used by copy/paste actions in admin mode.
	 */
	public class CloneUtils
	{
		public static function cloneArray(ar:Array):Array
		{
			var clonedArray:Array = new Array;
			for(var i:uint =0; i<ar.length; i++)
			{
				if(ar[i] is Array)
				{
					clonedArray.push(cloneArray(ar[i]));
				}
				else
				{
					clonedArray.push(clone(ar[i]));
				}
			}
			return clonedArray
		}
		/**
		 * Clones anything...
		 * @param ob
		 * @return 
		 */
		public static function clone(ob:*):*
		{
		
			if(ob!=null)
			{
			var qualifiedClassName : String = getQualifiedClassName( ob ).replace( "::", "." );
			var bytes : ByteArray = new ByteArray();
			registerClassAlias( qualifiedClassName, getDefinitionByName( qualifiedClassName ) as Class );
			bytes.writeObject( ob );
			bytes.position = 0;
			trace ("cloning... " + qualifiedClassName );
			return bytes.readObject() as (getDefinitionByName( qualifiedClassName ) as Class) ;
			}
			return null ;

		}
		
		/**
		* Clone an Object from a source object.
		*/
		public static function deepClone(source:*):* {
			
			var qualifiedClassName : String = getQualifiedClassName( source ).replace( "::", "." );
			registerClassAlias( qualifiedClassName, getDefinitionByName( qualifiedClassName ) as Class );
			var clone:Object;
			if (source) {
				clone = newSibling(source);
				if (clone) {
					copyData(source, clone);
				}
			}
			return clone as (getDefinitionByName( qualifiedClassName ) as Class) ;
		}
 
		/**
		 * Return an instance of the same class as the source object.
		 *
		 * @param source		Source Object
		 * @param destination	Destination Object
		 */
		public static function newSibling(source:Object):* {
			if (source) {
				var objSibling:*;
				try {
					var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(source)) as Class;
					objSibling = new classOfSourceObj;
				} catch (e:Object) { }
				return objSibling;
			}
			return null;
		}
		 
		/**
		 * Copy all datas from a source object to a detination object.
		 *
		 * @param source		Source Object
		 * @param destination	Destination Object
		 */
		public static function copyData(source:Object, destination:Object):void {
			if (source && destination) {
				try {
					var sourceInfo:XML = describeType(source);
					//trace(sourceInfo);
					for each (var prop:XML in sourceInfo.variable) {
						if (destination.hasOwnProperty(prop.@name)) {
							destination[prop.@name] = source[prop.@name];
							//trace(prop.@name);
						}
					}
					for each (prop in sourceInfo.accessor) {
						if (prop.@access == "readwrite") {
							if (destination.hasOwnProperty(prop.@name)) {
								destination[prop.@name] = source[prop.@name];
							}
						}
					}
				} catch (err:Object) { }
			}
		}

	}
}