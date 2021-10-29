/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.selection
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.core.project.storyboard.Story;
	
	import flash.utils.Dictionary;

	/**
	 * The <code><strong>StoryList</strong></code> class is the
	 * pseudo-singleton class
	 * that manages and keeps track of all the stories
	 * of a given page.  
	 */
	public class StoryList
	{
		private static var instance : StoryList;
		/**
		 * singleton implementation 
		 */
		protected static var allowInstantiation : Boolean = false;
		
		/**
		 * Constructor singleton
		 */
		public function StoryList()
		{
            if( !allowInstantiation )
            {
                throw new Error("Instance creation not allowed, please use singleton method.");
            }
		}
		
		/**
		 * Singleton implementation
		 * @return a single StoryList instance
		 */
        public static function getInstance() : StoryList
        {
            if( instance == null )
            {
                allowInstantiation = true;
                instance = new StoryList();
                allowInstantiation = false;
            }
            return instance;
        }

        /**
         * 
         * @default 
         */
        protected var stories:Dictionary = new Dictionary(true);
        
        /**
         * Adds a story in the specified page
         */
        public function addStory(story: Story, page : Page ):void
        {
            if( stories [ page ] == null )
            {
                stories [ page ] = new Array();
            }
            stories[page].push(story);
        }
        
        /**
         * Get stories of a page
         */
        public function getStories(page : PageList) : Array
        {
			if( stories [ page ] == null )
			{
				stories [ page ] = new Array();
			}
			// Create a copy of the array
			return stories[page].slice(0);
         }
        
        /**
         * Returns the number of stories in the StoryList
         * @return int StoryList length
         */
        public function length():int
        {
            return stories.length;
        }
        
         
        /**
         * Returns a story in a page based on its uuid
         */
        public function getStory(uuid:String,page:PageList):Story
        {
	       	if (uuid == null || uuid == "") 
	        	{
	        		return null;
	        	}
	            var story:Story;
            var pageElements : Array = stories[page];
            for each(story in pageElements) 
            {
                if (story.uuid == uuid)
                {
                	//trace ("Story found for uuid = "+uuid);
                    return story;
                    break;
                }
            }
           return null;
        }
        
        /**
         * Removes a story from the StoryList, based on its uuid
         * @param uuid
         * @param page
         */
        public function removeStory(story:Story,page:Page):void
        {
            var i:int;
            var pageElements:Array = stories[page];
            page.getStoryboard().removeStory(story);
           // AbstractBootstrap.getInstance().getTimerStoryboardPlayer().getStoryboard().removeStoryFromUuid(uuid);
            for(i=0; i < pageElements.length; i++)
            {

                if (pageElements[i] == story)
                {
                    pageElements.splice(i, 1);
                    return ;
                }
            }
        }
        
         
        /**
         * Removes a story from the StoryList, based on its uuid
         * @param uuid
         * @param page
         */
        public function removeStoryById(uuid:String,page:Page):void
        {
            var i:int;
            var pageElements:Array = stories[page];
            page.getStoryboard().removeStoryFromUuid(uuid);
           // AbstractBootstrap.getInstance().getTimerStoryboardPlayer().getStoryboard().removeStoryFromUuid(uuid);
            for(i=0; i < pageElements.length; i++)
            {

                if (pageElements[i].uuid == uuid)
                {
                    pageElements.splice(i, 1);
                    return ;
                }
            }
        }
        
        /**
         * Returns the Story whose uuid is passed as argument full list of Updates instances
         * @param uuid the uuid of the story whose updates must be listed 
         * @param page the current page
         * @return an array of updates
         */
        public function getStoryUpdates(uuid:String,page:Page):Array
        {
        	var updates : Array = new Array;
        	var s : Story = getStory(uuid,page);
        	return s.getUpdates();
        }
        
        
        /**
         * @private
         * parsing utility
         * 
         * @param el
         * @param page
         * @return 
         */
        private function getElementNode( el : * , page:PageList) : String 
        {
             return "<node label='"+el.uuid+"' type='Story' />";
        }
        
        /**
         * Retuns an array of Stories' uuid
         * @param page
         * @return 
         */
        public function getStoriesId(page:PageList) : Array
		{
			var i:int;
			var elId:Array = new Array();
			var pageElements : Array = getStories(page);
			for(i=0; pageElements != null && i < pageElements.length; i++)
			{

				elId.push(pageElements[i].uuid);
				
			}
			return elId;
		}
        
		/**
		 * Unserializes stories. Used in copy/paste commands
		 * @param page
		 * @return 
		 */
        public function getXML(page:Page): XMLList
        {
            var elem:Array = stories[page]
            if ( elem != null )
            {
		        var pageNode:String="<root>";
	            for (var i : int = 0 ; i < elem.length ; i++ )
	            {
	                pageNode+=getElementNode(elem[i],page);
	            }
	            pageNode+="</root>";
	            return new XML(pageNode).children();
            }
            else
            {
            	return null;
            }
        }

	}
}
