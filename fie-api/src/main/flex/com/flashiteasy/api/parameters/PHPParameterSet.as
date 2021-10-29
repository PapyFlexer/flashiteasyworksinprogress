/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters {
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IPHPElementDescriptor;
	

	[ParameterSet(description="null",type="Reflection", groupname="Form_Item")]
	/**
	 * The <code><strong>PHPParameterSet</strong></code> is the parameterSet
	 * that handles the calling of a php page, specifically
	 * for the submission of a form.
	 */
	public class PHPParameterSet extends AbstractParameterSet {
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			if(target is IPHPElementDescriptor)
			{
				( target as IPHPElementDescriptor).php=this.php;
				( target as IPHPElementDescriptor).address=this.address;
				( target as IPHPElementDescriptor).subject=this.subject;
				( target as IPHPElementDescriptor).failureMessage=this.failureMessage;
				( target as IPHPElementDescriptor).successMessage=this.successMessage;
				( target as IPHPElementDescriptor).setFormProperties(php, address, subject, failureMessage, successMessage);
			}
		}
		
		/**
		 * php source / meta, getter & setter
		 */
		private var _php:String="http://www.flashiteasy.com/php/sendForm.php";
		[Parameter(type="String", defaultValue="http://www.flashiteasy.com/php/sendForm.php",row="0", sequence="0", label="Source", groupname="Form")]
		/**
		 * Sets the php page url
		 */
		public function get php():String{
			return _php;
		}
		/**
		 * 
		 * @private
		 */
		public function set php(value:String):void{
			_php=value;
		}

		/**
		 * @default "le formulaire a été correctement soumis"
		 */
		private var _successMessage:String="le formulaire a été correctement soumis";
		[Parameter(type="String", defaultValue="le formulaire a été correctement soumis",row="1", sequence="1", label="Success", groupname="Form")]
		/**
		 * 
		 * Sets the success messsage, for when the form has been correctly submitted
		 */
		public function get successMessage():String{
			return _successMessage;
		}
		/**
		 * 
		 * @private
		 */
		public function set successMessage(value:String):void{
			_successMessage=value;
		}

		/**
		 * failure message / meta, getter & setter
		 * string returned when form has failed
		 */
		private var _failureMessage:String="le formulaire n'a pas pu être soumis";
		[Parameter(type="String", defaultValue="le formulaire n'a pas pu être soumis",row="2", sequence="2", label="Failure", groupname="Form")]
		/**
		 * 
		 * Sets the failure messsage, for when the form has not been correctly submitted
		 */
		public function get failureMessage():String{
			return _failureMessage;
		}
		/**
		 * 
		 * @private
		 */
		public function set failureMessage(value:String):void{
			_failureMessage=value;
		}


		/**
		 * email address  / meta, getter & setter
		 * (string) the mail the form is sent to
		 */
		private var _address:String="contact@flashiteasy.com";
		[Parameter(type="String", defaultValue="contact@flashiteasy.com",row="3", sequence="3", label="email", groupname="Form")]
		/**
		 * 
		 * Sets the mail address towards which the form is submitted
		 */
		public function get address():String{
			return _address;
		}
		/**
		 * 
		 * @private
		 */
		public function set address(value:String):void{
			_address=value;
		}

		/**
		 * mail subject / meta, getter & setter
		 * string returned when form has failed
		 */
		private var _subject:String="Mail from FIE platform";
		[Parameter(type="String", defaultValue="Mail from FIE platform",row="4", sequence="4", label="subject", groupname="Form")]
		/**
		 * 
		 * Sets the mail subject 
		 */
		public function get subject():String{
			return _subject;
		}
		/**
		 * 
		 * @private
		 */
		public function set subject(value:String):void{
			_subject=value;
		}


	}
}
