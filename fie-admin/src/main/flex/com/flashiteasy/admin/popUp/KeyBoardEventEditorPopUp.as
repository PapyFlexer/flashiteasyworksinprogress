package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.event.TriggerEvent;
	import com.flashiteasy.admin.utils.IconUtility;
	import com.flashiteasy.api.triggers.KeyBoardTrigger;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.Text;
	import mx.controls.TextInput;

	public class KeyBoardEventEditorPopUp extends PopUp
	{
		private var eventList : List ;
		private var nameInput : TextInput;
		private var keyInput : Text;
		
		public function KeyBoardEventEditorPopUp(parent:DisplayObject=null, centered:Boolean=true, closeOnOk:Boolean=true)
		{
			super(parent, true, centered, closeOnOk);
			var nameBox : HBox = new HBox();
			super.addChild(nameBox);
			var nameLabel : Label = new Label();
			nameLabel.text = Conf.languageManager.getLanguage("Name")+" : ";
            nameInput = new TextInput();
            nameBox.addChild(nameLabel);
            nameBox.addChild(nameInput);
            
            eventList=new List();
            eventList.percentWidth = 100;
            eventList.allowMultipleSelection = true;
            eventList.dataProvider = ArrayUtils.getConstant(KeyboardEvent);
            super.addChild(eventList);
            var keyBox : HBox = new HBox();
            keyBox.percentWidth = 100;
            super.addChild(keyBox);
            var keyLabel : Label = new Label();
            var keyButton : Button = new Button();
            keyButton.setStyle("icon",IconUtility.getClass(keyButton, 'assets/edit.png'));
            keyButton.toggle = true;
            keyButton.toolTip = Conf.languageManager.getLanguage("Click_and_type_on_the_desired_key");
            keyButton.addEventListener(Event.CHANGE, setKeyListener);
            keyLabel.text = Conf.languageManager.getLanguage("Key")+" : ";
            keyInput = new Text();
            keyInput.percentWidth = 100;
            keyBox.addChild(keyLabel);
            
            keyBox.addChild(keyInput);
            keyBox.addChild(keyButton);
            BindingUtils.bindProperty( buttonOk, "enabled", nameInput, "text" );  
            super.showOk();
            super.display();
            
		}
		
		private function setKeyListener(e:Event) : void
		{
			if(e.target.selected)
			{
				Ref.ADMIN_STAGE.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			}
			else
			{
				Ref.ADMIN_STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			}
		}
		
		private function keyDown(keyEvent : KeyboardEvent) : void
		{
			var modifier:String="";
			var keyPressed:String="";
			if (keyEvent.ctrlKey) {
				modifier="ctrlKey+";
			} else if (keyEvent.altKey) {
				modifier="altKey+";
			} else if (keyEvent.shiftKey) {
				modifier="shiftKey+";
			} else {
				modifier="";
			}
		
			keyPressed=keyEvent.keyCode.toString();
		
			keyInput.text=modifier+keyPressed;
		}
		/**
		 * Handles item OK button click
		 */
		override protected function clickOnOk(e:MouseEvent) : void
        {
        	var trigger : KeyBoardTrigger = new KeyBoardTrigger();
        	trigger.uuid = nameInput.text;
        	trigger.key = keyInput.text;
        	trigger.events = eventList.selectedItems;
        	dispatchEvent( new TriggerEvent(trigger, TriggerEvent.ADD_OR_UPDATE) );
        	
            Ref.ADMIN_STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
            super.clickOnOk(e);
        }
        
        /**
         * Sets mouse trigger
         */
        public function setTrigger( trigger : KeyBoardTrigger ) : void
        {
        	eventList.selectedItems = trigger.events;
        	nameInput.text = trigger.uuid;
        	keyInput.text = trigger.key;
        }
		
	}
}