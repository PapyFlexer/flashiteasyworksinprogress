package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.event.TriggerEvent;
	import com.flashiteasy.api.triggers.TimerTrigger;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.TextInput;

	public class TimerEventEditorPopUp extends PopUp
	{
		private var nameInput : TextInput;
		private var delayInput : TextInput ;
		
		public function TimerEventEditorPopUp(parent:DisplayObject=null, centered:Boolean=true, closeOnOk:Boolean=true)
		{
			super(parent, true, centered, closeOnOk);
			
			// Name box
			var nameBox : HBox = new HBox();
			super.addChild(nameBox);
			var nameLabel : Label = new Label();
			nameLabel.text = "Nom  : ";
            nameInput = new TextInput();
            nameBox.addChild(nameLabel);
            nameBox.addChild(nameInput);
            
            // Delay Box
            var delayBox : HBox = new HBox();
            super.addChild(delayBox);
            var delayLabel : Label = new Label();
            delayLabel.text = "Délai : ";
            delayInput=new TextInput();
            delayInput.percentWidth = 100;
            delayBox.addChild(delayLabel);
            delayBox.addChild(delayInput);
            
            BindingUtils.bindProperty( buttonOk, "enabled", nameInput, "text" );  
            super.showOk();
            super.display();
		}
		
		/**
		 * Handles item OK button click
		 */
		override protected function clickOnOk(e:MouseEvent) : void
        {
        	var trigger : TimerTrigger = new TimerTrigger();
        	trigger.uuid = nameInput.text;
        	trigger.delay = parseFloat(delayInput.text);
        	dispatchEvent( new TriggerEvent(trigger, TriggerEvent.ADD_OR_UPDATE) );
            super.clickOnOk(e);
        }
        
        /**
         * Sets mouse trigger
         */
        public function setTrigger( trigger : TimerTrigger ) : void
        {
        	nameInput.text = trigger.uuid;
        	delayInput.text = trigger.delay.toString();
        }
		
	}
}