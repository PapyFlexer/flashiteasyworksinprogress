package com.flashiteasy.admin.xml
{
	import com.flashiteasy.api.core.project.Artifact;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.indexation.IndexationManager;
	import com.flashiteasy.api.indexation.PageInformation;
	
	public class ProjectSerializer
	{

		//return XML for a page
		public static function serializePageForProject(page:Page):String
		{
			var pi : PageInformation = IndexationManager.getInstance().getPageInformation( page );
			
			if (page.getPages().length > 0)
			{
				var childPage:Page
				var pageNode:String="";
				pageNode='<page link="' + page.link + '"';
				if (page.container != null && page.container != "stage")
				{
					pageNode+=' container = "' + page.container + '"';
				}
				if (pi != null)
				{
					if (pi.title != "") pageNode+=' title = "' + pi.title + '"';
					if (pi.keywords != "") pageNode+=' keywords = "' + pi.keywords + '"';
					if (pi.description != "") pageNode+=' description = "' + pi.description + '"';
					if (pi.ishomepage == true) pageNode+=' ishomepage = "' + pi.ishomepage + '"';
				}
				pageNode+=' >';
				for each (childPage in page.getPages())
				{
					pageNode+=serializePageForProject(childPage);
				}
				pageNode+="</page>";
				return pageNode;
			}
			else
			{
				var simplePage:String='<page link="' + page.link + '"';
				if (page.container != null && page.container != "stage")
				{
					simplePage+=' container = "' + page.container + '"';
				}
				if (pi != null)
				{
					if (pi.title != "") simplePage+=' title = "' + pi.title + '"';
					if (pi.keywords != "") simplePage+=' keywords = "' + pi.keywords + '"';
					if (pi.description != "") simplePage+=' description = "' + pi.description + '"';
					if (pi.ishomepage == true) simplePage+=' ishomepage = "' + pi.ishomepage + '"';
				}
				simplePage+=' />';
				return simplePage;
			}
			return "";
		}
		
		public static function getPageXMLForProject(page:Page):String
		{
			
			var pi : PageInformation = IndexationManager.getInstance().getPageInformation( page );
			if (page.getPages().length > 0)
			{
				var childPage:Page
				var pageNode:String="";
				if(pi.ishomepage == true)
				{
					pageNode="<node label='" + page.link + "' ishomepage='true' >";
				}
				else
				{
					pageNode="<node label='" + page.link + "' >";
				}
				for each (childPage in page.getPages())
				{
					pageNode+=getPageXMLForProject(childPage);
				}
				pageNode+="</node>";
				return pageNode;
			}
			else
			{	
				var node:String="<node label='" + page.link + "' />";
				if(pi.ishomepage == true)
				{
					node="<node label='" + page.link + "' ishomepage='true' />";
				}
				return node;
			}
			return "";
		}

		public static function serializeDependenciesForProject( artifactArray : Array ) : XML
		{
/* 		<dependencies>
			<dependency>com.flashiteasy.sample:sample-lib:0.2-SNAPSHOT</dependency>
			<dependency>com.flashiteasy.snow:snow-lib:0.2-SNAPSHOT</dependency>
		</dependencies>
 */			var x : XML = new XML( "<dependencies></dependencies>" );
			for each ( var dep : Artifact in artifactArray )
			{
				var nodeXML : XML = new XML("<dependency>"+dep.getLongName()+"</dependency>")
				x.appendChild(nodeXML);
			}
			return x;
		}
		
	}
}