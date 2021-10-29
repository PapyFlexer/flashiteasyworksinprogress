package com.flashiteasy.admin.browser
{
	import com.flashiteasy.admin.components.componentsClasses.EventItemRenderer;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.event.TriggerEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.controls.Text;
	import mx.core.ClassFactory;
	
	// classe servant a afficher le clipboard
	
	public class ClipboardView extends Canvas
	{
		
		public static var SELECT_END:String="SELECT_END"; // evenement declenche lors de la confirmation de la selection
		
		
		private var ba:BrowserAction; // Reference de BrowserAction utilise pour effectuer toutes les actions
		
		// Elements graphiques eventuellement utilise par les vues
		
		private var cancel_button:Button;
		private var add:Button;
		private var del:Button;
		private var confirm:Button;
		private var clip:Clipboard;
		private var list:List;
		private var message:Text;
		private var title:Text;
		
		private var select:Boolean; // indique si un element est selectionné
		private var selection:String=""; // contient l element selectionne
		
		public function ClipboardView(ba:BrowserAction, is_select:Boolean=false)
		{	
			this.ba=ba;
			clip=ba.getClipboard();
			clip.addEventListener(Clipboard.CLIPBOARD_CHANGED , update );
			// initialisation des composant graphiques 

			title=new Text();
			message= new Text();
			cancel_button=new Button();
			cancel_button.visible=false;
			cancel_button.label=Conf.languageManager.getLanguage("Cancel");
			cancel_button.addEventListener(MouseEvent.CLICK, clear);
			
			list=new List();
			list.itemRenderer=new ClassFactory(EventItemRenderer);
			list.addEventListener(TriggerEvent.REMOVE_EVENT , removeSelectedItem ) ;
			list.width = 300;
			list.height = 70;
			init();
			
		}
		
		 private function removeSelectedItem( event : TriggerEvent ) : void
         {
           	clip.remove(list.selectedItem as String);
         }
		
		private function update(e:Event):void
		{
			list.dataProvider=clip.getFiles();
			if(clip.getAction())
				title.text=Conf.languageManager.getLanguage("Clipboard")+" ("+ clip.getState() + ")";
			else
				title.text=Conf.languageManager.getLanguage("Clipboard");
			cancel_button.visible=clip.getAction();
			message.text=clip.getError();
		}
		
		public function init():void{
			
			var box : VBox = new VBox();
				box.addChild(title);
				box.addChild(cancel_button);
				box.addChild(list);
				box.addChild(message);
			addChild(box);
			if(clip.isSelect()){
				title.text=Conf.languageManager.getLanguage("Selected_Files");
			}
			else{
				title.text=Conf.languageManager.getLanguage("Clipboard");
			}
		}
		
		private function clear(e:Event):void{
			clip.clear_clipboard();
		}

	}
}