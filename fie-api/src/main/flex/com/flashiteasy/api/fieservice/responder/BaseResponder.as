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
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.fieservice.ErrorsCatalog;
	import com.flashiteasy.api.fieservice.debug.DebugPanel;
	import com.flashiteasy.api.fieservice.transfer.tr.TransferObject;
	
	import flash.net.Responder;

	/**
	 * Flash'Iteasy uses amfphp 1.9 as the gateway for business logics.
	 * The <code><strong>BaseResponder</strong></code> class is pseudo-abstract class for all responders
	 * created while discussing with the business layers.
	 * All responders extend this class
	 * 
	 * @see com.flashiteasy.api.fieservice.AbstractBusinessDelegate
	 */
	public class BaseResponder extends Responder
	{
		/**
		 * Constructor
		 * @param result the method to fire when the server sends back the query result
		 * @param status the status of the request
		 */
		public function BaseResponder(result:Function, status:Function=null)
		{
			super(result, status);
			
		}

		private static var _errorListeners:Object = new Object();

		/**
		 * Sets the error type and the callback to execute when
		 * the specific error has occured.
		 * @param errorCode
		 * @param responder
		 */
		public static function addErrorListener(errorCode:Number, responder:Function):void
		{
			_errorListeners[errorCode]=responder;
		}		
		
		/**
		 * The callback method when the results arrives
		 * @param response
		 * @return 
		 */
		public static function handleResult ( response : Object ) : Boolean
		{
			addErrorListener(1, remoteError);
			
			var success : Boolean = false;
			if (!response)
			{
				success = handleSevereError(ErrorsCatalog.NO_EVENT_IN_RESPONDER);
			}
			else
			{
				try
				{
					var dto : TransferObject = TransferObject(response);
				}
				catch (e:Error)
				{
					success = handleSevereError(ErrorsCatalog.INVALID_TRANSFERT_OBJECT);
				}
				if (triggerErrorListeners(dto))
				{
					return false;
				}
				else
				{
					success = true;
				}
			}
			return success;
		}
		
		/**
		 * Specific error treatment for distants transfer objects
		 * @param dto
		 * @return 
		 */
		static protected function remoteError(dto : TransferObject):Boolean
		{
			/*
			var debugPanel : DebugPanel = new DebugPanel();
			debugPanel.x = 200;
			debugPanel.y = 200;
			debugPanel.width = 200;
			debugPanel.height = 200;
			debugPanel.graphics.beginFill(0xFF0000);
			AbstractBootstrap.CLIENT_STAGE.addChild( debugPanel );
			*/
			trace("remote Error " + dto.code );
			trace("remote Error " + dto.message );
			return false;
		}
		
		/**
		 * Handler for severe error types
		 * @param code
		 * @return 
		 */
		static protected function handleSevereError(code:String):Boolean
		{
			return false;
		}		

		/**
		 * Triggers the error listeners
		 * @param dto
		 * @return 
		 */
		static protected function triggerErrorListeners(dto:TransferObject):Boolean
		{
			var listenerAppend:Boolean=false;
			if (_errorListeners[dto.code] != null)
			{
				var responder:Function=_errorListeners[dto.code];
				var listenerResult:*=responder(dto);
				listenerAppend=true
			}
			return listenerAppend;
		}

	}
}