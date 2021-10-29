/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core
{
	import com.flashiteasy.api.core.project.Page;
	
	/**
	 * The <code><strong>PageLoader</strong></code> class instanciates in a singleton-like flavour the loader of a project's page.
	 * As a singleton, it must be called using <code><strong>PageLoader.getInstance()</strong></code>  syntax
	 */
	public class PageLoader
	{
		private static var instance : PageLoader;
		/**
		 * 
		 * @default 
		 */
		protected static var allowInstantiation : Boolean = false;
		
		/**
		 * 
		 */
		public function PageLoader()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		/**
		 * The unique instance of the Page loader
		 * @return 
		 */
		public static function getInstance() : PageLoader
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new PageLoader();
				allowInstantiation = false;
			}
			return instance;
		}
		
		/**
		 * Loads the pages
		 * @param pages
		 */
		public function loadPages( pages : Array ) : void 
		{
			var pagesToLoad : Array = ExtractPagesToLoad( pages );
			for each ( var page : String in pagesToLoad ) 
			{
				BrowsingManager.getInstance().showPageByName(page);	
			}
		}
		
		private function ExtractPagesToLoad ( pages : Array ) : Array 
		{
			var container : String;
			var indexStart : Number = 0;
			var i : int;
			for(i=0;i<pages.length;i++)
			{ 
    				container=BrowsingManager.getInstance().getPageByName(BrowsingManager.getInstance().getProject(),pages[i]).container;
    				if(container == "stage")
    					indexStart=i;
    		}
    		if(indexStart > 0 ) 
    		{
	    		var firstPage : Array = [];
	    		var firstPageString : String = "" ;
	    		for(i=0;i<indexStart;i++)
	    		{
	    			firstPageString += pages[i];
	    			if(i!=indexStart-1)
	    			{
	    				firstPageString += "/";
	    			}
	    		}
	    		firstPage.push(firstPageString);
	    		return firstPage.concat(pages.slice(indexStart));
    		}
    		else
    		{
    			return pages;
    		}
		}
		
		
	}
}