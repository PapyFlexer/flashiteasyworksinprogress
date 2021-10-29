package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.popUp.components.AboutComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;

	/**
	 * Flash'Iteasy
	 * Fie team is
	 * dany, didier, gilles
	 * & many thanks to alexis, ghazi, jean-françois
	 */public class AboutPopUp extends PopUp
	{
		
		private var _description : String;
		private var content: AboutComponent = new AboutComponent();
		
		/**
		 * 
		 * @param parent
		 * @param modal
		 * @param centered
		 * @param closeOnOk
		 */
		public function AboutPopUp(parent:DisplayObject=null, modal:Boolean=false, centered:Boolean=true , closeOnOk : Boolean = false)
		{
			super(parent, modal, centered,closeOnOk);
			super.addChild(content);
            BindingUtils.bindProperty( super.window, "title", content, "description" );
			super.display();
		}
		
		
		/**
		 * 
		 * @param value
		 */
		public function set description(value : String ) : void 
		{
			content.description=value;
		}
		
		
	}
}