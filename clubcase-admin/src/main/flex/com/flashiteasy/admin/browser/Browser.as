package com.flashiteasy.admin.browser
{
	import com.flashiteasy.admin.conf.Conf;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Spacer;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.events.ListEvent;

	public class Browser extends Canvas
	{
		public static var BROWSE_READY : String = "browse_ready";
		public static var BROWSE_COMPLETE : String = "browse_complete";

		private var upload_manager:String="";
		private var enable_select:Boolean;

		// Objet graphiques

		public var ba:BrowserAction;
		public var fd:FolderData;
		private var fv:FolderView;
		private var fiv:FileView;
		private var cv:ClipboardView;

		private var confirm:Button;
		private var selectionMode : Boolean ;
		private var clipboard:Clipboard;

		private var content : VBox ;
		private var _directoryList : Array;
		private var directoryCombo : ComboBox;
		
		private var _allowFileManipulation:Boolean;
		private var _allowDirectoryCreation:Boolean;
		
		public var fileBox : VBox = new VBox;
		
		public function Browser(default_directory:String="media", selectionMode:Boolean=false, allowFileManipulation:Boolean=true, allowDirectoryCreation:Boolean=true, showClipboard:Boolean=true, showFile:Boolean=true)
		{

			this.selectionMode = selectionMode;
			content = new VBox;
			content.setStyle("paddingTop", 10);
			content.setStyle("paddingLeft", 10);
			content.setStyle("paddingRight", 10);
			content.setStyle("paddingBottom", 10);
			addChild(content);
			clipboard=new Clipboard();
			fd = new FolderData(default_directory);
			ba=new BrowserAction(fd,clipboard);
			fv=new FolderView(fd,ba,allowFileManipulation,allowDirectoryCreation);
			fv.addEventListener(FolderView.DIRECTORY_READ , folderReady ,false , 0 , true );
			
			this._directoryList = fd.getAppRelativeDirectory().substr(0,-1).split("/").reverse();
			this.directoryCombo=new ComboBox;
			
			directoryCombo.addEventListener(ListEvent.CHANGE, changeDirectory);
			directoryCombo.dataProvider=_directoryList;
			var Hbox : HBox = new HBox;
			var folderBox : VBox = new VBox;
			
			content.addChild(directoryCombo);
			content.addChild(Hbox);
			Hbox.addChild(folderBox);
			Hbox.addChild(fileBox);
			folderBox.addChild(fv);
			fileBox.percentHeight = 100;

			if(showFile)
			{
				fiv=new FileView(fd);
				fileBox.addChild(fiv);
			}
			
			if(showClipboard)
			{
				cv=new ClipboardView(ba,enable_select);
				cv.addEventListener(ClipboardView.SELECT_END,selectionEnd);
				fileBox.addChild(cv);
			}


			if( selectionMode )
			{
				createConfirm();
			}

		}
		
		
		private function changeDirectory(e:Event):void
		{
			var parentDirectory:String = fd.default_directory.substr(0,-1).split(e.target.selectedItem)[0]+e.target.selectedItem;
			
			
			fd.default_directory=parentDirectory;
			
			this._directoryList = fd.getAppRelativeDirectory().substr(0,-1).split("/").reverse();
			this.directoryCombo.dataProvider= _directoryList;
			
			
			
		}

		private function folderReady(e:Event) : void 
		{
			dispatchEvent(new Event(BROWSE_READY));
		}
		public var urlTextField : TextInput;
		private function createConfirm():void 
		{
			var Hbox : HBox = new HBox;
			Hbox.percentWidth = 100;
			var spacer:Spacer = new Spacer;
			spacer.percentWidth=100;
			confirm=new Button();
			urlTextField = new TextInput;
			urlTextField.width=300;
			confirm.label=Conf.languageManager.getLanguage("Confirm");
			//BindingUtils.bindProperty(confirm , "enabled" , fd , "hasSelectableFile");
			confirm.addEventListener(MouseEvent.CLICK , mouseHandler);
			Hbox.addChild(urlTextField);
			Hbox.addChild(spacer);
			Hbox.addChild(confirm);
			content.addChild(Hbox);
		}

		private function selectionEnd( e : Event ) : void
		{
			mouseHandler(new MouseEvent(MouseEvent.MOUSE_UP));
		}

		public function getSelectedFiles():Array
		{
			return clipboard.getFiles();
		}
		
		public function setSelectedFile(s:String) : void
		{
			fd.currentFile = s;
			fv.setSelectedItem(s);
		}
		
		public function getSelectedFile():String 
		{
			var relativeDirectory:String = fd.getAppRelativeDirectory();
			var path:String;
			
			
			if(fd.hasSelectableFile)
			{
				path = relativeDirectory+fd.currentDirectory+fd.currentFile;
			}
			else if (urlTextField.text != "" && urlTextField.text != null)
			{
				path = urlTextField.text;
			}
			else
			{
				path = "null";
			}
			
			
			
			
			return path;
		}

		public function getSelectedFileName():String 
		{
			return fd.currentFile;
		}
		
		private function mouseHandler(e:MouseEvent) :void
		{
			this.dispatchEvent(new Event(Browser.BROWSE_COMPLETE));
		}

	}
}
