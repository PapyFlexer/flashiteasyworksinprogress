/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.fieservice
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.fieservice.responder.GetRemoteParameterListResponder;
	import com.flashiteasy.api.fieservice.responder.FormServiceResponder;
	import com.flashiteasy.api.fieservice.transfer.tr.FormDataTO;
	import com.flashiteasy.api.fieservice.transfer.tr.RemoteParameterListTO;
	import com.flashiteasy.api.fieservice.transfer.tr.TransferObject;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * The <code><strong>AbstractBusinessDelegate</strong></code> class is the class that
	 * manages external communication with databases, webservices, xml flux, ...
	 * via amfphp.
	 * <p>
	 * It extends EventDispatcher so listeners can be added to it.
	 * The service endpoint is set by a config file whose content
	 * is fixed by the installer. Finally the class-mapping is instanciated here.
	 * </p>
	 */
	public class AbstractBusinessDelegate extends EventDispatcher
	{
		/**
		 * 
		 */
		public function AbstractBusinessDelegate()
		{
			registerClassAlias("com.flashiteasy.api.fieservice.transfer.tr.TransferObject", TransferObject );
			registerClassAlias("com.flashiteasy.api.fieservice.transfer.tr.RemoteParameterListTO", RemoteParameterListTO );
			registerClassAlias("com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet", RemoteParameterSet );
			initializeNetConnection( getServiceUrl() );
		}
		
		/**
		 * The endpoint is overrided when the installer is runned
		 */
		protected function getServiceUrl() : String
		{
			return "../fie-service/amfphp/gateway.php";
		}
		
		private var _netConnection : NetConnection;
		
		/**
		 * Initializes the distant connction
		 * @param serviceUrl
		 */
		public function initializeNetConnection( serviceUrl : String ) : void
		{
			_netConnection = new NetConnection();
			_netConnection.connect( serviceUrl );
		}
		
		/**
		 * The methods that calls distant amfphp functions
		 * @param remoteMethodName the name of the service method
		 * @param responder
		 * @param args
		 * 
		 * This is an example of how the call to a distant method is made :
		 * <p>
		 * <listing>
		 * 		public function renameFile( files : Array , newFiles : Array ) : void 
		 * 		{
		 * 			currentAction = "rename" ;
		 * 			var transferObject : FileDataTO = new FileDataTO();
		 * 			transferObject.files = files;
		 * 			transferObject.deletedFiles = newFiles;
		 * 			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.renameFile",new FileServiceResponder(FileServiceResponder.renameHandle,this), transferObject );
		 * 		}
		 * 
		 * </listing>
		 * </p>
		 */
		public function call( remoteMethodName : String, responder : Responder, ...args ) : void
		{
			/*
			if ( !_netConnection.connected )
			{
				throw new Error("use initializeNetConnection first , connection is close");
			}
			else
			{
			*/
			 var collectArgs:Array = new Array;
			 collectArgs.push(remoteMethodName);
			 collectArgs.push(responder);
			 for (var i:uint=0; i<args.length; i++)
			 {
			  collectArgs.push(args[i]);
			 }
			 var callFunction:Function  = _netConnection.call;
			 _netConnection.addEventListener(NetStatusEvent.NET_STATUS , netError ,false , 0 , true ) ;
			 callFunction.apply(_netConnection,collectArgs);
			 //_netConnection.call( remoteMethodName, responder, args );
			//}
		}
		
		private function netError( e : NetStatusEvent ) : void 
		{
			trace("net error " + e.info);
		}
		
		/**
		 * Gets the remoteParameterList from the distant service.
		 * @param page
		 * @param paramList
		 */
		public function getRemoteParameterList( page : Page, paramList : Array ) : void
		{
			var transferObject : RemoteParameterListTO = new RemoteParameterListTO();
			transferObject.remoteParameterList = paramList;
			call("FieService.getRemoteParameterList", new GetRemoteParameterListResponder( GetRemoteParameterListResponder.handleResult  , page ), transferObject );
		}
		
		public function getRemoteXMLList( page : Page, paramList : Array ) : void
		{
			var transferObject : RemoteParameterListTO = new RemoteParameterListTO();
			transferObject.remoteParameterList = paramList;
			call("FieService.getRemoteParameterList", new GetRemoteParameterListResponder( GetRemoteParameterListResponder.handleResult  , page ), transferObject );
		}
		
		private var _pageRemoteStack : Dictionary=new Dictionary();
		
		/**
		 * Saves a call to a distant service in a given page.
		 * @param page
		 * @param iui
		 * @param parameterSet
		 */
		public function addPageRemoteStack( page : Page, iui : IUIElementDescriptor, parameterSet : RemoteParameterSet ) : void
		{
			/*if ( _pageRemoteStack == null )
			{
				_pageRemoteStack = new Dictionary();
			} */
			if ( _pageRemoteStack[page] == null )
			{
				_pageRemoteStack[page] = new Array();
			}
			
			parameterSet.uiElementDescriptorIdentifier = iui.uuid;
			(_pageRemoteStack[page] as Array).push( parameterSet );
		}
		
		/**
		 * Triggers the call to the distant service
		 * @param page
		 */
		public function triggerPageRemoteStack ( page : Page ) : void
		{
			trace( _pageRemoteStack );
			if ( _pageRemoteStack[page] != null )
			{
				getRemoteParameterList( page, _pageRemoteStack[page] );
			}
			
			delete _pageRemoteStack[page];
			
			// TODO dépiler _pageRemoteStack
		}


	}
}