package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.StoryList;
	
	import flash.events.Event;

	public class StoryCreationCommand extends AbstractCommand
	{
        private var type:String;
        private var name:String;
        private var id:String;
        private var story:Story;
        
		public function StoryCreationCommand(type:String,name:String,id:String)
		{
            this.type=type;
            this.id=id;
            this.name=name;
		}
		
        public override function execute():void
        {
            story=ApplicationController.getInstance().getBuilder().createStory(BrowsingManager.getInstance().getCurrentPage(),this.type,this.name,this.id);
            dispatchEvent(new Event(Event.COMPLETE));
        }
         
        public override function undo():void
		{
			story=StoryList.getInstance().getStory(this.id,BrowsingManager.getInstance().getCurrentPage());
			// Deselectionne le control si celui ci est deja selectionné
			StoryList.getInstance().removeStory(story , story.getPage());
			story.destroy();
			ApplicationController.getInstance().getStoryEditor().update();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public override function redo():void
		{
			story=ApplicationController.getInstance().getBuilder().createStory(BrowsingManager.getInstance().getCurrentPage(),type,id,name);
			//action.setParameterSet(pSet);
			//action.applyParameters();

		}
		
	}
}