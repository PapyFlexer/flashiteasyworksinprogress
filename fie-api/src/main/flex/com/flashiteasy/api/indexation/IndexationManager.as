/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.indexation
{
	import com.flashiteasy.api.core.project.Page;
	
	import flash.utils.Dictionary;
	
	/**
	 * The <code><strong>IndexationManager</strong></code> is a singleton-like implementation
	 * that manages the automatic indexation of the project pages.
	 * It takes care of recording the information of each page
	 * then sends it so it can be transformed into metas in the html page header 
	 */
	public class IndexationManager
	{
		
		/**
		 * A dictionary containing the pages information list.
		 * @default null
		 */
		public var pageInformationList : Dictionary = new Dictionary;
		
		private static var instance : IndexationManager;
		
		/**
		 * Singleton implementation
		 * @default 
		 */
		protected static var allowInstantiation : Boolean = false;
		
		/**
		 * Constructor
		 * As a singleton implementation, throws an error if a second instance is called
		 * Must be called using <code><strong>IndexationManager.getInstance()</strong></code> syntax. 
		 */
		public function IndexationManager()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		/**
		 * Singleton implementation.
		 * @return the IndexationManager instance
		 */
		public static function getInstance() : IndexationManager
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new IndexationManager();
				allowInstantiation = false;
			}
			return instance;
		}
		
		/**
		 * Resets the ProjectData object
		 */
		public function reset() : void
		{
			instance = null;
			homePage = null;
			pageInformationList = null;
			googlecode = "";
			siteinfo = null;
			
		}
		
		/**
		 * Adds page info to the list
		 * @param pi the instance of PageInformation object
		 * 
		 * @see com.flashiteasy.api.indexation.PageInformation
		 */
		public function addPageInformation( pi : PageInformation ) : void
		{
			pageInformationList[pi.page] = pi;
		}
	
	


		/**
		 * Gets the page info for the page passed in argument
		 * @param page The instance of the page we want the info on
		 * @return 
		 */
		public function getPageInformation( page : Page ) : PageInformation
		{
			if(pageInformationList[page] == null)
			{
				var pi : PageInformation = new PageInformation(page);
				addPageInformation( pi );
			}
			return PageInformation(pageInformationList[page]);
		}
	
		/*
		================================
		     GETTERS & SETTERS		
		================================
		*/

		private var _googlecode : String = "";
				
		
		/**
		 * Google analytics code
		 */
		public function get googlecode() : String
		{
			return _googlecode;
		}
		
		/**
		 * 
		 * @parivatee
		 */
		public function set googlecode( value : String) : void
		{
			_googlecode = value;
		}
		
		private var _homePage:Page;
		public function get homePage():Page
		{
			return _homePage;
		}
		
		public function set homePage(value:Page):void
		{
			_homePage = value;
		}
		
		private var _siteinfo : XML;
		
		/**
		 * the xml describing the global site info 
		 */
		public function get siteinfo() : XML
		{
			return _siteinfo;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set siteinfo (value : XML) : void
		{
			_siteinfo = value;
		}
	}
}