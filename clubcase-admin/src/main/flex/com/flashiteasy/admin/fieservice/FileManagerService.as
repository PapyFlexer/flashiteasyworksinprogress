package com.flashiteasy.admin.fieservice
{	
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.fieservice.responder.FileServiceResponder;
	import com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.fieservice.AbstractBusinessDelegate;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class FileManagerService extends EventDispatcher
	{
		public static var DELETE_FILE:String = "filemanager_delete";
		public static var UPLOAD_FILE:String = "filemanager_upload";
		public static var CREATE_DIRECTORY:String = "filemanager_mkdir";
		public static var COPY_FILE:String = "filemanager_copy";
		public static var CUT_FILE:String = "filemanager_cut";
		public static var ERROR : String = "filemanager_error";
		public static var PAGE_CREATED : String = "filemanager_create_page";
		public static var FILE_SAVED : String ="filemanager_saved";
		public static var FILE_CREATED : String ="filemanaged_create_file";
		public static var READ_DIRECTORY : String ="filemanager_foldertree";
		public static var FONT_COMPILED : String = "filemanager_compile";
		public static var FONT_READ : String = "filemanager_readfont";
		public static var RENAME_FILE : String ="filemanager_rename";
		public static var DATA_ADDED : String ="filemanager_data_added";
		public static var PROJECTS_CREATED : String = "filemanager_projects_created";
		public static var NEW_PROJECT_CREATED : String = "filemanager_new_project_created";
		public static var PROJECT_DELETED : String = "filemanager_project_deleted";
		public static var DIRECTORY_COPY : String = "filemanager_copy_directory";
		public static var UPDATES_COPY : String = "filemanager_updates_copy";
		public static var READ_XML : String = "filemanager_read_XML";

		public static var EXPORT_BITMAP : String = "filemanager_export_bitmap";
		public static var EXPORT_THUMBNAIL : String = "filemanager_export_thumbnail";

		public static var DELETE_VERSION_DIR:String = "versionmanager_delete_directory";
		public static var CREATE_VERSION_DIRECTORY:String = "versionmanager_create_directory";
		public static var RESTORE_VERSION_FILE:String = "versionmanager_restore_file";
		public static var RESTORE_VERSION_DIR:String = "versionmanager_restore_directory";
		public static var NEW_VERSION_CREATED : String = "versionmanager_new_version_created";

		private var fileRef:FileReference ;
		private var uploadFolder:String="";
		private var currentFiles : Array = [] ;
		private var currentAction : String ;
		public var content:String;
		public var contentArray:Object;
		
		public function FileManagerService()
		{
			registerClassAlias("com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO", FileDataTO );
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, startUpload);
			fileRef.addEventListener(ProgressEvent.PROGRESS, fileRef_progress);
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, fileRef_ioError);
		}
		
		
		
		public function getFontInfo ( directory : String , font : String ) : void 
		{
			currentAction = "getFontInfo" ;
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [font];
			transferObject.directory=directory;
			transferObject.contentArray = [];
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.getFontInfo",new FileServiceResponder(FileServiceResponder.getFontInfoHandle,this), transferObject );
		}
		
		public function compileFont ( directory : String , font : String,fontfamily:String,fontweight:String="normal",fontstyle:String="normal" ) : void 
		{
			currentAction = "compileFont" ;
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [font,fontfamily,fontweight,fontstyle];
			trace("transferObject.files :: "+transferObject.files);
			transferObject.directory=directory;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.compileFont",new FileServiceResponder(FileServiceResponder.compileFontHandle,this), transferObject );
		}
		
		public function appendToFile ( file : String , data : String ) : void 
		{
			currentAction = "appendData" ;
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [file];
			transferObject.content = data ;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.appendContent",new FileServiceResponder(FileServiceResponder.appendDataHandle,this), transferObject );
		}
		
		public function renameFile( files : Array , newFiles : Array ) : void 
		{
			currentAction = "rename" ;
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = files
			transferObject.deletedFiles = newFiles;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.renameFile",new FileServiceResponder(FileServiceResponder.renameHandle,this), transferObject );
		}
		
		
		public function getFolderTree( directory : String ) : void 
		{
			currentAction = "foldertree" ;
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = directory;
			trace("getfoldertree invoked with "+ directory);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.getFolderTree",new FileServiceResponder(FileServiceResponder.treeHandle,this), transferObject );
		}
		
		
		public function saveContent( file : String , content : String ) : void 
		{
			currentAction = "save" ;
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [file];
			transferObject.content = content ;
			
			// Trick to be able to use amfphp with no project loaded ... 
			
			if(AbstractBootstrap.getInstance() == null )
			{
				var service : AbstractBusinessDelegate = new AbstractBusinessDelegate;
				service.call("FieBrowserService.saveContent",new FileServiceResponder(FileServiceResponder.saveHandle,this), transferObject );
			}
			else
			{
				AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.saveContent",new FileServiceResponder(FileServiceResponder.saveHandle,this), transferObject );
			}
		}
		
		public function copyDirectory ( directory : String , newDirectory : String ) : void 
		{
			currentAction = "copy_dir";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory=directory;
			transferObject.files=[newDirectory];
			trace ("directory : "+directory+"     newDir : "+newDirectory);
			if(AbstractBootstrap.getInstance() == null )
			{
				var service : AbstractBusinessDelegate = new AbstractBusinessDelegate;
				service.call("FieBrowserService.copy_directory",new FileServiceResponder(FileServiceResponder.copyDirectoryHandler,this), transferObject );
			}
			else
			{
				//Previous call seems strange with copyHandle responder?? change to copyDirectoryHandler
				//AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.copy_directory",new FileServiceResponder(FileServiceResponder.copyHandle,this), transferObject );

				AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.copy_directory",new FileServiceResponder(FileServiceResponder.copyDirectoryHandler,this), transferObject );
			}
		}
		
		public function copyFiles ( files : Array , newFiles : Array ) : void 
		{
			currentAction = "copy";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files=files;
			transferObject.copiedFiles=newFiles;
			trace("FILES "+files+" NEWFILES "+newFiles);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.copyFile",new FileServiceResponder(FileServiceResponder.copyHandle,this), transferObject );
		}
		
		public function deleteFiles( directory : String , files : Array ) : void 
		{
			currentAction = "delete";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory=directory;
			transferObject.files=files;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.deleteFile",new FileServiceResponder(FileServiceResponder.deleteHandle,this), transferObject );
		}
		
		public function deleteDirectory( directory : String ) : void 
		{
			currentAction = "deleteDirectory";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory=directory;
			transferObject.files=[];
			if(AbstractBootstrap.getInstance() == null )
			{
				var service : AbstractBusinessDelegate = new AbstractBusinessDelegate;
				service.call("FieBrowserService.deleteDirectory",new FileServiceResponder(FileServiceResponder.deleteDirectoryHandle,this), transferObject );
			}
			else
			{
				AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.deleteDirectory",new FileServiceResponder(FileServiceResponder.deleteDirectoryHandle,this), transferObject );
			}
		}
		
		public function deleteProjectDirectory( directory : String ) : void 
		{
			currentAction = "deleteProjectDirectory";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = "../fie-projects/";
			transferObject.files=[directory+"/"];
			if(AbstractBootstrap.getInstance() == null )
			{
				var service : AbstractBusinessDelegate = new AbstractBusinessDelegate;
				service.call("FieBrowserService.deleteFile",new FileServiceResponder(FileServiceResponder.deleteProjectDirectoryHandle,this), transferObject );
			}
			else
			{
				AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.deleteFile",new FileServiceResponder(FileServiceResponder.deleteProjectDirectoryHandle,this), transferObject );
			}
		}
		
		public function deleteVersionDirectory( file : String ) : void 
		{
			currentAction = "deleteVersionDirectory";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = Conf.APP_ROOT+"/versions/";
			transferObject.files=[file];
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.deleteFile",new FileServiceResponder(FileServiceResponder.deleteVersionDirectoryHandle,this), transferObject );
		}
		
		public function create_directory ( currentFolder : String , folderName : String ) : void 
		{
			currentAction ="mkdir";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = currentFolder+folderName;
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.createDirectory",new FileServiceResponder(FileServiceResponder.createDirectoryHandle,this), transferObject );
			
		} 
		
		public function createPage( directory : String , file : String ):void
		{
			currentAction ="newPage";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = directory;
			transferObject.files = [ file+".xml"];
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.createNewPage",new FileServiceResponder(FileServiceResponder.createNewPageHandle,this), transferObject );
		}
		
		public function createFile ( file : String , content : String = "" ): void 
		{
			currentAction = "newFile";	
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [file];
			transferObject.content  = content ; 
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.createNewFile",new FileServiceResponder(FileServiceResponder.createNewFileHandle,this), transferObject );
		}
		public function deletePage( directory : String , file : String ) : void 
		{
			currentAction ="deletePage";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.directory = directory;
			transferObject.files = [file];
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.deletePage",new FileServiceResponder(FileServiceResponder.deleteHandle,this), transferObject );
		}
		
		public function createNewProject (directory : String, projectName:String, projectToCopy : String) : void
		{
			currentAction = "copyProject";
			var transferObject : FileDataTO = new FileDataTO();
		}
		
		
		public function getClientUpdate(updatedFilesPathArray : Array, localPathArray: Array) : void
		{
			currentAction = "update";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = updatedFilesPathArray ;
			transferObject.copiedFiles = localPathArray;
			trace("FILES "+transferObject.files+" NEWFILES "+transferObject.copiedFiles);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.updateFiles",new FileServiceResponder(FileServiceResponder.updateHandle,this), transferObject );
		}
		
		public function exportBitmap(fileName : String, destinationFolder : String, fileData : String ) : void
		{
			currentAction = "exportBitmap";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [fileName];
			transferObject.directory = destinationFolder=="" ? Conf.APP_ROOT+"/media/exports/" : Conf.APP_ROOT+"/"+destinationFolder;
			transferObject.content = fileData;
			trace("EXPORT image as "+transferObject.files[0]);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.exportBitmap",new FileServiceResponder(FileServiceResponder.exportHandle,this), transferObject );
			//AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.createNewFile",new FileServiceResponder(FileServiceResponder.exportHandle,this), transferObject );
		}
		
		public function exportPageThumbnail( fileName : String, destinationFolder : String, fileData : String ) : void
		{
			currentAction = "exportThumbnail";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [fileName];
			transferObject.directory = destinationFolder == "" ? Conf.APP_ROOT + "/xml_library/" :  destinationFolder;
			transferObject.content = fileData;
			trace("EXPORT thumbnail as " + transferObject.files[0]);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.exportBitmap",new FileServiceResponder(FileServiceResponder.exportHandle,this), transferObject );
		} 
		
		public function readXml( xmlUrl : String ) : void
		{
			currentAction = "readXml";
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.files = [ xmlUrl ];
			trace ("Reading distant xml (file or stream) :: "+transferObject.files[0]);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieBrowserService.readXML", new FileServiceResponder(FileServiceResponder.readXmlHandle, this), transferObject );
		}
		
		public function complete() : void 
		{
			switch(currentAction) 
			{
				case "appendData":
					dispatchEvent(new Event(DATA_ADDED));
					break;
				case "readXml":
					trace("dispatch xml fetched");
					dispatchEvent(new Event(READ_XML));
				case "delete":
				case "deletePage":
					dispatchEvent(new Event(DELETE_FILE));
					break;
				case "deleteDirectory":
					dispatchEvent(new Event(DELETE_FILE));
					break;
				case "deleteVersionDirectory":
					dispatchEvent(new Event(DELETE_VERSION_DIR));
					break;
				case "deleteProjectDirectory":
					dispatchEvent(new Event(PROJECT_DELETED));
					break;
				case "newPage":
					dispatchEvent(new Event(PAGE_CREATED));
					break;
				case "newFile":
					trace ("dispatching FILE_CREATED");
					dispatchEvent(new Event(FILE_CREATED));
					break;
				case "save":
					trace("dispatch save");
					dispatchEvent(new Event(FILE_SAVED));
					break;
					
				case "foldertree":
					dispatchEvent(new Event(READ_DIRECTORY));
					break;
				case "compileFont":
					dispatchEvent(new Event(FONT_COMPILED));
					break;
				case "getFontInfo":
					dispatchEvent(new Event(FONT_READ));
					break;
					
				case "copy":
					dispatchEvent(new Event(COPY_FILE));
					break;
				case "copy_dir":
					dispatchEvent(new Event(DIRECTORY_COPY));
					break;
				case "rename":
					dispatchEvent(new Event(COPY_FILE));
					break;
					
				case "mkdir":
					dispatchEvent(new Event(CREATE_DIRECTORY));
					break;
				case "upload":
					dispatchEvent(new Event(UPLOAD_FILE));
					break;
				case "copyProject":
					dispatchEvent(new Event(NEW_PROJECT_CREATED));
					break;
				case "update":
					dispatchEvent(new Event(UPDATES_COPY));
					break;
				case "exportBitmap":
					trace ("dispatching EXPORT_BITMAP");
					dispatchEvent(new Event(EXPORT_BITMAP));
				case "exportThumbnail":
					trace ("dispatching EXPORT_THUMBNAIL");
					dispatchEvent(new Event(EXPORT_THUMBNAIL));
			}
		}
		
		
		private var errorMessage : String ="";
		
		public function error(code:int=0, errorInfo : String = ""): void 
		{
			errorMessage = errorInfo;
			/*
			if(errorInfo != "")
			{
				Alert.show(errorInfo);
			}*/
			trace ("error au retour");
			dispatchEvent(new Event(ERROR));
		}
		
		public function getError() : String 
		{
			return errorMessage;
		}
		
		public function upload(directory : String ):void
		{
			uploadFolder = directory ;
			fileRef.browse();
		}
		
		protected function handleFileLoadedComplete(e:Event):void
		{
			currentAction="upload";
			var data:ByteArray = new ByteArray();
			fileRef = e.target as FileReference;
			fileRef.data.readBytes(data, 0, fileRef.data.length);
			var transferObject : FileDataTO = new FileDataTO();
			transferObject.bites = data;
			transferObject.files = [fileRef.name];
			transferObject.directory = uploadFolder;
			trace ("trying to upload with amfphp, file="+fileRef.name+"   bytes = "+ transferObject.bites.length);
			AbstractBootstrap.getInstance().getBusinessDelegate().call("FieFileUploadService.upload", new FileServiceResponder(FileServiceResponder.uploadHandle,this),transferObject);
			//AbstractBootstrap.getInstance().getBusinessDelegate().call("FieFileUploadService.testFileUpload", new FileServiceResponder(FileServiceResponder.uploadHandle,this));
		}

		private function startUpload( e : Event ) : void 
		{
			trace("startUpload... " );
			fileRef.addEventListener(Event.COMPLETE, handleFileLoadedComplete,false,0,true );
			fileRef.load();
		} 
		
		private function fileRef_progress(e:ProgressEvent):void
		{
			trace("uploadProgress... " + Math.round(e.bytesLoaded/e.bytesTotal*100));
			fileRef.removeEventListener(ProgressEvent.PROGRESS, fileRef_progress);

		}
		private function uploadComplete ( e : Event ) : void 
		{
			trace("uploaded file complete" + e.target.data);
			complete();
			//fileRef.removeEventListener(Event.COMPLETE, uploadComplete );
		} 
		private function fileRef_ioError(evt:IOErrorEvent):void {
                Alert.show(evt.text, evt.type);
           // fileRef.removeEventListener(IOErrorEvent.IO_ERROR, fileRef_ioError);
        }

	}
}