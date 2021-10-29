/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.fieservice.responder
{
	import com.flashiteasy.api.fieservice.FormManagerService;
	import com.flashiteasy.api.fieservice.transfer.tr.FormDataTO;

	/**
	 * The <code><strong>GetRemoteParameterListResponder</strong></code> class extends the base responder
	 * to treat the calling of external (distant) ParameterSet lists.
	 */
	public class FormServiceResponder extends BaseResponder
	{
		
		private static var fms:FormManagerService = new FormManagerService;
		
		/**
		 * Constructor
		 * @param result
		 * @param page
		 * @param status
		 */
		public function FormServiceResponder( result:Function , fms : FormManagerService ,status : Function=null)
		{
			FormServiceResponder.fms = fms;
			super(result, status);
		}
		
		/**
		 * 
		 * @param response
		 */
		public static function handleResult ( response : FormDataTO ) : void
		{
			//trace ("handling result in FormServiceResponder");
			if ( BaseResponder.handleResult( response ) )
			{
				doResult( response );
			}
		}
		
		/**
		 * Fires the result method callback
		 * @param response the RemoteParameterList transfer object coming back
		 * 
		 * @see com.flashiteasy.api.fieservice.transfer.tr.RemoteParameterListTO
		 */
		public static function doResult ( response : FormDataTO ) : void
		{
			trace ("doResult() in form returns "+response.success);
			if (response.success == true )
			{
				FormServiceResponder.fms.complete();
			}
			else
			{
				FormServiceResponder.fms.error(response.code, response.message);
			}			
/* 			for each ( var remoteParameterSet : RemoteParameterSet in response.remoteParameterList )
			{
				var iui : IUIElementDescriptor = ElementList.getInstance().getElement( remoteParameterSet.uiElementDescriptorIdentifier , GetRemoteParameterListResponder.page );
				if( iui !=null )
				{
					var paramset : IParameterSet = iui.getParameterSet();
					iui.updateParameterSet(remoteParameterSet);
				}
				
			}			
 */		}
		
		public static function onFault( e : * ) :void
		{
			trace("fault");
			FormServiceResponder.fms.error(0,e.faultString);	
		}
	}
}