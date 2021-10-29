package com.flashiteasy.clouds.lib
{
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CloudsElementDescriptor extends SimpleUIElementDescriptor implements ICloudableElementDescriptor

	//public class CloudsElementDescriptor extends ImgElementDescriptor implements ICloudableElementDescriptor
	{

		private var created:Boolean = false;
		private var cont : Sprite;

		private var _hSpeed : int = 2;
		private var _vSpeed : int = 1;
		
		public var cl : MovingCloud;
		
		public function setMovingClouds( hspeed : int, vspeed : int) : void
		{
			hSpeed = hspeed;
			vSpeed = vspeed;
			//drawContent()
		}
		
		override protected function drawContent( ) : void
		{
			if(!isNaN(width) && !isNaN(height))
			{
			if (created) 
			{
				refreshClouds(hSpeed, vSpeed);
			}
			else 
			{
				addClouds();
			}
			}			
		}
		
		
		private function removeClouds():void
		{
			trace ("removingClouds");
			cl.removedFromStage();
			this.getFace().removeChild(cont);
		}
		
		private function refreshClouds(hspeed:int, vspeed:int):void
		{
			/*cl.cloudsHeight = height;
			cl.cloudsWidth = width;
			cl.scrollAmountX = hSpeed;
			cl.scrollAmountY = vSpeed;
			//cl.makeClouds();
			cl.setRectangles();*/
			//cl = new MovingCloud(width, height, hSpeed, vSpeed);
			
			
		}
		private function addClouds():void
		{
			//cont = new Sprite();
			var www:Number = width;
			var hhh:Number = height;
			cl = new MovingCloud(www, hhh, hSpeed, vSpeed);
			//cont.addChild(cl);
			this.getFace().addChild(cl);
			created = true;
			end();
		}
		
		override protected function onSizeChanged():void
		{
			drawContent();	
		}
		
		public function get hSpeed():int
		{
			return this._hSpeed;
		}
		
		public function set hSpeed( value : int ) : void
		{
			this._hSpeed = value;
			if(cl != null)
			cl.scrollAmountX = _hSpeed;
		}
		
		public function get vSpeed():int
		{
			return this._vSpeed;
		}
		
		public function set vSpeed( value : int ) : void
		{
			this._vSpeed = value;
			if(cl != null)
			cl.scrollAmountY = _vSpeed;
		}
		
		override public function remove(e:Event):void
		{
			super.remove(e);
			removeClouds();
		}
		
		override public function getDescriptorType():Class
		{
			return CloudsElementDescriptor;
		}

		

	}
}