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
	import com.asual.swfaddress.SWFAddress;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.core.project.Project;
	import com.flashiteasy.api.core.project.XMLFile;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.events.FieStageResizeEvent;
	import com.flashiteasy.api.indexation.IndexationManager;
	import com.flashiteasy.api.managers.SWFSize;
	import com.flashiteasy.api.managers.StageResizeManager;
	import com.flashiteasy.api.utils.LoaderUtil;
	import com.flashiteasy.api.utils.PageUtils;
	import com.flashiteasy.api.utils.ProjectData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.Timer;

	/**
	 * The <code><strong>BrowsingManager</strong></code> is the pseudo-singleton class that takes care
	 * of all internal browsing functionalities : page change, load page and so on.
	 * As a singleton, it must not be directly instanciated but must be called
	 * by a <code><strong>BrowsingManager.getInstance()</strong></code> command.
	 */

	public class BrowsingManager extends EventDispatcher
	{

		private static var instance:BrowsingManager;

		/**
		 *This variable enforces singleton pattern
		 * @default false;
		 */
		protected static var allowInstantiation:Boolean=false;

		private var _project:Project;
		private var _currentPage:Page;

		/**
		 * Constructor
		 */
		public function BrowsingManager()
		{
			if (!allowInstantiation)
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		/**
		 * Resets the Browsingmanager when, for instance, a new project is loaded
		 */
		public function reset(): void
		{
			hideAll();
			_project = null;
			_currentPage = null;
			instance = null;
			pagesToShow = [];
			ProjectData.getInstance().reset();
			IndexationManager.getInstance().reset();
		}
		/**
		 * Singleton implementation
		 * @return the BrowsingManager instance (singleton)
		 */
		public static function getInstance():BrowsingManager
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new BrowsingManager();
				allowInstantiation=false;
			}
			return instance;
		}

		/**
		 *	Binds the current project to the BrowsingManager instance
		 * @param value sets the project (site)
		 */
		public function setProject(value:Project):void
		{
			_project=value;
			ProjectData.getInstance().setProject(value);
		}

		/**
		 *	Gets the project
		 * @return  the current project
		 */
		public function getProject():Project
		{
			return ProjectData.getInstance().getProject();
		}

		/**
		 * displays the first page of the project
		 */
		public function showFirstPage():void
		{
			var pageToShow:Page = IndexationManager.getInstance().homePage != null ? IndexationManager.getInstance().homePage : _project.getPages()[0] as Page ;
			showPage(pageToShow);
		}

		/**
		 * displays next page in the project tree structure
		 */
		public function nextPage():void
		{
			showPage(findNextPage());
		}

		/**
		 *
		 * This method, as the precedent one, displays next page in the project tree structure,
		 * using a reference page as argument.
		 * @param refPage
		 * @return
		 */
		private function findNextPage(refPage:Page=null):Page
		{
			if (refPage == null)
			{
				refPage=_currentPage;
			}
			var refPageIndex:int=findPageIndex(refPage);
			if (refPageIndex > -1 && refPageIndex < refPage.getParent().getPages().length - 1)
			{
				return Page(refPage.getParent().getPages()[refPageIndex + 1]);
			}
			// TODO Handle other cases
			return null;
		}

		/**
		 *
		 * @param page
		 * @return
		 */
		private function findPageIndex(page:Page):int
		{
			for (var i:int=0; i < page.getParent().getPages().length; i++)
			{
				if (page.getParent().getPages()[i] == page)
				{
					return i;
				}
			}
			return -1;
		}

		/**
		 * Sets current page
		 * @param page
		 */
		public function setCurrentPage(page:Page):void
		{
			if (page != _currentPage)
				_currentPage=page;
		}

		/**
		 *
		 * @return
		 */
		public function getCurrentPage():Page
		{
			return _currentPage;
		}


		private function callGarbageCollector():void
		{
			System.gc();
			System.gc();
			try
			{
				new LocalConnection().connect('gc');
				new LocalConnection().connect('gc');
			}
			catch (e:*)
			{
			}
		}

		/**
		 * Displays the page passed as arguments, with or without displaying animations
		 * @param page
		 * @param showAnimations a Boolean value that states if the animations must be displayed or not.
		 */

		public function showPage(page:Page, showAnimations:Boolean=true):void
		{
			trace("showPage invoked for "+page.link+" page");
			editType="page";
			if (page == null)
			{
				throw new Error("The page to show should not be null.");
			}

			//dispatchEvent(new Event(FieEvent.PAGE_UNLOAD));
			// Pages To hide 
			if (_currentPage != null)
			{

				var pagesToDestroy:Array=PageUtils.pagesToDestroy(_currentPage, page);

				prepareHiding(pagesToDestroy);
					//
			}

			pagesToShow=PageUtils.getParentNotDisplayed(page);
			if (pagesToShow.length == 0)
			{
				// fix a bug with parent page not beeing set as the current page ( because their doshow method is not beeing called )
				setCurrentPage(page);
				callGarbageCollector();
				dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
			}
			else
			{
				page.addEventListener(FieEvent.PAGE_LOADED, pageLoaded, false, 0, true);
				showPages(showAnimations);
			}

		}

		private function pageLoaded(e:Event):void
		{
			var p:Page=Page(e.target);
			p.removeEventListener(FieEvent.PAGE_LOADED, pageLoaded);
			if(p.getPageUrl().indexOf("/") == -1 && !LoaderUtil.isInApplication())
			{
				//var browserW:Number = SWFSize.getBrowserWidth();
				//var browserH:Number = SWFSize.getBrowserHeight();
				//AbstractBootstrap.getInstance().getStage().stageHeight = browserH;
				//AbstractBootstrap.getInstance().getStage().stageWidth = browserW;
				SWFSize.resizeSWFH("100%");
				SWFSize.resizeSWFW("100%");
				StageResizeManager.getInstance(AbstractBootstrap.getInstance().getStage(),60).dispatchEvent(new FieStageResizeEvent(FieStageResizeEvent.STAGE_RESIZE_PROGRESS));

			}
			dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
		}

		private var pagesToShow:Array;

		/**
		 *
		 */
		private function showPages(showAnimations:Boolean=true):void
		{
			//AbstractBootstrap.getInstance().getStage().focus = null;
			if (pagesToShow.length > 0)
			{
				var p:Page=pagesToShow.shift();
				trace("must show " + p.getPageUrl()+" ("+p.link+")");
				p.addEventListener(FieEvent.PAGE_LOADED, showNextPage);
				p.prepare(showAnimations);
			}
		}


		/**
		 *
		 * @param e
		 */
		private function showNextPage(e:Event):void
		{
			e.target.removeEventListener(FieEvent.PAGE_LOADED, showNextPage);
			showPages();
		}

		/**
		 * returns a page, using its name
		 * @param page
		 * @param name
		 * @return
		 */
		public function getPageByName(page:PageList, name:String):Page
		{
			for (var i:int=0; i < page.getPages().length; i++)
			{
				if ((page.getPages()[i] as Page).link == name)
				{
					return page.getPages()[i];
				}
			}

			var findPage:Page;
			for each (var p:Page in page.getPages())
			{
				findPage=getPageByName(p, name);
				if (findPage != null)
				{
					return findPage;
				}
			}
			return null
		}

		/**
		 * returns a page, using its url
		 * @param page
		 * @param url
		 * @return
		 */
		public function getPageByUrl(page:PageList, url:String):Page
		{
			for (var i:int=0; i < page.getPages().length; i++)
			{
				if ((page.getPages()[i] as Page).getPageUrl() == url)
				{
					return page.getPages()[i];
				}
			}

			var findPage:Page;
			for each (var p:Page in page.getPages())
			{
				findPage=getPageByUrl(p, url);
				if (findPage != null)
				{
					return findPage;
				}
			}
			return null
		}

		/**
		 *
		 * @param name
		 */
		public function showPageByName(name:String):void
		{
			showPage(getPageByName(_project, name));
		}

		/**
		 * Displays a page using its url
		 * @param url
		 */
		public function showUrl(url:String):void
		{
			showPage(getPageByUrl(_project, url));
			SWFAddress.setValue("/"+url);
		}

		private var _editType:String;

		/**
		 * Returns the current admin mode (viewing, editing, animating)
		 */
		public function get editType():String
		{
			return _editType;
		}

		/**
		 * @private
		 */
		public function set editType(value:String):void
		{
			_editType=value;
		}

		/**
		 * Displays a page, base on its xml source file
		 * @param xml the XMLFile instance to be loaded
		 */
		public function showXML(xml:XMLFile):void
		{
			if (xml.loadable)
			{
				dispatchEvent(new Event(FieEvent.PAGE_UNLOAD));
				hideAll();
				setCurrentPage(xml);
				xml.addEventListener(FieEvent.PAGE_LOADED, xmlLoaded);
				editType="xml";

				xml.prepare();
			}
			else
			{
				trace(" xml cannot be loaded ");
			}

		}

		private function xmlLoaded(e:Event):void
		{
			dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
			e.target.removeEventListener(FieEvent.PAGE_LOADED, xmlLoaded);
		}

		private var unloadTimer:Timer=null;
		private var unloadDuration:Number=0;

		/**
		 * 
		 */
		public function hideAll():void
		{

			//
			//
			var pages:Array=PageUtils.getAllDisplayedPage(_currentPage);
			for each (var page:Page in pages)
			{
				page.hide();
			}

			pendingPagesToDestroy=[];
		}

		private function destroyPages(pagesToDestroy:Array):void
		{
			while (pagesToDestroy.length > 0)
			{
				Page(pagesToDestroy.pop()).hide();
				
			}
			dispatchEvent(new Event(FieEvent.PAGE_REMOVED));
		}
		private var pendingPagesToDestroy:Array=[];

		private function prepareHiding(pagesToDestroy:Array):void
		{
			dispatchEvent(new Event(FieEvent.PAGE_UNLOAD));
			if (unloadTimer != null)
			{
				//destroyPages(pagesToDestroy);
				//unloadTimer.reset();
				unloadTimer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			}
			pendingPagesToDestroy=pagesToDestroy;
			var toPlay:Array=pagesToDestroy.slice();
			var timeBeforeDestroy:Number=0;
			for each (var p:Page in pagesToDestroy)
			{
				timeBeforeDestroy=Math.max(timeBeforeDestroy, p.delayBeforeDestroy);
				p.startPageStoriesOnUnload();
				p.removeActions();
			}
			unloadTimer=new Timer(timeBeforeDestroy, 1);
			unloadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUnloadTimerComplete);
			unloadTimer.start();
		}

		private function onUnloadTimerComplete(e:TimerEvent):void
		{
			destroyPages(pendingPagesToDestroy);
			pendingPagesToDestroy=[];
			unloadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onUnloadTimerComplete);
			unloadTimer.stop();
			unloadTimer=null;
		}
	}
}