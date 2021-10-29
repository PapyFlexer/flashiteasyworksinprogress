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

	public class IsZipCodeValidator extends AbstractValidator
	{
		 
		/**
		 * Constructor
		 */
		public function IsZipCodeValidator(owner : TextInputElementDescriptor) 
		{
			this.owner = owner;
			super();
		}

		
		/** @inheritDoc **/
		override public function validateString( value : String ) : Boolean
		{
			// "^(F-[0-9]{4,5}|B-[0-9]{4})$"
			var zipcodeExpression : RegExp = new RegExp('^(F-[0-9]{4,5}|B-[0-9]{4})$');
			return zipcodeExpression.test(value);
		}
		
		/** @inheritDoc **/
		override public function getErrorString():String
		{
			return "this input is not a valid zip code number";
		}
				
	}
}