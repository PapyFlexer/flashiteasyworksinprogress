package com.flashiteasy.admin.browser
{
	import com.flashiteasy.admin.components.CustomTree;
	import com.flashiteasy.admin.components.FileManipulationBar;
	import com.flashiteasy.admin.conf.Conf;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.XMLListCollection;
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Tree;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;

	// classe utilise pour afficher l arborescence du repertoire

	public class FolderView extends Canvas
	{

		public static var DIRECTORY_READ:String="folderview_directory";
		// données 

		private var ba:BrowserAction;
		private var fd:FolderData;

		// objets graphiques

		private var _tree:CustomTree;
		private var upload_button:Button;
		private var mkdir_button:Button;

		private var toolBar:FileManipulationBar;
		private var allowFileManipulation:Boolean;
		private var allowDirectoryCreation:Boolean;
		private var directoryCombo:ComboBox;
		private var _directoryList:Array;

		public function FolderView(fd:FolderData, ba:BrowserAction, allowFileManipulation:Boolean=true, allowDirectoryCreation:Boolean=true)
		{
			this.ba=ba;
			this.fd=fd;

			this.allowFileManipulation=allowFileManipulation;
			this.allowDirectoryCreation=allowDirectoryCreation;

			fd.addEventListener(FolderData.LOADED_XML, init);
			_tree=new CustomTree();
			_tree.addEventListener(ListEvent.CHANGE, changeFiles);
			_tree.labelFunction=treeLabel;
			_tree.x=20;
			_tree.y=20;
			_tree.width=200;

			toolBar=new FileManipulationBar;
			toolBar.visible=false;
			if (allowFileManipulation)
			{
				toolBar.visible=true;
				toolBar.addEventListener(Event.COMPLETE, initToolBar, false, 0, true);
				toolBar.addEventListener(ItemClickEvent.ITEM_CLICK, selectButton);
			}

			if (allowDirectoryCreation)
			{
				/*upload_button=new Button();
				upload_button.x=40;
				upload_button.y=190;
				upload_button.width=150;
				upload_button.label=Conf.languageManager.getLanguage("Upload_file");
				upload_button.addEventListener(MouseEvent.CLICK, upload, false,0,true);*/

				mkdir_button=new Button();
				mkdir_button.x=40;
				mkdir_button.y=220;
				mkdir_button.width=150;
				mkdir_button.label=Conf.languageManager.getLanguage("New_Directory");
				mkdir_button.addEventListener(MouseEvent.CLICK, mkdir, false,0,true);
			}
		}
		
		
		private function initToolBar(e:Event):void
		{
			BindingUtils.bindProperty(toolBar.deleteButton, "enabled", fd, "hasFile");
			BindingUtils.bindProperty(toolBar.copyButton, "enabled", fd, "hasFile");
			BindingUtils.bindProperty(toolBar.cutButton, "enabled", fd, "hasFile");
			toolBar.pasteButton.enabled=false;
			ba.getClipboard().addEventListener(Clipboard.CLIPBOARD_CHANGED, update);
			//toolBar.hideAdd();
			toolBar.hideEdit();
			toolBar.addButton.toolTip = "Upload";
		}

		private function update(e:Event):void
		{
			toolBar.pasteButton.enabled=!ba.getClipboard().isEmpty;
		}

		public function init(e:Event):void
		{
			var box:VBox=new VBox;
			box.addChild(_tree);
			box.addChild(toolBar);
			if (allowDirectoryCreation)
			{
				//box.addChild(upload_button);
				box.addChild(mkdir_button);
			}
			addChild(box);

			_tree.showRoot=false;
			_tree.dataProvider=fd.getXml();
			fd.removeEventListener(FolderData.LOADED_XML, init);
			dispatchEvent(new Event(DIRECTORY_READ));
			fd.addEventListener(FolderData.LOADED_XML, updateTree);
		}

		private function updateTree(e:Event):void
		{
			_tree.dataProvider=fd.getXml();
		}

		public function getTree():Tree
		{
			return _tree;
		}

		// fonctions presentant les noeuds de l arbre

		private function treeLabel(item:Object):String
		{
			var node:XML=XML(item);
			return node.@name || node.localName();
		}


		public function setSelectedItem(fileName:String):void

		{

			var tData:XMLListCollection=new XMLListCollection(_tree.dataProvider.children());
			var index:int=-1;
			for each (var parentNode:XML in tData)
			{
				index++;
				if (parentNode.@name == fileName)
				{
					break;
				}
			}
			_tree.selectedIndex=index;
			_tree.scrollToIndex(index);
			//sometimes scrollToIndex doesnt work if validateNow() not done
			//_tree.validateNow();

		}

		// Fonctions traitant les evenements

		// lors de la selection de fichier dans le tree

		public function changeFiles(e:Event):void
		{
			if (_tree.selectedItem != null)
			{
				// Selection de fichier : changement du fichier courant
				if (e.currentTarget.selectedItem.localName() == "file")
				{
					fd.directorySelected=false;
					var directory:String=e.currentTarget.selectedItem.@url;
					var file:String=e.currentTarget.selectedItem.@name;

					if (fd.currentDirectory != directory)
					{
						ba.changeDirectory(directory);
					}
					ba.changeFile(file);

				}

				// Selection de repertoire : changement du dossier courant

				else
				{
					fd.directorySelected=true;
					if (e.target.selectedItem.localName() == "root")
					{
						ba.changeDirectory();
						ba.changeFile();
					}
					else
					{
						ba.changeDirectory(e.target.selectedItem.@url);
						ba.changeFile();
					}


				}
			}
			else
			{
				fd.hasFile=false;
				fd.directorySelected=true;
				ba.changeFile();
				ba.changeDirectory();
			}
		}

		public function upload(e:Event):void
		{
			ba.upload();
		}

		public function get selected_file():String
		{
			return fd.currentFile;
		}

		public function get directory():String
		{
			return fd.currentDirectory;
		}

		public function mkdir(e:Event):void
		{
			ba.mkdir();
		}

		// When an action on file is performed 
		private function selectButton(e:ItemClickEvent):void
		{
			var directory:String;
			var file:String;
			var path:String;
			// set directory and files to pass 
			if (fd.directorySelected)
			{
				directory=fd.default_directory + "/";
				file=fd.currentDirectory;
			}
			else
			{
				directory=fd.default_directory + "/";
				file=fd.currentDirectory + fd.currentFile;
			}
			switch (e.item.id)
			{
				case "delete":
					ba.deleteFile(directory, [file]);
					break;
				case "cut":

					ba.cut(file);

					break;
				case "copy":

					ba.copy(file);
					break;
				case "paste":
					ba.paste();
					break;
				case "add":
					ba.upload();
					break;
			}
		}


	}
}