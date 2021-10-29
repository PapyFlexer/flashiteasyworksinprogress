package com.flashiteasy.admin.xml
{
	import com.flashiteasy.api.container.XmlElementDescriptor;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Transition;
	import com.flashiteasy.api.core.project.storyboard.Update;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.utils.getQualifiedClassName;
	
	import memorphic.xpath.XPathQuery;
	
	public class XMLUtils
	{
		
		public static function getNodeById(id : String , xml : XML ) : XML
		{
			var query:XPathQuery = new XPathQuery("//*[@id='"+id+"']")
			trace("get node by ID " + query.exec(xml)[0]);
			return query.exec(xml)[0];
		}
		
		
		public static function getNodeByPath(path : String , xml : XML ) : XML
		{
			var query:XPathQuery = new XPathQuery(path);
			trace("get node by path " + query.exec(xml)[0]);
			return query.exec(xml)[0];
		}
		
		public static function createControlXML(control : IUIElementDescriptor , mode : String = "normal" ) : XML
		{
			
				var nodeXml : XML;
				var attr : String ;
				if(mode == "html")
				{
					attr = 'type="'+getQualifiedClassName(control)+'" page="'+control.getPage().getPageUrl()+'" ';
				}
				else
				{
					attr = 'type="'+getQualifiedClassName(control)+'"';
				}
				
				// creation des noeuds XML du control
				if( control is XmlElementDescriptor)
				{
					nodeXml = new XML("<container "+attr+" id='"+IUIElementDescriptor(control).uuid+"' ></container>");
				}
				else if( control is IUIElementContainer ) 
				{
					nodeXml = new XML("<container "+attr+" id='"+IUIElementDescriptor(control).uuid+"' ></container>");
				}
				else
				{
					nodeXml = new XML("<control "+attr+" id='"+IUIElementDescriptor(control).uuid+"' ></control>");
				}
				
				return nodeXml;
		}
		
		public static function mergeXML( page : Page ): XML
		{
			var xml : XML ;
			var parents : Array = PageUtils.getParentList(page);
			parents.push(page);
			for each( var p : Page in parents ) 
			{
				trace("parse page " + p.getPageUrl());
				if(xml == null ) 
				{
					xml = XmlSerializer.serializePage(p,"html");
				}
				else
				{
					trace(" merge page " +p.getPageUrl() + " " + p.container );
					var node : XML = XmlSerializer.serializePage(p,"html");
					trace("true node" +  XmlSerializer.serializePage(p.getParent() as Page));
					trace("node" + xml);
					var node2 : XMLList = xml..*.(@id==p.container)[0].BlockListParameterSet;
					trace("node before " + xml..*.(@id==p.container)[0]);
					node2.* += node.*;
					trace("node after " + xml..*.(@id==p.container)[0]);
					xml..*.(@id==p.container)[0].BlockListParameterSet.* += new XML("<lol></lol>");
					
					trace("merged");
				}
			}
			trace(xml);
			return xml;
		}
		
		public static function duplicateNode( xml:XML , controlUuid : String , parentUuid : String , depth :int = -1 ) : void 
		{
			var query : XPathQuery = new XPathQuery("//*[@id='"+controlUuid+"']");
			var node : XML = query.exec(xml)[0].copy();
			var parentNode : XML = new XPathQuery("//*[@id='"+parentUuid+"']").exec(xml);
			if(depth == -1 ) 
			{
				parentNode.appendChild(node);
			}
			else
			{
				parentNode.insertChildBefore(parentNode.*[depth],node);			
			}
		}

		public static function getControlXML(control:IUIElementDescriptor):XML
		{
			var page:Page = control.getPage();
			var pageXML : XML = page.xml.copy();
			var node: XML ;
			if(control.hasParent())
			{
				node = pageXML..*.(hasOwnProperty("@id") && @id == control.uuid)[0];
			}
			else
			{
				node = pageXML.*.(hasOwnProperty("@id") && @id == control.uuid)[0];
			}
			return node;
		}
		
		/**
		 * Creates an XML tag for an action
		 */
		public static function createActionXML ( action : IAction , mode : String = "normal" ) : XML
		{
			var nodeXml : XML;
			if(mode =="normal")
			{
				nodeXml = new XML("<action type='"+getQualifiedClassName(action)+"' id='"+IAction(action).uuid+"' ></action>");
			}
			else
			{
				nodeXml = new XML("<action page='"+action.getPage().getPageUrl()+"' type='"+getQualifiedClassName(action)+"' id='"+IAction(action).uuid+"' ></action>");
			}
			
			return nodeXml;
		} 

		
		/**
		 * Creates an XML tag for a story
		 */
		public static function createStoryXML ( s : Story ) : XML
		{
			var nodeXml : XML;
			nodeXml = new XML("<story uuid='"+s.uuid+"' autoPlay='"+s.autoPlay+"' autoPlayOnUnload='"+s.autoPlayOnUnload+"' target='"+s.target+"' loop='"+s.loop+"' ></story>");
			for each(var u:Update in s.getUpdates())
			{
				nodeXml.* += createUpdateXML(u);
			}
			return nodeXml;
		}
		
		public static function createUpdateXML( u:Update) : XML 
		{
			var nodeXML : XML ;
			nodeXML = new XML("<update target='"+u.getParameterSetName()+"' targetProperty='"+u.getPropertyName()+"'></update>");
			for each(var transition : Transition in u.getTransitions())
			{
				if(transition == u.getTransitions()[0])
				{
					nodeXML.* += createFirstKeyFrameXML(transition);
				}
				nodeXML.* += createTransitionXML(transition);
			}
			return nodeXML;
		}
		/**
		 *  Return the XML of the first keyframe
		 * 	The first transition has a different XML because it defines 2 keyframes 
		 * */
		public static function createFirstKeyFrameXML( t:Transition ) : XML
		{
			var nodeXML : XML ;
			nodeXML = new XML("<keyframe time='"+t.begin+"'></keyframe>");
			nodeXML.* += new XML("<easing type='"+getQualifiedClassName(t.easingClass).split("::")[1]+"' easingType='"+t.easingType+"' />");
			nodeXML.* += new XML("<value>"+t.beginValue+"</value>");
			return nodeXML;
		}
		
		/**
		 * return the XML of a transition which is not the first one 
		 * only define its second keyframe since it use the last keyframe of the previous transition 
		 * */
		public static function createTransitionXML( t:Transition ) : XML 
		{
			var nodeXML : XML ;
			nodeXML = new XML("<keyframe time='"+t.end+"'></keyframe>");
			nodeXML.* += new XML("<easing type='"+getQualifiedClassName(t.easingClass).split("::")[1]+"' easingType='"+t.easingType+"' />");
			nodeXML.* += new XML("<value>"+t.endValue+"</value>");
			return nodeXML;
		} 

	}
}