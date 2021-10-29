package com.flashiteasy.admin.event
{
	import flash.events.Event;

	public class ProjectEvent extends Event
	{
		public static const PROJECTS_INFO_LOADED:String = "Projects_Info_Loaded";
		
		public static const PROJECTS_INFO_REFRESHED : String = "Project List Changed";

		public static const PROJECTS_INFO_REFRESHING : String = "Project List Changing";
		
		public var data:Object;
		
		public function ProjectEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
	}
}