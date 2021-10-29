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
	import com.flashiteasy.api.controls.Validator.ValidatorTypes;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.PageUtils;

	/**
	 * The <code><strong>ValidatorTargetParameterSet</strong></code> is the parameterSet
	 * that specifies is IsEqualValidator 's target.
	 */

	public class ValidatorTargetParameterSet extends AbstractParameterSet
	{
		private var _target:String = null;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			super.apply( targ );
			if( targ is IsEqualValidator )
			{
				IsEqualValidator( targ ).target = _target;
			}
		}
		/**
		 * The other TextInput Control whose content must be equal to the present one (uuid)
		 */
		public function get target():String
		{
			return _target;
		}

		/**
		 * 
		 * @privatee
		 */
		public function set target(value:String):void
		{
			_target=value;
		}
		/**
		 * Lists all possibles targets, ie. TextInput controls having the same FormContainer parent
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name : String ) : Array 
		{
			var values:Array;
			switch(name){
				case "type" :
				values = ValidatorTypes.getValidatorTypes();;
				break;
				case "target" :
				values = PageUtils.getTextInputItems( BrowsingManager.getInstance().getCurrentPage() );
				break;
				
			}
			return values;
		}
		
		public function getValidatorType():String
		{
			return "IsEqualValidator";
		}

	}
}