/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.project.storyboard
{
	/**
	 * Flash'Iteasy
	 * @author gillesroquefeuil
	 */
	public class StoryTypes
	{
		/**
		 * 
		 * @default 
		 */
		public static const PAGE_IN:String = "PageInStory";
		/**
		 * 
		 * @default 
		 */
		public static const PAGE_OUT:String = "PageOutStory";
		/**
		 * 
		 * @default 
		 */
		public static const TIMER:String = "TimedStory";
		/**
		 * 
		 * @default 
		 */
		public static const TRIGGER:String = "TriggeredStory";
		
		/**
		 * 
		 * @default 
		 */
		public static const STORY_TYPES:Array = [PAGE_IN, PAGE_OUT, TIMER, TRIGGER];
	}
}
