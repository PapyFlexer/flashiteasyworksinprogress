package com.flashiteasy.admin.clipboard
{
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	public class StoryClipboard
	{
		private var stories : Array = [] ;
		private static var instance:StoryClipboard;
		private static var allowInstantiation:Boolean=false;
		
		public function StoryClipboard()
		{
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}

		}

		public static function getInstance():StoryClipboard
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new StoryClipboard();
				allowInstantiation=false;
			}
			return instance;
		}
		
		public function isEmpty():Boolean
		{
			return stories.length == 0;
		}
		
		
		public function addStory ( story : Story ) : void
		{
			stories.push( story ) ;
		}
		
		public function getStories() : Array 
		{
			return stories;
		}
		
		
		public function clear():void
		{
			stories = [];
		}

	}
}