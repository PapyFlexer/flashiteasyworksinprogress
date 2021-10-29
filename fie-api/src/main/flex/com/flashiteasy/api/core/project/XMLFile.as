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
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.XMLFileList;
	import com.flashiteasy.api.utils.NameUtils;
	import com.flashiteasy.api.utils.XMLParser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * The <code><strong>XMLFile</strong></code> class extends the page, so it is basically a page, with the addition 
	 * that it is linked with a distant XMLFile, instead of the usual project pages.
	 */
	public class XMLFile extends Page
	{
		/**
		 * 
		 * @default 
		 */
		public static var XML_LOADED : String = "xml_loaded";
		private var _name : String ;
		
		/**
		 * Constructor
		 * @param name
		 * @param addInList boolean that states if the current XMLContainer must be added to the element  list. Its default value is TRUE
		 */
		public function XMLFile ( name : String  , addInList : Boolean = true ) : void 
		{
			_name = name ;
			if( addInList )
			{	
				XMLFileList.getInstance().addXML(this);
			}
		}

		/**
		 * 
		 * @return the name of the xmlcontainer
		 */
		public function get name():String 
		{
			return _name;
		}
		
		private var displayContainer : IUIElementContainer;
		
		
		// Display the xml in a container
		
		/**
		 * Displays the xml file into a container.
		 * @param container the container to which the xml code is applied
		 */
		public function showInContainer( container : IUIElementContainer ) : void 
		{
			
			trace("loading xml file " + loadable + " " + name + " in container " + container.uuid );
			// Set the page properties so it gets displayed properly
			
			this.parent = container.getPage();//BrowsingManager.getInstance().getCurrentPage();
			this.container = container.uuid;
			displayContainer = container ;
			
			// Start parsing the page 
			
			parsePage();
			parseStoryboard();
			initLoad();
		}
		
		/**
		 *
		 */
		override protected function parseStoryboard():void
		{
			super.storyboard=XMLParser.parseStoryboard(this, xmlStream, pageItems);
		}
		
		override protected function startPageStories():void
		{
			// Run timed based stories (trigger-based stories are loaded separately)
			if (AbstractBootstrap.getInstance().getTimerStoryboardPlayer() != null)
			{
				trace("start stories from xml");
				AbstractBootstrap.getInstance().getTimerStoryboardPlayer().start(storyboard);
			}

		}
		override protected function controlRendered(e:Event):void
		{
			e.target.removeEventListener(FieEvent.RENDER, this.controlRendered);
			controlRenderedCount++;
			//trace ("number of controls rendered in XML ::" +controlRenderedCount + " / "+pageItems.pageControls.length);
			//trace("rendered controls " + controlRenderedCount + " " + pageItems.pageControls.length );
			if (controlRenderedCount == pageItems.pageControls.length)
			{
				//trace("control rendered");
				controlRenderedCount=0;
				//if (super.startStories)
				//{
					startPageStories();
					
					for each (var action:IAction in ActionList.getInstance().getActions(this))
					{
						action.applyEvents();
					}
				//}
				//super.startStories=true;
			}

		}
		
		// Reset xmlfile values so it can get displayed again
		
		private function reset():void
		{
			parent = null ;
			container = "" 
			displayContainer = null;
		}

		public override function prepare(showAnimations : Boolean = true ):void
		{
			if (xmlLoaded)
			{
				super.doShow(showAnimations);
			}
			else
			{
				loadXML();
			}
		}
		
		/**
		 * launches the XMLContainer loading process
		 */
		public function loadXML() : void 
		{
			if(!xmlLoaded)
			{
				var loader : URLLoader = new URLLoader;
				loader.addEventListener(Event.COMPLETE , resourceLoaded ) ;
				loader.addEventListener(IOErrorEvent.IO_ERROR , loadFailed ) ;
				loader.load(new URLRequest(AbstractBootstrap.getInstance().getBaseUrl()+"/xml_library/" + name + ".xml?timestamp=" + (new Date()).getTime()));
				//loader.load(new URLRequest("../../fie-app/config/fonts.txt"));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function parsePage():void
		{
			if ( displayContainer != null )
			{
				trace("in container ");
				pageItems= XMLParser.parseXML(this, xmlStream , displayContainer );
			}
			else
			{
				pageItems = XMLParser.parseXML( this , xmlStream);
			}
			displayContainer = null;
		}
		/**
		 * @inheritDoc
		 */
		protected override function resourceLoaded( e : Event ) : void 
		{
			xmlStream = new XML(e.target.data);
			dispatchEvent( new Event ( XML_LOADED));
		}
		
		private var error : Boolean = false;
		/**
		 * 
		 * @param e
		 */
		protected function loadFailed ( e : Event ) : void 
		{
			
			error = true ;
			trace( "couldn t load xml");
			dispatchEvent( new Event ( XML_LOADED));
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get loadable() : Boolean 
		{
			return !error;
		}
		
		/**
		 * 
		 * @param xml
		 */
		public function setXML( xml : XML ) : void 
		{
			xmlStream = xml ;
			error = false;
		}
		
		/**
		 * Copies the XMLsource file
		 * @return a copy of the xml source file
		 */
		public function copy():XMLFile
		{
			var newXML : XMLFile = new XMLFile( NameUtils.findUniqueName( this.name , XMLFileList.getInstance().getXMLNames() ) , false );
			newXML.setXML( xmlStream );
			return newXML;
		}
		
		public override function hide():void
		{
			super.hide();
			reset();
		}

	}
}