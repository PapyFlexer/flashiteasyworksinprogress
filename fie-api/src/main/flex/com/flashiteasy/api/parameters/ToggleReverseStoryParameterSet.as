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
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.action.IStoryAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;

	// metadata
    [ParameterSet(description="Toggle_Reverse_Story",type="Reflection", groupname="Story")]
	/**
	 * The <code><strong>ToggleStoryParameterSet</strong></code> is the parameterSet
	 * that handles the action of pausing/resuming an animation (Story).
	 * The metadata generates a list component listing the possible targets (stories)
	 * on stage.
	 */
	public class ToggleReverseStoryParameterSet extends ToggleStoryParameterSet  implements IParameterSetStaticValues
	{
		
		//protected var _storyList:Array;
		//protected var _pageUrl:String;
		
        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            super.apply( target );
          /*  if ( target is IStoryAction )
            {
                
            	if(_page != null )
            	{
            		IStoryAction( target ).setStoriesToTrigger(_storyList , _page ); 
            	}
            	else
            	{
            		IStoryAction( target ).setStoriesToTrigger(_storyList , target.getPage() ); 
            	}
            }*/
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
 
		public function get storyList():Array
		{
			return _storyList;
		}

		public function set storyList(value:Array):void
		{
			_storyList=value;
		}
		

		public function getPossibleValues(name:String):Array
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
		}
		*/
	}
}