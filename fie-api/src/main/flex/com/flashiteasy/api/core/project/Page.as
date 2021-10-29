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
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Storyboard;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.LoaderUtil;
	import com.flashiteasy.api.utils.XMLParser;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * The <code><strong>Page</strong></code> class represents a single page of a project.
	 * It can be single or parent or child of another page
	 */


	public class Page extends PageList
	{
		/**
		 *
		 * ===================================
		 * 			PRIVATE VARS
		 * ===================================
		 *
		 */
		private var _container:String;
		private var _link:String;
		private var control:IUIElementDescriptor;
		protected var pageItems:PageItems;
		protected var parent:PageList;
		protected var xmlStream:XML;
		protected var storyboard:Storyboard;
		private var _referenceTime:int=0;
		private var _delayBeforeDestroy:int;

		/**
		 *
		 * ===================================
		 * 			PUBLIC VARS
		 * ===================================
		 *
		 */

		public var isDisplayed:Boolean=false;

		/**
		 * Constructor, adds an FieEvent.PAGE_INIT listener and declares page's parent
		 * @param parent:PageList
		 */
		public function Page(parent:PageList=null):void
		{
			this.parent=parent;
			addEventListener(FieEvent.PAGE_INIT, loadRemoteParameter);
		}

		/**
		 * This method returns a copy (clone) of the page
		 * @return cloned Page
		 */
		public function clone():Page
		{
			var clonedPage:Page=new Page(null);
			clonedPage.link=link;
			clonedPage.container=container;
			for each (var subPage:Page in this.getPages())
			{
				var clonedSubPage:Page=subPage.clone();
				clonedSubPage.setParent(PageList(clonedPage));
				clonedPage.addPage(clonedSubPage);
			}
			return clonedPage;
		}

		private var subPage:Page;

		/**
		 * Prepares the page to be displayed, specifically if a sub-page must be loaded
		 * @param forceLoading
		 * @param subPageToShow
		 */
		public function prepare(showAnimations:Boolean=true):void
		{
			if (xmlLoaded)
			{
				doShow(showAnimations);
			}
			else
			{
				LoaderUtil.getLoader(this, resourceLoaded).load(new URLRequest(AbstractBootstrap.getInstance().getBaseUrl() + "/xml/" + getPageUrl() + ".xml?timestamp=" + (new Date()).getTime()));
			}
		}

		/**
		 * Returns the link of the pages (cf SWFAddress impl)
		 * @return url String
		 */
		public function getPageUrl():String
		{
			if (parentIsPage)
			{
				return Page(parent).getPageUrl() + "/" + link;
			}
			return link;
		}

		/**
		 * Executed when a resource has been correctly loaded.
		 * @param e
		 */
		protected function resourceLoaded(e:Event):void
		{
			xmlStream=new XML(e.target.data);
			doShow();
		}
		
		public function removeActions():void
		{
			var actions:Array=ActionList.getInstance().getActions(this);
			for each (var action:IAction in actions)
			{
				//if (!isInApp)
				//{
				action.removeEvents();
				//}
				action.destroy();
			}
		}

		/**
		 * Hides the page before unloading everything in it
		 */
		public function hide():void
		{

			isDisplayed=false;
			// We must remove event before removing components
			var isInApp:Boolean=LoaderUtil.isInApplication();
			removeActions();
			/*var actions:Array=ActionList.getInstance().getActions(this);
			for each (var action:IAction in actions)
			{
				//if (!isInApp)
				//{
				action.removeEvents();
				//}
				action.destroy();
			}*/
			// then, after stopping the player...

			//var pl:IStoryboardPlayer = AbstractBootstrap.getInstance().getTimerStoryboardPlayer();

			//pl.stop(storyboard);
			// ... we have to remove all animations
			//var stories : Array = this.getStoryboard().getStories();
			var stories:Array=StoryList.getInstance().getStories(this);
			for each (var s:Story in stories)
			{

				s.stop();
				s.destroy(false);
			}
			// then we finish by destroying all faces left

			var elements:Array=ElementList.getInstance().getTopLevelElements(this);
			//var elements:Array=pageItems.pageControls;

			for each (var el:IUIElementDescriptor in elements)
			{
				el.destroy();
			}
			//

		}

		/**
		 *
		 */

		protected var startStories:Boolean;

		public function doShow(startStories:Boolean=true):void
		{
			this.startStories=startStories;
			trace("Showing " + this.getPageUrl() + " url : " + this.link);
			BrowsingManager.getInstance().setCurrentPage(this);
			parsePage();
			parseStoryboard();
			initLoad();
		}

		/**
		 *
		 * @return
		 */
		public function getPageItems():PageItems
		{
			return pageItems;
		}

		/**
		 *
		 */
		protected function parseStoryboard():void
		{
			storyboard=XMLParser.parseStoryboard(this, xmlStream, pageItems);
		}

		/**
		 *
		 */
		protected function parsePage():void
		{
			if (container == "stage" || container == "")
			{
				pageItems=XMLParser.parseXML(this, xmlStream);
			}
			else
			{
				pageItems=XMLParser.parseXML(this, xmlStream, ElementList.getInstance().getElement(container, parent) as IUIElementContainer);
			}
			dispatchEvent(new FieEvent(FieEvent.PAGE_PARSED));
		}

		/**
		 *
		 */
		protected function initLoad():void
		{
			//trace ("invoke initLoad with "+ pageItems.pageControls.length );
			if (pageItems.pageControls.length > 0)
			{
				for each (control in pageItems.pageControls)
				{
					control.addEventListener(FieEvent.COMPLETE, countLoadedControls);
				//	trace ("adding eventListener COMPLETE  to "+control.uuid);
					control.getFace().addEventListener(FieEvent.RENDER, controlRendered);
				//	trace ("adding eventListener RENDER  to "+control.uuid)
				}
				for each (control in pageItems.pageControls)
				{
					control.applyParameters();;
				}
				dispatchEvent(new FieEvent(FieEvent.PAGE_INIT));
			}
			else
			{
				trace ("page is loaded :: "+this.link);
				isDisplayed=true;
				dispatchEvent(new FieEvent(FieEvent.PAGE_INIT));
				dispatchEvent(new FieEvent(FieEvent.PAGE_LOADED));
				startStories=true;
					//BrowsingManager.getInstance().setCurrentPage(this);
			}
		}
		
		//private function

		private var controlsLoaded:int=0;

		/**
		 *
		 * @param e
		 */
		private function countLoadedControls(e:Event):void
		{
			controlsLoaded++;
			//trace ("number of controls counted ::" +controlsLoaded + " / "+pageItems.pageControls.length+" in :: "+link);
			e.target.removeEventListener(FieEvent.COMPLETE, countLoadedControls);

			if (controlsLoaded == pageItems.pageControls.length)
			{
				// if all controls of a page are ready , display them
				//trace("page " + link + " has finished loading");
				isDisplayed=true;
				controlsLoaded=0;
				var stageElements:Array=ElementList.getInstance().getElementOnStage(this);
				var parent:DisplayObjectContainer;

				if (hasContainer())
				{
					trace("Parent :: "+getParent());
					parent=ElementList.getInstance().getElement(container, getParent()).getFace();
				}
				else
				{
					parent=AbstractBootstrap.getInstance();
				}

				// Arrange on stage controls so they are displayed in the good order 
				
				for each (var el:IUIElementDescriptor in pageItems.pageControls)
				{
					trace ("control "+el.uuid+" is loaded!");
					parent.addChild(el.getFace());
					el.getFace().visible=true;
					el.getFace().dispatchEvent(new FieEvent(FieEvent.RENDER));
				}

				dispatchEvent(new FieEvent(FieEvent.PAGE_LOADED));

			}
		}

		protected var controlRenderedCount:int=0;

		protected function controlRendered(e:Event):void
		{
			e.target.removeEventListener(Event.RENDER, this.controlRendered);
			controlRenderedCount++;
			//trace("rendered controls " + controlRenderedCount + " / " + pageItems.pageControls.length +" in :: "+link);
			if (controlRenderedCount == pageItems.pageControls.length)
			{
				//trace("control rendered");
				controlRenderedCount=0;
				if (startStories)
				{
					startPageStories();
					for each (var action:IAction in ActionList.getInstance().getActions(this))
					{
						action.applyEvents();
					}
				}
				startStories=true;
				
					
			}

		}

		protected function startPageStories():void
		{
			// Run timed based stories (trigger-based stories are loaded separately)
			if (AbstractBootstrap.getInstance().getTimerStoryboardPlayer() != null)
			{
				//trace("start stories from page");
				AbstractBootstrap.getInstance().getTimerStoryboardPlayer().start(storyboard);
			}

		}

		public function startPageStoriesOnUnload():void
		{
			// Run timed based stories (trigger-based stories are loaded separately)
			if (AbstractBootstrap.getInstance().getTimerStoryboardPlayer() != null)
			{
				//trace("start unload stories from page");
				AbstractBootstrap.getInstance().getTimerStoryboardPlayer().startOnUnload(storyboard);
			}

		}
		
		/**
		 *
		 */
		public function reload():void
		{
			hide();
			doShow();
		}

		/**
		 *
		 * @return
		 */
		public function get hasChild():Boolean
		{
			return getPages().length > 0;
		}

		/**
		 *
		 * @return
		 */
		public function get parentIsPage():Boolean
		{
			return parent is Page;
		}

		/**
		 *
		 * @return
		 */
		public function get xmlLoaded():Boolean
		{
			return xmlStream != null;
		}

		/**
		 *
		 * @param event
		 */
		public function loadRemoteParameter(event:FieEvent):void
		{
			AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack(this);
		}

		/**
		 *
		 * @return boolean : do the page own a container ?
		 */
		public function hasContainer():Boolean
		{
			return !(container == "stage" || container == "" || container == null);
		}

		/**
		 *
		 * @return
		 */
		public function getStoryArray():Array
		{
			if(storyboard == null) return [];
			return storyboard.getStories();
		}

		/**
		 *
		 * ===================================
		 * 			GETTERS & SETTERS
		 * ===================================
		 *
		 */


		/**
		 *
		 * @return
		 */
		public function getParent():PageList
		{
			return parent;
		}

		/**
		 *
		 * @param parent
		 */
		public function setParent(parent:PageList):void
		{
			this.parent=parent;
		}

		/**
		 *
		 * @return
		 */
		public function get container():String
		{
			return _container;
		}

		/**
		 *
		 * @param value
		 */
		public function set container(value:String):void
		{
			_container=value;
		}

		/**
		 *
		 * @return
		 */
		public function get link():String
		{
			return _link;
		}

		/**
		 *
		 * @param value
		 */
		public function set link(value:String):void
		{
			_link=value;
		}

		/**
		 *
		 * @return
		 */
		public function get referenceTime():int
		{
			return _referenceTime;
		}

		/**
		 *
		 * @param value
		 */
		public function set referenceTime(value:int):void
		{
			_referenceTime=value;
		}

		/**
		 *
		 * @return
		 */
		public function get delayBeforeDestroy():int
		{
			// Run timed based stories (trigger-based stories are loaded separately)
			if (AbstractBootstrap.getInstance().getTimerStoryboardPlayer() != null)
			{
				_delayBeforeDestroy = AbstractBootstrap.getInstance().getTimerStoryboardPlayer().getDelayBeforeDestroy();
			}
			return _delayBeforeDestroy;
		}

		/**
		 *
		 * @param value
		 */
		public function set delayBeforeDestroy(value:int):void
		{
			_delayBeforeDestroy=value;
		}

		/**
		 *
		 * @return
		 */
		public function get xml():XML
		{
			return xmlStream;
		}

		/**
		 *
		 * @param value
		 */
		public function set xml(value:XML):void
		{
			xmlStream=value;
		}

		/**
		 *
		 * @return
		 */
		public function getStoryboard():Storyboard
		{
			return storyboard;
		}
	}
}

