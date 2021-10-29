package com.flashiteasy.api.events
{
	import flash.events.Event;

	/**
	 * The FieStageResizeManagerEvent class represents the events dispatched by the StageResizeManager class.
	 * 
	 * @see controller.StageResizeManager
	 * @author fie
	 */	

	public class FieStageResizeEvent extends Event
	{
		/**
		 * Creates a new FieStageResizeManagerEvent object.
		 * 
		 * @param type The type of the event.
		 * @param bubbles Indicates whether the event is a bubbling event.
		 * @param cancelable Indicates whether the behavior associated with the event can be prevented.
		 * 
		 */	
		public function FieStageResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	
		/**
		* Type of the event that is dispatched by a StageResizeManager object when the resize of the stage starts
		* <table class=innertable>
		* <tr><th>type</th><th>empty string</th></tr>
		* <tr><th>info</th><th>null</th></tr>
  		* <tr><th>cancelable</th><th>false</th></tr>
  		* <tr><th>bubbles</th><th>false</th></tr>
  		* </table>
		*
		* @eventType stageResizeStart
		*/
		[Event(name="fie_resize_stage", type="flash.events.Event")]
		public static const STAGE_RESIZE_START:String = "stageResizeStart";
		
		/**
		* Type of the event that is dispatched by a StageResizeManager object when the stage is being resized
		* <table class=innertable>
		* <tr><th>type</th><th>empty string</th></tr>
		* <tr><th>info</th><th>null</th></tr>
  		* <tr><th>cancelable</th><th>false</th></tr>
  		* <tr><th>bubbles</th><th>false</th></tr>
  		* </table>
		*
		* @eventType stageResizeProgress
		*/
		[Event(name="stageResizeProgress", type="flash.events.Event")]
		public static const STAGE_RESIZE_PROGRESS:String = "stageResizeProgress";
		
		/**
		* Type of the event that is dispatched by a StageResizeManager object when the resize of the stage is finished
		* <table class=innertable>
		* <tr><th>type</th><th>empty string</th></tr>
		* <tr><th>info</th><th>null</th></tr>
  		* <tr><th>cancelable</th><th>false</th></tr>
  		* <tr><th>bubbles</th><th>false</th></tr>
  		* </table>
		*
		* @eventType stageResizeEnd
		*/
		[Event(name="stageResizeEnd", type="flash.events.Event")]
		public static const STAGE_RESIZE_END:String = "stageResizeEnd";
		
		
		/**
		 * @private
		 */
		public override function clone():Event
		{
			
			return new FieStageResizeEvent( type, bubbles, cancelable );
			
		}
		
		/**
		 * @private
		 */
		public override function toString():String
		{
			
			return '[FieStageResizeManagerEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ']';
			
		}
		
	}
		
}