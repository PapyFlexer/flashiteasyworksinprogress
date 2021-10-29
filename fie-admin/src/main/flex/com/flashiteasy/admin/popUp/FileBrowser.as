package com.flashiteasy.admin.popUp
{
	import com.flashiteasy.admin.browser.Browser;
	import com.flashiteasy.admin.browser.BrowserAction;
	import com.flashiteasy.admin.browser.FolderData;
	import com.flashiteasy.admin.browser.FolderView;
	import com.flashiteasy.admin.event.FieAdminEvent;

	import flash.display.DisplayObject;
	import flash.events.Event;

	import mx.controls.Button;
	import mx.controls.TextInput;

	public class FileBrowser extends PopUp
	{
		public var browser:Browser;
		private var directory:String;
		private var ba:BrowserAction;
		private var fd:FolderData;
		private var fv:FolderView;
		private var confirm:Button;
		private var setFile:String;

		public function FileBrowser(directory:String, parent:DisplayObject, selectionMode:Boolean=true, viewFile:Boolean=false, fileManipulation:Boolean=false, createDirectory:Boolean=false, modal:Boolean=false, centered:Boolean=true, setFile:String=null)
		{
			super(parent, modal, centered);
			this.directory=directory;
			this.setFile=setFile;
			browser=new Browser(directory, selectionMode, fileManipulation, createDirectory, false, viewFile);
			super.addChild(browser);
			browser.addEventListener(Browser.BROWSE_READY, fileBrowserReady, false, 0, true);
			browser.addEventListener(Browser.BROWSE_COMPLETE, fileBrowserComplete, false, 0, true);
		}

		private function fileBrowserReady(e:Event):void
		{
			super.display();
			if (setFile != null)
			{
				if (setFile.indexOf("http") == -1)
					browser.setSelectedFile(setFile);
			}
		}

		private function fileBrowserComplete(e:Event):void
		{
			super.closePopUp();
			dispatchEvent(new Event(FieAdminEvent.COMPLETE));

		}

		public function get selectedFile():String
		{

			//return fv.selected_file;
			var url:String=browser.getSelectedFile();
			return url;
		}

		public function getSelectedFileName():String
		{
			return browser.getSelectedFileName();
		}

	}
}