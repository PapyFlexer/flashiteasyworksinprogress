/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.bootstrap
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.flashiteasy.api.assets.TextManager;
	import com.flashiteasy.api.assets.XMLContainerLoader;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.motion.IStoryboardPlayer;
	import com.flashiteasy.api.core.project.Project;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.events.FieStageResizeEvent;
	import com.flashiteasy.api.fieservice.AbstractBusinessDelegate;
	import com.flashiteasy.api.ioc.ILibraryManagerListener;
	import com.flashiteasy.api.ioc.LibraryManager;
	import com.flashiteasy.api.library.BuiltInLibrary;
	import com.flashiteasy.api.managers.StageResizeManager;
	import com.flashiteasy.api.motion.TimerStoryboardPlayerImpl;
	import com.flashiteasy.api.utils.FontLoader;
	import com.flashiteasy.api.utils.LoaderUtil;
	import com.flashiteasy.api.utils.StringUtils;
	import com.flashiteasy.api.xml.ProjectParser;
	import com.millermedeiros.swffit.SWFFit;
	import com.millermedeiros.swffit.SWFFitEvent;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	/**
	 * The <code><strong>AbstractBootstrap</strong></code> class is the basic low-level container class for all FIE applications (client sites or projects) instances.
	 * It extends Sprite so visual controls are AddToStage-able.
	 * It reads some configuration files so its link to the amf services is established.
	 * It also checks for users permissions and domain validity.
	 *
	 * It uses a singleton-like pattern, so must only be called by AbstractBootstrap.getInstance()
	 */
	public class AbstractBootstrap extends Sprite implements ILibraryManagerListener
	{
		private static var PROJECT_NODE:String="project";

		/**
		 *
		 * @default
		 */
		public static var CLIENT_STAGE:Stage;

		/**
		 *
		 * @default
		 */
		public static var AMF_ENDPOINT:String="AMF_ENDPOINT";
		public static var ROOT_URI:String="";

		private var _project:Project;


		// security
		/**
		 * @private
		 * @default  : .*localhost.*|.*flashiteasy.com
		 */
		public var allowedDomains:String="";

		/**
		 * @private
		 * @default
		 */
		public var allowedPatterns:String="";

		/**
		 *
		 * @default
		 */
		private var _businessDelegate:AbstractBusinessDelegate;

		/**
		 *
		 * @default : The animation player implementation
		 */
		private var timerStoryboardPlayer:TimerStoryboardPlayerImpl;

		/**
		 *
		 * @default
		 */
		private var triggerStoryboardPlayer:IStoryboardPlayer;

		/**
		 *
		 * @default
		 */
		private static var instance:AbstractBootstrap;

		private var accessData:XML;

		private var baseUrl:String=".";

		private static var configFolder:String="config";

		private static var libFolder:String="external";

		private static var accessUrl:String=configFolder + "/access.xml";

		private var siteWrapper:FieUIComponent=new FieUIComponent();

		private var xmlStream:XML;

		private var _srm:StageResizeManager;
		
		// access inhibate for projectors
		private var _isWebsiteApp : Boolean = false;
		private var _isProjectorApp : Boolean = false;
		private var _isBannerApp : Boolean = false;


		// Fonts

		private var fontsConfig:Array=[];
		private var fontsLoaded:int=0;

		/**
		 *
		 * @return  returns the instance of the BootStrap (overridden by FieApp)
		 */
		public static function getInstance():AbstractBootstrap
		{
			return instance;
		}

		/**
		 *
		 * @param realstage
		 */
		public function setStage(realstage:Stage):void
		{
			CLIENT_STAGE=realstage;
			registerStage(realstage);
		}

		/**
		 *
		 * @param realstage
		 */
		public function getStage():Stage
		{
			return CLIENT_STAGE;
		}

		/**
		 * singleton implementation : only one fie site
		 */
		public function AbstractBootstrap()
		{

			if (instance != null)
			{
				throw new Error("Multiple instances of bootstrap not allowed.");
			}
			instance=this;

			//RegisteringStage
			if (parent is Stage)
			{
				CLIENT_STAGE=stage;
				stage.scaleMode=StageScaleMode.NO_SCALE;
				stage.align=StageAlign.TOP_LEFT;
				registerStage(stage);
			}
			if (isProjectorApp)
			{
				stage.scaleMode=StageScaleMode.SHOW_ALL;
				//stage.align=StageAlign.
			}
			if (isBannerApp)
			{
				//Uncomment this line to make banners type project with the hard coded url of your project
				this.setBaseUrl("");
			}
			// TODO Temporary utility : the menu will be loaded depending on user
			var cMenu:ContextMenu=new ContextMenu();
			cMenu.hideBuiltInItems();

			var aboutFIE:ContextMenuItem=new ContextMenuItem("A propos de FIE");
			aboutFIE.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:Event):void
				{ /* TODO : make a splash screen with Api and admin version numbers*/
				});
			cMenu.customItems=[aboutFIE];
			contextMenu=cMenu;
			
			trace("is in APp ? "+LoaderUtil.isInApplication())
			trace("is a Projector ? "+_isProjectorApp);
			// check domain validity
			if (!LoaderUtil.isInApplication() && !_isProjectorApp )
			{
				//loadAccessFile();
				setTimeout(loadAccessFile, 500);

			}
			else
			{


				// Waiting 500 ms so a potential wrapper may have the time to inject parameters, such as the base url.  
				trace("projo ok, no security");
				setTimeout(prepare, 500);


					//setBusinessDelegate( new businessDelegate() );  
			}

		}

		/**
		 *  Resets the BootStrap so different projects can be succesfully loaded
		 */
		public function reset():void
		{
			BrowsingManager.getInstance().reset();
			_project=null;
			_businessDelegate=null;
			timerStoryboardPlayer=null;
			XMLContainerLoader.getInstance().reset();
			LibraryManager.getInstance().reset();
			instance=null;
			delete this;
		}

		/**
		 *
		 * @return the service class (overridden in FieApp)
		 */
		protected function get businessDelegate():Class
		{
			// need to be overridden
			return null;
		}


		/**
		 * @ private
		 * loads the access file and states listeners for onComplete and onError
		 */
		private function loadAccessFile():void
		{
			var pathToAccessFile:String="config/access.xml";
			trace("loading access file..." + this.baseUrl);
			var ldr:URLLoader=new URLLoader();
			ldr.dataFormat=URLLoaderDataFormat.BINARY;
			ldr.addEventListener(Event.COMPLETE, onAccessLoaded);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, onAccessLoaded);
			ldr.load(new URLRequest(baseUrl + "/" + pathToAccessFile));
		}

		/**
		 *
		 * @param loadEvent dispatched when the access file has been completely loaded
		 * @private
		 */
		private function onAccessLoaded(e:Event):void
		{
			trace("access binary loaded" + e.type);
			if (e.type == Event.COMPLETE)
			{
				var data:*=URLLoader(e.target).data;
				if (data is ByteArray)
				{
					try
					{
						var i:uint=data.length;
						while (i--)
						{
							data[i]+=128
						}
						ByteArray(data).uncompress();
					}
					catch (e:Error)
					{
					}
				}
				accessData=XML(data);
				allowedDomains=accessData.domain.@url;
				allowedPatterns="^http(|s)://(?P<name>" + allowedDomains + ")/";
				//trace ("valid domain load "+accessData.domain.@url);
				if ( !_isProjectorApp )
				{
					checkDomainValidity();
				}
				else 
				{
					setTimeout(prepare, 500);	
				}
			}
		}

		/**
		 *
		 * @private
		 * checks the registration of the domain on which the client site is executed
		 * (typically, localhost domains and flashiteasy domains are valid contexts)
		 * if unregistered
		 *
		 */
		private function checkDomainValidity():void
		{
			trace ("recup access.xml="+accessData.toXMLString());
			var url:String;
			if (ExternalInterface.available)
			{
				url=ExternalInterface.call("window.location.href.toString");
			}
			else
			{
				url=loaderInfo.loaderURL;
			}
			trace("checking url = " + url);
			trace("against allowed domains = " + allowedDomains + "...");
			var domainCheck:RegExp=new RegExp(allowedPatterns, "i");
			var domainCheckResult:Object=domainCheck.exec(url);
			if (domainCheckResult == null)
			{
				// domain check failed, abort application
				trace("Aborting App... domainCheck result=" + domainCheckResult);
				abortApp();
			}
			else
			{
				// domain okay, proceed
				trace("loading App for " + domainCheckResult.name) // the domain name

				// Waiting 500 ms so a potential wrapper may have the time to inject parameters, such as the base url.  
				setTimeout(prepare, 500);
				trace("registering stage")

//setBusinessDelegate( new businessDelegate() );
			}
		}

		private function abortApp():void
		{
			//TODO : stop everything and display a skull that warns of piracy!!!
			var s:String="FIE applications are registered in order to function on a local server (localhost) or on a licensed domain.\n";
			s+="You're trying to execute an application that either is unregistered or has been registered to a different domain than the current one.\n";
			s+="Please contact Flash'Iteasy team at <a href='mailto:invaliddomain@flashiteasy.com'><i><u>invaliddomain@flashiteasy.com</u></i></a> stating the involved domains.";
			var fmt:TextFormat=new TextFormat;
			fmt.align=TextFormatAlign.CENTER;
			fmt.font="Arial";
			fmt.size=20;
			var tf:TextField=new TextField;
			tf.setTextFormat(fmt);
			tf.multiline=true;
			tf.width=800;
			tf.height=300;
			tf.x=200; //(this.stage.width - tf.width)/2;
			tf.y=50
			tf.htmlText=s;
			addChild(tf);
			this.setBusinessDelegate(null);
		}

		/**
		 *
		 * @param storyboardPlayer
		 */
		public function setTimerStoryboardPlayer(storyboardPlayer:TimerStoryboardPlayerImpl):void
		{
			this.timerStoryboardPlayer=storyboardPlayer;
		}

		/**
		 *
		 * @return
		 */
		public function getTimerStoryboardPlayer():TimerStoryboardPlayerImpl
		{
			return timerStoryboardPlayer;
		}

		/**
		 *
		 * @param storyboardPlayer
		 */
		public function setTriggerStoryboardPlayer(storyboardPlayer:IStoryboardPlayer):void
		{
			this.triggerStoryboardPlayer=storyboardPlayer;
		}

		/**
		 *
		 * @return
		 */
		public function getTriggerStoryboardPlayer():IStoryboardPlayer
		{
			return triggerStoryboardPlayer;
		}

		/**
		 * Prepare the external libraries and initialize the project.
		 */
		protected function prepare():void
		{
			LibraryManager.getInstance().addListener(this);
			loadTextAssets();
		}

		/**
		 *
		 */
		protected function loadTextAssets():void
		{
			var tm:TextManager=new TextManager();
			tm.addEventListener(TextManager.COMPLETE, assetsLoaded, false, 0, true);
			tm.loadTextAssets(baseUrl + "/config/fonts.txt", baseUrl + "/styles/styles.xml");
		}

		private function assetsLoaded(e:Event):void
		{
			e.target.removeEventListener(TextManager.COMPLETE, assetsLoaded);
			loadXMLContainers();
		}

		private function loadXMLContainers():void
		{
			var loader:XMLContainerLoader=XMLContainerLoader.getInstance();
			loader.addEventListener(XMLContainerLoader.XML_LIST_LOADED, xmlLoaded);
			loader.loadXMLNames(baseUrl + "/xml_library");
		}

		private function xmlLoaded(e:Event):void
		{
			e.target.removeEventListener(XMLContainerLoader.XML_LIST_LOADED, xmlLoaded);
			initProject();
		}


		/**
		 *
		 */
		protected function initLibraries():void
		{
			trace("Initializing built-in libraries...");
			for (var i:int=0; i < getLibraries().length; i++)
			{
				LibraryManager.getInstance().registerLibrary(getLibraries()[i]);
			}
			LibraryManager.getInstance().loadExternalLibraries(_project.getExternalLibraries() , baseUrl + "/external" );
		}


		/**
		 *
		 */
		protected function initProject():void
		{
			loadProject();
		}

		/**
		 *
		 */
		protected function loadProject():void
		{
			loadResource(baseUrl + "/xml/project.xml");
		}

		/**
		 *
		 * @param e
		 */
		protected function handleSWFAddressChange(e:Event):void
		{
			
			var address:String=SWFAddress.getValue();
			stage.focus = stage;

			//var pages:Array=[];
			var pages:String;
			pages=address.substr(address.indexOf('/') + 1, address.length); //.split("/");
			switch (SWFAddress.getValue())
			{

				// charge la page par defaut

				case "/":
					//SWFAddress.setTitle(IndexationManager.getInstance().getPageInformation(BrowsingManager.getInstance().getProject().getPages()[0] as Page).title);
					BrowsingManager.getInstance().showFirstPage();
					break;

				// Sinon charge la liste des pages

				default:
					//SWFAddress.setTitle(IndexationManager.getInstance().getPageInformation(BrowsingManager.getInstance().getPageByUrl(BrowsingManager.getInstance().getProject(), pages)).title);

					BrowsingManager.getInstance().showUrl(pages);
				//PageLoader.getInstance().loadPages(pages);
			}

		}

		/**
		 *
		 * @param url
		 */
		protected function loadResource(url:String):void
		{
			url+="?timestamp=" + (new Date()).getTime();
			LoaderUtil.getLoader(this, resourceLoaded).load(new URLRequest(url));
		}

		/**
		 *
		 * @param e
		 */
		protected function resourceLoaded(e:Event):void
		{
			xmlStream=new XML(e.target.data);
			if (xmlStream.name() == PROJECT_NODE)
			{
				doProject(xmlStream);
			}
		}

		/**
		 *
		 * @param xmlStream
		 */
		protected function doProject(xmlStream:XML):void
		{
			_project=ProjectParser.parseProject(xmlStream);
			BrowsingManager.getInstance().setProject(_project);
			initLibraries();
			setBusinessDelegate(new businessDelegate());
		}

		/**
		 *
		 */
		public function librariesLoaded():void
		{
			// Application is ready, launching display.
			BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_CHANGE, changePage);
			if (!SWFAddress.hasEventListener(SWFAddressEvent.EXTERNAL_CHANGE))
				SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, handleSWFAddressChange);
			else
				BrowsingManager.getInstance().showFirstPage();
		}

		private function changePage(e:Event):void
		{
			
			this.dispatchEvent(new FieEvent(FieEvent.PAGE_CHANGE));
			//BrowsingManager.getInstance().dispatchEvent(new FieEvent(FieEvent.PAGE_CHANGE));
		}

		/**
		 *
		 * @param url
		 */
		protected function loadFonts(url:String):void
		{
			LoaderUtil.getLoader(this, fontsConfigLoaded).load(new URLRequest(url));
		}

		/**
		 *
		 * @param e
		 */
		protected function fontsConfigLoaded(e:Event):void
		{
			fontsConfig=e.target.data.split(/\n/);
			var font:FontLoader;
			FontLoader.unloadFonts();
			for each (var s:String in fontsConfig)
			{
				font=new FontLoader(baseUrl + "/font");
				font.addEventListener(FontLoader.COMPLETE, onFontLoaded);
				font.addEventListener(FontLoader.ERROR, onFontLoaded);
				s=StringUtils.removeWhiteSpace(s);
				font.loadFont(s);
			}
		}

		private function onFontLoaded(event:Event):void
		{
			event.target.removeEventListener(FontLoader.COMPLETE, onFontLoaded);
			event.target.removeEventListener(FontLoader.ERROR, onFontLoaded);
			fontsLoaded++;

			if (fontsLoaded == fontsConfig.length)
			{
				initProject();
			}

		}

		/**
		 * An array of classes which implements the ILibrary interface.
		 */
		protected function getLibraries():Array
		{
			return [BuiltInLibrary];
		}

		/**
		 *
		 * @return
		 */
		public function getBaseUrl():String
		{
			return baseUrl;
		}

		/**
		 *
		 * @param baseUrl
		 */
		public function setBaseUrl(baseUrl:String):void
		{
			this.baseUrl=baseUrl;
		}

		/**
		 *
		 * @return
		 */
		public function getBusinessDelegate():AbstractBusinessDelegate
		{
			return _businessDelegate;
		}

		/**
		 *
		 * @param businessDelegate
		 */
		public function setBusinessDelegate(businessDelegate:AbstractBusinessDelegate):void
		{
			_businessDelegate=businessDelegate;
		}

		/**
		 *
		 * @return
		 */
		public function getProject():Project
		{
			return _project;
		}

		/**
		 *
		 * @return
		 */
		public function getXML():XML
		{
			return xmlStream;
		}

		
		public function get isProjectorApp() : Boolean
		{
			return _isProjectorApp;
		}

		public function set isProjectorApp( value : Boolean ) : void
		{
			_isProjectorApp = value;
		}



		
		public function get isBannerApp() : Boolean
		{
			return _isBannerApp;
		}

		public function set isBannerApp( value : Boolean ) : void
		{
			_isBannerApp = value;
		}



		
		public function get isWebsiteApp() : Boolean
		{
			return _isWebsiteApp;
		}

		public function set isWebsiteApp( value : Boolean ) : void
		{
			_isWebsiteApp = value;
		}


		/**
		 *
		 * Stage resize management
		 *
		 * */

		// SWFSize ref
		private function registerStage(stg:Stage):void
		{
			if (!LoaderUtil.isInApplication())
			{
				CLIENT_STAGE=this.stage;
				stage.focus = stage;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, true);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyDown, true);
				//initializing swfFit
				//SWFFit.configure({target:"FieAppDiv"});
				//SWFFit.startFit();

				/*SWFFit.addEventListener(SWFFitEvent.CHANGE, SWFFitChanged);
				SWFFit.fit("FieAppDiv", 800, 600, undefined, undefined, false, false);
				SWFFit.startFit();*/
					// create SWFSize ref & add some listeners
				/*SWFSize.SWF_ID = stg.loaderInfo.parameters.swfsizeId;
				   trace("SWFSize.SWF_ID :: "+SWFSize.SWF_ID);
				   swfSizer = SWFSize.getInstance();
				   swfSizer.addEventListener(SWFSizeEvent.INIT, onSWFSizeInit);
				   swfSizer.addEventListener(SWFSizeEvent.RESIZE, onSWFSizeResize);
				   _srm = StageResizeManager.getInstance( stg, 200 );

				   if (_srm.hasEventListener(FieStageResizeEvent.STAGE_RESIZE_START))
				   _srm.removeEventListener(FieStageResizeEvent.STAGE_RESIZE_START, onStageResizeStart);
				   if (_srm.hasEventListener(FieStageResizeEvent.STAGE_RESIZE_PROGRESS))
				   _srm.removeEventListener(FieStageResizeEvent.STAGE_RESIZE_PROGRESS, onStageResizeProgress);
				   if (_srm.hasEventListener(FieStageResizeEvent.STAGE_RESIZE_END))
				   _srm.removeEventListener(FieStageResizeEvent.STAGE_RESIZE_END, onStageResizeEnd);

				   // resize listeners
				   _srm.addEventListener( FieStageResizeEvent.STAGE_RESIZE_START, onStageResizeStart );
				   _srm.addEventListener( FieStageResizeEvent.STAGE_RESIZE_PROGRESS, onStageResizeProgress );
				 _srm.addEventListener( FieStageResizeEvent.STAGE_RESIZE_END, onStageResizeEnd );*/
			}
		}
