package com.flashiteasy.admin.browser
{
	import com.flashiteasy.admin.conf.Conf;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class FolderData extends EventDispatcher
	{
			public static var CHANGED_FILE:String="CHANGED_FILE";
			public static var CHANGED_DIRECTORY:String="CHANGED_DIRECTORY";
			public static var LOADED_XML:String="LOADED_XML";
			public static var CHANGED_DEFAULT_DIRECTORY:String="CHANGED_DEFAULT_DIRECTORY";
			
			private var _default_directory:String="";
			private var current_file:String="";
			private var _xml:XML;
			private var current_directory:String="";
			private var selected_files:Array;
			
			[Bindable]
			public var hasFile : Boolean = false;
			[Bindable]
			public var hasSelectableFile : Boolean = false;
			[Bindable]
			public var directorySelected: Boolean = false;
			
			public function FolderData(directory:String){
				this._default_directory=directory;
				this.selected_files = [];
				this._xml=new XML();
			}
			
			public function addFiles(name:String):Boolean{
				
				if (selected_files.length > 0){
					var i:Number;
					for (i=0; i < selected_files.length; i++)
					{
						if (selected_files.getItemAt(i) as String == name)
							return false;
					}
				}

				// si non , ajout dans la liste
				selected_files.addItem(name);
				return true;
			}
			
			
			public function get default_directory():String 
			{
				return _default_directory;
			}
			
			
			public function set default_directory(s:String):void 
			{
				_default_directory = s;
				dispatchEvent(new Event(CHANGED_DEFAULT_DIRECTORY));
			}
			
			[Bindable]
			public function get currentFile():String 
			{
				return current_file;
			}
			
			public function set currentFile(name:String):void
			{
				if(name != current_file)
				{
					this.current_file=name;
					if(name!="" && name!=null)
					{
						hasFile=true;
						hasSelectableFile = true;
					}
					else
					{
						hasSelectableFile = false;
					}
					dispatchEvent(new Event(CHANGED_FILE));
				}
			}
		
			[Bindable]
			public function set currentDirectory(name:String):void {
				this.current_directory=name;
				if(current_directory == ""  && name != null)
				{
					hasFile = false;
				}
				else
				{
					hasFile = true ;
				}
				dispatchEvent(new Event(CHANGED_DIRECTORY));
			}
			
			public function get currentDirectory():String{
				return current_directory;
			}
			
			public function getAppRelativeDirectory():String 
			{
				var relativeDirectory:String = "";
				if(default_directory.indexOf(Conf.APP_ROOT) != -1)
				{
					relativeDirectory = default_directory.substr(Conf.APP_ROOT.length+1) + "/";
				}
				return relativeDirectory;
			}
			
			public function getXml():XML
			{ 
				if(_xml.children().length() == 0)
					return null;
				return this._xml;	
			}
			
			public function setXml(_xml:XML):void
			{ 
				this._xml=new XML(_xml) ;
				trace("SETXML :: "+_xml.children().length());
				if(_xml.children().length() == 0)
					this._xml=new XML() ;
				dispatchEvent(new Event(LOADED_XML));
			}
			
			public function setStringXML(s:String):void{ 
				this._xml= new XML(s);
				trace("SETSTRINGXML :: "+_xml.children().length());
				if(_xml.children().length() == 0)
					this._xml=new XML("<root></root>") ;
				dispatchEvent(new Event(LOADED_XML));
			}
			

		}

	}
