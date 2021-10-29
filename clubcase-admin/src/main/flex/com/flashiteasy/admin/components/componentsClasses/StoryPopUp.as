package com.flashiteasy.admin.components.componentsClasses
{
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;

	public class StoryPopUp extends PopUp
	{
		
		// timeline editor panel
		private var _timelinePanel : Canvas;
		private var _story : Story;
		private var _updates : Array;
		
		public function StoryPopUp( story:Story, parent:DisplayObject=null, modal:Boolean=false, centered:Boolean=true, closeOnOk:Boolean=true)
		{
			_story = story;
			_updates = _story.getUpdates();
			callLater( initUpdates );	
		}
		
		
		private function initUpdates():void
		{
			
		}

		protected override function onClose():void
		{
			
		}

	}
}