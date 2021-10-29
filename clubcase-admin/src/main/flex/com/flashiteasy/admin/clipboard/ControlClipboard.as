package com.flashiteasy.admin.clipboard
{
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	public class ControlClipboard
	{
		private var controls : Array = [] ;
		private var actions : Array = [] ;
		private var stories : Array = [] ;
		private static var instance:ControlClipboard;
		private static var allowInstantiation:Boolean=false;
		
		public function ControlClipboard()
		{
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}

		}

		public static function getInstance():ControlClipboard
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new ControlClipboard();
				allowInstantiation=false;
			}
			return instance;
		}
		
		public function isEmpty():Boolean
		{
			return (controls.length == 0 && actions.length == 0 && stories.length == 0);
		}
		
		public function addControl ( control : IUIElementDescriptor ) : void
		{
			controls.push( control ) ;
		}
		
		public function getActions() : Array 
		{
			return actions;
		}
		
		public function addStory ( story : Story ) : void
		{
			stories.push( story ) ;
		}
		
		public function getStories() : Array 
		{
			return stories;
		}
		
		public function addAction ( action : IAction ) : void
		{
			actions.push( action ) ;
		}
		
		public function getControls() : Array 
		{
			return controls;
		}
		
		public function clear():void
		{
			controls = [];
			actions = [];
			stories = [];
		}

	}
}