/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.container 
{
	import com.flashiteasy.api.controls.FormItemElementDescriptor;
	import com.flashiteasy.api.controls.TextElementDescriptor;
	import com.flashiteasy.api.controls.TextInputElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IFormElementDescriptor; 
	import com.flashiteasy.api.core.elements.IPHPElementDescriptor;
	
	
	import com.flashiteasy.api.fieservice.FormManagerService;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	/**
	 * The <code><strong>FormElementDescriptor</strong></code> is the container to use when editing forms. It has to be targetted by 
	 * two embedded buttons, one that resets all form elements children, the other that submits the form.
	 */
	public class FormElementDescriptor extends BlockElementDescriptor implements IUIElementContainer, IPHPElementDescriptor 
	{
		
		public var fms : FormManagerService;
		private var _address : String;
		private var _failureMessage:String;
		//interface implementation
		private var _php:String;
		private var _subject : String;
		private var _successMessage:String;
		private var formErrors:Array = new Array();
		private var formItems:Array=new Array();
		private var itemsToValidate:Array = new Array();
		
		private var missingRequiredItems : Array;
		
		//form management
		private var formResults:Array = new Array();
		private var text:TextElementDescriptor=new TextElementDescriptor();
		
		private var tf:TextField;
		// vars sent to the treatment page (php service);
		private var variables:Object;
		
		/**
		 * The mail address where by default the form is sent.
		 * @param value
		 */
		public function set address(value : String) : void {
			_address = value;
		}
		
		/**
		 * The message displayed when an error has been encountered while sending the form.
		 * @param value
		 */
		public function set failureMessage(value : String) : void {
			_failureMessage = value;
		}

		override public function getDescriptorType():Class
		{
			return FormElementDescriptor;
		}
		
		override public function layoutElement( elementDescriptor : IUIElementDescriptor ) : void{
			super.layoutElement(elementDescriptor);
			if(elementDescriptor is IFormElementDescriptor){
				formItems.push(elementDescriptor);
			}
			if (elementDescriptor is TextInputElementDescriptor)
			{
				itemsToValidate.push( elementDescriptor );
			}
		}
		// Parametres specifiques au formElementDescriptor
		
		/**
		 * 
		 * @param value The php script to which the form is sent for treatment. By default it is sent to a php page that mails
		 * the key/value pairs to a given mail address.
		 */
		public function set php(value : String) : void 
		{
			_php = value;
		}
		
		public function resetValues():void
		{
			var item:FormItemElementDescriptor;
			for each(item in formItems)
			{
				item.resetValues();
			}
		}
		
		public function setFormProperties(phpProp : String, addressProp : String, subjectProp : String, failureMessageProp : String, successMessageProp : String) : void
		{
			this.php = phpProp;
			this.address = addressProp;
			this.subject = subjectProp;
			this.failureMessage = failureMessageProp;
			this.successMessage = successMessageProp;
		}
		
		/**
		 * The subject of the mail containing the key/value pairs from the form elements.
		 * @param value
		 */
		public function set subject(value : String) : void {
			_subject = value;
		}
		
		// Fonction specifique au formElementDescriptor
		
		// Recupere les donnee du formulaire ; les verifie et les envoie
		
		/**
		 * This method submits the form.
		 */
		public function submit():void
		{
			formErrors = [];
			formResults=[];
			var len : uint = formItems.length;
			var item:IFormElementDescriptor;
			var itemsRequiredAreAllFilled : Boolean = checkForRequiredItems();
			if (!itemsRequiredAreAllFilled)
			{
				displayRequiredItems();
			} else {
				for each(item in itemsToValidate)
				{
					// only textinputs have validators
					if ( item is TextInputElementDescriptor )
					{
						if ( TextInputElementDescriptor( item ).check() == true )
						{
							var o:Object = new Object;
							o.itemName = item.name;
							o.itemResult = item.getValue();
							formResults.push(o);
						}
						else
						{
							var ob:Object = new Object;
							ob.uuid = IDescriptor(item).uuid;
							ob.itemName = item.name;
							ob.itemError = TextInputElementDescriptor( item ).validator.getErrorString();
							formErrors.push(ob);
						}
					}
				}
				//trace ("total validators = "+itemsToValidate.length+" (ok="+formResults.length+"/bad="+formErrors.length+")");
				// Si les donnees du formulaire sont valides
				if (formErrors.length == 0)
				{
					if(_php != null)
					{
						// ici on change pour une adresse complete, passee au service
						variables=new Object;
						for (var i:uint=0; i<formResults.length; i++) {
							if (formResults[i].itemResult != null)
							{
								var oc:Object = formResults[i];
								variables[oc.itemName]=oc.itemResult;
							}
						}
						variables["mailToUrl"]=this._address;
						variables["mailSubject"]=this._subject;
						// on envoie le formulaire au service distant
						sendForm();
					} 
				}
				else
				// sinon les donnees sont invalides
				{ 
					displayFormErrors();
				}
	
			}
		}	

		/**
		 * This method checks elements that must be filled (ie : TextInputs, Combo on a given value, radiobuttongroups with a selection, etc.).
		 * @param null
		 * @return a boolean true is evrything required has been filled, false otherwise.
		 */
		public function checkForRequiredItems(): Boolean 
		{
			missingRequiredItems = [];
			var itemsOk:Boolean = true;
			for each (var elem : IFormElementDescriptor in formItems)
			{
				if (elem.required)
				{
					if (elem.getValue() == null || elem.getValue() == "")
					{
						missingRequiredItems.push(elem);
						itemsOk = false;
					}
				}
			}
			return itemsOk;
		}


		/**
		 * This method displays messages in fields not correctly filled.
		 * @param value
		 */
		public function displayRequiredItems():void
		{
			if (missingRequiredItems.length >0)
			{
				var el : FormItemElementDescriptor;
				for each( el in missingRequiredItems )
				{
					el.getFace().setStyle("themeColor", 0xFF0099);
            		el.getFace().setStyle("color", "Red")
					if (el is TextInputElementDescriptor)
					{
						el.displayError("the field '"+el.uuid+"' is required");
					}
					changeStyles(el.getFace());
					el.getFace().invalidate();
				}
			}
		}

		/**
		 * The message displayed when the form has been successfully sent.
		 * @param value a string input in the SendFormAction parameterSet
		 */
		public function set successMessage(value : String) : void {
			_successMessage = value;
		}
		
		

		/**
		 * This method is fired when the form has been successfully sent, which means that the distant service has returned a value (true/false).
		 * @param e : Event asynchronous from distant service
		 */
		private function displayFormErrors():void
		{
			for each (var o:Object in this.formErrors)
			{
				//trace ("calling displayError for element '"+o.itemName+"' with errorstr='"+o.itemError+"'");
				IFormElementDescriptor(ElementList.getInstance().getElement(o.uuid, BrowsingManager.getInstance().getCurrentPage())).displayError(o.itemError);
			}
		}
		

		private function errorHandler(e:IOErrorEvent):void
		{
			trace("Error loading URL.");	
		}

		private function formFailure( e : Event ) : void
		{
			trace ("Form has failed to be sent");
		}
		
		/**
		 * This method is fired when the form has been successfully sent, which means that the distant service has returned a value (true/false).
		 * @param e : Event asynchronous from distant service
		 */
		private function formSuccess( e : Event ) : void
		{
			var errorMsg : String = FormManagerService( e.target ).getError();
			var res : Boolean = (errorMsg == "") ? true : false;
			var fmt : TextFormat = new TextFormat;
			fmt.align = TextFormatAlign.CENTER;
			fmt.font = "Arial";
			fmt.color = 0xCC0000;
			fmt.size = 12;
			tf = new TextField;
			//tf.embedFonts = true;
			tf.multiline = true;
			tf.width = 300;
			tf.height = 200;
			tf.x = 10;//(this.stage.width - tf.width)/2;
			tf.y = face.height - 50;
			//tf.defaultTextFormat = fmt;
			tf.setTextFormat(fmt);
			
	
			if (res) 
			{
				tf.text = _successMessage;
			}
			else
			{
				tf.text = _failureMessage
			} 
			face.addChild(tf);
			waitForDisplayThenKillMessage();
			// on reset les elements de formulaire
			resetValues();
						
		}
	
		private function killMessage(e:TimerEvent) : void
		{
			if (!isNaN(face.getChildIndex(tf)))
				face.removeChild (tf);
		}
		
		
		
		private function sendForm():void{
			if(_php != null){
				// ici on change pour une adresse complete, passee au service
				fms = new FormManagerService;
				//listeners			
				fms.addEventListener(FormManagerService.FORM_SENT_OK, formSuccess, false,0, true);
				fms.addEventListener(FormManagerService.FORM_ERROR, formFailure, false, 0, true);				
				fms.sendFormInfoToDistantService(_php, variables);
			}
		}
		
		private function waitForDisplayThenKillMessage() : void
		{
			var t : Timer = new Timer(5000,1);
			t.addEventListener(TimerEvent.TIMER, killMessage);
			t.start();
		}
		
		public var couleur:Number
		public function changeStyles( item : FieUIComponent ):void 
		{
			if (item.getStyle("color") == "16711680") 
			{
				item.setStyle("color", 0x66CCFF);            
			} else {
				item.setStyle("color", "Red");           
			}
			couleur = Number(item.getStyle("color")); // Returns 16711680
		}
		
	}
}
