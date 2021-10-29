package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.popUp.components.InputComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.events.FlexEvent;

	public class InputStringPopUp extends PopUp
	{
		
		public static var SUBMIT : String = "input_submit";
		
		private var content: InputComponent = new InputComponent();
		
		public function InputStringPopUp(parent:DisplayObject=null, modal:Boolean=false, centered:Boolean=true , closeOnOk : Boolean = false)
		{
			super(parent, modal, centered,closeOnOk);
			super.addChild(content);
			content.addEventListener(FlexEvent.CREATION_COMPLETE, displayPopUp);
            BindingUtils.bindProperty( super.window, "title", content, "description" );
			super.showOk();
			//super.display();
		}
		
		private function displayPopUp(e:Event):void
		{
			super.display();
		}
		
		public function setError ( error : String ) : void 
		{
			content.setError( error ) ;
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
			//content.inputError=value;
		}
		public function getInput():String
		{
			return content.input_error.text;
		}
		public function setInputDefaultValue(value:String):void
		{
			content.inputValue=value;
		}
		override protected function clickOnOk(e:MouseEvent):void
		{
			
			
			dispatchEvent(new Event(SUBMIT));
			super.clickOnOk(e);
		}
		
	}
}