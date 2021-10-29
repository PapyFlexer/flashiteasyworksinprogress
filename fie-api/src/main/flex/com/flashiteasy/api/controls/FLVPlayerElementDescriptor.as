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
	import com.flashiteasy.api.core.FieFLVPlayback;
	import com.flashiteasy.api.core.elements.ILoopElementDescriptor;
	import com.flashiteasy.api.core.elements.IPlayableElementDescriptor;
	import com.flashiteasy.api.core.elements.IResizableElementDescriptor;
	import com.flashiteasy.api.core.elements.ISizableElementDescriptor;
	import com.flashiteasy.api.core.elements.ISmoothElementDescriptor;
	import com.flashiteasy.api.core.elements.IVideoElementDescriptor;
	
	import fl.video.MetadataEvent;
	import fl.video.SkinErrorEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoScaleMode;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class FLVPlayerElementDescriptor extends SimpleUIElementDescriptor implements IVideoElementDescriptor, IResizableElementDescriptor, ISizableElementDescriptor, ILoopElementDescriptor, ISmoothElementDescriptor, IPlayableElementDescriptor
	{
		public function FLVPlayerElementDescriptor()
		{
			super();
			player=this.getFLVPlayer();

			trace("FLVPlayer instanciated");
		}

		private var player:FieFLVPlayback;

		private var _skin:String;
		private var _skinAutoHide:Boolean;
		private var _skinBackgroundColor:uint
		private var _skinBackgroundAlpha:Number;
		private var _autoPlay:Boolean
		private var _autoRewind:Boolean;


		protected var source:String;
		protected var _mode:String;
		protected var isResizable:Boolean;
		// ILoopElementDescriptor
		private var _loop:Boolean;

		private var added:Boolean=false;

		protected var loaded:Boolean=false;

		private var t:Timer;

		protected override function initControl():void
		{
			player=new FieFLVPlayback();
			//player.skinBackgroundColor = 0x666666;
			player.addEventListener(VideoEvent.SKIN_LOADED, onVideoEvent);
			player.addEventListener(VideoEvent.READY, onVideoEvent);
			player.addEventListener(MetadataEvent.METADATA_RECEIVED, loaderInfoLoaded);
			player.addEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
			player.addEventListener(IOErrorEvent.IO_ERROR, doIOError);
			player.addEventListener(SkinErrorEvent.SKIN_ERROR, doSkinError);
			//player.setSize(face.width, face.height);
		}

		private function traceVideoState():void
		{
		/* t = new Timer(2000);
		   if (!t.hasEventListener(TimerEvent.TIMER))
		   {
		   t.addEventListener(TimerEvent.TIMER, vidState);
		   }
		 t.start( ); */
		}

		private function vidState(e:TimerEvent):void
		{
			trace("current flvplayer state : " + player.state + " (url=" + player.source + ")");

		}

		private function onVideoEvent(ve:VideoEvent):void
		{
			switch (ve.type)
			{
				case VideoEvent.READY:
					trace("FLVPlayer source is ready !!!");
					face.addChild(player);
					added=true;
					refreshPlayerProps();
					if (t == null)
					{
						traceVideoState();
					}
					loaded=true;
					drawContent();
					end();
					break;
				case VideoEvent.SKIN_LOADED:
					trace("FLVPlayer skin is loaded !!!");
					if(ve.target.getSkinLoader().content.hasOwnProperty("vc"))
					{
						ve.target.getSkinLoader().content.vc = ve.target;
					}
					if(ve.target.getSkinLoader().content.hasOwnProperty("uiM"))
					{
						ve.target.getSkinLoader().content.uiM = ve.target.getUiManager();
					}
					break;
				case VideoEvent.COMPLETE:
					trace("FLVPlayer skin has finished playing !!!");
					break;
				default:
					trace("nothing to do here... unknown video event");
					break;
			}
		}

		public function refreshPlayerProps():void
		{
			player.autoPlay=autoPlay;
			player.autoRewind=autoRewind;
			player.skinAutoHide=skinAutoHide;
			player.skinBackgroundColor=skinBackgroundColor;
			player.skinBackgroundAlpha=skinBackgroundAlpha;
			//player.skin = skin;
			if (autoPlay && source != null)
			{
				player.play();
			}
		}

		private function playerCreated(e:Event):void
		{
			trace("FLVPlayer added to Stage")
			trace("========================");
			trace(" src = " + player.source);
			trace("skin = " + player.skin);
			trace("========================");
		}

		/**
		 * Returns the instance of the FLVPlayback component
		 * @return : FLVPlayback component instance
		 */
		public function getFLVPlayer():FieFLVPlayback
		{
			return player;
		}

		/**
		 * Changes the video source
		 * @param URL
		 */
		public function changeVideo(src:String):void
		{
			//removeVideo();
			setVideo(src);
		}

		/**
		 * Removes the video from the control
		 */
		public function removeVideo():void
		{
			source=null;
		}

		override public function getContent():Array
		{
			var ar:Array=new Array();
			ar.push(source);
			return ar;
		}


		override public function setContent(a:Array):void
		{
			source=a.pop();
			changeVideo(source);
		}


		/**
		 * Sets the source of the image control.
		 * @param source url string.
		 */
		public function setVideo(source:String):void
		{
			if (source != null && this.source != source)
			{
				loaded=false;
				this.source=source;
				if (source.indexOf("http://") == -1)
				{
					player.source=AbstractBootstrap.getInstance().getBaseUrl() + "/" + source;
				}
				else
				{
					player.source=source;
				}
			}
			else if (source == null)
			{
				end();
			}
		}


		override protected function onSizeChanged():void
		{
			drawContent();
		}

		override protected function drawContent():void
		{

			if (isResizable && loaded && vidInfo != null)
			{
				var ratioW:Number=Math.abs(width) / vidInfo.width;
				var ratioH:Number=Math.abs(height) / vidInfo.height;
				var ratioMin:Number=Math.min(ratioH, ratioW);
				var ratioMax:Number=Math.max(ratioH, ratioW);
				if (_mode == "scale")
				{
					player.scaleMode=VideoScaleMode.MAINTAIN_ASPECT_RATIO;
						//player.height = player.loaderInfo.height * ratioMin;
						//player.width = player.loaderInfo.width * ratioMin;

				}
				else if (_mode == "fit")
				{
					player.scaleMode=VideoScaleMode.EXACT_FIT;
						//player.width=Math.abs(width);
						//player.height=Math.abs(height);
				}
				else
				{
					player.scaleMode=VideoScaleMode.NO_SCALE;
						//player.width=player.loaderInfo.width;
						//player.height=player.loaderInfo.height;
				}
				player.width=Math.abs(width);
				player.height=Math.abs(height);

				player.scaleX=width < 0 ? -Math.abs(player.scaleX) : Math.abs(player.scaleX);
				player.scaleY=height < 0 ? -Math.abs(player.scaleY) : Math.abs(player.scaleY);

			}


		}

		private var vidInfo:Object;

		private function loaderInfoLoaded(e:MetadataEvent):void
		{
			vidInfo=e.info;
			//	loaded=true;
			//drawContent();
		}

		private function doIOError(evt:IOErrorEvent):void
		{
			trace("AbstractStream.ioError:" + evt.text);
			end();
			// there was a connection drop, a loss of internet connection, or something else wrong. 404 error too.
		}
		
		private function doSkinError(evt:SkinErrorEvent):void
		{
			trace("AbstractStream.skinError:" + evt.text);
			end();
			// there was a connection drop, a loss of internet connection, or something else wrong. 404 error too.
		}

		private function doAsyncError(evt:AsyncErrorEvent):void
		{
			trace("AsyncError:" + evt.text);

			end();
			// this is more related to streaming server from my experience, but you never know
		}

		// === Fonctions generiques aux controls ====

		override public function destroy():void
		{
			trace("destroying FLVPlayer");
			
			removeListeners();
			if (face.contains(player))
			{
				face.removeChild(player);
			}
			
			if (source != null)
			{
				player.stop();
				player.getVideoPlayer(0).close();
				FieFLVPlayback(player).dispose();
					//player.source = null;
			}

			player=null;
			super.destroy();
		}

		public function setResize(resize:Boolean, mode:String):void
		{
			isResizable=resize;
			_mode=mode;
		}


		private function playLoop(e:VideoEvent):void
		{
			player.seek(0);
			player.play();
		}

		private function removeListeners():void
		{
			player.removeEventListener(VideoEvent.SKIN_LOADED, onVideoEvent)
			player.removeEventListener(VideoEvent.READY, onVideoEvent);
			player.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError);
			player.removeEventListener(IOErrorEvent.IO_ERROR, doIOError);
			player.removeEventListener(MetadataEvent.METADATA_RECEIVED, loaderInfoLoaded);
			if (t != null)
			{
				t.stop();
				t.removeEventListener(TimerEvent.TIMER, vidState);
				t=null;
			}
		}
		/**
		 * ==================================================
		 * 		IPlayableElementDescriptor implementation
		 * ==================================================
		 */


		private var isPlaying:Boolean=false;

		/**
		 *
		 */
		public function play():void
		{
			isPlaying=true;
			player.play()
		}

		/**
		 *
		 */
		public function stop():void
		{
			if (isPlaying)
			{
				player.pause();
			}
		}

		/**
		 *
		 */
		public function gotoTimeAndStop(time:uint):void
		{
			player.seek(time);
			player.stop();
			isPlaying=false;
		}

		/**
		 *
		 */
		public function gotoTimeAndPlay(time:uint):void
		{
			player.seek(time);
			player.play();
			isPlaying=true;
		}

		/**
		 *
		 */
		public function pause():void
		{
			player.pause();
			isPlaying=false;
		}

		/**
		 *
		 */
		public function resume():void
		{
			player.play();
			isPlaying=true;
		}

		/**
		 *
		 */
		public function toggle():void
		{
			if (isPlaying)
			{
				isPlaying=false;
				player.pause();
			}
			else
			{
				isPlaying=true;
				player.play();
			}
		}

		/**
		 * ==================================================
		 * 		ISmoothElementDescriptor implementation
		 * ==================================================
		 */

		private var _smooth:Boolean

		public function setSmooth(value:Boolean):void
		{
			player.getVideoPlayer(0).smoothing=value;
		}

		public function getSmooth():Boolean
		{
			return _smooth;
		}


		/**
		 * =========================================
		 * 		Getters & Setters
		 * =========================================
		 */

		/**
		 * getter skin
		 */
		public function get skin():String
		{
			return _skin;
		}

		/**
		 * @private
		 */
		public function set skin(value:String):void
		{
			if (value != null)
			{
				_skin=value;
				player.skin=AbstractBootstrap.getInstance().getBaseUrl() + "/media/Video/skins/" + value + ".swf";
//				player.skin = value + ".swf";
			}
			else
			{
				player.skin=AbstractBootstrap.getInstance().getBaseUrl() + "/media/Video/skins/SkinOverPlaySeekMute.swf";
			}
		}

		/**
		 * getter skinAutoHide
		 */
		public function get skinAutoHide():Boolean
		{
			return _skinAutoHide;
		}

		/**
		 * @private
		 */
		public function set skinAutoHide(value:Boolean):void
		{
			_skinAutoHide=value;
		}

		/**
		 * getter skinBackgroundColor
		 */
		public function get skinBackgroundColor():uint
		{
			return _skinBackgroundColor;
		}

		/**
		 * @private
		 */
		public function set skinBackgroundColor(value:uint):void
		{
			_skinBackgroundColor=value;
		}

		/**
		 * getter skinAutoHide
		 */
		public function get skinBackgroundAlpha():Number
		{
			return _skinBackgroundAlpha;
		}

		/**
		 * @private
		 */
		public function set skinBackgroundAlpha(value:Number):void
		{
			_skinBackgroundAlpha=value;
		}

		/**
		 * getter autoPlay
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		/**
		 * @private
		 */
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay=value;
		}

		/**
		 * getter autoRewind
		 */
		public function get autoRewind():Boolean
		{
			return _autoRewind;
		}

		/**
		 * @private
		 */
		public function set autoRewind(value:Boolean):void
		{
			_autoRewind=value;
		}

		public function setLoop(value:Boolean):void
		{
			if (value)
			{
				player.addEventListener(VideoEvent.COMPLETE, playLoop);
			}
			else
			{
				if (player.hasEventListener(VideoEvent.COMPLETE))
				{
					player.removeEventListener(VideoEvent.COMPLETE, playLoop);
				}
			}
		}

		public function get loop():Boolean
		{
			return _loop;
		}


		/**
		 * =========================================
		 * 		Descriptor Type
		 * =========================================
		 */
		override public function getDescriptorType():Class
		{
			return FLVPlayerElementDescriptor;
		}

	}
}