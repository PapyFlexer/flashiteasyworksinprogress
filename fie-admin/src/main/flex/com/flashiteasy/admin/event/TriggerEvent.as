package com.flashiteasy.admin.event
{
	import com.flashiteasy.api.core.ITrigger;
	
	import flash.events.Event;

	public class TriggerEvent extends Event
	{

        public static const ADD_OR_UPDATE:String = "triggerAddOrUpdate";
        public static const REMOVE_EVENT:String = "removeEvent";
		
		private var _trigger : ITrigger;
		
		public function TriggerEvent( trigger : ITrigger, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_trigger = trigger;
		}
		
		public function getTrigger() : ITrigger
		{
			return _trigger;
		}
		
	}
}