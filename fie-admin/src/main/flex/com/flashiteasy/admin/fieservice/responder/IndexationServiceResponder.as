package com.flashiteasy.admin.fieservice.responder
{	
	import com.flashiteasy.admin.fieservice.IndexationService;
	import com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO;
	
	import flash.net.Responder;

	public class IndexationServiceResponder extends Responder
	{
		private static var ids:IndexationService
		
		public function IndexationServiceResponder(result:Function, ids:IndexationService,status:Function=null)
		{
			trace ("creating Responder");
			IndexationServiceResponder.ids = ids;
			super(result, status);
		}
		
		public static function saveToHTML( response : Object ) : void 
		{
			var fd : FileDataTO = FileDataTO( response ) ;
			if( fd.success )
			{
				ids.complete();
			}
			else
			{
				ids.error();
			}
		}
		public static function savePageIndexationHandle( response : Object ) : void 
		{
			trace ("response from php is "+response.code);
			if( Boolean ( response.code )) 
			{

				trace(" age has been indexed with success ");
				IndexationServiceResponder.ids.content = response.content;
				IndexationServiceResponder.ids.complete();
			} 
			else
			{
				trace(" couldn t index page ");
				IndexationServiceResponder.ids.error(response.code);	
			
			}
		}

		public static function saveIndexationObjectHandle( response : Object ) : void 
		{
			trace ("response from php is "+response.code + "/ "+response.content);
			if( Boolean ( response.code )) 
			{

				trace(" Indexation Object has been saved with success ");
				IndexationServiceResponder.ids.content = response.content;
				IndexationServiceResponder.ids.complete();
			} 
			else
			{
				trace(" couldn t save indexation object ");
				IndexationServiceResponder.ids.error(response.code);	
			
			}
		}
		
		
	}
}