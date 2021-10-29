package com.flashiteasy.admin.event
{
	import com.flashiteasy.api.core.IAction;
	
	import flash.events.Event;

	public class ActionEvent extends Event
	{

        public static const REMOVE_ACTION:String = "removeAction";
		
		private var _action : IAction;
		
		public function ActionEvent( action : IAction, type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_action = action;
			super(type, bubbles, cancelable);
		}
		
		public function getAction() : IAction
		{
			return _action;
		}
		
	}
}