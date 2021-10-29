package com.flashiteasy.api.core
{
	import fl.video.FLVPlayback;
	import fl.video.UIManager;
	import fl.video.VideoPlayer;
	import fl.video.flvplayback_internal;
	
	import flash.display.Loader;
	import flash.events.TimerEvent;

    use namespace flvplayback_internal;


    /**
     * FLVPlayback2 adds a dispose() method to FLVPlayback so that it can
     * be garbage collected once it is removed.
     */
    public class FieFLVPlayback extends FLVPlayback
    {
        public function FieFLVPlayback()
        {
            super();
        }
		
		
		
		public function getUiManager():UIManager
		{
			return uiMgr;
		}
		
		
		
		public function getSkinLoader():Loader
		{
			return uiMgr.skinLoader;
		}
        /**
         * Removes all internal references that could prevent garbage collection.
         * Warning:  Once this method has been called,
         *              FLVPlayback's other methods are likely to fail.
         */
        public function dispose():void
        {
            // stop the video
            stop();

            // kill the timers
            if( skinShowTimer )
            {
                skinShowTimer.stop();
                skinShowTimer.removeEventListener(TimerEvent.TIMER, showSkinNow);
                skinShowTimer = null;
            }
            if( uiMgr )
            {
                uiMgr._volumeBarTimer.reset();
                uiMgr._bufferingDelayTimer.reset();
                uiMgr._seekBarTimer.reset();
                uiMgr._skinAutoHideTimer.reset();
                uiMgr._skinFadingTimer.reset();

                uiMgr._seekBarTimer.removeEventListener(TimerEvent.TIMER, uiMgr.seekBarListener);
                uiMgr._volumeBarTimer.removeEventListener(TimerEvent.TIMER, uiMgr.volumeBarListener);
                uiMgr._bufferingDelayTimer.removeEventListener(TimerEvent.TIMER, uiMgr.doBufferingDelay);
                uiMgr._skinAutoHideTimer.removeEventListener(TimerEvent.TIMER, uiMgr.skinAutoHideHitTest);
                uiMgr._skinFadingTimer.removeEventListener(TimerEvent.TIMER, uiMgr.skinFadeMore);
                
                uiMgr._volumeBarTimer = null;
                uiMgr._bufferingDelayTimer = null;
                uiMgr._seekBarTimer = null;
                uiMgr._skinAutoHideTimer = null;
                uiMgr._skinFadingTimer = null;
                if(uiMgr.skinLoader!=null)
                {
                	try {
					uiMgr.skinLoader.close();
				} catch (e1:Error) {
				}
                	//uiMgr.skinLoader.close();
                	Loader(uiMgr.skinLoader).unloadAndStop();
                	uiMgr.skinLoader = null;
                }
                uiMgr.skin = null;
                
            }
            // close the net connection
            // this kills all of the playback timers too
            for( var i:int = 0; i < videoPlayers.length; ++i )
            {
                var vp:VideoPlayer = getVideoPlayer(i);
                vp.stop();
                vp.close();
            }
			this.skin = null;
			uiMgr = null;
        }
    }
}
