/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.action.IStoppableElementAction;
	import com.flashiteasy.api.core.action.IStoryAction;
	import com.flashiteasy.api.core.action.ITimedElementAction;

	// metadata
    [ParameterSet(description="Play_To_Story",type="Reflection", groupname="Story")]
	/**
	 * The <code><strong>PlayStoryParameterSet</strong></code> is the parameterSet
	 * that handles the action of triggering an animation (Story).
	 * The metadata generates a combobox listing the possible targets (stories)
	 * on stage.
	 */
	public class PlayToStoryParameterSet extends ToggleStoryParameterSet  implements IStoppableElementAction
	{
		
		//private var _storyList:Array;
		private var _time : uint;
		private var _timeStop : uint;
		//private var _pageUrl:String;
		
		
        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            super.apply( target );
            if ( target is IStoryAction )
            {
            	/*if(_page != null )
            	{
            		IStoryAction( target ).setStoriesToTrigger(_storyList , _page ); 
            	}
            	else
            	{
            		IStoryAction( target ).setStoriesToTrigger(_storyList , target.getPage() ); 
            	}*/
                
                ITimedElementAction( target ).time = _time;
                IStoppableElementAction( target ).timeStop = _timeStop;
            }
        }
        
       /* public function get pageURL():String
        {
        	return _pageUrl;
        }
        
        private var _page : Page ;
        public function set pageURL( value : String ) : void 
        {
        	_pageUrl = value ;
        	if( value != null )
        	{
        		_page = BrowsingManager.getInstance().getPageByUrl(AbstractBootstrap.getInstance().getProject(),_pageUrl);
        	}
        	
        }
 
       [Parameter(type="ComboList", defaultValue="",row="0", sequence="0", label="Story")]*/
		/**
		 * the Array of stories to play
		 */
		/*public function get storyList():Array
		{
			return _storyList;
		}*/

		/**
		 * 
		 * @private
		 */
		/*public function set storyList(value:Array):void
		{
			_storyList=value;
		}
		*/
       [Parameter(type="Number", defaultValue="0",row="1", sequence="1", label="Time")]
		/**
		 * the time to play
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
		
       [Parameter(type="Number", defaultValue="2000",row="1", sequence="2", label="stop")]
		/**
		 * the time to play
		 */
		public function get timeStop():uint
		{
			return _timeStop;
		}

		/**
		 * 
		 * @private
		 */
		public function set timeStop(value:uint):void
		{
			_timeStop=value;
		}
		
		/**
		 * Returns the array of 
		 * @param name
		 * @return 
		 */
		/*public function getPossibleValues(name:String):Array
		{
			var page : Page ;
			if(_page == null )
			{
				page = BrowsingManager.getInstance().getCurrentPage();
			}
			else
			{
				page= _page;
			}
			
			
			var stories:Array = page.getStoryArray();
			var storyLabels : Array = new Array;
		
			for each (var story : Story in stories)
			{
				storyLabels.push(story.uuid);
			}
			return storyLabels;
		}*/
		
	}
}