/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.events {

	import flash.events.Event;
	
	/**
	 * This class groups FIE-specific events while extending the pureAS3 Event
	 */
	public class FieEvent extends Event {
		
		/**
		* The FieEvent.COMPLETE constant is fired when
		* the object
		* for a <code>loadComplete</code> event.
		*
		* <p>The properties of the event object have the following values:</p>
		* <table class=innertable>
		* <tr><th>type</th><th>empty string</th></tr>
		* <tr><th>info</th><th>null</th></tr>
  		* <tr><th>cancelable</th><th>false</th></tr>
  		* <tr><th>bubbles</th><th>false</th></tr>
  		* </table>
		*
		* @eventType fie_load_complete
		*/
		[Event(name="fie_load_complete", type="flash.events.Event")]
		public static const COMPLETE:String = "fie_load_complete";
		
		/**
		* The FieEvent.PARAMETER_APPLIED constant is fired when
		* one of the ParameterSet property has been refreshed.
		* <p>The properties of the event object have the following values:</p>
		* <table class=innertable>
		* <tr><th>type</th><th>empty string</th></tr>
		* <tr><th>info</th><th>null</th></tr>
  		* <tr><th>cancelable</th><th>false</th></tr>
  		* <tr><th>bubbles</th><th>false</th></tr>
  		* </table>
		*
		* @eventType fie_parameter_applied
		*/
		[Event(name="fie_parameter_applied", type="flash.events.Event")]
		public static const PARAMETER_APPLIED : String ="fie_parameter_applied";
		/**
		 * 
		 * @default 
		 */
		public static const MOVED:String = "fie_component_moved";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_container_resize", type="flash.events.Event")]
		public static const CONTAINER_RESIZE : String = "fie_container_resize";
		/**
		 * 
		 * @default 
		 */
		public static const CONTAINER_INCREASE : String = "fie_container_increase";
		/**
		 * 
		 * @default 
		 */		
		[Event(name="fie_destroyed", type="flash.events.Event")]
		public static const REMOVED:String = "fie_destroyed";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_padding_move", type="flash.events.Event")]
		public static const PADDING_MOVED:String= "fie_padding_move";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_resize", type="flash.events.Event")]
		public static const RESIZE:String= "fie_resize";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_scale", type="flash.events.Event")]
		public static const SCALE:String= "fie_scale";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_page_change", type="flash.events.Event")]
		public static const PAGE_CHANGE:String="fie_page_change";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_page_unload", type="flash.events.Event")]
		public static const PAGE_UNLOAD:String="fie_page_unload";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_page_parsed", type="flash.events.Event")]
		public static const PAGE_PARSED:String="fie_page_parsed";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_page_removed", type="flash.events.Event")]
		public static const PAGE_REMOVED:String="fie_page_removed";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_page_loaded", type="flash.events.Event")]
		public static const PAGE_LOADED:String="fie_page_loaded";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_page_init", type="flash.events.Event")]
		public static const PAGE_INIT:String="fie_page_init";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_control_init", type="flash.events.Event")]
		public static const CONTROL_INIT : String="fie_control_init";
		
		
		/**
		 * 
		 * @default 
		 */
		[Event(name="transitions_ended", type="flash.events.Event")]
		public static const TRANSITIONS_ENDED:String="transitions_ended";
		/**
		 * 
		 * @default 
		 */
		[Event(name="story_ended", type="flash.events.Event")]
		public static const STORY_ENDED:String = "story_ended";
		
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_render", type="flash.events.Event")]
		public static const RENDER:String = "fie_render";
		
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_resize_stage", type="flash.events.Event")]
		public static const RESIZE_STAGE_CONTAINER:String = "fie_resize_stage";
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_controlname_change", type="flash.events.Event")]
		public static const CONTROLNAME_CHANGE:String = "fie_controlname_change";
		
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_error_actionHasNoTrigger", type="flash.events.Event")]
		public static const ERROR_ACTION_NO_TRIGGER:String = "fie_error_actionHasNoTrigger";
		
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_error_actionHasNoTarget", type="flash.events.Event")]
		public static const ERROR_ACTION_NO_TARGET:String = "fie_error_actionHasNoTarget";
		
		/**
		 * 
		 * @default 
		 */
		[Event(name="fie_error_storyHasNoTarget", type="flash.events.Event")]
		public static const ERROR_STORY_NO_TARGET:String = "fie_error_storyHasNoTarget";
		
		/**
		 * 
		 * @default 
		 */
		public var info:Object;
		
		/**
		 * 
		 * @param type
		 * @param info
		 * @param bubbles
		 * @param cancelable
		 */
		public function FieEvent(type:String, info:Object = null, bubbles:Boolean = false, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
			this.info = info;
		}
		
		// Override the inherited clone() method.
        public override function clone():Event {
            return new FieEvent(type, info, bubbles, cancelable);
        }
	}	
}
