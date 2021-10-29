/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * The <code><strong>LoaderUtils</strong></code> class is
	 * an utility class dealing with the project Loaders.
	 * Each new loader replaces the old one so its data can be garbage collected.
	 */
	public class LoaderUtil
	{
		
		private static var loaders : Dictionary = new Dictionary(true); 
		
		/**
		 * Returns a Loader stocked in the Dictionary, 
		 * and adds the correct listeners for
		 * Event.COMPLETE and IOErrorEvent.IO_ERROR events.
		 * @param referenceObject
		 * @param resourceLoaded
		 * @return 
		 */
		public static function getLoader( referenceObject : Object, resourceLoaded : Function ) : URLLoader
		{
			var loader : URLLoader = loaders[ referenceObject ];
			if( loader != null )
			{
				loader.removeEventListener( Event.COMPLETE, resourceLoaded );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
			}
			loader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, resourceLoaded );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onError );
			loaders[ referenceObject ] = loader;
			return loader;
		}
		
		public static function directLoad( referenceObject : Object, resourceLoaded : Function , url : String ) : void
		{
			url+="?timestamp=" + (new Date()).getTime();
			trace ("loading... "+ url);
			getLoader( referenceObject , resourceLoaded ).load(new URLRequest(url));
		}
		
		/**
		 * Fired when an IOErrorEvent is dispatched
		 * @param e Event
		 */
		public static function onError( e : Event ) : void
		{
			trace( "Could not load XML file."+(e.target as Loader).contentLoaderInfo.url);
		}
		
		/**
		 * Method that states if the project is running
		 * in client mode or in admin mode : true for client, false for admin.
		 * @return a Boolean
		 */
		public static function isInApplication() : Boolean
		{
            var isInApp:Boolean = true;
            var appClazz : Class;
            try
            {
                appClazz = getDefinitionByName("mx.core.Application") as Class;
                appClazz = null;
            }
            catch ( e : Error )
            {
                return false;
            }
            return true;
		}

	}
}