package
{
	
	import com.flashiteasy.admin.conf.Conf;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.containers.Canvas;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	public class Version extends EventDispatcher
	{
		
		// Elements pour l affichage de la gestion de version
		
		private var can:Canvas;
		private var _tree:Tree;
		private var button1:Button;
		private var button2:Button;
		private var button3:Button;
		private var text:Text;
		private var ti:TextInput;
		private var text2:Text;
		private var ti2:TextInput;
		private var text3:Text;
		private var ti3:TextInput;
		
		// variables stockant les fichiers actuels
		
		private var current_dir:String="";
		private var current_file:String="";
		private var version:String="";
		private var current_select:String="";
		
		// variables pour effectuer les requete php
		
		private var variables:URLVariables;
		private var loader:URLLoader; // loader pour recuperer l arborescence du repertoire courant
		private var default_directory:String="";
		
		// fichiers php
		
		private var folder_manager:String="php/foldertotree.php";
		private var file_manager:String="php/filemanager.php";
		private var version_manager:String="php/versionmanager.php";
		
		//=====================
		
		private var uploadBox:TitleWindow; // fenetre popup

		// elements dont les popup auront eventuellement besoin

		private var popup_text1:Text;
		private var popup_text2:Text;
		private var popup_textInput:TextInput;
		private var popup_button1:Button;
		private var popup_button2:Button;
		private var popup_can:Canvas;
		
		private var current_action:String;
		
		public function Version(default_directory:String="versions")
		{
			text=new Text();
			text.text="Version";
			text.x=240;
			text.y=20;
			ti=new TextInput();
			ti.text=version;
			ti.editable=false;
			ti.x=240;
			ti.y=50;
			text2=new Text();
			text2.text=Conf.languageManager.getLanguage("Current_Directory");
			text2.x=240;
			text2.y=80;
			ti2=new TextInput();
			ti2.text=current_file;
			ti2.editable=false;
			ti2.x=240;
			ti2.y=110;
			text3=new Text();
			text3.text=Conf.languageManager.getLanguage("Current_File");
			text3.x=240;
			text3.y=140;
			ti3=new TextInput();
			ti3.text=current_dir;
			ti3.editable=false;
			ti3.x=240;
			ti3.y=170;
			button1=new Button();
			button1.label=Conf.languageManager.getLanguage("New_Version");
			button1.x=240;
			button1.y=230;
			button1.width=150;
			button1.addEventListener(MouseEvent.CLICK,popup_mkdir);
			button2=new Button();
			button2.label=Conf.languageManager.getLanguage("Restore");
			button2.x=240;
			button2.y=260;
			button2.width=150;
			button2.addEventListener(MouseEvent.CLICK,askRestore);
			button3=new Button();
			button3.label=Conf.languageManager.getLanguage("Delete_Version");
			button3.x=240;
			button3.y=290;
			button3.width=150;
			button3.addEventListener(MouseEvent.CLICK,askDelete);
			button3.visible=false;
			_tree=new Tree();
			_tree.labelFunction=treeLabel;
			_tree.x=20;
			_tree.y=20;
			_tree.width=200;
			_tree.height=300;
			_tree.addEventListener(ListEvent.ITEM_CLICK,changeSelect);
			can=new Canvas();
			can.addChild(text);
			can.addChild(ti);
			can.addChild(text2);
			can.addChild(ti2);
			can.addChild(text3);
			can.addChild(ti3);
			can.addChild(_tree);
			can.addChild(button1);
			can.addChild(button2);
			can.addChild(button3);
			this.default_directory=default_directory;
			variables=new URLVariables();
			loader=new URLLoader();
			loader.addEventListener(Event.COMPLETE, finLoader);
			getFolder();
		}
		
		public function getFolder():void{
				current_action="_refresh"
				var fileRequest:URLRequest=new URLRequest(folder_manager);
				variables= new URLVariables();
				variables.folder=null;
				variables.folder=default_directory;
				fileRequest.data=variables;
				fileRequest.method="POST";
				loader.load(fileRequest);
		}
		
				
		public function getDisplay():DisplayObject{
			return can;
		}
		private function treeLabel(item:Object):String
			{
				var node:XML=XML(item);
				if(node.localName()=="root")
					return default_directory
				else
					return node.@name || node.localName();
			}
		
		private function finLoader(e:Event):void{
			
			switch ( current_action ){
				case "_mkdir":
					variables=new URLVariables();
					variables.varRetour=null;
					variables.decode(e.target.data);
					var s:String=variables.varRetour;
					if (s=="true"){
						close_popup2();
						Alert.show(Conf.languageManager.getLanguage("Version_Created"));
						makeVersion();
						
					}
					if ( s=="exist" ){
						Alert.show(Conf.languageManager.getLanguage("A_version_with_this_name_already_exist"));
					}
					if ( s=="false"){
						close_popup2();
						Alert.show(Conf.languageManager.getLanguage("Impossible_to_create_new_version"));
					}
					
					
				break;
				case "_refresh":
					variables=new URLVariables();
					variables.xml=null;
					variables.decode(e.target.data);
				//	Alert.show(e.target.data);
					var s:String=variables.xml;
					var _xml:XML= new XML(s);
					_tree.dataProvider=_xml;
					dispatchEvent(new Event("fin"));
					break;
				case "_set":
					getFolder();
					break;
				case "_get":
					version="";
					button3.visible=false;
					ti.text="";
					current_select="";
					current_dir="";
					Alert.show(Conf.languageManager.getLanguage("Restoration_finished"));
					getFolder();
					break;
				case "_del":
					getFolder();
					version="";
					button3.visible=false;
					ti.text="";
					current_select="";
					current_dir="";
					Alert.show(Conf.languageManager.getLanguage("Version_Deleted");
					break;
			}
		}

			
		private function popup_mkdir(e:Event):void{
				uploadBox=new TitleWindow();
				uploadBox=PopUpManager.createPopUp( mx.core.Application.application as DisplayObject , TitleWindow, true) as TitleWindow;
				uploadBox.showCloseButton=true;
				uploadBox.title=Conf.languageManager.getLanguage("Create_New_Version");
				uploadBox.addEventListener(CloseEvent.CLOSE, close_popup);
				can=new Canvas();
				popup_text1=new Text();
				popup_text1.text=Conf.languageManager.getLanguage("New_Version_Name");
				
				popup_textInput= new TextInput();
				popup_textInput.text=Conf.languageManager.getLanguage("New_Version");
				
				popup_textInput.y=20;
				popup_button1=new Button();
				
				popup_button1.y=50;
				popup_button1.label=Conf.languageManager.getLanguage("Confirm");
				popup_button1.addEventListener(MouseEvent.CLICK, confirmMkdir);
				popup_button2=new Button();
				popup_button2.x=85;
				popup_button2.y=50;
				popup_button2.label=Conf.languageManager.getLanguage("Cancel");
				popup_button2.addEventListener(MouseEvent.CLICK, close_popup);
				can.addChild(popup_text1);
				can.addChild(popup_textInput);
				can.addChild(popup_button1);
				can.addChild(popup_button2);
				uploadBox.addChild(can);
				PopUpManager.centerPopUp(uploadBox);
		}
		
		private function makeVersion():void{
			current_action="_set";
			variables= new URLVariables();
			variables.action=current_action;
			variables.versionname=popup_textInput.text;
			var _fileRequest:URLRequest=new URLRequest(version_manager);
			_fileRequest.data=variables;
			_fileRequest.method="POST";
			loader.load(_fileRequest);
		}
		// Fonction traitant les evenements 
		
		private function confirmMkdir(e:Event):void{
				current_action="_mkdir";
				variables= new URLVariables();
				variables.action=current_action;
				variables.noms=default_directory+"/"+popup_textInput.text;
				var _fileRequest:URLRequest=new URLRequest(file_manager);
				_fileRequest.data=variables;
				_fileRequest.method="POST";
				loader.load(_fileRequest);
				
		}
		
		private function changeSelect(e:Event):void{
			// Selection de fichier : changement du fichier courant
			
			if (e.currentTarget.selectedItem.localName() == "file")
				{
						
					if (e.currentTarget.selectedItem.@url != null){
						ti3.text=e.target.selectedItem.@url;
						button3.visible=true;
						current_file=e.currentTarget.selectedItem.@url;
						current_select="file";
					}
				}
				
			// Selection de repertoire : changement du dossier courant
			
			else
				{
					if (e.target.selectedItem.localName() == "root")
						current_dir=default_directory;
					else {
					
						if( e.target.selectedItem.@url == e.target.selectedItem.localName() ){
							ti.text=e.target.selectedItem.localName();
							button3.visible=true;
							version=e.target.selectedItem.localName();
							current_select="version";
						}
						else {
							ti2.text=e.target.selectedItem.@url;
							button3.visible=true;
							current_select="folder"
							current_dir=e.target.selectedItem.@url;
						}
					}
				}
		}
		
		private function clearSelect(e:Event):void{
			version="";
			current_file="";
			
		}
		
		private function close_popup(e:Event):void{
				close_popup2();
			}
			

		private function close_popup2():void{
				
				popup_button1.removeEventListener(MouseEvent.CLICK, confirmMkdir);
				popup_button2.removeEventListener(MouseEvent.CLICK, close_popup);
				uploadBox.removeAllChildren();
				PopUpManager.removePopUp(uploadBox);
		}
		
		private function askRestore(e:Event):void{
			
			if( version=="" && current_file=="" && current_dir =="" )
				Alert.show(Conf.languageManager.getLanguage("No_version_or_file_selected"));
			else {
				Alert.show(Conf.languageManager.getLanguage("Do_you_wish_to_restore_selection_?"),null,(Alert.YES | Alert.NO),null,restore,null,null);
			}
		}
		private function restore(e:CloseEvent):void{
			if(e.detail== Alert.YES){
				current_action="_get";
				variables= new URLVariables();
				variables.action=current_action;
				if(current_select == "file" ){
					variables.versionpath=current_file;
					variables.versionname=current_file;
				}
				if(current_select == "version" ){
					variables.versionpath=version;
					variables.versionname=version;
				}
				if(current_select == "folder" ){
					variables.versionpath=current_dir;
					variables.versionname=current_dir;
				}
				var _fileRequest:URLRequest=new URLRequest(version_manager);
				_fileRequest.data=variables;
				_fileRequest.method="POST";
				loader.load(_fileRequest);
			}
		}
		private function askDelete(e:Event):void{
			if(version =="" && current_select=="" && current_dir=="")
				Alert.show(Conf.languageManager.getLanguage("No_version_selected"));
			else {
				Alert.show(Conf.languageManager.getLanguage("Do_you_want_to_delete_selected_version_?"),null,(Alert.YES | Alert.NO),null,deleteVersion,null,null);
			}
		}
		
	
		private function deleteVersion(e:CloseEvent):void{
			if(e.detail== Alert.YES){
				current_action="_del";
				variables= new URLVariables();
				variables.action=current_action;
				variables.versionname=version;
				var _fileRequest:URLRequest=new URLRequest(version_manager);
				_fileRequest.data=variables;
				_fileRequest.method="POST";
				loader.load(_fileRequest);
			}
		}
	}
}