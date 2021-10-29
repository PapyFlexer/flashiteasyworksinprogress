package com.flashiteasy.admin.utils
{
	public class MetadataUtil
	{
		public static function getMetadata( x : XML, name : String ) : Metadata
		{
			var xMetadata : XML = x.metadata.(@name==name)[0];
			if( xMetadata != null )
			{
				var metadata : Metadata = new Metadata();
				metadata.setName( xMetadata.@name );
				var xArgs : XMLList = xMetadata.arg;
				for each( var xArg : XML in xArgs )
				{
					metadata.getArguments().push( new MetadataArgument( xArg.@key, xArg.@value ) );
				}
				return metadata;
			}
			return null;
		}

	}
}