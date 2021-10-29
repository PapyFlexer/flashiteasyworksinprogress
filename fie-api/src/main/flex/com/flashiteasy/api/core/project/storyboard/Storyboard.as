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
	 * The <code><strong>Storyboard</strong></code> class represents all the animations to display in a given page.
	 * As so, it owns an array of stories, each of these stories independant frome the others.
	 * The animations of the page, depicted in code><strong>Storyboard</strong></code> instance, are played using the code><strong>StoryboardPlayer</strong></code> implementation.
	 */
	public class Storyboard
	{
		private var stories : Array = [];
		
		/**
		 * Adds an instance of Story to the storyboard instance
		 * @param s
		 */
		public function addStory( s : Story ) : void
		{
			stories.push( s );
		}
		
		/**
		 * Remove an instance of Story to the storyboard instance
		 * @param s
		 */
		public function removeStory( s : Story ) : void
		{
			 for(var i:uint = 0; i < stories.length; i++)
            {

                if (stories[i] == s)
                {
                    stories.splice(i, 1);
                    return ;
                }
            }
		}
		/**
		 * Remove an instance of Story to the storyboard instance
		 * @param s
		 */
		public function removeStoryFromUuid( uuid : String ) : void
		{
			 for(var i:uint = 0; i < stories.length; i++)
            {

                if (stories[i].uuid == uuid)
                {
                    stories.splice(i, 1);
                    return ;
                }
            }
		}
		/**
		 * Returns all the stories of the storyboard
		 * @return 
		 */
		public function getStories() : Array
		{
			return stories;
		}
		
		/**
		 * gets the list of stories owned by the Storyboard 
		 * and transforms it in a data-provider compatible format (XMLList) 
		 * so it can be used to fill a ComboBox (see in admin module)
		 * @return 
		 */
		public function getStoriesDP() : XMLList
		{
			return null;
		}

	}
}