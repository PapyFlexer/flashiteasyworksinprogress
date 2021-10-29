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
	import com.flashiteasy.api.controls.Validator.*;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IValidatorElementDescriptor;
	import com.flashiteasy.api.utils.PageUtils;
	

	[ParameterSet(description="Validator",type="Reflection",groupname="Block_Content")]
	/**
	 * The <code><strong>ValidatorParameterSet</strong></code> is the parameterSet
	 * that handles verifications on form item inputs by users
	 */
	public class ValidatorParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{

		private var _type : String = "IsNoneValidator";
		private var _enable : Boolean = true;
		//private var _validator : IValidatorElementDescriptor;
		
		private var _target : String;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			
			if( target is IValidatorElementDescriptor )
			{
				IValidatorElementDescriptor( target ).setValidator( type );  
			}
		}
		
		

        [Parameter(type="Combo", defaultValue="IsNoneValidator",row="0", sequence="1", label="Validator")]
		/**
		 * Sets the validator type 
		 */
		public function get type() : String
		{
			return _type;
		}

		/**
		 * 
		 * @private
		 */
		public function set type(value:String):void{
			_type=value; 
		}
		
		[Parameter(type="Boolean",defaultValue="true",row="0", sequence="0",label="Enable")]
		
		/**
		 * The error string displayed when the validator checks false
		 */
		public function get enable() : Boolean
		{
			return _enable;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set enable( value : Boolean ) : void
		{
			_enable=value;
		}
		
		public function get target() : String
		{
			return _target;
		}
		public function set target(value:String) : void
		{
			_target = value;
		}
		
        /**
         * Lists all validators
         * @param name
         * @return 
         */
        public function getPossibleValues(name:String):Array
		{
			//return ArrayUtils.getConstant(com.flashiteasy.api.controls.Validator.ValidatorTypes);
			var values:Array;
			switch(name){
				case "type" :
				values = ValidatorTypes.getValidatorTypes();
				break;
				case "target" :
				values = PageUtils.getTextInputItems(BrowsingManager.getInstance().getCurrentPage());
				break;
				
			}
			return values;
		}

	}
}
