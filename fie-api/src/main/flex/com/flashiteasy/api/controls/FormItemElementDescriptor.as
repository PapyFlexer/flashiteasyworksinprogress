/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.controls.Validator.*;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IFormElementDescriptor;
	import com.flashiteasy.api.core.elements.IValidatorElementDescriptor;

	/**
	 * The <code><strong>FormItemElementDescriptor</strong></code> is a pseudo-abstract Descriptor that defines  all form-related controls.
	 */

	public class FormItemElementDescriptor extends SimpleUIElementDescriptor implements IUIElementDescriptor,IFormElementDescriptor 
	{
		
		
	
		/*
		===============================
		
		PUBLIC METHODS
		
		===============================
		*/
		
		/**
		 * 
		 * @return 
		 */
		public function check():Boolean{
			return _validator.validateString(this.getValue());
		}
		
		/**
		 * 
		 * @return String to record the value of the formItem. 
		 * As this class is an Abstract, it must be overriden.
		 */
		public function getValue() : String 
		{
			// MUST BE OVERRIDDEN
			return null;
		}
		protected override function onComplete():void
		{

			super.onComplete();
			end();
		}
		
		
		/**
		 * 
		 * @return the <code><strong>IUIElementContainer</strong></code> that is the parent Form container of the form item.
		 */
		public function getParentForm() : IUIElementContainer
		{
			return this.parentBlock;
		}
		
		/**
		 * The <code><strong>resetValues()</strong></code> method is called when the Reset Button is clicked in the parent form container
		 */
		public function resetValues():void
		{
			throw new Error("MUST BE OVERRIDDEN");
		}
		/**
		 * 
		 * @param s the string displayed when a validator returns false or when a required form item is not filled.
		 */
		public function displayError(s:String):void
		{
			throw new Error("MUST BE OVERRIDDEN");
		}

		/*
		===============================
		
		GETTERS & SETTERS
		
		===============================
		*/
		/**
		 * 
		 * @private
		 */
		private var _name:String;
		
		/**
		 * 
		 * records the 'name' property of the form item descriptor class 
		 * @default FormItem
		 * 
		 */
		public function get name():String
		{
			return _name;
		}
		/**
		 * 
		 * @private
		 */
		public function set name( value : String	) : void 
		{
			this._name=value;
		}
		
		
		/**
		 * 
		 * @private
		 */
		private var _validator : IValidatorElementDescriptor;
		
		/**
		 * IValidator, sets a Validator to the form item, usually a TextInput control.
		 */
		public function get validator( ):IValidatorElementDescriptor
		{
			return _validator;
		}
		
		/**
		 * @private
		 */
		public function set validator(value:IValidatorElementDescriptor):void
		{
			this._validator=value;
		}

		/**
		 * 
		 * @private
		 * 
		 */
		
		private var _error:String;
		/**
		 * Sets the error string displayed if and when the <code>check()</code> method returns <code>false</code>.
		 */
		public function get error() : String 
		{	
			return _error;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set error(value : String) : void 
		{
			_error=value;
		}
		
		/**
		 * 
		 * @private
		 * 
		 */	
		private var _required:Boolean;
		
		/**
		 * Boolean value that states if the form item is required before sending form info.
		 * Displays a red asterisk besides the control.
		 */
		public function get required() : Boolean {
			
			return _required;
		}
	
		/**
		 * 
		 * @private
		 */
		public function set required(value : Boolean) : void {
			_required=value;
		}
		
		override public function getDescriptorType():Class
		{
			return FormItemElementDescriptor;
		}
		

	}
}
