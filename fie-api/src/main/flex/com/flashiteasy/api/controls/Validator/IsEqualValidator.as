/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.controls.Validator {
	import com.flashiteasy.api.controls.TextInputElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.selection.ElementList;
	
	/**
	 * 
	 * The <code><strong>IsEqualValidator</strong></code> class checks if the string input by the user is the same that in the one that is targetted.
	 * Mostly used in coordination with isEmailvalidator to check if a correct mail address has been requested (twice).
	 */

	public class IsEqualValidator extends AbstractValidator 
	{
		
		private var _target : String;
		
		/**
		 * Constructor
		 */
		public function IsEqualValidator(owner : TextInputElementDescriptor, target : String   ) 
		{
			this.owner = owner;
			owner.validator = this;
			this.target = target;
			super();
		}

		
		/**  @inheritDoc **/
		override public function validateString(value : String) : Boolean 
		{
			var targettedTIED : TextInputElementDescriptor = TextInputElementDescriptor( ElementList.getInstance().getElement( target,BrowsingManager.getInstance().getCurrentPage()) );
			return value == targettedTIED.getValue();
		}
		
		/**  @inheritDoc **/
		override public function getErrorString():String
		{
			return "the fields are not equal !";
		}
		
		public function set target( value : String ) : void
		{
			_target = ElementList.getInstance().getElement( value,BrowsingManager.getInstance().getCurrentPage()).uuid; 
		}
		
		public function get target() : String
		{
			return _target;
		}
	}
}
