package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.event.TriggerEvent;
	import com.flashiteasy.api.triggers.MouseTrigger;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.TextInput;

	public class MouseEventEditorPopUp extends PopUp
	{
		private var eventList : List ;
		private var nameInput : TextInput;
		
		public function MouseEventEditorPopUp(parent:DisplayObject=null, centered:Boolean=true, closeOnOk:Boolean=true)
		{
			super(parent, true, centered, closeOnOk);
			var nameBox : HBox = new HBox();
			super.addChild(nameBox);
			var nameLabel : Label = new Label();
			nameLabel.text = "Nom : ";
            nameInput = new TextInput();
            nameBox.addChild(nameLabel);
            nameBox.addChild(nameInput);
            
            eventList=new List();
            eventList.percentWidth = 100;
            eventList.allowMultipleSelection = true;
            eventList.dataProvider = ArrayUtils.getConstant(MouseEvent);
            super.addChild(eventList);
            BindingUtils.bindProperty( buttonOk, "enabled", nameInput, "text" );  
            super.showOk();
            super.display();
		}
		
		/**
		 * Handles item OK button click
		 */
		override protected function clickOnOk(e:MouseEvent) : void
        {
        	var trigger : MouseTrigger = new MouseTrigger();
        	trigger.uuid = nameInput.text;
        	trigger.events = eventList.selectedItems;
        	dispatchEvent( new TriggerEvent(trigger, TriggerEvent.ADD_OR_UPDATE) );
            super.clickOnOk(e);
        }
        
        /**
         * Sets mouse trigger
         */
        public function setTrigger( trigger : MouseTrigger ) : void
        {
        	eventList.selectedItems = trigger.events;
        	nameInput.text = trigger.uuid;
        }
		
	}
}