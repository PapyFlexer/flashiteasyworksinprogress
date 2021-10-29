package com.flashiteasy.admin.fieservice.responder
{	
	import com.flashiteasy.admin.fieservice.FileManagerService;
	import com.flashiteasy.admin.fieservice.transfer.tr.FileDataTO;
	import com.flashiteasy.api.fieservice.responder.BaseResponder;


	public class FileServiceResponder extends BaseResponder
	{
		private static var fms:FileManagerService
		
		public function FileServiceResponder(result:Function, fms:FileManagerService,status:Function=null)
		{
			FileServiceResponder.fms=fms;
			super(result, FileServiceResponder.onFault);
		}
		
		public static function readXmlHandle( transfer : FileDataTO ) : void
		{
			if ( Boolean( transfer.success ) )
			{
				trace ("xml data read ok" );
				FileServiceResponder.fms.content = transfer.content;
				FileServiceResponder.fms.complete();
			}
			else
			{
				trace ( "could not read the xml...");
				FileServiceResponder.fms.error();
			}
		} 
		
		public static function appendDataHandle ( transfer : FileDataTO ) : void 
		{
			if( Boolean ( transfer.success )) 
			{
				trace("add data success");
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("add data failed");
				FileServiceResponder.fms.error();
			}
		}
		
		public static function compileFontHandle ( transfer : FileDataTO) : void 
		{
			if( Boolean ( transfer.success )) 
			{
				trace("compileFont success");
				FileServiceResponder.fms.content = transfer.content;
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("compileFont Failed");
				FileServiceResponder.fms.error();
			}
		}
		
		public static function getFontInfoHandle ( transfer : FileDataTO) : void 
		{
			if( Boolean ( transfer.success )) 
			{
				trace("readFont success");
				FileServiceResponder.fms.contentArray = transfer.contentArray;
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("readFont Failed");
				FileServiceResponder.fms.error();
			}
		}
		public static function renameHandle( transfer : FileDataTO ) : void 
		{
			
			var numberOfFile : int = transfer.files.length;
			if( numberOfFile != transfer.deletedFiles.length ) 
			{
				trace ( " couldn t move all files "+ transfer.errorFiles.toString());
				FileServiceResponder.fms.error(1);
			}
			else
			{
				trace ( " delete success " ) ;
				FileServiceResponder.fms.complete();
			}
		}
		
		
		public static function treeHandle ( transfer : Object ) : void 
		{
			if(transfer.code==0) 
			{
				trace(" create tree success ");
				FileServiceResponder.fms.content = transfer.content;
				FileServiceResponder.fms.complete();
			} 
			else if(transfer.code ==1)
			{
				trace(" couldn t create tree :: "+transfer.code);
				FileServiceResponder.fms.error(transfer.code);	
			
			}
		}
		
		public static function saveHandle (  transfer : FileDataTO ) : void 
		{
			var test : Boolean = Boolean ( transfer.success ) ;
			if(test) 
			{
				trace("save success");
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("save Failed");
				FileServiceResponder.fms.error();
			}
		}
		
		public static function createNewFileHandle( transfer : FileDataTO ) : void 
		{
			
			if (transfer.success)
			{
				FileServiceResponder.fms.complete();
			}
			else 
			{
				FileServiceResponder.fms.error(Number(transfer.success), "cannot create xml");
			}
/* 			if(transfer.code==0) 
			{
				trace(" create new file success ");
				
			}
			else if(transfer.code ==1)
			{
				trace(" couldn t create file ");
				FileServiceResponder.fms.error(transfer.code);	
			}
			else if(transfer.code==2)
			{
				trace(" file already exist");
				FileServiceResponder.fms.error(transfer.code);		
			}
			else
			{
				trace ("bad case in FieServiceResponder, code is invalid");
			}
 */		}
		
		public static function createNewPageHandle( transfer : FileDataTO ) : void 
		{
			if(transfer.code==0) 
			{
				trace(" create new page success ");
				FileServiceResponder.fms.complete();
			}
			else if(transfer.code ==1)
			{
				trace(" couldn t create directory ");
				FileServiceResponder.fms.error(transfer.code);	
			}
			else if(transfer.code==2)
			{
				trace(" couldn t create file ");
				FileServiceResponder.fms.error(transfer.code);		
			}
		}
		public static function createDirectoryHandle( transfer : FileDataTO ) : void 
		{
			if(transfer.success) 
			{
				trace(" create new directory success ");
				FileServiceResponder.fms.complete();
			}
			/*else if(transfer.code ==1)
			{
				trace(" couldn t create directory ");
				FileServiceResponder.fms.error(transfer.code);	
			}*/
			else //if(transfer.code==2)
			{
				trace(" couldn t create file ");
				FileServiceResponder.fms.error(1);		
			}
		}
		
		public static function deleteHandle( transfer : FileDataTO ) : void 
		{
			var numberOfFile : int = transfer.files.length;
			if( numberOfFile != transfer.deletedFiles.length ) 
			{
				trace ( " couldn t delete all files "+ transfer.errorFiles.toString());
				FileServiceResponder.fms.error(1);
			}
			else
			{
				trace ( " delete success " ) ;
				FileServiceResponder.fms.complete();
			}
		}

		public static function deleteDirectoryHandle( transfer : FileDataTO ) : void 
		{
			var test : Boolean = Boolean ( transfer.success ) ;
			if (test) 
			{
				trace("deleteDir success");
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("deleteDir Failed");
				FileServiceResponder.fms.error(0, transfer.message);
			}
		}

		public static function deleteProjectDirectoryHandle( transfer : FileDataTO ) : void 
		{
			var numberOfFile : int = transfer.files.length;
			if( numberOfFile != transfer.deletedFiles.length ) 
			{
				trace ( " couldn t delete all files "+ transfer.errorFiles.toString());
				FileServiceResponder.fms.error(1);
			}
			else
			{
				trace ( " delete success " ) ;
				FileServiceResponder.fms.complete();
			}
		}

		public static function deleteVersionDirectoryHandle( transfer : FileDataTO ) : void 
		{
			var numberOfFile : int = transfer.files.length;
			if( numberOfFile == transfer.deletedFiles.length ) 
			{
				trace("deleteVersionDir success");
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("deleteVersionDir Failed");
				FileServiceResponder.fms.error(0, transfer.message);
			}
		}

		public static function copyHandle( transfer : FileDataTO ) : void 
		{
			var numberOfFile : int = transfer.files.length;
			if( numberOfFile != transfer.copiedFiles.length ) 
			{
				trace ( " couldn t copy all files "+ transfer.errorFiles.toString());
				FileServiceResponder.fms.error(1);
			}
			else
			{
				trace ( " copy success " ) ;
				FileServiceResponder.fms.complete();
			}
		}
		
		public static function updateHandle( transfer : FileDataTO ) : void 
		{
			var numberOfFile : int = transfer.files.length;
			if( numberOfFile != transfer.copiedFiles.length ) 
			{
				trace ( " couldn t update all files "+ transfer.errorFiles.toString());
				FileServiceResponder.fms.error(1);
			}
			else
			{
				trace ( " update success " ) ;
				FileServiceResponder.fms.complete();
			}
		}
		
		public static function exportHandle( transfer : FileDataTO ) : void
		{
			var test : Boolean = Boolean( transfer.success );
			if (test )
			{
				trace ("export ok!");
				FileServiceResponder.fms.complete();
			}
			else
			{
				trace ("export not ok!");
				FileServiceResponder.fms.error();
			}
		}
		
		public static function copyDirectoryHandler( transfer : FileDataTO ) : void 
		{
			var test : Boolean = Boolean ( transfer.success ) ;
			if(test) 
			{
				trace("copyDir success");
				FileServiceResponder.fms.complete();
			}	
			else
			{
				trace("copyDir Failed");
				FileServiceResponder.fms.error(0, transfer.message);
			}
		}
		
		public static function uploadHandle( transfer : FileDataTO ) :void
		{
			trace ("retour amf FileServiceResponder : "+transfer.message);
			if(transfer.code==0) 
			{
				trace(" upload file successful ");
				FileServiceResponder.fms.complete();
			}
			else if(transfer.code ==1)
			{
				trace(" couldn t upload file ");
				FileServiceResponder.fms.error(transfer.code);	
			}
			else if(transfer.code==2)
			{
				trace(" another upload error ");
				FileServiceResponder.fms.error(transfer.code);		
			}
		}
		
		public static function onFault( e : * ) :void
		{
			trace("fault");
			FileServiceResponder.fms.error(0,e.faultString);	
		}
	}
}