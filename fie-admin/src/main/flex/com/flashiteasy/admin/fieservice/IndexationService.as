package com.flashiteasy.admin.fieservice
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.fieservice.responder.IndexationServiceResponder;
	import com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO;
	import com.flashiteasy.admin.popUp.MessagePopUp;
	import com.flashiteasy.admin.utils.TextUtils;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.indexation.PageInformation;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	import flash.net.registerClassAlias;
	
	public class IndexationService extends EventDispatcher
	{
		private var indexationFolder:String=Conf.APP_ROOT+"/indexation";
		private var currentAction : String ;
		[Bindable]
		public var content:String;
		
		private var variables : URLVariables;
		
		public static var INDEX_OBJ_SAVED:String = "indexation_object_saved";
		public static var PAGE_INDEXATION_SAVED:String = "page_indexation_saved";
		public static var ERROR : String = "indexation_error";
		
		public function IndexationService()
		{
			registerClassAlias("com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO", FileDataTO );
		}
		

		private var alert : MessagePopUp;
		
		public function saveHTML( page : Page , xml : XML ) : void 
		{
			alert = new MessagePopUp(Conf.languageManager.getLanguage("Creating_HTML"), null, true);
			currentAction = "saveHTML";
			var transferObject : FileDataTO = new FileDataTO();
			//transferObject.content = page.link;
			transferObject.files = [Conf.APP_ROOT+"/xml/"+page.getPageUrl()+".xml", Conf.APP_ROOT+"/html/"+page.getPageUrl()+".html" ];
			transferObject.content = xml;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieIndexationService.createHTML",new IndexationServiceResponder(IndexationServiceResponder.saveToHTML,this), transferObject );
		}

		public function saveIndexationObject( content : String ) : void
		{
			currentAction ="saveIndexationObject";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = Conf.APP_ROOT + "indexation/";
			transferObject.files = ["info.xml"];
			transferObject.content = content;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("IndexationService.saveIndexationObject",new IndexationServiceResponder(IndexationServiceResponder.saveIndexationObjectHandle,this), transferObject );
		}

		public function complete() : void 
		{
			switch(currentAction) 
			{
				case "savePageIndexation":
					trace ("PAGE_INDEXATION_SAVED");
					dispatchEvent(new Event(PAGE_INDEXATION_SAVED));
					break;
				case "saveHTML" :
					alert.closePopUp();
					break;
				case "saveIndexationObject":
					trace ("INDEX_OBJ_SAVED");
					dispatchEvent(new Event(INDEX_OBJ_SAVED));
					break; 
			}
		}
		
		public function error(code:int=0): void 
		{
			trace ("error saving");
			dispatchEvent(new Event(ERROR));
			if( currentAction == "saveHTML") 
			{
				alert.changeMessage(Conf.languageManager.getLanguage("Error_while_creating_html"));
				alert.showOk();
			}
		}
		
		private function serializePageInfo( pageInfo : PageInformation ) : String
		{
			var sep : String = "<#>";
			return pageInfo.title+sep+pageInfo.keywords+sep+pageInfo.description
		}
		
		/* private function unserializePageInfo(pageInfoString : String) : PageInformation
		{
			var pi : PageInformation = new PageInformation();
			pi.title = pageInfoString.split("<#>")[0];	
			pi.keywords = pageInfoString.split("<#>")[1];
			pi.description = pageInfoString.split("<#>")[0];		
		} */
	}
}