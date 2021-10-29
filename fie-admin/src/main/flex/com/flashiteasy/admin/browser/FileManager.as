package com.flashiteasy.admin.browser
{
	import com.flashiteasy.api.utils.LoaderUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	
	public class FileManager extends EventDispatcher
	{
		public static var DELETE_FILE:String = "filemanager_delete";
		public static var UPLOAD_FILE:String = "filemanager_upload";
		public static var CREATE_DIRECTORY:String = "filemanager_mkdir";
		public static var COPY_FILE:String = "filemanager_copy";
		public static var CUT_FILE:String = "filemanager_cut";
		
		private var variables : URLVariables;
		
		public var folder_manager:String="php/foldertotree.php";
		public var file_manager:String="php/filemanager.php";
		public var upload_manager:String="php/upload_file.php";
		
		private var fileRef:FileReference;
		private var uploadFolder:String="";
		private var currentFiles : Array = [] ;
		
		public function FileManager()
		{
			fileRef = new FileReference;
			fileRef.addEventListener(Event.SELECT, startUpload);
			fileRef.addEventListener(Event.COMPLETE, uploadComplete );
		}
		
		public function upload(uploadFolder : String ):void
		{
			this.uploadFolder=uploadFolder;
			fileRef.browse();	
		}
		
		private function startUpload(e:Event) : void 
		{
			variables.folder=null;
			variables.folder=uploadFolder;
			var request:URLRequest=new URLRequest(upload_manager);
			request.method="POST";	
			request.data=variables;
			try{	fileRef.upload(request,"file" );	}
			catch (event:*){	Alert.show("erreur lors du chargement du fichier ");	}
		}
		
		private function uploadComplete ( e : Event ) : void 
		{
			dispatchEvent(new Event(UPLOAD_FILE));
		}
		
		public function create_directory ( currentFolder : String , folderName : String ) : void 
		{
			
			variables.action="_mkdir";
			variables.noms=currentFolder+ "/" + folderName;
			var request:URLRequest=new URLRequest(file_manager);
			request.data=variables;
			request.method="POST";
			var loader:URLLoader = LoaderUtil.getLoader(this , directoryCreated );
			loader.load( request );
		}
		
		public function directoryCreated( e : Event ) : void 
		{
			dispatchEvent(new Event(FileManager.CREATE_DIRECTORY));
		}
		
		public function deleteFiles( files : Array  ) : void 
		{
			variables = new URLVariables();
			variables.action="_delete";
			variables.fics=files;
			var request:URLRequest=new URLRequest(file_manager);
			request.data=variables;
			request.method="POST";
			var loader:URLLoader = LoaderUtil.getLoader(this , deleteComplete );
			loader.load( request );
		}
		
		private function deleteComplete ( e : Event ) : void
		{
			dispatchEvent(new Event(DELETE_FILE));
		}

		public function copyFiles( filesToCopy : Array , newFiles : Array ) : void 
		{
			variables = new URLVariables();
			variables.action="_copy";
			
			variables.fics=null;
			variables.noms=null;
			variables.fics=filesToCopy.toString();
			variables.noms=newFiles.toString();
			var request:URLRequest=new URLRequest(file_manager);
			request.data=variables;
			request.method="POST";
			var loader:URLLoader = LoaderUtil.getLoader(this , copyComplete );
			loader.load( request );
		}
		
		public function copyDirs( dirsToCopy : Array , newDirs : Array ) : void 
		{
			variables = new URLVariables();
			variables.action="_copyDir";
			variables.fics=null;
			variables.noms=null;
			variables.fics=dirsToCopy.toString();
			variables.noms=newDirs.toString();
			trace("CopyDirs :: "+variables.fics+" :: "+variables.noms);
			var request:URLRequest=new URLRequest(file_manager);
			request.data=variables;
			request.method="POST";
			var loader:URLLoader = LoaderUtil.getLoader(this , copyComplete );
			loader.load( request );
		}
		
		private function copyComplete ( e : Event ) : void 
		{
			trace("copyComplete :: "+e.target.data);
			dispatchEvent(new Event(COPY_FILE));
		}
		
		public function cut( filesToCopy : Array , newFiles : Array ) : void 
		{
			currentFiles = filesToCopy ; 
			copyFiles(filesToCopy , newFiles);
			this.addEventListener(COPY_FILE , deleteAfterCopy ) ;
		}
		
		private function deleteAfterCopy( e:Event ) : void 
		{
			this.addEventListener(DELETE_FILE , cutEnd );
			deleteFiles(currentFiles)
			this.removeEventListener(COPY_FILE , deleteAfterCopy ) ;
		}
		
		private function cutEnd( e : Event ) : void 
		{
			this.removeEventListener(DELETE_FILE , cutEnd ) ; 
			dispatchEvent(new Event(CUT_FILE )) ;
		}
		
	}
}