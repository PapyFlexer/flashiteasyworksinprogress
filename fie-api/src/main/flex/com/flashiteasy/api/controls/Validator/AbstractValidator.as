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
	import com.flashiteasy.api.core.elements.IValidatorElementDescriptor;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code><strong>AbstractValidator</strong></code> class is an abstract class shared by all Validator calsses. The validators are used to validate form elements (TextInput controls) so they confort the given structure.
	 * Validators include for example :
	 * <ul>
	 * <li>IsEmailValidator</li>
	 * <li>IsEqualValidator</li>
	 * <li>RestrictValidator</li>
   	 * <li>etc.</li>
  	 * </ul>
	 * 
	 */
	public class AbstractValidator implements IValidatorElementDescriptor
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  A string containing the upper- and lower-case letters
	     *  of the Roman alphabet  ("A" through "Z" and "a" through "z").
	     */
	    protected static const ROMAN_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	
	
	    /**
	     *  A String containing the decimal digits 0 through 9.    
	     */ 
    	protected static const DECIMAL_CHARS:String = "0123456789";
    	
		
		/**
		 * Constructor
		 */
		public function AbstractValidator() 
		{
			//owner.validator = this;
		}
		

/*
		function setValidatorEnable( enable : Boolean ):void
		function getErrorString() : String;

*/


		/**
		 * 
		 * @param value the input by user
		 * @return Boolean if checks
		 */
		public function validateString(value:String):Boolean
		{
			//MUST BE OVERRIDDEN
			return false;
		}

		/**
		 * 
		 * @param value the name of the type of validator used
		 * @return void
		 */
		public function setValidator( value:String ):void
		{
			//MUST BE OVERRIDDEN
		}
		
		/** @private **/
		private var _enable : Boolean;
		
		public function setValidatorEnable( value : Boolean) : void
		{
			//MUST BE OVERRIDDEN
		}
		
		
		
		/** @private **/
		private var _validator : IValidatorElementDescriptor;
		
		/**
		 * Sets the TextInputElementDescriptor the Validator is applied to.
		 * @return the TextInputElementDescriptor the Validator is applied to.
		 */
		public function get validator( ) : IValidatorElementDescriptor
		{
			return _validator;
		}
   		
		/** @private **/
   		public function set validator( value : IValidatorElementDescriptor ) : void
   		{
   			_validator = value;
   		}
    	
		
		
		
		/** @private **/
		private var _owner : TextInputElementDescriptor;
		
		/**
		 * Sets the TextInputElementDescriptor the Validator is applied to.
		 * @return the TextInputElementDescriptor the Validator is applied to.
		 */
		public function get owner( ) : TextInputElementDescriptor
		{
			return _owner;
		}
   		
		/** @private **/
   		public function set owner( own : TextInputElementDescriptor ) : void
   		{
   			_owner = own;
   		}
    	
		/**
		 * As this class in an Abstract, this method must be overriden in  the classes extending this one.
		 * @return the string to display when the <code>validator.validateString()</code> method returns false.
		 */
		public function getErrorString():String
		{
			//MUST BE OVERRIDDEN
			return null;
		}
		
		public function getType() : String
		{
			return getQualifiedClassName( this ).split( "::" )[1];
		}
		
		
		/**
		 * Validator creation
		 * @param type
		 * @param args
		 * @return 
		 */
		public function createValidator( type : Class,...args ) : IValidatorElementDescriptor 
		{
          switch( getType ) {
                        case IsNoneValidator:
                                return new type();
                        case IsEqualValidator:
                        		return new type(args[0]);// args[0] = target
                       	default:
                       			return new type();
                }
        
		var c:Class=getDefinitionByName( "com.flashiteasy.api.controls.Validator."+type() ) as Class;
		trace ("Applying validator type "+c);
		trace ("= "+type);
		//var c:Class = validatorType as Class;
		}
	}
}