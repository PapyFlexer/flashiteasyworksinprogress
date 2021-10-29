/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.selection
{
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;

	import flash.utils.Dictionary;

	/**
	 * The <code><strong>ActionList</strong></code> class is the
	 * pseudo-singleton class
	 * that manages and keeps track of all the actions
	 * of a given page.  
	 */
	public class ActionList
	{
		private static var instance:ActionList;
		/**
		 * singleton implementation 
		 */
		protected static var allowInstantiation:Boolean=false;

		/**
		 * Constructor singleton
		 */
		public function ActionList()
		{
			if (!allowInstantiation)
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}

		/**
		 * Singleton implementation
		 * @return a single ActionList instance
		 */
		public static function getInstance():ActionList
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new ActionList();
				allowInstantiation=false;
			}
			return instance;
		}

		/**
		 * A Dictionary holding actions instances
		 * @default null
		 */
		protected var actions:Dictionary=new Dictionary(true);

		/**
		 * Adds an action in the specified page
		 */
		public function addAction(action:IAction, page:Page):void
		{
			if (actions[page] == null)
			{
				actions[page]=new Array();
			}
			actions[page].push(action);
		}

		/**
		 * Lists all actions of a page
		 */
		public function getActions(page:PageList):Array
		{
			if (actions[page] == null)
			{
				actions[page]=new Array();
			}
			// Create a copy of the array
			return actions[page].slice(0);
		}

		/**
		 * Lists actions
		 * @return the number of actions loaded in page
		 */
		public function length():int
		{
			return actions.length;
		}

		/**
		 * Returns an action in a page using its name
		 */
		public function getAction(uuid:String, page:PageList):IAction
		{
			if (uuid == null || uuid == "")
			{
				return null;
			}
			var action:IAction;
			var pageElements:Array=actions[page];
			for each (action in pageElements)
			{
				if (action.uuid == uuid)
				{
					return action;
				}
			}
			return null;
		}

		/**
		 * Removes an action
		 */
		public function removeAction(el:IAction, page:Page):void
		{
			var i:int;
			var pageElements:Array=actions[page]
			for (i=0; i < pageElements.length; i++)
			{

				if (pageElements[i] == el)
				{
					pageElements.splice(i, 1);
					return;
				}
			}
			trace("Could not delete action with ID : " + el.uuid);
		}

/**
		 * Removes an action
		 */
		public function removeActionById(uuid:String, page:Page):void
		{
			var i:int;
			var pageElements:Array=actions[page]
			for (i=0; i < pageElements.length; i++)
			{

				if (pageElements[i].uuid == uuid)
				{
					pageElements.splice(i, 1);
					return;
				}
			}
			trace("Could not delete action with ID : " + uuid);
		}
		private function getElementNode(el:*, page:PageList):String
		{
			return "<node label='" + el.uuid + "' type='com.flashiteasy.api.action.ExternalBrowsingAction' />";
		}

		/**
		 * Utility class : returns an array of actions' uuid
		 * @param page
		 * @return 
		 */
		public function getActionsId(page:PageList):Array
		{
			var i:int;
			var elId:Array=new Array();
			var pageElements:Array=getActions(page);
			for (i=0; pageElements != null && i < pageElements.length; i++)
			{

				elId.push(pageElements[i].uuid);

			}
			return elId;
		}

		/**
		 * Unserializes actions. Used in copy/paste commands
		 * @param page
		 * @return 
		 */
		public function getXML(page:Page):XMLList
		{
			var elem:Array=actions[page]
			if (elem != null)
			{
				var pageNode:String="<root>";
				for (var i:int=0; i < elem.length; i++)
				{
					pageNode+=getElementNode(elem[i], page);
				}
				pageNode+="</root>";
				return new XML(pageNode).children();
			}
			else
			{
				return null;
			}
		}

	}
}