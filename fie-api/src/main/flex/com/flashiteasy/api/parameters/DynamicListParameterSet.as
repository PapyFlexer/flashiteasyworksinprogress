package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.container.DynamicListElementDescriptor;
	import com.flashiteasy.api.core.IDescriptor;
	
	public class DynamicListParameterSet extends ListTypeParameterSet
	{
		public function DynamicListParameterSet()
		{
			super();
		}

		private var _dataProvider:Object;

		private var _xmlProvider:XMLList;

		private var _request:String; // fie://AMF/TXT/newsService/home/

		public function get xmlProvider():XMLList
		{
			return _xmlProvider;
		}

		public function set xmlProvider(value:XMLList):void
		{
			_xmlProvider=value;
		}

		public function set dataProvider(value:Object):void
		{
			_dataProvider=value;
			xmlProvider = XMLList(value);
		}

		public function get dataProvider():Object
		{
			return _dataProvider;
		}

		/**
		 * The request sent to amfphp
		 */
		public function get request():String
		{
			return _request;
		}

		/**
		 *
		 * @private
		 */
		public function set request(value:String):void
		{
			_request=value;
		}

		override public function apply(target:IDescriptor):void
		{
			if (target is DynamicListElementDescriptor)
			{
				//TODO use an interface
				DynamicListElementDescriptor(target).init(xmlProvider, request);
			}
		}


	}
}