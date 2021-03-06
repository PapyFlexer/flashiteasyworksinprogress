/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
 package com.flashiteasy.api.controls
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.elements.ILoopElementDescriptor;
	import com.flashiteasy.api.core.elements.IPlayableElementDescriptor;
	import com.flashiteasy.api.core.elements.IResizableElementDescriptor;
	import com.flashiteasy.api.core.elements.ISmoothElementDescriptor;
	import com.flashiteasy.api.core.elements.IVideoElementDescriptor;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;


	/**
	 * Descriptor class for the <code><strong>Video</strong></code> element.
	 */
	public class VideoElementDescriptor extends SimpleUIElementDescriptor implements IPlayableElementDescriptor, IVideoElementDescriptor, ILoopElementDescriptor, ISmoothElementDescriptor, IResizableElementDescriptor
	{
		private var nc:NetConnection;
		private var _source:String;
		private var _mode:String;
		private var isResizable:Boolean
		private var _smooth:Boolean
		private var ecranVideo:Video;
		private var fluxVideo:NetStream;
		private var chargeurVideo:NetConnection;
		private var innerMask:Sprite=new Sprite();
		private var loaded:Boolean = false;

		protected override function initControl():void
		{

			// création de l'objet Video 
			ecranVideo=new Video();
			// ajout à la liste d'affichage 
			//face.addChild(ecranVideo);

		}

		private var loop:Boolean=false;
		private var _pauseAtStart : Boolean = false;

		/**
		 * 
		 * @param loop
		 */
		public function setLoop(loop:Boolean):void
		{
			this.loop=loop;
			if (isLoaded() && !isPlaying && loop == true)
			{
				play();
			}

		}

		/**
		 * 
		 * @param resize
		 * @param mode
		 */
		public function setResize(resize:Boolean, mode:String):void
		{
			isResizable=resize;
			_mode=mode;
		}


		/**
		 * 
		 * @param value
		 */
		public function setSmooth(value:Boolean):void
		{
			ecranVideo.smoothing=value;
		}


		/**
		 * 
		 * @return 
		 */
		public function hasVideo():Boolean
		{
			if (_source == null)
			{
				return false;
			}
			return true;
		}

		private var customClient:Object;

		/**
		 * 
		 * @param source
		 */
		public function setVideo(source:String):void
		{
			if (source != null && _source != source)
			{
				
				stop();
				_source=source;
				// instanciation d'un objet NetConnection
				chargeurVideo=new NetConnection();
				// lors d'un chargement de fichier local nous nous connectons à null 
				chargeurVideo.connect(null);
				// création d'un objet NetStream 
				fluxVideo=new NetStream(chargeurVideo);
				customClient = new Object;
				fluxVideo.client = customClient;
				customClient.onCuePoint=cuePointHandler;
				customClient.onMetaData=metaDataHandler;
				//fluxVideo.addEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
				fluxVideo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
				fluxVideo.addEventListener(IOErrorEvent.IO_ERROR, doIOError);
				// écoute de l'événement NetStatusEvent.NET_STATUS 
				fluxVideo.addEventListener(NetStatusEvent.NET_STATUS, etatLecture);
				// on attache le flux à l'écran vidéo 
				ecranVideo.attachNetStream(fluxVideo);
				// le scénario joue le rôle du client 
				//fluxVideo.client=this;
				// on affecte le smoothing
				ecranVideo.smoothing=_smooth;
				play();
			}
		}

		private var isPlaying:Boolean=false;

		/**
		 * 
		 */
		public function play():void
		{
			isPlaying=true;
			fluxVideo.play(AbstractBootstrap.getInstance().getBaseUrl() + "/" + _source);
		}

		/**
		 * 
		 */
		public function stop():void
		{
			if (isPlaying)
			{
				fluxVideo.pause();
				chargeurVideo.close();
				fluxVideo.close();
				ecranVideo.clear();
			}
		}

		/**
		 * 
		 */
		public function gotoTimeAndStop( time : uint ):void
		{
			fluxVideo.pause(); 
			fluxVideo.seek( time );
			isPlaying = false;
		}

		/**
		 * 
		 */
		public function gotoTimeAndPlay( time : uint ):void
		{
			fluxVideo.seek( time );
			fluxVideo.resume();
			//fluxVideo.play( AbstractBootstrap.getInstance().getBaseUrl() + "/" + _source, time );
			isPlaying = true;
		}

		/**
		 * 
		 */
		public function pause():void
		{
			fluxVideo.pause();
		}
		
		
		public function get pauseAtStart() : Boolean
		{
			return _pauseAtStart;
		}

		public function set pauseAtStart( value : Boolean ) : void
		{
			_pauseAtStart = value;
			if (isLoaded() && isPlaying && value == true)
			{
				pause();
			}

		} 

		/**
		 * 
		 */
		public function resume():void
		{
			fluxVideo.resume();
		}

		/**
		 * 
		 */
		public function toggle():void
		{
			fluxVideo.togglePause();
		}



		protected override function drawContent():void
		{
			if (isResizable && loaded && _infoObject != null)
			{
				var ratioW:Number=Math.abs(width) / _infoObject.width;
				var ratioH:Number=Math.abs(height) / _infoObject.height;
				var ratioMin:Number=Math.min(ratioH, ratioW);
				var ratioMax:Number=Math.max(ratioH, ratioW);
				if (_mode == "scale")
				{
					ecranVideo.height = _infoObject.height * ratioMin;
					ecranVideo.width = _infoObject.width * ratioMin;

				}
				else if (_mode == "fit")
				{
					ecranVideo.width=Math.abs(width);
					ecranVideo.height=Math.abs(height);
				}
				else 
				{
					ecranVideo.width=_infoObject.width;
					ecranVideo.height=_infoObject.height;
				}
				ecranVideo.scaleX=width < 0 ? -Math.abs(ecranVideo.scaleX) : Math.abs(ecranVideo.scaleX);
				ecranVideo.scaleY=height < 0 ? -Math.abs(ecranVideo.scaleY) : Math.abs(ecranVideo.scaleY);
			end();
			}
			else
			{
				/*ecranVideo.width = Math.abs(face.width);
				ecranVideo.height = Math.abs(face.height);
				if(face.width <0 )
					ecranVideo.scaleX = -Math.abs(ecranVideo.scaleX);
				if(face.height < 0 )
					ecranVideo.scaleY = -Math.abs(ecranVideo.scaleY);*/
			}
			
		}

		override protected function onSizeChanged():void
		{
			drawContent();	
		}

		private var _infoObject:Object;

		private function cuePointHandler(infoObject:Object):void
		{
			trace("cuePoint");
		}

		private function metaDataHandler(infoObject:Object):void
		{

			if (infoObject.duration != null)
			{
				// trace("our video is "+infoObject.duration+" seconds long");

			}

			if (infoObject.height != null && infoObject.width != null)
			{
				_infoObject=infoObject;
				// ajout à la liste d'affichage 
				face.addChild(ecranVideo);
				loaded=true;
				drawContent();

			}
		}

		private function etatLecture(event:NetStatusEvent):void
		{

			switch (event.info.code)
			{
				case "NetStream.Play.Start" :
					if (pauseAtStart == true )
					{
						//trace ("I must pause At Start");
						//isPlaying = false;
						fluxVideo.seek( 0 );
						fluxVideo.pause();
					}
					break;
				case "NetStream.Play.Stop":
					isPlaying=false;
					if (loop)
					{
						play();
					}
					break;
			}

		}

		private function doNetStatus(evt:NetStatusEvent):void
		{
			//trace("netstatus" + evt.info.code);
			// this will eventually let us know what is going on.. is the stream loading, empty, full, stopped?
		}

		private function doSecurityError(evt:SecurityErrorEvent):void
		{
			trace("AbstractStream.securityError:" + evt.text);
			// when this happens, you don't have security rights on the server containing the FLV file
			// a crossdomain.xml file would fix the problem easily
		}

		private function doIOError(evt:IOErrorEvent):void
		{
			trace("AbstractStream.ioError:" + evt.text);
			end();
			// there was a connection drop, a loss of internet connection, or something else wrong. 404 error too.
		}

		private function doAsyncError(evt:AsyncErrorEvent):void
		{
			trace("AsyncError:" + evt.text);
			
			end();
			// this is more related to streaming server from my experience, but you never know
		}

		private function netStatus(e:Event):void
		{

		}

		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			trace(event.text);
		}

		override protected function onComplete():void
		{
			/*if (_source == null)
				end();*/
			super.onComplete();
		}

		override public function getDescriptorType():Class
		{
			return VideoElementDescriptor;
		}

		/**
		 * 
		 * @param URL
		 */
		public function changeVideo(URL:String):void
		{
			removeBitmap();
			makeBitmap(ecranVideo);
			removeVideo();
			if (URL != "")
			{
				setVideo(URL);
			}

		}

		/**
		 * 
		 */
		public function removeVideo():void
		{
			if (fluxVideo != null)
			{
				chargeurVideo.close();
				chargeurVideo=null;
				fluxVideo.resume();
				fluxVideo.close();
				fluxVideo.removeEventListener(NetStatusEvent.NET_STATUS, doNetStatus);
				fluxVideo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
				fluxVideo.removeEventListener(NetStatusEvent.NET_STATUS, etatLecture);
				fluxVideo=null;
				ecranVideo.clear();
				getFace().removeChild(ecranVideo);
				_source=null;
			}
		}

		public override function destroy():void
		{
			removeVideo();
			super.destroy();
		}

		override public function setContent(a:Array):void
		{
			_source=a.pop();
			changeVideo(_source);
		}

		override public function getContent():Array
		{
			var ar:Array=new Array();
			ar.push(_source);
			return ar;
		}
	}
}