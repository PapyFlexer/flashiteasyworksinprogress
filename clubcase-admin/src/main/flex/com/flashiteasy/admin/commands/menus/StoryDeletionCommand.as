package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.StoryboardUtils;
	
	import flash.events.Event;

	public class StoryDeletionCommand extends AbstractCommand
	{
		private var storyId:String;
		private var page:Page;
		private var storyCopy : Story; 
		
		public function StoryDeletionCommand( s : Story ):void
		{
			storyId = s.uuid;
			page = s.getPage();
		}
		
		public override function execute():void
        {
        	var s : Story =  StoryList.getInstance().getStory(storyId,page);
        	// FIXME : add cloning
        	
        	storyCopy =s.clone();
        	s.stop();
        	s.destroy();
			ApplicationController.getInstance().getStoryEditor().update();
			dispatchEvent(new Event(Event.COMPLETE));
        }
        
        public override function undo():void
		{
			//storyCopy.setPage(page);
			//controlCopy.dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
			storyCopy.setPage(page);
			StoryList.getInstance().addStory(storyCopy,page);
			//ActionList.getInstance().addAction(el, BrowsingManager.getInstance().getCurrentPage());
			
			ApplicationController.getInstance().getStoryEditor().update();
		}
		
		public override function redo():void
		{
			
			execute();
			
			
		}
		
	}
}