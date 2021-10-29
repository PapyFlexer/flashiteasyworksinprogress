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
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.fieservice.transfer.tr.RemoteParameterListTO;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.net.Responder;

	/**
	 * The <code><strong>GetRemoteParameterListResponder</strong></code> class extends the base responder
	 * to treat the calling of external (distant) ParameterSet lists.
	 */
	public class GetRemoteParameterListResponder extends Responder
	{
		
		private static var page : Page ;
		
		/**
		 * Constructor
		 * @param result
		 * @param page
		 * @param status
		 */
		public function GetRemoteParameterListResponder(result:Function , page : Page , status:Function=null)
		{
			GetRemoteParameterListResponder.page = page ;
			super(result, status);
		}
		
		/**
		 * 
		 * @param response
		 */
		public static function handleResult ( response : RemoteParameterListTO ) : void
		{
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
		public static function doResult ( response : RemoteParameterListTO ) : void
		{
			// TODO, check the format of the response, use ElementList For apply dynamic remote property to each iuicomponent
			// TODO implementer la gestion des erreur server en faisant un check sur la propriété code du RemoteParameterListTO
			
			for each ( var remoteParameterSet : RemoteParameterSet in response.remoteParameterList )
			{
				var iui : IUIElementDescriptor = ElementList.getInstance().getElement( remoteParameterSet.uiElementDescriptorIdentifier , GetRemoteParameterListResponder.page );
				if( iui !=null )
				{
					var paramset : IParameterSet = iui.getParameterSet();
					iui.updateParameterSet(remoteParameterSet);
				}
				
			}			
		}
		
	}
}