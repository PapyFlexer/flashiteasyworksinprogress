/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.controls.Validator
{
	import com.flashiteasy.api.controls.TextInputElementDescriptor;
	
	
	/**
	 * 
	 * The <code><strong>IsEmailValidator</strong></code> class checks if the string input is correctly composed of only number elements
	 */

	public class IsPhoneNumberValidator extends AbstractValidator
	{
		
		/**
		 * Constructor
		 */
		public function IsPhoneNumberValidator(owner : TextInputElementDescriptor) 
		{
			this.owner = owner;
			super();
		}

		
		/** @inheritDoc **/
		override public function validateString( value : String ) : Boolean
		{
			var phoneExpression:RegExp = new RegExp('^0[1-68][0-9]{8}$');
			return phoneExpression.test(value);
		}
		
		/** @inheritDoc **/
		override public function getErrorString():String
		{
			return "this input is not a valid phone number!";
		}
				
	}
}