package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.StoryList;
	
	import flash.events.Event;
	
	public class PlayRelativeStoryAction extends PlayToStoryAction
	{
		public override function apply( event : Event ) : void
		{
			for each (var storyName:String in super._storyList)
			{
				var s:Story = StoryList.getInstance().getStory(storyName, super.storyPage); //player.storyName = _storyNameToPlay;
				s.timeToPause=_timeStop;
				s.isRelative = true;
				s.start(_time);
			}
			
		}

		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
			return PlayRelativeStoryAction;
		}
	}
}