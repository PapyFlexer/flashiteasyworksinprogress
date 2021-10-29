package com.flashiteasy.admin.utils
{
	public class Metadata
	{
		private var _name : String;
		private var _arguments : Array = [];

		public function getName() : String
		{
			 return _name;
		}
		public function setName( value : String		 ) : void
		{
			_name = value;
		}
		
		public function getArguments() : Array
		{
			 return _arguments;
		}
		public function setArguments( value : Array ) : void
		{
			_arguments = value;
		}
		
		public function getArgumentValue( key : String ) : *
		{
			for each( var arg : MetadataArgument in _arguments )
			{
				if( arg.getKey() == key )
				{
					return arg.getValue();
				}
			}
			return null;
		}

	}
}