package com.flashiteasy.admin.clipboard
{
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	public class ActionClipboard
	{
		private var actions : Array = [] ;
		private static var instance:ActionClipboard;
		private static var allowInstantiation:Boolean=false;
		
		public function StoryClipboard() : void
		{
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}

		}

		public static function getInstance():ActionClipboard
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new ActionClipboard();
				allowInstantiation=false;
			}
			return instance;
		}
		
		public function isEmpty():Boolean
		{
			return actions.length == 0;
		}
		
		
		public function addAction ( action : IAction ) : void
		{
			actions.push( action ) ;
		}
		
		public function getActions() : Array 
		{
			return actions;
		}
		
		
		public function clear():void
		{
			actions = [];
		}

	}
}