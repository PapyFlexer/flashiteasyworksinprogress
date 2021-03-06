package com.flashiteasy.admin.browser
{
	//import collections.ArrayCollection;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	// Classe modele servant a stocker une liste de fichiers et differentes variables indiquant les actions a effectuer
	
	public class Clipboard extends EventDispatcher
	{
		public static var CLIPBOARD_CHANGED:String="CLIPBOARD_CHANGED";
		
		[Bindable]
		public var clipboard:Array = []; // liste de fichiers
		public var isEmpty: Boolean = true ;
		private var selection : Array = [];
		public var hasSelectedFile : Boolean = false ;
		private var clipboard_state:String=""; // action en cours
		private var clipboard_error:String=""; // erreurs ou messages
		private var clipboard_action:Boolean=false; // indique si une action est en cours
		private var is_select:Boolean = false; // indique si la liste doit etre traite comme une selection de fichiers ou comme simple clipboard
		
			
		public function Clipboard(is_select:Boolean=false)
		{
			this.is_select=is_select;
		}
		
		public function isSelect():Boolean{
			return is_select;
		}
		public function getError():String{
			return clipboard_error;
		}
		public function getAction():Boolean{
			return clipboard_action;
		}
		public function setError(error:String):void{
			clipboard_error=error;
		}
		
		public function getState():String{
			return clipboard_state;
		}

		public function getFiles():Array{
			return clipboard;
		}
		
		public function clear_clipboard():void
		{
			clipboard.splice(0);
			clipboard_error="";
			clipboard_state="";
			clipboard_action=false;
			isEmpty=true;
			dispatchEvent(new Event(CLIPBOARD_CHANGED));
		}
		
		public function length():Number{
			return clipboard.length;
		}
		


		public function add_clipboard(name:String, action:String=""):Number
			{
				if( action !="") {
				if (clipboard_state == "")
				{
					// mise a jour de l action du clipboard
					clipboard_state=action;
				}
				else
				{
					if (clipboard_state != action)
						return 1;
				}
				}

				// verifie si le fichier se trouve deja dans le clipboard

				if (clipboard.length > 0)
				{
					var i:Number;
					for (i=0; i < clipboard.length; i++)
					{
						if (clipboard[i] as String == name)
							return 2;
					}
				}

				// si non , ajout dans le clipboard
				clipboard.push(name);
				isEmpty=false;
				return 0;
			}
			
			public function remove(name:String):void{
				var i:uint;
				for (i=0; i < clipboard.length; i++)
					{
						if (clipboard[i] as String == name)
							clipboard.splice(i,1);
					}
				if(clipboard.length == 0 )
				{
					
					clear_clipboard();
				}
				dispatchEvent(new Event(CLIPBOARD_CHANGED));
			}
			
			public function cut(fileName:String):int
			{
				switch (add_clipboard(fileName, "couper"))
				{
					case 0:
						clipboard_error="";
						clipboard_action=true;
						dispatchEvent(new Event(CLIPBOARD_CHANGED));
						return 0;
						break;
					case 1:
						clipboard_error="impossible de couper ( action copier en cours ) ";
						dispatchEvent(new Event(CLIPBOARD_CHANGED));
						return 1;
						break;
					case 2:
						clipboard_error="fichier deja present dans le clipboard";
						dispatchEvent(new Event(CLIPBOARD_CHANGED));
						return 2;
						break;
				}
				
				return 0;
			}
			public function copy(fileName:String):Number
			{
				switch (add_clipboard(fileName, "copier"))
				{
					case 0:
						clipboard_error="";
						clipboard_action=true;
						dispatchEvent(new Event(CLIPBOARD_CHANGED));
						return 0;
						break;
					case 1:
						clipboard_error="impossible de copier ( action couper en cours ) ";
						dispatchEvent(new Event(CLIPBOARD_CHANGED));
						return 1;
						break;
					case 2:
						clipboard_error="fichier deja present dans le clipboard";
						dispatchEvent(new Event(CLIPBOARD_CHANGED));
						return 2;
						break;
				}
				
				return 0;
			}
		
			
			public function getItemAt(index:Number):Object{
				return this.clipboard[index];
			}
			
			public override function toString():String{
				var i:Number;var s:String="";
					
				for (i=0; i < clipboard.length; i++)
					{
						s+=( clipboard[i] as String )+"\n";
					}
				return s;
			}
			
		
	}
}