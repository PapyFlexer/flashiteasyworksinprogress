package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.popUp.components.StoryComponent;
	import com.flashiteasy.admin.utils.LabelUtils;
	import com.flashiteasy.admin.utils.TextInputErrorUtils;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;

	public class NewStoryPopUp extends PopUp
	{
		public static var SUBMIT:String="input_submit";

		private var content:StoryComponent;

		public function NewStoryPopUp(parent:DisplayObject, modal:Boolean=false, centered:Boolean=true, closeOnOk:Boolean=false)
		{
			super(parent, modal, centered, closeOnOk);
			content=new StoryComponent();
			//super.window.title = 
            BindingUtils.bindProperty( super.window, "title", content, "description" );//content.description;
			super.addChild(content);
			super.showOk();
			super.display();
		}

		public function set description(value:String):void
		{
			content.description=value;
		}

		public function set label(value:String):void
		{
			content.inputLabel=value;
		}
		
		public function getLoop():Boolean
		{
			return content.loop.selected;
		}

		public function getAutoplay():Boolean
		{
			return content.autoplay.selected;
		}
		
		public function getAutoplayOnUnload():Boolean
		{
			return content.autoplayonunload.selected;
		}
		
		public function getInput():String
		{
			return content.input.text;
		}

		public function setInputDefaultValue(value:String):void
		{
			content.inputValue=value;
		}

		public function getInterpolationName():String
		{
			return LabelUtils.getClassLabel(content.interpolCB.selectedItem);
		}

		public function getInterpolationType():Class
		{
			return Class(content.interpolCB.selectedItem);
		}

		public function getEasingType():String
		{
			return content.easingCB.selectedItem.toString();
		}

		public function getChoosedStory():Story
		{
			return Story(content.story_list.selectedItem);
		}

		public function isNewStory():Boolean
		{
			return content.story_list.selectedItem == Conf.languageManager.getLanguage("New");
		}

		override protected function clickOnOk(e:MouseEvent):void
		{
			var name:String=content.input.text;
			//If story is new and name exist we set an error
			if (ArrayUtils.containsString(name, StoryList.getInstance().getStoriesId(BrowsingManager.getInstance().getCurrentPage())) && content.story_list.selectedItem == "New")
			{
				TextInputErrorUtils.showError( content.input , Conf.languageManager.getLanguage("storie_name_already_used" ));
			}
			else
			{
				TextInputErrorUtils.resetErrors();
				dispatchEvent(new Event(SUBMIT));
				super.clickOnOk(e);
			}
		}

		private function resetError():void
		{
			content.input.errorString=null;
			content.input.setStyle("styleName", null);
		}


		private function removeError(e:Event):void
		{
			resetError();
			content.input.removeEventListener(Event.CHANGE, removeError);
		}

		private function setError(error:String):void
		{
			content.input.setStyle("styleName", "TextError");
			content.input.errorString=Conf.languageManager.getLanguage(error);
			content.input.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			content.input.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			if (!content.input.hasEventListener(Event.CHANGE))
			{
				content.input.addEventListener(Event.CHANGE, removeError);
			}
		}
	}
}