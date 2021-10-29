/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core.project
{
	import flash.events.EventDispatcher;
	
	/**
	 * The <code><strong>PageList</strong></code> class represents the objects that come into an FIE project.
	 * It extends the event dispatcher so listeners can be added at runtime.
	 */
	public class PageList extends EventDispatcher
	{
		private var pages : Array = [];
		
		/**
		 * Adds a page to PageList
		 * @param page the page to add to the list.
		 */
		public function addPage( page : Page ) : void
		{
			pages.push( page );
		}
		
		/**
		 * Removes a Page from pageList
		 * @param page the page to be removed
		 */
		public function removePage( page : Page ) : void
		{
			var urlToRemove:String  = page.getPageUrl();
			for (var i:int=0; i<pages.length; i++)
			{
				if(pages[i].getPageUrl()==urlToRemove){
					pages.splice(i, 1);
				}
			}
		}
		
		/**
		 * The array of pages that are included in the PageList 
		 * @return the array of pages contained in the PageList
		 */
		public function getPages() : Array
		{
			return pages;
		}
	}
}