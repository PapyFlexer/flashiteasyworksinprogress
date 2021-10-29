/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.action.IStoryAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.StoryList;

	import flash.events.Event;

	/**
	 *
	 * The <code><strong>PlayElementAction</strong></code> class defines an Action that triggers
	 * one or more "playable" Elements (swfs, videos, ...) on stage
	 */
	public class TogglePlayableStoryAction extends Action implements IStoryAction
	{

		/**
		 *
		 * @default : the Array of animations to play
		 */
		protected var _storyList:Array;
		private var storiesPage:Page;

		/**
		 * Constructor
		 */
		public function TogglePlayableStoryAction()
		{
			super();
		}

		/**
		 *
		 * @param stories : Array of animations to be triggered
		 * @param page : page from the project where the animations are called
		 * Usually set in the same page as the action.
		 * TODO : make sub and parent pages available
		 */
		public function setStoriesToTrigger(stories:Array, page:Page):void
		{
			_storyList=stories;
			storiesPage=page;
		}

		override public function apply(event:Event):void
		{
			for each (var storyName:String in _storyList)
			{
				var story:Story=StoryList.getInstance().getStory(storyName, storiesPage);
				story.toggle();
			}
		}

		/**
		 *
		 * @return the Array of animations names to play (String)
		 * Getter
		 */
		public function get storyList():Array
		{
			return _storyList;
		}

		/**
		 *
		 * @param value the Array of animations names to play (String)
		 * Setter
		 */
		public function set storyList(value:Array):void
		{
			_storyList=value;
		}

		/**
		 *
		 * @param value pushes a new playable element into the array of elements to  be played
		 */
		public function addStoryToStoryList(value:String):void
		{
			_storyList.push(value);
		}

		/**
		 *
		 * @param value withdraws an animation uuid from the string array of animations to  be played
		 */
		public function removeStoryFromStoryList(value:String):void
		{
			_storyList.splice(_storyList.lastIndexOf(value), 1);
		}

		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
			return TogglePlayableStoryAction;
		}

	}
}