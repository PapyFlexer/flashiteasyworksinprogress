/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import com.flashiteasy.api.container.FormElementDescriptor;
	import com.flashiteasy.api.controls.TextInputElementDescriptor;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.selection.ElementList;
	
	/**
	 * The <code><strong>PageUtils</strong></code> class is
	 * an utility class dealing with project's pages
	 */
	public class PageUtils
	{
		/**
		 * Returns an Array of parent pages not showing on stage
		 * @param page
		 * @return 
		 */
		public static function getParentNotDisplayed(page:Page):Array
		{
			var pages : Array = [];
			var p:PageList = page;
			while(p is Page)
			{
				if( !Page(p).isDisplayed ) 
				{
					pages.unshift(p);
					p=Page(p).getParent();	
				}
				else
				{
					break;
				}
			}
			return pages;
		}
		
		/**
		 * Returns the level of the current page into the tree structure (Home = 1, Chapter = 2, Sub Chapter = 3, and so on...).
		 * @param page
		 * @return the level of the page in the tree structure
		 */
		public static function getPageLevel(page:Page):int
		{
			var p:Page = page ;
			var count:int=1;
			while (p.parentIsPage)
			{
				count++
				p=Page(p.getParent());
			}
			return count;
		}
		
		public static function getLinkToHome(level:int):String
		{
			var link : String = "./";
			var i : int ;
			for(i=1; i<level;i++)
			{
				link +="../";
			}
			return link;
		}
		
		/**
		 * Returns an Array of parent pages (displayed or not)
		 * @param page
		 * @return 
		 */
		public static function getParentList(page:Page):Array
		{
			var parents:Array = [] ;
			var p:Page = page ;
			while (p.parentIsPage)
			{
				parents.unshift(p.getParent());
				p=Page(p.getParent());
			}
			return parents;
		}
		
		public static function getFirstPage(page: Page ): Page
		{
			var parents : Array = getParentList(page);
			if(page.parentIsPage)
			{
				return Page(parents[0]);
			}
			else
			{
				return page;
			}
		}
		
		/**
		 * Returns an Array of all currently displayed pages
		 * @param page
		 * @return 
		 */
		public static function getAllDisplayedPage( page : Page ) :Array 
		{
			var pages : Array  = getParentList( page ) ;
			pages.unshift(page);
			return pages;
		}
		
		// Return the list of pages to destroy created from an old displayed page and a  new one 
		
		/**
		 * Return the list of pages to destroy, at the page-change event 
		 * @param oldPage
		 * @param newPage
		 * @return 
		 */
		public static function pagesToDestroy(oldPage:Page , newPage:Page ) : Array 
		{
			var oldPageParents : Array = getParentList(oldPage);
			oldPageParents.push(oldPage);
			var newPageParents : Array = getParentList(newPage);
			newPageParents.push(newPage);
			var destroy:Array = [];

			for each ( var page : Page in oldPageParents)
			{
				if(ArrayUtils.getIndex( newPageParents , page ) == -1 )
				{
					destroy.unshift(page);
				}
			}
			return destroy;
		}
		
		/**
		 * Returns an array of pages' URI
		 * @param page
		 * @return 
		 */
		public static function getPagesLink(page:PageList):Array
		{
			var pgs : Array = page.getPages();
			var Ar:Array=[];
			for (var i:int=0; i < pgs.length; i++)
			{
				Ar.push(pgs[i].link);
			}
			return Ar;
		}
		
		public static function getPageForms(page:Page):Array
		{
			var arr : Array = new Array;
			var blcks : Array = page.getPageItems().pageControls;
			var item : IUIElementDescriptor;
			var itemId : String; 
			var elements : Array = ElementList.getInstance().getContainerList(page);
			for each (itemId in elements)
			{
				item =  ElementList.getInstance().getElement(itemId, page);
				if (item is FormElementDescriptor)
				{
						
					arr.push(item);
				}			
			}
			return arr;
		}
		
		public static function getTextInputItems( page : Page ) : Array
		{
			var arr : Array = new Array;
			var items : Array = ElementList.getInstance().getElements( page );
			//var items : Array = page.getPageItems().pageControls;
			var item : IUIElementDescriptor;
			//var itemId : String;
			for each ( item in items )
			{
				if (item is TextInputElementDescriptor)
				{
					arr.push( item.uuid );
				}
			}
			return arr;
		}
	}
}