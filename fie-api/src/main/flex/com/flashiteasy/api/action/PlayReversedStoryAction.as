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
	import com.flashiteasy.api.core.action.ITimedElementAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.StoryboardUtils;

	import flash.events.Event;

	/**
	 *
	 * The <code><strong>PlayReversedAction</strong></code> class defines an Action that triggers one or more Story (animation) on stage
	 * then plays them in reverse mode.
	 */
	public class PlayReversedStoryAction extends Action implements IStoryAction, ITimedElementAction
	{

		/**
		 *
		 * @default : the Array of animations to play
		 */
		protected var _storyList:Array;
		protected var _reverseList:Array;
		private var storyPage:Page;
		private var _isCreate:Boolean=false;


		private var _time:uint;

		/**
		 * Constructor
		 */
		public function PlayReversedStoryAction()
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
			storyPage=page;
		}

		override public function apply(event:Event):void
		{
			if (_isCreate)
			{
				for each (var story:Story in _reverseList)
				{
					story.start(_time);
				}
			}
			else
			{
				var createdStoryList:Array=[];
				for each (var storyName:String in _storyList)
				{
					var s:Story=StoryList.getInstance().getStory(storyName, storyPage); //player.storyName = _storyNameToPlay;
					var reversedStory:Story=StoryboardUtils.reverseStory(s, true);
					s.reverseStory=reversedStory;
					reversedStory.start(_time);
					createdStoryList.push(reversedStory);
				}
				_reverseList=createdStoryList;
				_isCreate=true;
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
		 * @param value pushes a new animation uuid into the string array of animations to  be played
		 */
		public function addStoryToStoryList(value:String):void
		{
			if (_isCreate)
			{
				var s:Story=StoryList.getInstance().getStory(value, storyPage); //player.storyName = _storyNameToPlay;
				var reversedStory:Story=StoryboardUtils.reverseStory(s, true);
				s.reverseStory=reversedStory;
				_reverseList.push(reversedStory);
			}
			else
			{
				_storyList.push(value);
			}
		}

		/**
		 * gets the time in an animation
		 */
		public function get time():uint
		{
			return _time;
		}

		/**
		 *
		 * @private
		 */
		public function set time(value:uint):void
		{
			_time=value;
		}


		/**
		 *
		 * @param value withdraws an animation uuid from the string array of animations to  be played
		 */
		public function removeStoryFromStoryList(value:String):void
		{
			if (_isCreate)
			{
				var index:int=-1;
				for each (var story:Story in _reverseList)
				{
					index++;
					if (story.uuid == value)
					{
						story.destroy(false);
						_reverseList.splice(index, 1);
						break;
					}
				}
			}
			else
			{
				_storyList.splice(_storyList.lastIndexOf(value), 1);
			}
		}

		override public function destroy():void
		{
			super.destroy();
			if (_isCreate)
			{
				for each (var story:Story in _reverseList)
				{
					story.destroy(false);
				}
			}

		}

		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
			return PlayReversedStoryAction;
		}
	}
}