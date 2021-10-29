package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.controls.Validator.*;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IFormElementDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;

	[ParameterSet(description="null",type="Reflection", groupname="Form_Item")]
	/**
	 * The <code><strong>FormItemParameterSet</strong></code> is a pseudo-abstract
	 * ParameterSet that handle the properties shared by all Form Items.
  	 * 
	 */
	public class FormItemParameterSet extends AbstractParameterSet //implements IParameterSetStaticValues
	{
		
		private var _required : Boolean;
				
		private var _name : String;
				
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target : IDescriptor ) : void
		{
			if (target is IFormElementDescriptor)
			{
				IFormElementDescriptor(target).required = _required;
				IFormElementDescriptor(target).name = _name;
			}
		}
		
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="0" , label="Required")]
		/**
		 * The <strong>required</strong> property takes a boolean value (checkBox in admin mode)
		 * ans is symbolized by a red asterisk besides the form item.
		 */
		public function get required() : Boolean
		{
			return _required;
		}
		
		/**
		 * Private
		 */
		public function set required( value : Boolean) : void
		{
			_required = value;
		}
		
 		[Parameter(type="String",defaultValue="Component",row="1", sequence="1" , label="Name")]
		/**
		 * The name of the form item. Sent as the key property of the form item when submitted.
		 */
		public function get name() : String
		{
			return _name;
		}
		
		/**
		 * 
		 * @private 
		 */
		public function set name( value : String) : void
		{
			_name = value;
		}
		
		
	}
}