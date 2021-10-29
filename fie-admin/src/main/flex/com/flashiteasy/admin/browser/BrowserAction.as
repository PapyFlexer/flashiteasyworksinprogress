package com.flashiteasy.admin.browser
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.fieservice.FileManagerService;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.XMLListCollection;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	/*
	   Classe controleur du MVC Browser effectuant toutes les actions sur les fichiers
	   et mettant a jour les données des modeles
	 */
	[Bindable]
	public class BrowserAction extends Sprite
	{
		// Instance des modeles

		private var clipboard:Clipboard; // clipboard stockant les fichiers pour les actions couper / copier
		private var select_clip:Clipboard; // clipboard stockant la liste des fichiers selectionnées
		private var fd:FolderData;


		private var fms:FileManagerService=new FileManagerService();

		// action en train d etre effectue

		private var current_action:String="";

		// Variable pour les popup

		private var uploadBox:TitleWindow; // fenetre popup

		// elements dont les popup auront eventuellement besoin

		private var popup_text1:Text;
		private var popup_text2:Text;
		private var popup_textInput:TextInput;
		private var popup_button1:Button;
		private var popup_button2:Button;

		public function BrowserAction(folderData : FolderData , clipboard : Clipboard )
		{
			fms.addEventListener(FileManagerService.ERROR, error);
			
			this.clipboard = clipboard;
			select_clip=new Clipboard(true);
			fd=folderData;
			fms.addEventListener(FileManagerService.UPLOAD_FILE , uploadHandler);
			fd.addEventListener(FolderData.CHANGED_DEFAULT_DIRECTORY ,directoryChanged);
			init();

		}
		private function directoryChanged( e : Event ) : void 
		 {
		 	init();
		 }

		public function init():void
		{
			getFolder();
		}

		public function getFd():FolderData
		{
			return this.fd;
		}

		public function getXmlList():XMLList
		{
			return new XMLList(fd.getXml());
		}

		public function getXmlListCollection():XMLListCollection
		{
			return new XMLListCollection(this.getXmlList());
		}

		public function changeFile( file : String = null ):void
		{
			fd.currentFile = file ;
		}

		public function changeDirectory(directory : String = null ):void
		{
			fd.currentDirectory = directory ;
		}


		// upload d un fichier 

		public function upload():void
		{
			fms.upload(fd.default_directory+"/"+fd.currentDirectory);
		}

		// recuperation de l arborescence

		public function getFolder():void
		{
			
			fms.addEventListener(FileManagerService.READ_DIRECTORY, completeReadFolder);
			fms.getFolderTree(fd.default_directory);
		}

		private function error(e:Event):void
		{
			trace("error with fileManager");
		}

		private function completeReadFolder(e:Event):void
		{
			fms.removeEventListener(FileManagerService.READ_DIRECTORY, completeReadFolder);
			var s:String=fms.content;
			fd.setStringXML(s);
		}

		private function loadFail(e:Event):void
		{
			trace("couldn't read directory " + fd.default_directory);
		}

		private function finFileLoader(e:Event):void
		{
			switch (current_action)
			{
				case "_delete":
					fms.removeEventListener(FileManagerService.DELETE_FILE , finFileLoader);
					fd.currentFile = "";
					fd.currentDirectory= "";
					getFolder();
					break;
				case "_rename":
					fd.currentFile = popup_textInput.text;
					close_popup2();
					getFolder();
					break;
				case "_paste":
					fms.removeEventListener(FileManagerService.COPY_FILE , finFileLoader);
					if (clipboard.getState() == "couper")
					{
						delete_after_cut();
					}
					else
					{
						getFolder();
					}
					clipboard.clear_clipboard();
					close_popup2();
					break;
				case "_mkdir":

					fms.removeEventListener(FileManagerService.CREATE_DIRECTORY, finFileLoader);
					Alert.show(Conf.languageManager.getLanguage("Success_creating_new_directory"));
					close_popup2();
					getFolder();

					break;

			}
		}

		public function copy(file:String):void
		{
			clipboard.copy(file);

		}

		public function cut(file:String):void
		{
			clipboard.cut(file);
		}

		// creation d un pop up demandant une confirmation pour coller

		public function paste():void
		{

			uploadBox=new TitleWindow();
			uploadBox=PopUpManager.createPopUp(mx.core.Application.application as DisplayObject, TitleWindow, true) as TitleWindow;
			uploadBox.showCloseButton=true;
			uploadBox.title=clipboard.getState() + " "+Conf.languageManager.getLanguage("file");
			uploadBox.addEventListener(CloseEvent.CLOSE, onCloseNewStyleBox);
			popup_text1=new Text();
			popup_text1.text=Conf.languageManager.getLanguage("Clipboard_files_will_be_moved_in_current_directory")+" :" + fd.currentDirectory;
			popup_button1=new Button();
			popup_button1.x=360;
			popup_button1.y=40;
			popup_button1.label=Conf.languageManager.getLanguage("Confirm");
			popup_button1.addEventListener(MouseEvent.CLICK, confirmPaste);
			popup_button2=new Button();
			popup_button2.x=360;
			popup_button2.y=70;
			popup_button2.label=Conf.languageManager.getLanguage("Cancel");
			popup_button2.addEventListener(MouseEvent.CLICK, close_popup);
			popup_text2=new Text();
			popup_text2.x=20;
			popup_text2.y=40;
			popup_text2.width=300;
			popup_text2.text=Conf.languageManager.getLanguage("File")+"(s) \n" + clipboard.toString();
			uploadBox.addChild(popup_text1);
			uploadBox.addChild(popup_text2);
			uploadBox.addChild(popup_button1);
			uploadBox.addChild(popup_button2);
			PopUpManager.centerPopUp(uploadBox);

		}

		public function renameFile():void
		{
			uploadBox=new TitleWindow();
			uploadBox=PopUpManager.createPopUp(mx.core.Application.application as DisplayObject, TitleWindow, true) as TitleWindow;
			uploadBox.showCloseButton=true;
			uploadBox.title=Conf.languageManager.getLanguage("Rename")+" "+Conf.languageManager.getLanguage("file");
			uploadBox.addEventListener(CloseEvent.CLOSE, onCloseNewStyleBox);
			popup_text1=new Text();
			popup_text1.text=Conf.languageManager.getLanguage("New")+" "+Conf.languageManager.getLanguage("name")+" :";
			this.popup_textInput=new TextInput();
			popup_textInput.text=fd.currentFile;
			popup_button1=new Button();
			popup_button1.x=360;
			popup_button1.y=40;
			popup_button1.label=Conf.languageManager.getLanguage("Confirm");
			popup_button1.addEventListener(MouseEvent.CLICK, confirmRename);
			popup_button2=new Button();
			popup_button2.x=360;
			popup_button2.y=70;
			popup_button2.label=Conf.languageManager.getLanguage("Cancel");
			popup_button2.addEventListener(MouseEvent.CLICK, close_popup);
			popup_text2=new Text();
			popup_text2.x=20;
			popup_text2.y=40;
			popup_text2.width=300;
			uploadBox.addChild(popup_text1);
			uploadBox.addChild(popup_textInput);
			uploadBox.addChild(popup_button1);
			uploadBox.addChild(popup_button2);
			uploadBox.addChild(popup_text2);
			PopUpManager.centerPopUp(uploadBox);
		}

		public function confirmRename(e:Event):void
		{

			current_action="_rename";
			if (check_name(fd.currentFile, popup_textInput.text))
			{
				fms.addEventListener(FileManagerService.RENAME_FILE, finFileLoader);
				fms.renameFile([fd.currentDirectory + "/" + fd.currentFile], [fd.currentDirectory + "/" + popup_textInput.text]);
			}
			else
			{
				popup_text2.text=Conf.languageManager.getLanguage("Invalid_name");

			}
		}

		public function check_name(old_name:String, new_name:String):Boolean
		{

			if (old_name == new_name)
			{
				return false;
			}
			if (new_name.length < 4)
			{
				return false;
			}
			return true;
		}

		public function mkdir():void
		{

			current_action="_mkdir";
			uploadBox=new TitleWindow();
			uploadBox=PopUpManager.createPopUp(mx.core.Application.application as DisplayObject, TitleWindow, true) as TitleWindow;
			uploadBox.showCloseButton=true;
			uploadBox.title=Conf.languageManager.getLanguage("Create_new_file");
			uploadBox.addEventListener(CloseEvent.CLOSE, onCloseNewStyleBox);
			popup_text1=new Text();
			popup_text1.text=Conf.languageManager.getLanguage("Directory_name") + fd.currentDirectory ;
			popup_textInput=new TextInput();
			popup_textInput.text=Conf.languageManager.getLanguage("New_Directory");
			popup_button1=new Button();
			popup_button1.x=360;
			popup_button1.y=40;
			popup_button1.label=Conf.languageManager.getLanguage("Confirm");
			popup_button1.addEventListener(MouseEvent.CLICK, confirmMkdir);
			popup_button2=new Button();
			popup_button2.x=360;
			popup_button2.y=70;
			popup_button2.label=Conf.languageManager.getLanguage("Cancel");
			popup_button2.addEventListener(MouseEvent.CLICK, close_popup);
			uploadBox.addChild(popup_text1);
			uploadBox.addChild(popup_textInput);
			uploadBox.addChild(popup_button1);
			uploadBox.addChild(popup_button2);
			//stage.addChild(uploadBox);
			PopUpManager.centerPopUp(uploadBox);
		}

		public function confirmMkdir(e:Event):void
		{
			current_action="_mkdir";

			fms.addEventListener(FileManagerService.CREATE_DIRECTORY, finFileLoader);
			fms.create_directory(fd.default_directory+"/"+fd.currentDirectory , popup_textInput.text);
		}

		private function onCloseNewStyleBox(e:Event):void
		{
			close_popup2();
		}

		// Confirmation coller

		private function confirmPaste(e:MouseEvent):void
		{
			current_action="_paste";
			var files : Array = clipboard.getFiles();
			var originalFiles : Array = []
			var destinationFiles : Array = [];
			var destination : String;
			for each( var file : String in files ) 
			{
				
				if(file.lastIndexOf("/") == file.length-1)
				{
					file = file.substr(0,-1);
				}
				originalFiles.push(fd.default_directory+"/"+file);
				if(file.lastIndexOf("/") == -1 )
				{
					destination = fd.default_directory+"/"+fd.currentDirectory  +file ;
				}
				else
				{
					destination = fd.default_directory+"/"+fd.currentDirectory  + file.substr(file.lastIndexOf("/")+1) ;
				}
				
				destinationFiles.push(destination);
			}

			// envoi de la requete

			fms.addEventListener(FileManagerService.COPY_FILE, finFileLoader);
			fms.copyFiles(originalFiles, destinationFiles);
		}

		public function deleteFile(folder: String , files : Array):void
		{
			current_action="_delete";
			
			fms.addEventListener(FileManagerService.DELETE_FILE, finFileLoader);
			fms.deleteFiles(folder , files);
		}

		public function delete_after_cut():void
		{
			current_action="_delete";
			var i:Number;
			var files:Array=clipboard.getFiles();

			// envoi de la requete
			fms.addEventListener(FileManagerService.DELETE_FILE, finFileLoader);
			fms.deleteFiles(fd.default_directory , files);

		}



		public function setCurrentDirectory(directory : String ):void
		{
			fd.currentDirectory = directory ;

		}

		private function close_popup(e:Event):void
		{
			close_popup2();
		}

		// Fermeture du pop up via l appel d une fonction

		private function close_popup2():void
		{
			popup_button1.removeEventListener(MouseEvent.CLICK, confirmRename);
			popup_button1.removeEventListener(MouseEvent.CLICK, confirmMkdir);
			popup_button1.removeEventListener(MouseEvent.CLICK, confirmPaste);
			popup_button2.removeEventListener(MouseEvent.CLICK, close_popup);
			uploadBox.removeAllChildren();
			PopUpManager.removePopUp(uploadBox);
		}

		public function uploadHandler(e:Event):void
		{
			getFolder();
		}
		
		public function getClipboard():Clipboard
		{
			return clipboard;
		}

	}
}