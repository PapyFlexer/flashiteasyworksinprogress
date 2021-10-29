/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.action.IExternalLinkAction;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * The <code><strong>ExternalBrowsingAction</strong></code> class is a basic getURL-equivalent action. Used to call browser requests
	 * 
	 */
	public class ExternalBrowsingAction extends Action implements IExternalLinkAction
	{
		/**
		 * 
		 * @default String that describes the url called
		 */
		protected var link:String;
		/**
		 * 
		 * @default String that represents the HREF window attribute
		 */
		protected var window:String;
		
		/**
		 * Action Constructor
		 */
		public function ExternalBrowsingAction()
		{
			super();
		}
		
		/**
		 * Sets the link and the target link's target 
		 * @param linkURL :  the url called
		 * @param target : the HREF window attribute
		 */
		public function setLinkAndTarget ( linkURL : String, target : String ) : void
		{
			link = linkURL;
			window = target;
		}
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( event : Event ) : void
		{
			var request : URLRequest = new URLRequest(link);
			navigateToURL(request, window);
		}
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return ExternalBrowsingAction;
		}
		
	}
}