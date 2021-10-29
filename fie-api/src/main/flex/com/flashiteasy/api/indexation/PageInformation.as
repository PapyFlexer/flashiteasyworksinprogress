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
	
	/**
	 * The <code><strong>PageInformation</strong></code> object keeps records of the metas
	 * that will be added to each page of the html site created to index the fie project.
	 * The meta used are :
	 * <ul>
	 * <li><code><strong>title</strong></code>  : this is the title of the page. Displayed in gross blue text in Google search results pages </li>
	 * <li><code><strong>description</strong></code>  : the meta that comes under the title in Google search results pages </li>
	 * <li><code><strong>keywords</strong></code>  : the reactive keywords</li>
	 * </ul> 
	 */
	public class PageInformation
	{
		
		private var _title : String ; 
		private var _description : String ; 
		private var _keywords : String;
		private var _page : Page ; 
		private var _ishomepage : Boolean;
		
		/**
		 * Constructor
		 * @param page
		 */
		public function PageInformation( page : Page )
		{
			_page = page ;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get page():Page
		{
			return _page;
		}
		
		/*
		================================
		     GETTERS & SETTERS		
		================================
		*/
		/**
		 * The page title
		 */
		public function get ishomepage() : Boolean
		{
			return _ishomepage;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set ishomepage( value : Boolean) : void
		{
			_ishomepage = value;
		}

		/**
		 * The page title
		 */
		public function get title() : String
		{
			return _title;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set title( value : String) : void
		{
			_title = value;
		}
		
		/**
		 * The page description
		 */
		public function get description() : String
		{
			return _description;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set description( value : String) : void
		{
			_description = value;
		}
		
		/**
		 * The keywords
		 */
		public function get keywords() : String
		{
			return _keywords;
		}
		
		/**
		 * 
		 * @rprivate 
		 */
		public function set keywords(value : String) : void
		{
			_keywords = value;
		}
		
		
		/**
		 *  utility for serializing pageInfo
		 * @return : an xml of the page information
		 */
		
		public function serializePageMetaData( pi : PageInformation) : String
		{
			var str : String="";
				try 
				{
					str += "\t<pageinfo>\n";
					str += "\t\t<title>"+pi.title+"</title>\n";
					str += "\t\t<description>"+pi.description+"</description>\n";
					str += "\t\t<keywords>"+pi.keywords+"</keywords>\n";
					str += "\t</pageinfo>\n";

				}	
				catch (e : Error)
				{
					
				}
				return str;		
		}
			
		
		/**
		 * utility for debugging purposes
		 * @return 
		 */
		public function toFieString():String
		{
			return "PageInfo ["+page.link+"], title : "+title;
		}
	}
}