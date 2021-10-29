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
	 * The <code><strong>IsNoneValidator</strong></code> class defines the default validator that does nothing...
	 */

	public class IsNoneValidator extends AbstractValidator
	{
		
		/**
		 * Constructor
		 */
		public function IsNoneValidator( owner : TextInputElementDescriptor ) 
		{
			this.owner = owner;
			super();
		}

		
		/** @inheritDoc **/
		override public function validateString( value : String ) : Boolean
		{
			return true;// allways true because it is a no validator
		}
		
		/** @inheritDoc **/
		override public function getErrorString():String
		{
			return "";
		}
		
	}
}