package com.flashiteasy.admin.edition
{
	import com.flashiteasy.api.core.IParameterSet;
	

	public class ParameterSetEditionDescriptor
	{
		public var _parameters : Array = [];
		private var _isReflection : Boolean = true; // Default
		private var _description : String;
		private var _groupName : String;
		private var _customComponentClass : Class;
		private var _parameterSet : IParameterSet;

		public function ParameterSetEditionDescriptor( parameterSet : IParameterSet )
		{
			 _parameterSet = parameterSet;
		}
		
		public function getParameterSet() : IParameterSet
		{
			return _parameterSet;
		}

		public function getCustomComponentClass() : Class
		{
			 return _customComponentClass;
		}
		
		public function setCustomComponentClass( value : Class ) : void
		{
			_customComponentClass = value;
		}

		public function getGroupName() : String
		{
			 return _groupName;
		}
		
		public function setGroupName( value : String ) : void
		{
			_groupName = value;
		}

		public function getDescription() : String
		{
			 return _description;
		}
		
		public function setDescription( value : String ) : void
		{
			_description = value;
		}
		
		public function getParameters() : Array
		{
			 return _parameters;
		}
		
		public function setParameters( value : Array ) : void
		{
			_parameters = value;
		}
		
		public function isCustom() : Boolean
		{
			 return !_isReflection;
		}
		
		public function setCustom( value : Boolean ) : void
		{
			_isReflection = !value;
		}
		
		public function isReflection() : Boolean
		{
			 return _isReflection;
		}

		public function isEditable() : Boolean
		{
			return isReflection() && getParameters().length > 0 ||
				isCustom() && getCustomComponentClass() != null; 
			//return true;
		}
	}
}