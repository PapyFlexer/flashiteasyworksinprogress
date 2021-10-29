/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.motion
{
	import com.flashiteasy.api.core.motion.IStoryboardPlayer;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Storyboard;
	import com.flashiteasy.api.utils.StoryboardUtils;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * The <code><strong>TimerStoryboardPlayerImpl</strong></code> handles
	 * all animation on the page. 
	 * It keeps an array of stories to play
	 * and manages several time tracks so
	 * stories are correctly synchronized.
	 */
	public class TimerStoryboardPlayerImpl extends AbstractStoryboardPlayer implements IStoryboardPlayer
	{

		private var storyMap:Array;
		private var storyMapOnUnload:Array;
		private var pageTimer:Timer;

		/**
		 * 
		 * @default 0
		 */
		public var currentTime:int=0;

		private var pageStartTime:int
		private var pageMaxTime:int
		private var delayBeforeDestroyPage:int;


		/**
		 * Animation speed
		 * @default 90
		 */
		public static const FPS:int=30;


		/**
		 *
		 * The animations are organized using :
		 * <ul>
		 * <li> Stories (applied to faces)</li>
		 * <li> Updates (applied to numeric properties of the face's tweenable ParameterSets)</li>
		 * <li> Transitions (where keyframes are defined using time and tweenable ParameterSet's properties values)</li> 
		 * </ul>
		 * 
		 * @see package com.flashiteasy.api.core.project.storyboard.
		 *
		 * @param s : the storyboard to play
		 * @param time : the time when to start
		 */
		override public function start(s:Storyboard, time:int=0):void
		{
			super.start(s);
			storyMap=[];
			storyMapOnUnload=[];
			pageMaxTime=0;
			delayBeforeDestroyPage=0;
			//TODO 
			/*pageTimer=new Timer(1000 / FPS);
			   pageTimer.addEventListener(TimerEvent.TIMER, onPageTimerBegin);
			   pageStartTime=4000;
			   pageStartTime+=new Date().getTime();
			   pageTimer.start();
			 */
			// Iterating through the stories

			//	
			for each (var story:Story in getStoryboard().getStories())
			{
				// getting the maxTime & minTime for each story
				story.maxTime=StoryboardUtils.computeStoryDuration(story)["end"];
				story.minTime=StoryboardUtils.computeStoryDuration(story)["begin"];
				pageMaxTime=Math.max(pageMaxTime, story.maxTime);
				// is the story autoPlayed ?
				if (story.autoPlay)
				{
					storyMap.push(story);
				}
				if (story.autoPlayOnUnload)
				{
					storyMapOnUnload.push(story);
					delayBeforeDestroyPage=Math.max(delayBeforeDestroyPage, story.maxTime);
				}
			}
			startPageFps(time);
		}

		/**
		 * 
		 * @inheritDoc
		 */
		override public function startOnUnload(s:Storyboard, time:int=0):void
		{
			
			for each (var story:Story in storyMapOnUnload)
			{
				story.start(time);
			}
			if(storyMapOnUnload != null && storyMapOnUnload.length >0)
				storyMapOnUnload.slice(0);
		}
		
		private function onPageTimerBegin(e:TimerEvent):void
		{
			currentTime=new Date().getTime();
			if (currentTime >= pageStartTime)
			{
				pageTimer.removeEventListener(TimerEvent.TIMER, onPageTimerBegin);
				startPageFps();
				pageTimer.stop();
				pageTimer=null;
			}
		}

		private function startPageFps(time:int=0):void
		{
			for each (var story:Story in storyMap)
			{
				story.start(time);
			}

			storyMap.slice(0);
		}

		/**
		 * 
		 * @inheritDoc
		 */
		override public function goToTimeAndStop(s:Storyboard, time:int=0):void
		{

			for each (var story:Story in storyMap)
			{
				story.goToTimeAndStop(time);
			}
			//storyMap.slice(0);
		}

		/**
		 *
		 * Stops everything and puts the pointer to 0
		 * in all stories
		 *
		 * @param s
		 */
		override public function reset(s:Storyboard):void
		{
			if (s.getStories().length > 0)
			{
				// Iterating through the stories
				for each (var story:Story in s.getStories())
				{
					story.reset();
				}
			}
		}

		/**
		 *
		 * Stops everything and puts the pointer to 0
		 * in all stories
		 *
		 * @param s
		 */
		override public function resetOriginalValues(s:Storyboard):void
		{
			if (s.getStories().length > 0)
			{
				// Iterating through the stories
				for each (var story:Story in s.getStories())
				{
					story.resetOriginalValues();
				}
			}
		}
		/**
		 * 
		 * @inheritDoc
		 */
		override public function stop(s:Storyboard):void
		{
			//super.stop(s);
			super.storyboard=s;
			if (pageTimer != null)
			{
				this.pageTimer.stop();
				this.pageTimer=null;
			}
			// Iterating through the stories
			for each (var story:Story in s.getStories())
			//for each (var story:Story in this.storyMap)
			{
				story.stop();
			}
		}

		/**
		 * 
		 * @inheritDoc
		 */
		override public function getMaxTime():Number
		{
			return pageMaxTime;
		}
		
		override public function getDelayBeforeDestroy():Number
		{
			return delayBeforeDestroyPage;
		}


	}
}