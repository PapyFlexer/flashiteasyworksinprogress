package com.flashiteasy.clock.lib
{
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.clock.lib.core.AlarmClock;
	import com.flashiteasy.clock.lib.core.SimpleClock;
	
	import flash.events.Event;
	
	public class ClockElementDescriptor extends SimpleUIElementDescriptor implements IClockableElementDescriptor

	{

		private var _type : String = "simple";
		
		public var cl : SimpleClock;
		
		public function setClock( type : String ) : void
		{
			_type = type;
			cl = _type == "alarm" ? new AlarmClock : new SimpleClock;
			cl.initClock(100);
			face.addChild(cl);
		}
		
		override protected function drawContent( ) : void
		{
			cl.width = face.width*2;
			cl.height = face.height*2;
		}
		
		
		override protected function onSizeChanged():void
		{
			drawContent();	
		}
		
		public function get type():String
		{
			return this._type;
		}
		
		public function set type( value : String ) : void
		{
			this._type = value;
		}
		
		public function getClock():SimpleClock
		{
			return cl;
		}
		
		override public function remove(e:Event):void
		{
			super.remove(e);
			face.removeChild(cl);
		}
		
		override public function getDescriptorType():Class
		{
			return ClockElementDescriptor;
		}

	}
}