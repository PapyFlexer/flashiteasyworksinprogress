package com.flashiteasy.admin.utils
{
	public class MetadataArgument
	{
		private var _key : String;
		private var _value : *;

		public function MetadataArgument( key : String, value : String ) : void
		{
			setKey( key );
			setValue( value );
		}

		public function getKey() : String
		{
			 return _key;
		}
		public function setKey( value : String ) : void
		{
			_key = value;
		}
		
		public function getValue() : *
		{
			 return _value;
		}
		
		public function setValue( value : * ) : void
		{
			_value = value;
		}
		
	}
}