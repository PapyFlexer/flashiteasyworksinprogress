/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.action.IInternalLinkAction;
	import com.flashiteasy.api.core.project.Page;

	import flash.events.Event;

	
	/**
	 * The <code><strong>InternalBrowsingAction</strong></code> class handles 
	 * internal link actions. It is used to call pages from the project
	 * 
	 */
	public class InternalBrowsingAction extends Action implements IInternalLinkAction
	{
		/**
		 * 
		 * @default the Page to go to link attribute
		 */
		protected var targetPageUrl:String;

		/**
		 * 
		 * @param target : the Page to go to link attribute
		 */
		public function setTargetPage(target:String):void
		{
			targetPageUrl=target;
		}

		override public function apply(event:Event):void
		{
			BrowsingManager.getInstance().showUrl(targetPageUrl);
		}
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return InternalBrowsingAction;
		}

	}
}