public function keyDown(event:KeyboardEvent):void
		{
			trace("keyDOWN");
			trace("key :: " + event.keyCode);
		}
		private function SWFFitChanged(e:SWFFitEvent):void
		{
			// get the swffit properties values (those values are returned from the javascript and only work inside the html file)
			var t:String=SWFFit.target;
			var mw:int=SWFFit.minWid;
			var mh:int=SWFFit.minHei;
			var xw:int=SWFFit.maxWid;
			var xh:int=SWFFit.maxHei;
			var hc:Boolean=SWFFit.hCenter;
			var vc:Boolean=SWFFit.vCenter;
			var iw:int=SWFFit.innerW;
			var ih:int=SWFFit.innerH;
			//change the properties textfield text
			trace("SWFFit.target = " + t + "; SWFFit.minWid = " + mw + "; SWFFit.minHei = " + mh + "; SWFFit.maxWid = " + xw + "; SWFFit.maxHei = " + xh + "; SWFFit.hCenter = " + hc + "; SWFFit.vCenter = " + vc + "; SWFFit.innerW = " + iw + "; SWFFit.innerH = " + ih + ";");

		}

		private function onStageResizeStart(e:FieStageResizeEvent):void
		{

			trace("start resizing stage");

		}

		private function onStageResizeProgress(e:FieStageResizeEvent):void
		{

			trace("progress resizing stage");

		}

		private function onStageResizeEnd(e:FieStageResizeEvent):void
		{
			//	var tt:Array = ElementList.getInstance().getElementOnStage(BrowsingManager.getInstance().getCurrentPage());
			//this.dispatchEvent(new Event(FieEvent.RESIZE));
			trace("end resizing stage");

		}


	}
}