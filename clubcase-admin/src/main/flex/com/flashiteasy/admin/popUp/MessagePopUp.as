package com.flashiteasy.admin.popUp
{
	import flash.display.DisplayObject;
	
	import mx.controls.Text;

	public class MessagePopUp extends PopUp
	{
		
		private var message:String;
		private var tf:Text= new Text();
		
		
		public function MessagePopUp(message:String , parent:DisplayObject = null , modal:Boolean=false, centered:Boolean=true, pageChangeClosing:Boolean=true)
		{
			super(parent, modal, centered, true, pageChangeClosing);
			this.message=message;
			super.window.setStyle("headerHeight", 0);
			tf.text=message;
			super.closeButton(false);
			super.addChild(tf);
			super.display();
		}
		
		public function changeMessage(message:String):void{
			tf.text=message;
		}
		
	}
}