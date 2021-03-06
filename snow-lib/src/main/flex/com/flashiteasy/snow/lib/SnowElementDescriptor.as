/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.snow.lib
{
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class SnowElementDescriptor extends SimpleUIElementDescriptor implements ISnowableElementDescriptor
	{
		// timer
		private var timer:Timer;
		
		private const FPS:Number = 30 / 1000;
		
		//  define a rectangle  
		private var faceArea:Rectangle;
		
		// and decide the maximum number of flakes 
		private var numFlakes : uint = 100;
		
		private var flakeColor : uint = 0xFFFFFF;
		
		private var _useMouseForWind : Boolean = false;
		
		private var _baseSpeedFactor : uint = 3;
		 
		
		// first make an array to put all our snowflakes in
		private var snowFlakes : Array = new Array();
		
		override public function applySize() : void
		{
			super.applySize();
 		}
 		
		
		public function setSnowStorm (quantity : Number, color : uint, useMouseForWind : Boolean ):void
		{
			numFlakes = quantity;
			flakeColor = color;
			_useMouseForWind = useMouseForWind
		}
		
		
		protected override function onSizeChanged():void
		{
			faceArea= new Rectangle(0,0,width,height);
			face.removeEventListener(Event.ENTER_FRAME, timeLoop);
			drawContent();
		}
		
		
		protected override function drawContent():void
		{
			timer = new Timer (	FPS );
			timer.start();
			faceArea = new Rectangle(0,0,width,height)
			face.addEventListener(Event.ENTER_FRAME, timeLoop);
			//face.addEventListener(TimerEvent.TIMER, timeLoop);
			end();
		}

		public override function destroy():void 
		 {
			face.removeEventListener(Event.ENTER_FRAME, timeLoop);
			timer.stop();
			timer = null;
			super.destroy();
		}

		// What a pity that ActionScript does not support Generics...
		override public function getDescriptorType() : Class
		{
			return SnowElementDescriptor;
		}
		
		private function timeLoop(e:Event) : void
		{
			
			var snowflake : SnowFlake; 
			
			// if we don't have the maximum number of flakes... 
			if(snowFlakes.length<numFlakes)
			{
				// then make a new one!
				snowflake = new SnowFlake(faceArea, flakeColor, _baseSpeedFactor); 
				
				// add it to the array of snowflakes
				snowFlakes.push(snowflake); 
				
				// and add it to the stage
				getFace().addChild(snowflake); 
				
			}
			if( snowFlakes.length > numFlakes)
			{
				while(snowFlakes.length> numFlakes)
				{
					var snow : SnowFlake = SnowFlake(snowFlakes.pop());
					face.removeChild(snow);
				}
			}
			
			// now calculate the wind factor by looking at the x position 
			// of the mouse relative to the centre of the face
			var wind : Number = _useMouseForWind ? ((faceArea.width/2) - getFace().mouseX) : Math.random()*width/2;
			
			// and divide by 60 to make it smaller 
			wind /=60; 
			
			// now loop through every snowflake
			for(var i:uint = 0; i<snowFlakes.length; i++)
			{
				
				snowflake = snowFlakes[i]; 
				
				// and update it
				snowflake.update(wind, new Rectangle(0,0,width,height)); 
			}
		}
		
	}
}