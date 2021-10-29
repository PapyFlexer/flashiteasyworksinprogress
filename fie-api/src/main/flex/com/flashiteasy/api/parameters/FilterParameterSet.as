/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IFilterElementDescriptor;
	import com.flashiteasy.api.filter.FilterUtils;

	import flash.filters.*;

	[ParameterSet(description="null",type="Reflection",groupname="Effects")]
	/**
	 * @private
  	 * 
	 */
	public class FilterParameterSet extends AbstractParameterSet
	{

		/**
		 * 
		 * @default 
		 */
		public var filters:Array=[];

		override public function apply(target:IDescriptor):void
		{
			super.apply(target);
			if (target is IFilterElementDescriptor && changed)
			{
				changed=false;
				filters=FilterUtils.StringToFilters(_types, _filters);
				IFilterElementDescriptor(target).setFilters(filters);
			}
		}

		/**
		 * 
		 * @param index
		 */
		public function removeFilter(index:int):void
		{
			changed=true;
			FilterUtils.removeFilterAtIndex(this, index);
		}


		/**
		 * 
		 * @param index
		 * @param oldIndex
		 */
		public function moveFilter(index:int, oldIndex:int):void
		{
			changed=true;
			FilterUtils.moveFilterAtIndex(this, index, oldIndex);
		}

		/**
		 * 
		 * @param filter
		 * @return 
		 */
		public function getFilterIndex(filter:*):int
		{
			var i:int;
			for (i=0; i < filters.length; i++)
			{
				if (filters[i] == filter)
					return i;
			}
			return -1;
		}

		private var _types:String = "";

		[Parameter(type="Filter",defaultValue="",row="0",sequence="0",label="Filter")]
		/**
		 * 
		 * @return 
		 */
		public function get types():String
		{
			return _types;
		}

		/**
		 * 
		 * @param value
		 */
		public function set types(value:String):void
		{
			_types=value;
		}

		private var _filters:String = "";
		private var changed:Boolean=false;

		/**
		 * 
		 * @return 
		 */
		public function get filterString():String
		{
			return _filters;
		}

		/**
		 * 
		 * @param value
		 */
		public function set filterString(value:String):void
		{
			if (value != _filters)
			{
				changed=true;
				_filters=value;
			}
		}

	}
}