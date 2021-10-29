package com.flashiteasy.admin.fieservice.transfer.tr
{
	import com.flashiteasy.api.fieservice.transfer.tr.TransferObject;
	
	import flash.utils.ByteArray;
	
	
	public class FileDataTO extends TransferObject
	{
		public function FileDataTO()
		{
			super();
		}
		
		public var files : Array ;
		public var directory : String ;
		public var deletedFiles : Array ;
		public var copiedFiles : Array ;
		public var errorFiles : Array ;
		public var success : Boolean ;
		public var content : String ;
		public var contentArray : Object ;
		
		public var bites : ByteArray;
		
	}
}