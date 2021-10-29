/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.xml
{
	import com.flashiteasy.api.core.project.Artifact;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.core.project.Project;
	import com.flashiteasy.api.indexation.IndexationManager;
	import com.flashiteasy.api.indexation.PageInformation;
	
	/**
	 * The <code><strong>ProjectParser</strong></code> class is
	 * a parsing utility class parsing dealing globally with the project files.
	 */
	public class ProjectParser
	{

		/**
		 * Reads and parses the project.xml file
		 * @param xmlStream
		 * @return 
		 */
		public static function parseProject( xmlStream : XML ) : Project
		{
			var p : Project = new Project();
			
			var dependencies : XMLList = xmlStream.dependencies.dependency;
			for each( var dep : XML in dependencies )
			{
				var artifactNameParts : Array = dep.text().split(":"); 
				p.addExternalLibrary( new Artifact( artifactNameParts[0], artifactNameParts[1], artifactNameParts[2] ) );
			}
			
			var params : XMLList = xmlStream.params.param;
			for each( var param : XML in params )
			{
				p.addParameter( param.@key , param.@value );	
			}
			
			var subPages : XMLList = xmlStream.pages.page;
			var idxMngr : IndexationManager = IndexationManager.getInstance();
			idxMngr.googlecode = xmlStream.@googlecode			
			for each( var subPage : XML in subPages )
			{
				parsePage( p, subPage, p, idxMngr );
			}
			
			return p;
		}
		
		/**
		 * Parses pages in project files.
		 * @param targetPageList
		 * @param xPage
		 * @param parent
		 */
		public static function parsePage( targetPageList : PageList, xPage : XML, parent : PageList, idxMgr : IndexationManager ) : void
		{
			var page : Page = new Page( parent );
			page.container = xPage.@container;
			if( page.container == null || page.container.length < 1)
			{
				page.container = "stage";
			}
			page.link = xPage.@link;
			targetPageList.addPage( page );
			
			var pageInfo : PageInformation = new PageInformation( page );
			pageInfo.title = xPage.@title;
			pageInfo.description = xPage.@description ;
			pageInfo.keywords = xPage.@keywords;
			if(xPage.@ishomepage == "true")
			{
				pageInfo.ishomepage = true;
				idxMgr.homePage = page;
			}
			idxMgr.addPageInformation( pageInfo );
			
			
			for each( var subPage : XML in xPage.page )
			{
				parsePage( page, subPage, page, idxMgr );
			}
		}
		

	}
}