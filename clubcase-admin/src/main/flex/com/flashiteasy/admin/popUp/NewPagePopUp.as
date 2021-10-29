package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.popUp.components.NewPageComponent;
	import com.flashiteasy.admin.utils.TextInputErrorUtils;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;

	public class NewPagePopUp extends PopUp
	{
		public static var SUBMIT : String = "input_submit";
		
		private var content : NewPageComponent ;
		
		public function NewPagePopUp(parent:DisplayObject , modal:Boolean=false, centered:Boolean=true, closeOnOk:Boolean=false)
		{
			super(parent, modal, centered, closeOnOk);
			content=new NewPageComponent();
			super.addChild(content);
            BindingUtils.bindProperty( super.window, "title", content, "description" );
			super.showOk();
			super.display();
		}
		public function set description(value : String ) : void 
		{
			content.description=value;
		}
		public function set label(value:String) : void
		{
			content.inputLabel = value;
		}
		public function set error(value:String) : void
		{
			content.inputError=value;
		}
		public function getInput():String
		{
			return content.input.text;
		}
		public function setInputDefaultValue(value:String):void
		{
			content.inputValue=value;
		}
		override protected function clickOnOk(e:MouseEvent):void
		{
			var name : String = content.input.text;
			if(ArrayUtils.containsString(name ,PageUtils.getPagesLink(content.parentPage)))
			{
				TextInputErrorUtils.showError( content.input , Conf.languageManager.getLanguage("The_name_") + name + Conf.languageManager.getLanguage("_is_already_in_use"));
				//content.Conf.languageManager.getLanguage("The_name_") + name + Conf.languageManager.getLanguage("_is_already_in_use");
			}
			else
			{
				dispatchEvent(new Event(SUBMIT));
				super.clickOnOk(e);
			}
			
		}
		
		public function isOnStage():Boolean
		{
			return content.mode1.selected;
		}
		
		public function setIsOnStage(selected:Boolean):void
		{
			if(selected)
			{
				content.mode1.selected = true;
			}
			else
			{
				content.mode2.selected = true;
			}
		}
		
		public function isSubPage():Boolean
		{
			return content.position2.selected;
		}
		
		
		public function setIsSubPage(select:Boolean):void
		{
			if(select)
			{
				content.isSubPage = true;
				content.position2.dispatchEvent(new Event(Event.CHANGE));
			}
			else
			{
				content.isSubPage = false;
				content.position1.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function pageContainer():String 
		{
			if(content.mode2.selected){
				return content.container_list.selectedItem as String;
			}
			else
			{
				return "stage";
			}
			
		}
		
		public function setPageContainer(container: String) : void
		{
			content.mode2.selected = true;
			content.selectContainer(container);
		}
		
	}
}