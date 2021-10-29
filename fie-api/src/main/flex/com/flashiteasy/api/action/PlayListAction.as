/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.utils.PreciseTimer;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	
	/**
	 * The <code><strong>InternalBrowsingAction</strong></code> class handles 
	 * internal link actions. It is used to call pages from the project
	 * 
	 * 
	 */
	 
	public class PlayListAction extends Action
	{
		/**
		 * 
		 * @default the Page to go to link attribute
		 */
		protected var xmlStream:XML;
		private var xmlLoaded:Boolean;
		private var xmlUrl: String;

		/**
		 * Constructor
		 */
		public function PlayListAction()
		{
			super();
		}

		override public function apply(event:Event):void
		{
			if (xmlLoaded)
			{
				
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
				loader.load(new URLRequest(AbstractBootstrap.getInstance().getBaseUrl()+"/xml/" + xmlUrl + ".xml?timestamp=" + (new Date()).getTime()));
				//loader.load(new URLRequest("../../fie-app/config/fonts.txt"));
			}
		}
		private var _timeList:Array = [];
		private var _urlList:Array = [];
		private var _xmlList:Array = [];
		private var _timer:Timer;
		/**
		 * @inheritDoc
		 */
		protected function resourceLoaded( e : Event ) : void 
		{
			xmlLoaded = true;
			xmlStream = new XML(e.target.data);
			parsePlayList();
		}
		
		private var index:uint = 0;
		private function parsePlayList():void
		{
			error = false;
			index = 0;
			if(_timer!= null)
			{
				_timer.stop();
				_timer.reset();
			}
			var firstNode:XMLList = xmlStream.playlist.media;
			for each(var node:XML in firstNode)
			{
				_timeList.push(XML(node.duree).text()[0].toString());
				_urlList.push(XML(node.template).text()[0].toString());
				_xmlList.push(XML(node.id_xml).text()[0].toString());
			}
			
			BrowsingManager.getInstance().showUrl(_urlList[index]);
			_timer = new Timer(Number(_timeList[index]));
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, navigate);
			_timer.start();
		}
		
		
		private function navigate(e:Event) : void
		{
			index++;
			if(index == _timeList.length)
			{
				index = 0;
			}
			BrowsingManager.getInstance().showUrl(_urlList[index]);
			
			if(_timer!= null)
			{
				_timer.delay = Number(_timeList[index]);
				_timer.stop();
				_timer.reset();
			}
			_timer.start();
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
		}
		
		/**
		 * 
		 * @param xml
		 */
		public function setXML( xml : String ) : void 
		{
			xmlUrl = xml ;
			
        	_timeList = [];
			_urlList = [];
			_xmlList = [];
		}
		
		override public function destroy():void
		{
			super.destroy();
			if(_timer != null)
	        {
	        	_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, navigate);
	        	_timer.stop();
	        	_timer = null;
        	}
        	_timeList = [];
			_urlList = [];
			_xmlList = [];
		}
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return PlayListAction;
		}

	}
}