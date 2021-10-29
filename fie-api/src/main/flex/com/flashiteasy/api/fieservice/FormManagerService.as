package com.flashiteasy.api.fieservice
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.fieservice.responder.FormServiceResponder;
	import com.flashiteasy.api.fieservice.transfer.tr.FormDataTO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	import flash.net.registerClassAlias;
	
	public class FormManagerService extends EventDispatcher
	{
		public static var FORM_SENT_OK:String = "formmanager_success";
		public static var FORM_ERROR:String = "formmanager_failure";

		private var distantServiceUrl : String ;
		private var variables : URLVariables;
		
		public function FormManagerService()
		{
			registerClassAlias("com.flashiteasy.api.fieservice.transfer.tr.FormDataTO", FormDataTO );
		}
		
		public function sendFormInfoToDistantService( distantServiceUrl : String, formInfos : Object ) : void
		{
			var transferObject : FormDataTO = new FormDataTO();
			transferObject.phpFilePath = distantServiceUrl;
			transferObject.formData = formInfos;
			//trace ("calling php service send form on "+transferObject.phpFilePath);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieFormService.sendForm", new FormServiceResponder( FormServiceResponder.handleResult, this ), transferObject );
		}

		public function complete() : void 
		{
			dispatchEvent(new Event(FORM_SENT_OK));
		}
		
		
		private var errorMessage : String ="";
		
		public function error(code:int=0, errorInfo : String = ""): void 
		{
			errorMessage = errorInfo;
			trace ("error au retour du sendForm : "+errorMessage);
			dispatchEvent(new Event(FORM_ERROR));
		}
		
		public function getError() : String 
		{
			return errorMessage;
		}
		
	}


}