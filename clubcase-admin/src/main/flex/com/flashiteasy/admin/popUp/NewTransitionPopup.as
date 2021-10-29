package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.popUp.components.NewTransitionComponent;
	import com.flashiteasy.admin.utils.LabelUtils;
	import com.flashiteasy.api.core.project.storyboard.Update;
	
	import flash.events.Event;
	
	import mx.containers.TitleWindow;

	public class NewTransitionPopup extends PopUp
	{
		public static var TRANSITION_CREATED : String = "transition_created";
		
		private var component : NewTransitionComponent = new NewTransitionComponent;
		private var update : Update ;
		
		public function NewTransitionPopup( update : Update )
		{
			super(null , true , true , true );
			width = 200;
			height = 250 ;
			this.update = update ;
			component.update=update;
			component.allowedMinTime = update.calculateMaxTime();
			component.addEventListener(NewTransitionComponent.TRANSITION_CREATED , transitionCreated );
			super.window.title=LabelUtils.getLang('new_transition');
			super.addChild(component);
			super.display();
		}
		
		public function set allowedMinTime( value : int ) : void 
		{
			component.allowedMinTime = value ;
		}
		
		private function transitionCreated( e : Event ) : void 
		{
			super.closePopUp();		
			dispatchEvent(new Event(TRANSITION_CREATED));
		}
		
		override protected function onClose():void
		{
			component.removeEventListener(NewTransitionComponent.TRANSITION_CREATED , transitionCreated ) ;
		}
		
	}
}