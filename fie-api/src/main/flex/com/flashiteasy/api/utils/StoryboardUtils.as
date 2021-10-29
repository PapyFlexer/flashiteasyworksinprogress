/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Transition;
	import com.flashiteasy.api.core.project.storyboard.Update;
	
	/**
	 * The <code><strong>StoryboardUtils</strong></code> class is
	 * an utility class dealing with storyboards, stories, updates and transitions
	 */
	public class StoryboardUtils
	{
		
		
		/**
		 * Return the maximum and minimum cue points in a story (in milliseconds)
		 * @param s story instance
		 * @return an Object formatted this way <listing>var o:Object = {begin:2000, end:10000}</listing>
		 */
		public static function computeStoryDuration ( s : Story ) : Object
		{
			var o:Object = {begin:10000, end:-10000};
			//var s:Story = StoryboardUtils.findStoryByName(storyName);
			if (s==null)
			{
				trace ("no transition !!!")
				return o;
			} else {
				for each (var u:Update in s.getUpdates())
				{
					for each (var t:Transition in u.getTransitions())
					{
						o.begin = Math.min(o.begin, t.begin);
						o.end = Math.max (o.end, t.end);
					}
				}
			}
			return o;
		}
		
		/**
		 * Returns a story instance using its name (uuid)
		 * @param storyName
		 * @return the srtory instance whose name is passed as argument
		 */
		public static function findStoryByName (storyName : String) : Story
		{
			var page:Page = BrowsingManager.getInstance().getCurrentPage();
			var stories:Array = page.getStoryArray();
			for ( var i : uint =0; i<stories.length; i++)
			{
				if (storyName == (stories[i] as Story).uuid)
				{
					return stories[i] as Story;
					break;
				}
			}
			return null;
		}

		/**
		 * Return the story (or a clone) reversed 
		 * @param s story instance
		 * @param cloneIt a Boolean that states if the returned story is cloned (duplicated) or not
		 * @return the story instance, or a clone
		 */
		public static function reverseStory ( s : Story, cloneIt : Boolean ) : Story
		{
			trace ("reversing story "+ s.uuid) ;
			// init vars
			//var story : Story = CloneUtils.clone(s) ;
			var page : Page = BrowsingManager.getInstance().getCurrentPage();
			var story : Story = new Story;
			story.uuid = NameUtils.findUniqueName( s.uuid, StoryboardUtils.getUUIDs( s.getPage().getStoryArray() ));
			var valuesArray : Array = new Array;
			var timesArray : Array = new Array;
			var easingTypesArray : Array = new Array;
			var updateReverses : Array = new Array;
			// cycle through the story to fill the Arrays
			for each (var u : Update in s.getUpdates())
			{
				trace ("update"+u.getId())
				updateReverses.unshift(u);
				var updateTimes:Array=new Array;
				for each (var t : Transition in u.getTransitions())
				{
					trace ("trans ");
					valuesArray.push(t.beginValue);
					valuesArray.push(t.endValue);
					updateTimes.push(t.begin);
					updateTimes.push(t.end);
					easingTypesArray.push( t.easingClass );
					easingTypesArray.push( t.easingType );
				}
				timesArray = timesArray.concat(StoryboardUtils.reverseTimes( updateTimes).reverse());
			}
			// clone it or not ?
			valuesArray = valuesArray.reverse();
			timesArray = timesArray.reverse();
			//timesArray = StoryboardUtils.reverseTimes( timesArray );
			//timesArray.sort(Array.NUMERIC);
			//easingTypesArray = StoryboardUtils.reverseEasingType(easingTypesArray);
			story.setElementDescriptor(s.getElementDescriptor());
			// set the array counts
			var upd_idx : uint = 0;
			var idx : uint = 0;
			var updatesArray : Array = [];
			// cycle thru updates & transitions
			story.init(story.uuid, story.getElementDescriptor(), s.loop, s.autoPlay, s.autoPlayOnUnload);
			//var updateReverses : Array = s.getUpdates().reverse();
			trace("Update Array :: "+s.getUpdates()+ " sorted :: "+updateReverses);
			for each (var up : Update in updateReverses)
			{
				var update : Update = new Update();
				update.story = story;
				update.init( up.getParameterSetName(), up.getPropertyName(), String(story.uuid+idx), story ); 
				
				var transArray : Array = new Array;
				for each (var tr : Transition in up.getTransitions())
				{
					trace ("trans #"+upd_idx);
					var trans : Transition = new Transition();
					trans.init(up.getParameterSet(), up.getPropertyName(), story, up);
					trans.beginValue = valuesArray[idx];
					trans.endValue = valuesArray[idx+1];
					trans.begin = timesArray[idx];
					trans.end = timesArray[idx+1];
					trans.easingClass = tr.easingClass;
					trans.easingType = StoryboardUtils.reverseEasingType(tr.easingType);
					trans.originalValue = trans.beginValue;
					
					idx += 2;
					transArray.push( trans );
				}
				update.setTransitions( transArray );
				story.addUpdate( update );
				upd_idx++;
				//idx++;
			}
			//story.createStory( page );
 			//page.getStoryboard().addStory( story )
 			
			return story;
		}
		/**
		 * Return the story (or a clone) reversed 
		 * @param s story instance
		 * @param cloneIt a Boolean that states if the returned story is cloned (duplicated) or not
		 * @return the story instance, or a clone
		 */
		public static function reverseStorySimple ( s : Story ) : void
		{
			var valuesArray : Array = new Array;
			var timesArray : Array = new Array;
			var easingTypesArray : Array = new Array;
			var updateReverses : Array = new Array;
			// cycle through the story to fill the Arrays
			for each (var u : Update in s.getUpdates())
			{
				trace ("update"+u.getId())
				updateReverses.unshift(u);
				var updateTimes:Array=new Array;
				for each (var t : Transition in u.getTransitions())
				{
					trace ("trans ");
					valuesArray.push(t.beginValue);
					valuesArray.push(t.endValue);
					updateTimes.push(t.begin);
					updateTimes.push(t.end);
					easingTypesArray.push( t.easingClass );
					easingTypesArray.push( t.easingType );
				}
				timesArray = timesArray.concat(StoryboardUtils.reverseTimes( updateTimes).reverse());
			}
			// clone it or not ?
			valuesArray = valuesArray.reverse();
			timesArray = timesArray.reverse();
			// set the array counts
			var upd_idx : uint = 0;
			var idx : uint = 0;
			var updatesArray : Array = [];
			// cycle thru updates & transitions
			for each (var up : Update in updateReverses)//s.getUpdates())
			{
				var transArray : Array = new Array;
				for each (var tr : Transition in up.getTransitions())
				{
					trace ("trans #"+upd_idx);
					var trans : Transition = new Transition();
					trans.init(up.getParameterSet(), up.getPropertyName(), s, up);
					trans.beginValue = valuesArray[idx];
					trans.endValue = valuesArray[idx+1];
					trans.begin = timesArray[idx];
					trans.end = timesArray[idx+1];
					trans.easingClass = tr.easingClass;
					trans.easingType = StoryboardUtils.reverseEasingType(tr.easingType);
					trans.originalValue = trans.beginValue;
					
					idx += 2;
					transArray.push( trans );
				}
				up.setTransitions( transArray );
				upd_idx++;
				//idx++;
			}
		}
		
		/**
		 * Return an array composed of the stories uuids 
		 * @param storyArray story array instance
		 * @return the array of stories uuids instance
		 */
		private static function getUUIDs( storyArray : Array ) : Array
		{
			var a : Array = new Array;
			for each (var s : Story in storyArray)
			{
				a.push(s.uuid);
			}
			return a;
		}
		
		/**
		 * @private
		 */
		private static function reverseTimes( timesArray : Array ) : Array
		{
			var a : Array = new Array;
			var l : uint = timesArray.length;
			for (var i:uint = l; i>0; i--)
			{
				//a.push(timesArray[l-1] - timesArray[i]);
				a.push(Math.abs(timesArray[i-1]-timesArray[l-1]));
			}
			return a;
		}
		
		/**
		 * @private
		 */
		private static function reverseEasingType(easingType : String) : String
		{
			var type : String = "";
			switch (easingType)
			{
				case "easeIn" :
					type = "easeOut";
					break;
				
				case "easeOut" :
					type = "easeIn";
					break;
					
				default :
					type = easingType;
					break;
				
			}
			
			return type;
		}
		
		/**
		 * Returns a clone of the selected story 
		 * @param s story instance
		 * @return the cloned instance
		 */
		public static function cloneStory( s : Story) : Story
		{
			var story : Story = new Story;
			story = CloneUtils.clone(s);
			story.setElementDescriptor(s.getElementDescriptor());
			return story;
		}
		
	}
}