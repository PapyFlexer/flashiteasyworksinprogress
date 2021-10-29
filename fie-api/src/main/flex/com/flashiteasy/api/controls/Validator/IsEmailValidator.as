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
	 * The <code><strong>IsEmailValidator</strong></code> class checks if the string input by the user is a vali email address :
	 * it must contain an arobase and a point, with at least 2 letters before the arobase,
	 * two letters between arobase and point and finally 2 letters after the point (aa@bb.cc)
	 */

	public class IsEmailValidator extends AbstractValidator
	{
		
		/**
		 * Constructor
		 */
		public function IsEmailValidator(owner : TextInputElementDescriptor) 
		{
			this.owner = owner;
			super();
		}

		/** @inheritDoc **/
		override public function validateString(value:String):Boolean
		{
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(value);
		}
		
		/** @inheritDoc **/
		override public function getErrorString():String
		{
			return "invalid mail address!";
		}
		
	}
}