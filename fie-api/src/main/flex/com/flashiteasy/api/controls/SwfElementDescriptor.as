package com.flashiteasy.api.controls
{
	import com.flashiteasy.api.core.elements.IPlayableElementDescriptor;
	
	import flash.display.MovieClip;

	public class SwfElementDescriptor extends ImgElementDescriptor implements IPlayableElementDescriptor
	{
		private var _isPlaying : Boolean = false;
		public function SwfElementDescriptor()
		{
			super();
		}
		
		public function gotoTimeAndPlay(time:uint):void
		{
			var frame : int = Math.round((time/30)%MovieClip(img.content).totalFrames);
			MovieClip(img.content).gotoAndPlay(frame);
			_isPlaying = true;
		}
		
		public function gotoTimeAndStop(time:uint):void
		{
			
			var frame : int = Math.round((time/30)%MovieClip(img.content).totalFrames);
			MovieClip(img.content).gotoAndStop(frame);
			
			_isPlaying = false;
		}
		
		public function pause():void
		{
			MovieClip(img.content).stop();
			_isPlaying = false;
		}
		
		public function resume():void
		{
			MovieClip(img.content).play();
			_isPlaying = true;
		}
		
		public function toggle():void
		{
			if(_isPlaying)
			{
				MovieClip(img.content).stop();
			_isPlaying = false;
			}
			else
			{
				MovieClip(img.content).play();
			_isPlaying = true;
			}
		}
	
		override public function getDescriptorType():Class
		{
			return SwfElementDescriptor;
		}
		
		
	}
}