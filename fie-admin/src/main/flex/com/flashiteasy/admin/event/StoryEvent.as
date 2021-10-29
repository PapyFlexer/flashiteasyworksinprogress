package com.flashiteasy.admin.event
{
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	import flash.events.Event;

	public class StoryEvent extends Event
	{

		public static const ADD_STORY:String = "addStory";
		public static const REMOVE_STORY:String = "removeStory";
		public static const START_STORY:String = "StoryStarts";
		public static const STOP_STORY:String = "StoryStops";
		public static const LOOP_STORY:String = "StoryLoops";
       
		
		private var _story : Story;
		
		public function StoryEvent( s : Story, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_story = s;
			super(type, bubbles, cancelable);
		}
		
		public function getStory() : Story
		{
			return _story;
		}
		
	}
}