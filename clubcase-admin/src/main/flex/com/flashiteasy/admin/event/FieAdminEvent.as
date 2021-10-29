package com.flashiteasy.admin.event
{
	import flash.events.Event;

	public class FieAdminEvent extends Event
	{
		
		public static const COMPLETE:String = "fie_admin_action_complete";
		public static const STORY_COMPLETE:String = "fie_admin_story_complete";
		public static const PARAMETER_UPDATED:String = "fie_admin_parameter_updated";
		
		public var info:Object;
		
		public function FieAdminEvent(type:String, info:Object = null, bubbles:Boolean = false, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
			this.info = info;
		}
	}
}