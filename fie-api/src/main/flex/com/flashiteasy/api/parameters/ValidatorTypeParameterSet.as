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
	import com.flashiteasy.api.controls.Validator.IsEqualValidator;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IValidatorElementDescriptor;
	
	[ParameterSet(description="null",type="Reflection",groupname="Block_Content")]
	/**
	 * @private
	 * The <code><strong>ValidatorTypeParameterSet</strong></code> is the parameterSet
	 * that handles the type of validators applied to TextInput form item..
	 */

	public class ValidatorTypeParameterSet extends CompositeParameterSet
	{
		
		private var _enable : Boolean = true;
		//private var _type : String = "IsNone";
		/**
		 * 
		 * @iniheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			if( targ is IValidatorElementDescriptor )
			{
				IValidatorElementDescriptor( targ ).setValidatorEnable( enable );
				IValidatorElementDescriptor( targ ).setValidator(ValidatorParameterSet(this).type);
			} 
			super.apply( targ );
		}
		
		[Parameter(type="ValidatorType",defaultValue="true",row="1", sequence="1",label="null")]
		/**
		 * Enables the validator to be added to a TextInput component 
		 */
		public function get enable() : Boolean
		{
			return _enable;
		}
		/**
		 * 
		 * @private
		 */
		public function set enable( value : Boolean) : void{
			_enable=value;
		}
	}	
}