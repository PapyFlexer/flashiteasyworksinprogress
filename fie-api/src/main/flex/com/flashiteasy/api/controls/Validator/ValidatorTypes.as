/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.controls.Validator
{
	/**
	 * 
	 * The <code><strong>ValidatorTypes</strong></code> class lists validator types and is used by the administration module to build a Combo.
	 * 
	 * 
	 */
	public class ValidatorTypes
	{

		/**
		 * 
		 * @default 
		 */
		public static const IS_NONE 		: String = "IsNoneValidator";

		/**
		 * 
		 * @default 
		 */
		public static const IS_CREDITCARD 	: String = "IsCreditCardValidator";

		/**
		 * 
		 * @default 
		 */
		public static const IS_EMAIL 	: String = "IsEmailValidator";

		/**
		 * 
		 * @default 
		 */
		public static const IS_NUMBER 	: String = "IsNumberValidator";

		/**
		 * 
		 * @default 
		 */
		public static const IS_PHONENUMBER 	: String = "IsPhoneNumberValidator";

		/**
		 * 
		 * @default 
		 */
		public static const IS_ZIPCODE 	: String = "IsZipCodeValidator";

		/**
		 * 
		 * @default 
		 */
		public static const IS_EQUAL 	: String = "IsEqualValidator";

		public static function getValidatorTypes() : Array
		{
			return [IS_NONE,IS_CREDITCARD,IS_EMAIL,IS_NUMBER,IS_PHONENUMBER,IS_ZIPCODE,IS_EQUAL];
		}
		
	}
}