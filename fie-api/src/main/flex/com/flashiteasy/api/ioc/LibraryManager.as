/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.ioc
{
	import com.flashiteasy.api.core.project.Artifact;
	import com.flashiteasy.api.core.project.Project;
	import com.flashiteasy.api.library.ILibrary;
	import com.flashiteasy.api.library.LibraryLoader;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ProjectData;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	/**
	 * 
	 * The <code><strong>LibraryManager</strong></code> is the
	 * class that keeps track and manages the loading
	 * of internal and external libraries.
	 * 
	 * It is a pseudo-singleton, so any call to it must be made using 
	 * the <code><strong>LibraryManager.getInstance()</strong></code> syntax.
	 */
	public class LibraryManager
	{
		
		private static var instance : LibraryManager;
		/**
		 * Singleton implementation,
		 * it allows only one instanciation
		 * @default flase
		 */
		protected static var allowInstantiation : Boolean = false;
		
		private var listeners : Array = [];
		
		//private 
		
		/**
		 * Constructor : it accepts only one
		 * instance.
		 */
		public function LibraryManager()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use getInstance method.");
			}
		}
		
		/**
		 * Reset when loading a different project in the admin mode
		 */
		public function reset() : void
		{
			instance = null;
			delete this;
		}
		
		/**
		 * Events implementation for the loading
		 * of internal and external libraries.
		 * Pushes a special listener into the array
		 * @param listener ILibraryManagerListener
		 * 
		 * @see com.flashiteasy.api.ioc.ILibraryManagerListener
		 */
		public function addListener( listener : ILibraryManagerListener ) : void
		{
			listeners.push( listener );
		}
		
		/**
		 * Singleton implementation
		 * @return 
		 */
		public static function getInstance() : LibraryManager
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new LibraryManager();
				allowInstantiation = false;
			}
			return instance;
		}
		
		/**
		 * Registers a class in the library
		 * @param clazz
		 * throws Error when library implementations don't implement ILibrary 
		 * or when they are a constructor using arguments.
		 */
		public function registerLibrary( clazz : Class ) : void
		{
			try
			{
				var library : ILibrary = ILibrary( new clazz() );
				library.init();
				trace("init library");
			}
			catch( e : Error )
			{
				throw new Error("Unable to initialize FIE library : " + getQualifiedClassName( clazz ) + ", " + 
						"library implementations should implement ILibrary and define a no-args constructor." + describeType(clazz));
			}
		}
		
		private var libLoadedCountdown : int = 0;
		
		/**
		 * Loads the external libraries.
		 */
		public function loadExternalLibraries( libraries : Array , baseUrl : String ) : void
		{
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			libLoadedCountdown = libraries.length;
			
			for( var i : int = 0; i < libraries.length; i++ )
			{
				loadLibrary( Artifact( libraries[i] ) , baseUrl );
			}
		}
		
		private var loadedLibraries : Array = [];
		private var loadedArtifacts : Array = [];
		
		public function loadLibrary( artifact : Artifact , baseUrl : String ) : void 
		{
			trace("Loading external library " + artifact.getLongName() );
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			if( ArrayUtils.containsString( artifact.getLongName() , loadedLibraries  ) )
			{
				trace("library " + artifact.getLongName() + " already loaded ");
				externalLibraryLoaded();
			}
			else
			{
				loadedArtifacts.push(artifact);
				loadedLibraries.push( artifact.getLongName());
				var libraryLoader : LibraryLoader = new LibraryLoader( artifact );
				libraryLoaders.push( libraryLoader );
				// WORKAROUND FOR COMPLETE EVENT NOT FIRING

				//libraryLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, libraryLoaded, false, 0, true );
				if(!libraryLoader.contentLoaderInfo.hasEventListener( ProgressEvent.PROGRESS))
					libraryLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, libraryLoading, false, 0, true );
				trace( "-> "  + baseUrl + "/external/" + artifact.getCanonicalUrl() + "?var="+ new Date());
				var request : URLRequest = new URLRequest( baseUrl + "/" + artifact.getCanonicalUrl() );
				libraryLoader.load( request, context );
			}
		}
		
		private var libraryLoaders : Array = [];
		
		public function getLoadedLibraries () : Array 
		{
			return loadedLibraries;
		}
		
		/**
		 * Instead of using the buggy COMPLETE event, we need to check for progression
		 * of the external libraries loading and initialize them using a delay when they are
		 * fully loaded.
		 */
		private function libraryLoading( event : Event ) : void
		{
			var info : LoaderInfo = LoaderInfo(event.target);
			if( info.bytesLoaded == info.bytesTotal )
			{
				setTimeout( initExternalLib, 500, info );
			}
		}
		
		private function initExternalLib( info : LoaderInfo ) : void
		{
			var artifact : Artifact
			for( var i : int = 0; i < libraryLoaders.length; i++ )
			{
				if( LibraryLoader( libraryLoaders[i] ).contentLoaderInfo == info )
				{
					artifact = LibraryLoader( libraryLoaders[i] ).getArtifact();
					break;
				}
			}
			trace("Finished library loading("+artifact.getLongName()+"), artifact : " + artifact.artifactId );
			//var externalLib : ILibrary = ILibrary( info.applicationDomain.getDefinition("ExternalLibrary") );
			var clazzName : String = artifact.groupId + ".ExternalLibrary";
			trace("Initializing library using " + clazzName + " initializer.");
			var externalLibClazz : Class = info.applicationDomain.getDefinition(clazzName) as Class;
			registerLibrary( externalLibClazz );
			externalLibraryLoaded();
		}

		private function externalLibraryLoaded() : void
		{
			libLoadedCountdown--;
			if( libLoadedCountdown == 0 )
			{
				for( var i : int = 0; i < listeners.length; i++ )
				{
					ILibraryManagerListener( listeners[i] ).librariesLoaded();
				}
				listeners = [];
			}
			
		}
		
		
		public function checkForProjectDependencies( name : String ) : void
		{
			var baseUrl:String=".";
			var libMustBeRegistered : Boolean = false;
			var isExternalControl : Boolean = false;
			var toFind:String = "";
			var libToAdd : Artifact;
			var mustAddLibInClient : Boolean;
			if (name.indexOf("api") == -1) { // si le descriptor est externe 
				toFind = String(name.split("::")[1].split("ElementDescriptor")[0]).toLowerCase();
				isExternalControl = true;
			}
			trace ("isExternalControl :: "+isExternalControl+ " for ("+toFind+")"); 
			if (isExternalControl)
			{
				// the control is external, is it already registered in client ?
				
				var clientExternalLibs : Array = ProjectData.getInstance().getProject().getExternalLibraries();
				if ( clientExternalLibs.join("").indexOf(toFind)==-1 )
				{
					libMustBeRegistered = true;
				}
				
				if (libMustBeRegistered)
				{
					// external libs in admin
					var loadedLibString : String = loadedLibraries.join("");
					if (loadedLibString.indexOf(toFind) == -1 )
					{
						mustAddLibInClient = true;
					}
					else 
					{
						mustAddLibInClient =false;
					}
					/* for (var j:uint=0; j<loadedLibraries.length; j++)
					{
						trace ("iteration "+ j + " :: "+ String(loadedLibraries[j]+" :: "+String(loadedLibraries[j]).indexOf(toFind))+"("+toFind+")");
						if ( String(loadedLibraries[j]).indexOf(toFind) == -1 )
						{
							mustAddLibInClient = true;
							break;
						}
					} */
					if (mustAddLibInClient)
					{
						trace("==>>> ext lib "+ toFind +" must be registered in client");
						//loadLibrary(Artifact(externalLibsArtifacts[j]), "libraries/external");
						//ProjectData.getInstance().getProject().addExternalLibrary( Artifact(externalLibsArtifacts[j]) );
					}		
				}
			}
			trace ("checking dependency for "+name);
			trace ("mustAddLibInClient :: "+mustAddLibInClient);
		}

		public function listExternalLibraries() : void
		{
			
			var currentProject : Project = ProjectData.getInstance().getProject();
			var libArray : Array = currentProject.getExternalLibraries();
			//external libs in client
			for (var i:uint=0; i<libArray.length; i++)
			{
				trace ("loadedinclient lib :: "+Artifact(libArray[i]).getLongName());
			}
			// external libs in admin
			for (var j:uint=0; j<loadedLibraries.length; j++)
			{
				trace ("loadedinadminlib :: "+ this.loadedLibraries[j]);
			}
			var arr : Array = IocContainer.externalDescriptors;
			for (var k:uint =0; k<arr.length; k++)
			{
				trace ("controle :: "+arr[k]);
			}
		}

	}
}