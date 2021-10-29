package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.event.TriggerEvent;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.triggers.StoryTrigger;
	import com.flashiteasy.api.utils.StoryboardUtils;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.events.ListEvent;

	public class StoryEventEditorPopup extends PopUp
	{
		
		private var storyList : List ;
		private var keyFramesCombo : ComboBox;
		private var nameInput : TextInput;
		
		public function StoryEventEditorPopup(parent:DisplayObject=null, modal:Boolean=false, centered:Boolean=true, closeOnOk:Boolean=true)
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
            
            // StoryBox 
            var storyBox : HBox = new HBox();
            storyList=new List();
            storyList.percentWidth = 100;
            storyList.dataProvider = BrowsingManager.getInstance().getCurrentPage().getStoryArray();
            storyList.labelField = "uuid";
            storyList.addEventListener(ListEvent.ITEM_CLICK, doBuildKeyframesCombo);
            keyFramesCombo = new ComboBox;
            //keyFramesCombo.dataProvider = 
            BindingUtils.bindProperty( buttonOk, "enabled", nameInput, "text" );
            storyList.selectedIndex = 0;  
            storyList.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK));
            super.addChild(storyList);
            super.addChild(keyFramesCombo);
            super.showOk();
            super.display();
		}
		/**
		 * Handles item OK button click
		 */
		override protected function clickOnOk(e:MouseEvent) : void
        {
        	var trigger  : StoryTrigger = new StoryTrigger();
        	trigger.uuid = nameInput.text;
        	trigger.events = getStoryTriggerEvents();
        	dispatchEvent( new TriggerEvent(trigger, TriggerEvent.ADD_OR_UPDATE) );
            super.clickOnOk(e);
        }
        
        /**
         * Sets story trigger
         */
        public function setTrigger( trigger : StoryTrigger) : void
        {
        	storyList.selectedItems = trigger.events;
        	nameInput.text = trigger.uuid;
        }
		
		private function doBuildKeyframesCombo( e : ListEvent ) : void
		{
			var storyStr : String = Story(storyList.selectedItem).uuid;
			var st : Story = StoryboardUtils.findStoryByName(storyStr);
			var kfArray : Array = st.getAllKeyframes();
			var dp : Array = new Array;
			var i : uint = 0;
			for each (var key : int in kfArray)
			{
				var o : Object = new Object();
				o.label = String( i + " : " + key + " ms" );
				o.data = st;
				dp.push(o);
				i++;
			} 
			keyFramesCombo.dataProvider = dp;
		}
		
		private function getStoryTriggerEvents() : Array
		{
			var evts : Array = new Array;
			var selectedStory : String = Story(storyList.selectedItem).uuid;
			var keyframeTrigger : String = "fie_story_keyframe";//keyFramesCombo.selectedItem.label;
			//evts = [keyframeTrigger];
			evts = [String(selectedStory+"::"+keyframeTrigger)];
			return evts;
		}
		
		private function  setStoryTriggerEvents() : Array
		{
			var dp : Array = new Array;
			var stArr : Array = BrowsingManager.getInstance().getCurrentPage().getStoryArray();
			var i : uint = 0;
			for each (var s : Story in stArr)
			{
				
			}
			return []
		}
	}
}