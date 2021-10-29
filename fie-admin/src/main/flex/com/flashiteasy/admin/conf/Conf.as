package com.flashiteasy.admin.conf
{
	import com.flashiteasy.admin.manager.LanguageManager;
	
	public class Conf
	{
		//set by compiler
		public static const Revision:String = VERSION::Revision;
		public static const LastChangedRev:String = VERSION::LastChangedRev;
		public static const LastChangedDate:String = VERSION::LastChangedDate;
		public static const Company:String = VERSION::Company;
		public static const Team:String = VERSION::Team;
		public static const Version:String = VERSION::Version;
		public static const ApiRevision:String = VERSION::ApiRevision;
		public static const ServiceRevision:String = VERSION::ServiceRevision;
		
		
		public static var APP_ROOT : String = "";	// set when the project is loaded by the admin
		public static var SERVICE_URL : String = ""; // set when the project is loaded by the admin
		public static var PROJECT_NATURE : String = ""; // set when the project is loaded by the admin 
		public static var languageManager : LanguageManager = new LanguageManager("fr_FR");
		//public static var languageManager : LanguageManager = new LanguageManager();
		
		// Libraries loaded by admin project 
		
		public static var libraries : Array = [];
		/* menu */ 
		
		//[Bindable]
		public static var fieMenu:Object={label: languageManager.getLanguage("FlashIteasy"), children: [{label: languageManager.getLanguage("About")+languageManager.getLanguage("FlashIteasy"), data:"about"}]};
		//[Bindable]
		public static var fileMenu:Object={label: languageManager.getLanguage("File"), children: [{label: languageManager.getLanguage("Open_Project")+"...", data: "loadApp"}, {type: "separator"}, {label: languageManager.getLanguage("Save")+"   Ctrl+S", data: "save"}]};
		//[Bindable]
		public static var editMenu:Object={label: languageManager.getLanguage("Edit"), children: [{label: languageManager.getLanguage("Undo")+"   Ctrl+Z", data: "undo"}, {label: languageManager.getLanguage("Redo")+"   Ctrl+Y", data: "redo"}]};

		//public static var toolMenu:Object={label: languageManager.getLanguage("Window"), children: [{label: languageManager.getLanguage("Browser"), data: "browse"}, {label: languageManager.getLanguage("Font_loader"), data: "font"},{label: languageManager.getLanguage("Style_editor"), data: "style"}, {label: languageManager.getLanguage("Indexation_editor"), data:"indexation"}, {label: languageManager.getLanguage("Library_manager"), data: "library"}]};
		public static var toolMenu:Object={label: languageManager.getLanguage("Window"), children: [{label: languageManager.getLanguage("Browser"), data: "browse"}, {label: languageManager.getLanguage("Convert_to_HTML"), data: "convertHTML"}, {label: languageManager.getLanguage("Font_loader"), data: "font"},{label: languageManager.getLanguage("Style_editor"), data: "style"}, {label: languageManager.getLanguage("Indexation_editor"), data:"indexation"}, {label: languageManager.getLanguage("Library_manager"), data: "library"}, {label: languageManager.getLanguage("Version_manager"), data: "versions"}]};

		private static var _applicationMenu:Array;//[fieMenu, fileMenu, editMenu, toolMenu];		
		
		//[Bindable]
		public static function get applicationMenu() : Array
		{
			fieMenu={label: languageManager.getLanguage("FlashIteasy"), children: [{label: languageManager.getLanguage("About")+languageManager.getLanguage("FlashIteasy"), data:"about"}]};
			fileMenu={label: languageManager.getLanguage("File"), children: [{label: languageManager.getLanguage("Open_Project")+"...", data: "loadApp"}, {type: "separator"}, {label: languageManager.getLanguage("Save")+"   Ctrl+S", data: "save"}]};
			editMenu={label: languageManager.getLanguage("Edit"), children: [{label: languageManager.getLanguage("Undo")+"   Ctrl+Z", data: "undo"}, {label: languageManager.getLanguage("Redo")+"   Ctrl+Y", data: "redo"}]};
			toolMenu={label: languageManager.getLanguage("Window"), children: [{label: languageManager.getLanguage("Browser"), data: "browse"}, {label: languageManager.getLanguage("Convert_to_HTML"), data: "convertHTML"}, {label: languageManager.getLanguage("Font_loader"), data: "font"},{label: languageManager.getLanguage("Style_editor"), data: "style"}, {label: languageManager.getLanguage("Indexation_editor"), data:"indexation"}, {label: languageManager.getLanguage("Library_manager"), data: "library"}, {label: languageManager.getLanguage("Version_manager"), data: "versions"}, {label: languageManager.getLanguage("Bitmap_Exporter"), data: "export"}]};

			_applicationMenu = [fieMenu, fileMenu, editMenu, toolMenu];
			return _applicationMenu;
		}
		
		
	}
}