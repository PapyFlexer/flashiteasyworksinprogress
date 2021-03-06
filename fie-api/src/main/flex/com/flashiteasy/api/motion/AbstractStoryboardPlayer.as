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
	import com.flashiteasy.api.core.project.storyboard.Storyboard;
	
	/**
	 * The <code><strong>AbstractStoryboardPlayer</strong></code> defines
	 * how the FIE animations are played. A StoryboardPlayer will 
	 * handle all animations on a given page.
	 * <p>As a pseudo-abstract class
	 * some of its methods will be overriden 
	 * by the implementations.</p>
	 * 
	 * @see com.flashiteasy.api.core.project.storyboard.Story
	 */
	public class AbstractStoryboardPlayer implements IStoryboardPlayer
	{
		protected var storyboard : Storyboard;
		private var maxTime : Number;
		private var delayBeforeDestroyPage : Number;
		
		/**
		 * Starts the animation
		 * @param s : the Storyboard to play
		 */
		public function start( s : Storyboard, t:int=0 ) : void
		{
			this.storyboard = s;
		}
		
		/**
		 * Starts the animation that must play when leaving a Page
		 * @param s : the Storyboard to play
		 */
		public function startOnUnload( s : Storyboard, t:int=0 ) : void
		{
			this.storyboard = s;
		}
		/**
		 * Positions the animation pointer at a given
		 * time and pauses the animation
		 * @param s : going at a time while stopping
		 */
		public function goToTimeAndStop( s : Storyboard , t : int = 0) : void
		{
			this.storyboard = s;
		}
		/**
		 * Stops the playing if all stories
		 * @param s the Storyboard to play
		 */
		public function stop(s : Storyboard) : void
		{
			this.storyboard = s;
		}
		
		/**
		 * Resets the storyboard when changing project
		 * @param s the Storyboard to play
		 */
		public function reset(s : Storyboard) : void
		{
			this.storyboard = s;
		}
		
		/**
		 * Resets the storyboard when changing project
		 * @param s the Storyboard to play
		 */
		public function resetOriginalValues(s : Storyboard) : void
		{
			this.storyboard = s;
		}
		/**
		 * Returns the last animated time in the page
		 * @param s : the Storyboard to play
		 */
		public function getMaxTime() : Number
		{
			return maxTime;
		}
		
		public function getDelayBeforeDestroy():Number
		{
			return delayBeforeDestroyPage;
		}
		
		/**
		 * Returns the currently playing storyboard
		 * @return  a reference to the storyboard
		 */
		public function getStoryboard() : Storyboard
		{
			return storyboard;
		}
		

	}
}