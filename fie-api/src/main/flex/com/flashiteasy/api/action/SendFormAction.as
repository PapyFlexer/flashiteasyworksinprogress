/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 * 
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.container.FormElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.action.ISendFormAction;
	import com.flashiteasy.api.core.elements.IPHPElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.events.Event;

	public class SendFormAction extends Action implements ISendFormAction, IPHPElementDescriptor
	{
		
		//interface implementation
		private var _php:String;
		private var _address : String;
		private var _subject : String;
		private var _successMessage:String;
		private var _failureMessage:String;
		
		/**
		 * 
		 * @param value The php script to which the form is sent for treatment. By default it is sent to a php page that mails
		 * the key/value pairs to a given mail address.
		 */
		public function set php(value : String) : void 
		{
			_php = value;
		}
		public function get php() : String
		{
			return _php;
		}
		
		/**
		 * The mail address where by default the form i sent.
		 * @param value
		 */
		public function set address(value : String) : void {
			_address = value;
		}
		public function get address() : String
		{
			return _address;
		}
		
		/**
		 * The subject of the mail containing the key/value pairs from the form elements.
		 * @param value
		 */
		public function set subject(value : String) : void {
			_subject = value;
		}
		public function get subject() : String
		{
			return _subject;
		}
		
		/**
		 * The message displayed when the form has been successfully sent.
		 * @param value
		 */
		public function set successMessage(value : String) : void {
			_successMessage = value;
		}
		public function get successMessage() : String
		{
			return _successMessage;
		}
		
		/**
		 * The message displayed when an error has been encountered while sending the form.
		 * @param value
		 */
		public function set failureMessage(value : String) : void {
			_failureMessage = value;
		}
		public function get failureMessage() : String
		{
			return _failureMessage;
		}
		


		public function setFormProperties(phpProp : String, addressProp : String, subjectProp : String, failureMessageProp : String, successMessageProp : String) : void
		{
			this.php = phpProp;
			this.address = addressProp;
			this.subject = subjectProp;
			this.failureMessage = failureMessageProp;
			this.successMessage = successMessageProp;
		}


		protected var _form : FormElementDescriptor;
		
		protected var _formName : String;
		//protected var _page : Page;
		
		
		public function SendFormAction()
		{
			super();
			
		}
		
		public function verifyAndSendForm( target : String ) : void
		{
			
			_formName = target;
			//var blocks : Array = page.getPageItems().pageControls;
			/*  */
		}

		public function setFormName( name : String ) : void
		{
			_formName = name;
		}

		override public function apply( event : Event ) : void
		{
			findForm(formName,BrowsingManager.getInstance().getCurrentPage())
			form.setFormProperties(php, address, subject, failureMessage, successMessage);
			form.submit();
		}
		
		public function get form () : FormElementDescriptor
		{
			return _form;
		}
		
		public function set form( value : FormElementDescriptor ) : void
		{
			_form = value;
		}
		public function get formName () : String
		{
			return _formName;
		}
		
		public function set formName( value : String) : void
		{
			_formName = value;
		}
		
		private function findForm( formName : String, page : Page) : void
		{
			var blocks : Array = PageUtils.getPageForms(page);
			var item : IDescriptor;
			for each (item in blocks)
			{
				if (item.uuid == formName)
				{
					form = item as FormElementDescriptor;
					break;
				}			
			}
		}

		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return SendFormAction;
		}
		
	}
}