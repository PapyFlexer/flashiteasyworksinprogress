package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.commands.IRedoableCommand;
	import com.flashiteasy.admin.commands.IUndoableCommand;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.utils.StoryboardUtils;
	
	import mx.core.Application;
	public class ReverseStoryCommand extends AbstractCommand implements IUndoableCommand, IRedoableCommand
	{
		
		public function ReverseStoryCommand( stories : Array , page :Page )
		{
			this.stories = stories.slice(0);
			this.page = page ;
		}
		private var stories : Array = [];
		
		private var count:int=0;
		private var id:Array = [];
		private var page : Page ;
		
		private var pastedStories : Array = [];
		
		override public  function execute():void
		{
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			for each ( var story : Story in stories )
			{
				StoryboardUtils.reverseStorySimple(story);
				
			}
			ApplicationController.getInstance().getStoryEditor().update();
			if(Application.application.currentState == "stories")
			{
				Ref.stageTimeLine.init();
			}
		}
		
		override public  function redo():void
		{
			execute();
		}
		
		override public  function undo():void
		{	
			execute();
		}
		
	}
}