package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.events.FieEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	public class PopUp extends UIComponent
	{
		public static var CLOSED : String = "popup_closed";
		
		protected var window :TitleWindow;
		protected var buttonOk:Button=new Button();
		private var centered : Boolean ;
		private var modal:Boolean ;
		private var _parent : DisplayObject;
		private var closeOnOk : Boolean ;
		
		public function PopUp( parent:DisplayObject=null, modal:Boolean=false, centered:Boolean=true, closeOnOk:Boolean=true, pageChangeClosing:Boolean=true, showCloseButton:Boolean = true )
		{
				this.closeOnOk=closeOnOk;
				this.modal=modal;
				this._parent=parent;
				this.centered=centered
				this.window=new TitleWindow();
				window.showCloseButton=showCloseButton;
				window.addEventListener(CloseEvent.CLOSE,closeHandler);
				buttonOk.addEventListener(MouseEvent.CLICK , clickOnOk ,false,0,true);
				if(pageChangeClosing) BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_CHANGE , closeOnPageChange ) ;
				init();
		}
		
		protected function init():void
		{
			
		}
		
		protected function clickOnOk(e:MouseEvent) : void
		{
			if(closeOnOk)
				closePopUp();
		}
		
		protected function closeButton(close:Boolean):void{
			window.showCloseButton=close;
		}
		protected function closeHandler(e:CloseEvent):void{
				closePopUp();
		}
		public function display():void
		{
			if(_parent == null ) 
			{
				
				PopUpManager.addPopUp(window,mx.core.Application.application as DisplayObject,modal);
			}
			else
			{
				PopUpManager.addPopUp(window,_parent,modal);
			}
			if(centered)
				{
					PopUpManager.centerPopUp(window);
				}
		}
		
		public function center():void
		{
			PopUpManager.centerPopUp(window);
		}
		public function closePopUp():void{
			onClose();
			BrowsingManager.getInstance().removeEventListener(FieEvent.PAGE_CHANGE , closeOnPageChange);
			window.removeEventListener(CloseEvent.CLOSE,closeHandler);
			window.removeAllChildren();
			PopUpManager.removePopUp(window);
			window=null;
			dispatchEvent(new Event(CLOSED));
		}
		
		protected function onClose():void
		{
			// override this function to add behavior when closing popup
		}
		public function getWindow():TitleWindow
		{
			return window;	
		}
		public override function addChild(child:DisplayObject):DisplayObject
		{
			window.addChild(child);
			return child;
		}
		public function showOk():void
		{
			buttonOk.label= Conf.languageManager.getLanguage("Ok");
			addChild(buttonOk);
		}
		
		public function setWidth( value : int ):void
		{
			this.width = value ;
			window.width = value ;
		}
		
		public function setHeight ( value : int ) : void 
		{
			this.height = value ;
			window.height = value ;
		}
		
		private function closeOnPageChange ( e : Event ) : void 
		{
			this.closePopUp();
		}

	}
}