/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.filter
{
	import com.flashiteasy.api.parameters.FilterParameterSet;
	import com.flashiteasy.api.utils.StringUtils;

	import flash.utils.getDefinitionByName;

	/**
	 * Utility class for filters generation
	 */
	public class FilterUtils
	{

		/**
		 * Removes a filter from the filters array at a given index
		 * @param param the FilterParameterSet corresponding to the filter applied
		 * @param index the index of the filter in the filters array applied to the control
		 */
		public static function removeFilterAtIndex(param:FilterParameterSet, index:int):void
		{
			var filters:String=param.filterString;
			var types:String=param.types;
			filters=StringUtils.removeBrackets(filters);
			types=StringUtils.removeBrackets(types);
			var filterList:Array=StringUtils.StringToArray(filters, "||");
			var typeList:Array=StringUtils.StringToArray(types, ",");
			filterList.splice(index, 1);
			typeList.splice(index, 1);
			param.filterString=filterList.join("||");
			param.types=typeList.join(",");
		}

		/**
		 * Moves a filter from the filters array at a given index
		 * @param param the FilterParameterSet corresponding to the filter applied
		 * @param index the new index in the filter Array
		 * @param oldIndex the old index in the flter Array
		 */
		public static function moveFilterAtIndex(param:FilterParameterSet, index:int, oldIndex:int):void
		{
			var filters:String=param.filterString;
			var types:String=param.types;
			filters=StringUtils.removeBrackets(filters);
			types=StringUtils.removeBrackets(types);
			var filterList:Array=StringUtils.StringToArray(filters, "||");
			var typeList:Array=StringUtils.StringToArray(types, ",");
			var removedFilter:Array=filterList.splice(oldIndex, 1);
			var removedType:Array=typeList.splice(oldIndex, 1);
			filterList.splice(index, 0, removedFilter);
			typeList.splice(index, 0, removedType);
			param.filterString=filterList.join("||");
			param.types=typeList.join(",");
		}

		// get a string of filters separated by comas , and transform it into an array 
		// [a,b,c,d] or a,b,c,d

		/**
		 * Gets a string of filters separated by comas, and transform it into an array 
		 * @param types the string of filter types
		 * @param s
		 * @return 
		 */
		public static function StringToFilters(types:String, s:String):Array
		{
			if (types == null || s == null)
			{
				return [];
			}
			if (removeBrackets(types).length == 0)
			{
				return [];
			}

			var filterTypes:Array=removeBrackets(types).split(",");
			var filterStrings:Array=removeBrackets(s).split("||");

			// String of one filter
			var filterString:String;
			// Array that will contains filters
			var filters:Array=[];
			var filterClass:Class;

			var arrayValues:Array;

			// Create a filter for each string

			for each (filterString in filterStrings)
			{
				// if the string contains values that are arrays ( [a,[a,b],b] ) 
				// extract them from the string

				arrayValues=[];

				while (filterString.indexOf("[") != -1)
				{
					var stringOfArray:String=removeBrackets(filterString);
					var index:int=filterString.indexOf("[");
					var endIndex:int=filterString.indexOf("]");
					if (index != -1)
					{
						stringOfArray=stringOfArray.slice(index + 1, endIndex);
					}

					// convert string to Array
					var array:Array=stringOfArray.split(",")
					// store the array and remove it from the string 
					arrayValues.push(array);
					filterString=filterString.replace("[" + stringOfArray + "]", "");
				}

				// convert string to arguments
				var arguments:Array=filterString.split(",");

				// since some arguments are array that have been removed from the string 
				// replace arrays at their proper position 
				var filterArguments:Array=[];
				var i:int;
				var argument:String;

				for (i=0; i < arguments.length; i++)
				{
					argument=StringUtils.removeWhiteSpace(arguments[i]);
					// empty string means an array was here
					if (argument == "")
					{
						filterArguments[i]=arrayValues.shift();
					}
					else
					{
						filterArguments[i]=arguments[i];
					}
				}

				// finally create the filter
				// class of the filter
				filterClass=getDefinitionByName("flash.filters." + filterTypes.shift()) as Class;
				filters.push(FilterFactory.createFilter(filterClass, filterArguments));

			}

			return filters;

		}

		private static function removeBrackets(s:String):String
		{
			if (s.indexOf("[", 0) == 0)
			{
				s=s.slice(1);
				s=s.slice(0, s.lastIndexOf("]"));
			}
			return s;
		}
	}
}