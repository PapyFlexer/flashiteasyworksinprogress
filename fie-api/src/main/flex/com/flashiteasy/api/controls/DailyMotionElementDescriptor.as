package com.flashiteasy.api.controls
{
	import com.flashiteasy.api.core.elements.IDailyMotionElementDescriptor;
	import com.flashiteasy.api.core.elements.IPlayableElementDescriptor;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	public class DailyMotionElementDescriptor extends ImgElementDescriptor implements IDailyMotionElementDescriptor, IPlayableElementDescriptor
	{
		// The player SWF file on www.dailymotion.com needs to communicate with your host
        // SWF file. Your code must call Security.allowDomain() to allow this communication.
        Security.allowDomain("www.dailymotion.com");
 		Security.allowDomain("www.youtube.com");
 		Security.allowInsecureDomain("*");
		Security.allowDomain("*");

        // This will hold the API player instance once it is initialized.
        public var player:Object;
        private var apiDomain : String;

		override public function setImage(source:String):void
		{
			if (source != null && this.source != source)
			{
				loaded=false;
				this.source=source;
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = new ApplicationDomain();
				context.checkPolicyFile = true;
			//	var ul:URLRequest=new URLRequest("http://www.dailymotion.com/swf?enableApi=1");
				var ul:URLRequest=new URLRequest(apiDomain);
				img.contentLoaderInfo.addEventListener(Event.INIT, initDaily, false, 0, true);
				img.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageError, false, 0, true);
				img.load(ul);
			}
		}
		
		public function setDomain ( domain:String ) : void
		{
			var reload : Boolean = false;
			if(apiDomain != null)
				reload = apiDomain.indexOf(domain) == -1;
			if(reload)
				removeImage();
			if(domain == "youtube")
			{
				apiDomain = "http://www.youtube.com/apiplayer?version=3";
			}
			else
			{
				apiDomain = "http://www.dailymotion.com/swf?enableApi=1&chromeless=1";
			}
			if(reload)
			{
				setImage(source);
			}
		}
		
		protected function initDaily(e:Event):void
		{
			face.addChild(img);
			//onPlayerReady(e);
			end();
			this.img.content.addEventListener("onReady", this.onPlayerReady);
		}
		
		override protected function drawContent():void
		{
			if (source == null || source == "" )
			{
				end();
			}
			else
			{
				if (isResizable && loaded)
				{
					this.player.setSize(width, height);
				}
			}
		}
		
		
		public function onPlayerReady(event:Event):void
        {
            // Event.data contains the event parameter, which is the Player API ID
           // trace("player ready:", Object(event).data.playerId);

            // Save a reference to this player's instance
            this.player = this.img.content;

            // Set appropriate player dimensions for your application
            
            

            // Once this event has been dispatched by the player, we can use
            // cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
            // to load a particular YouTube video.
            this.player.loadVideoById(source);
            _isPlaying = true;
			loaded=true;
			drawContent();
            //end()
        }
        
        
		public function gotoTimeAndPlay(time:uint):void
		{
			
			if(apiDomain.indexOf("dailymotion") != -1)
			{
				player.seekTo(time);
			}
			else
			{
				player.seekTo(time, true);
			}
			_isPlaying = true;
			
		}
		public function gotoTimeAndStop(time:uint):void
		{
			if(apiDomain.indexOf("dailymotion") != -1)
			{
				player.seekTo(time);
			}
			else
			{
				player.seekTo(time, true);
			}
			player.pauseVideo();
			_isPlaying = false;
			
		}
		public function pause():void
		{
			player.pauseVideo();
			_isPlaying = false;
		}
		
		public function resume():void
		{
			player.playVideo();
			_isPlaying = true;
		}
		
		private var _isPlaying : Boolean = false;
		public function toggle():void
		{
			if(_isPlaying)
			{
				player.pauseVideo();
				_isPlaying = false;
			}
			else
			{
				player.playVideo();
				_isPlaying = true;
			}
		}

        public function onPlayerError(event:Event):void
        {
            // Event.data contains the event parameter, which is the error code
            trace("player error:", Object(event).data);
        }

        public function onPlayerStateChange(event:Event):void
        {
            // Event.data contains the event parameter, which is the new player state
            trace("player state:", Object(event).data);
        }
        
        override public function removeImage():void
		{
			if (source != null && player != null)
			{
				loaded=false;
				if(player!=null && apiDomain != null)
				{
					if(apiDomain.indexOf("dailymotion") != -1)
					{
						player.clearVideo();
					}
					else
					{
						player.destroy();
					}
				}
				img.unload();
				img.contentLoaderInfo.removeEventListener(Event.INIT, init);
				img.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageError);
				source=null;
				if (img.parent != null)
				{
					face.removeChild(img);
				}
			}
		}


		override public function getDescriptorType():Class
		{
			return DailyMotionElementDescriptor;
		}
	}
}