package com.flashiteasy.admin.browser
{
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.TextInput;


	// classe servant a previsualiser les fichiers 

	public class FileView extends Canvas
	{

		private var ba:BrowserAction;
		private var fd:FolderData;
		private var enable:Boolean;

		// Objets graphiques

		private var img:Image;
		

		public function FileView(fd:FolderData)
		{
			this.fd=fd;
			img=new Image();
			img.width=300;
			img.height=200;
			fd.addEventListener(FolderData.CHANGED_FILE , refresh );
			// initialisation des boutons 
			addChild(img);
		}
		
		private function refresh(e:Event):void
		{
			var src : String ;
			if(fd.directorySelected)
			{
				img.visible=false;
				src = null;
				img.source=src;
			}
			else
			{
				img.visible=true;
				src = fd.default_directory+"/"+ fd.currentDirectory + fd.currentFile;
				img.source=src;
			}
		}

	}
}