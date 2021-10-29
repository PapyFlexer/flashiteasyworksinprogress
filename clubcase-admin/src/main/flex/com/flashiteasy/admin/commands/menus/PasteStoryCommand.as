package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.admin.commands.IRedoableCommand;
	import com.flashiteasy.admin.commands.IUndoableCommand;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.NameUtils;
	
	import flash.events.Event;
	
	import mx.core.Application;
	public class PasteStoryCommand extends AbstractCommand implements IUndoableCommand, IRedoableCommand
	{
		
		public function PasteStoryCommand( stories : Array , page :Page , parent : IUIElementContainer = null )
		{
			this.stories = stories.slice(0);
			this.parent = parent ;
			if( parent != null )
			{
				parentId= parent.uuid;
				parentPage = parent.getPage();
			}
			this.page = page ;
		}
		private var stories : Array = [];
		
		private var count:int=0;
		private var id:Array = [];
		private var page : Page ;
		private var parent :IUIElementContainer ;
		private var parentId : String = "" ;
		private var parentPage : Page ;
		
		private var pastedStories : Array = [];
		
		override public  function execute():void
		{
			count=0;
			var tmpControls : Array = [];
			var story : Story;
			var page:Page=BrowsingManager.getInstance().getCurrentPage();
			parent = ElementList.getInstance().getElement(parentId ,parentPage) as IUIElementContainer;
			for each ( story in stories )
			{
				story.uuid=NameUtils.findUniqueName(story.uuid, StoryList.getInstance().getStoriesId(page));
				
				story.init(story.uuid, story.getElementDescriptor(), story.loop, story.autoPlay, story.autoPlayOnUnload);
				// add the clone to the elementList
				story.setPage(page);
				StoryList.getInstance().addStory(story, page);
				BrowsingManager.getInstance().getCurrentPage().getStoryboard().addStory(story);
				
				
				pastedStories.push(story.uuid);
				
			}
			ApplicationController.getInstance().getStoryEditor().update();
			if(Application.application.currentState == "stories")
			{
				Ref.stageTimeLine.init();
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
			// load remote parameter stack in case copied controls contains remote parameterSets
			
			AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack( page );
		}
		
		override public  function redo():void
		{
			execute();
		}
		
		override public  function undo():void
		{	
			var tmpStories : Array = [];
			//var control :;
			var storyId : String ;
			var story : Story;
			for each ( storyId in pastedStories )
			{	
				story =StoryList.getInstance().getStory(storyId , page );
				//Clone copied controls to redo
				tmpStories.push(story.clone());
				//if(VisualSelector.getInstance().isSelected(control))
					//ApplicationController.getInstance().getElementEditor().editAction(action);
					
				BrowsingManager.getInstance().getCurrentPage().getStoryboard().removeStory(story);
				story.destroy();
			}
			stories = tmpStories.slice(0);
			ApplicationController.getInstance().getStoryEditor().update();
			if(Application.application.currentState == "stories")
			{
				Ref.stageTimeLine.init();
			}
			pastedStories = [];
		}
		
	}
}