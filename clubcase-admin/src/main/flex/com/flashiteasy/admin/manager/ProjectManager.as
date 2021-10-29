package com.flashiteasy.admin.manager
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.event.ProjectEvent;
	import com.flashiteasy.admin.fieservice.FileManagerService;
	import com.flashiteasy.admin.popUp.MessagePopUp;
	import com.flashiteasy.api.core.project.Artifact;
	import com.flashiteasy.api.core.project.Project;
	import com.flashiteasy.api.ioc.ILibraryManagerListener;
	import com.flashiteasy.api.ioc.LibraryManager;
	import com.flashiteasy.api.utils.LoaderUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	import mx.core.Application;
	
	public class ProjectManager extends EventDispatcher implements ILibraryManagerListener
	{
		
		public const SITE_PROJECT : String = Conf.languageManager.getLanguage("site_project");

		public const PRES_PROJECT : String = Conf.languageManager.getLanguage("presentation_project");

		public const BANN_PROJECT : String = Conf.languageManager.getLanguage("banner_project");
		
		public const PROJECT_NATURES : Array = [SITE_PROJECT,PRES_PROJECT,BANN_PROJECT];


		public static var PROJECT_CREATED : String = "PROJECT_MANAGER_CREATE";
		public static var CREATION_FAILED : String = "CREATION_FAILED";
		
		
		[Bindable]
		private var _projects : Array = new Array;
		
		protected static var projectUrl : String = "res/projects.xml"
		protected static var librariesUrl : String = "res/libraries.xml";
				
		private static var instance : ProjectManager;
		protected static var allowInstantiation : Boolean = false;
		
		private static var fms : FileManagerService = new FileManagerService();
		private static var alert:MessagePopUp;
		
		public function ProjectManager()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		public static function getInstance() : ProjectManager
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new ProjectManager();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function getLang(s:String):String
			{
				return Conf.languageManager.getLanguage(s);
			}

		public function loadInformation() : void
		{
			
			
			//LoaderUtil.getLoader(this, projectsInfoLoaded ).load(new URLRequest( projectUrl+"?timestamp=" + (new Date()).getTime() ));
			
			LibraryManager.getInstance().addListener(this);
			
			trace ("creating Loader for projects info");
			LoaderUtil.getLoader(this, librariesXMLLoaded ).load(new URLRequest( librariesUrl+"?timestamp=" + (new Date()).getTime() ));
		}
		
		private function librariesXMLLoaded( e : Event ) : void 
		{
			var artifacts : Array = [];
			var info : XML = new XML(e.target.data);
			for each ( var xml : XML in info.*)
			{ 
				var artifactNameParts : Array = xml.text().split(":"); 
				artifacts.push(new Artifact( artifactNameParts[0], artifactNameParts[1], artifactNameParts[2] ));
			}
			LibraryManager.getInstance().loadExternalLibraries( artifacts , "libraries" );
		}
		
		private function projectsInfoLoaded(e:Event) : void
		{
			if (e.type == "complete")
			{
				_projects=[];
				var info : XML = new XML(e.target.data);
				for each ( var xml : XML in info..project)
				{ 
					var projInfo:Object = new Object;
					projInfo.label = xml.@name;
					projInfo.data = xml.@url;
					projInfo.nature = xml.@nature;
					projInfo.owner = xml.@owner;
					_projects.push(projInfo);
					trace ("project : "+xml.@name);
				}
				trace ("dispatch PROJECTS_INFO_LOADED");
				dispatchEvent(new ProjectEvent(ProjectEvent.PROJECTS_INFO_LOADED));
			}
		}
		
		private var projectName : String = "";
		private var projectNature : String = "";
		private var projectOwner : int = -1;
		private var newProject : Object;
		
		public function deleteProject( project : Object ) : void
		{
			newProject = project ;
			projectName = project.label;
			projectNature = project.nature;
			projectOwner = project.owner;
			fms.addEventListener(FileManagerService.ERROR , saveError, false ,0 , true);
			trace ("ProjectManager is trying to delete project '"+projectName+"'");
			alert = new MessagePopUp(getLang("Deleting_project...") , mx.core.Application.application as DisplayObject, true);
			fms.addEventListener(FileManagerService.PROJECT_DELETED, projectDeleted);
			fms.deleteProjectDirectory( projectName );
		}
		
		public function writeNewProject( project : Object , projectToCopy : String = "" ) : void
		{
			newProject = project ;
			projectName = project.label;
			projectNature = project.nature;
			projectOwner = project.owner;
			fms.addEventListener(FileManagerService.ERROR , saveError, false ,0 , true);
			alert = new MessagePopUp(getLang("Creating_new_project...") , mx.core.Application.application as DisplayObject, true);
			fms.addEventListener(FileManagerService.DIRECTORY_COPY , projectCreated);
			if( projectToCopy == "" )
			{
				fms.copyDirectory( "../fie-projects/fie-sample-app" , "../fie-projects/"+ projectName ) ;
			}
			else
			{
				fms.copyDirectory( "../fie-projects/"+projectToCopy , "../fie-projects/"+ projectName ) ;
			}
		}
		
		public function librariesLoaded() : void
		{
			trace ("creating Loader for projects info");
			Conf.libraries = LibraryManager.getInstance().getLoadedLibraries().concat();
			var projectsURL : String = projectUrl+"?timestamp=" + String( (new Date()).getTime() );
			if(Security.sandboxType == Security.REMOTE)
			{
			  var context:LoaderContext = new LoaderContext();
			  context.securityDomain = SecurityDomain.currentDomain;
			  LoaderUtil.getLoader(this, projectsInfoLoaded ).load( new URLRequest( projectsURL ) )
			} else {
				LoaderUtil.getLoader(this, projectsInfoLoaded ).load( new URLRequest( projectsURL ) );
			}
			
		}
		
		
		
		private function saveError(e:Event):void{
			var manager : FileManagerService = e.target as FileManagerService ;
			fms.removeEventListener(FileManagerService.ERROR , saveError);
			if (manager.getError() != null) alert.changeMessage(Conf.languageManager.getLanguage(manager.getError()));
			alert.center();
			alert.showOk();
			dispatchEvent(new Event(CREATION_FAILED));
		}
			
		private function saveSuccess(e:Event):void
		{
			fms.removeEventListener(FileManagerService.FILE_SAVED , saveSuccess);
			alert.closePopUp();
			dispatchEvent(new Event(PROJECT_CREATED));
		}
		
		private function projectCreated( e : Event ) : void 
		{
			_projects.push(this.newProject);
			fms.removeEventListener(FileManagerService.ERROR , saveError);
			fms.removeEventListener(FileManagerService.DIRECTORY_COPY , projectCreated );
			fms.addEventListener(FileManagerService.FILE_SAVED , saveSuccess,false , 0 , true);
			fms.addEventListener(FileManagerService.ERROR , saveError, false ,0 , true);
			alert.changeMessage(Conf.languageManager.getLanguage("updating_projects"));
			fms.saveContent(projectUrl,serializeProjects());
		}
		
		private function projectDeleted( e : Event ) : void 
		{
			var arr:Array = new Array;
			for each (var p:Object in _projects)
			{
				if (p.label != this.newProject.label)
				{
					arr.push(p);
				}
			}
			projects = arr;
			fms.removeEventListener(FileManagerService.ERROR , saveError);
			fms.removeEventListener(FileManagerService.DELETE_FILE , projectDeleted );
			fms.addEventListener(FileManagerService.FILE_SAVED , saveSuccess,false , 0 , true);
			fms.addEventListener(FileManagerService.ERROR , saveError, false ,0 , true);
			alert.changeMessage(Conf.languageManager.getLanguage("updating_projects"));
			fms.addEventListener(ProjectEvent.PROJECTS_INFO_REFRESHING, onProjectListSaved);
			fms.saveContent(projectUrl,serializeProjects());
		}
	
		private function onProjectListSaved(e:ProjectEvent):void
		{
			trace("dispatching a project refreshed event");
			fms.removeEventListener(ProjectEvent.PROJECTS_INFO_REFRESHING, onProjectListSaved);
			dispatchEvent(new ProjectEvent(ProjectEvent.PROJECTS_INFO_REFRESHED));
		}
		
		private static  function copyProjectError(e:Event):void
		{
			fms.removeEventListener(FileManagerService.ERROR , copyProjectError);
			//throw new Error(" Error : couldn t save XML ");
			alert.changeMessage(Conf.languageManager.getLanguage("CopyProjectError"));
			alert.showOk();
		}
			
		private function copyProjectSuccess(e:Event):void
		{
			fms.removeEventListener(FileManagerService.NEW_PROJECT_CREATED , copyProjectSuccess);
			trace("new project saved");
			fms.addEventListener(FileManagerService.FILE_SAVED , saveSuccess,false , 0 , true);
			fms.saveContent(projectUrl,serializeProjects());
			
		}
		
		private function serializeProjects() : XML
		{
			var projectsXml : XML = new XML(<projects />);
			for each (var prj : Object in projects)
			{
				var prnode:XML = new XML(<project />);
				prnode.@name = prj.label;
				prnode.@url = prj.data;
				prnode.@nature = prj.nature;
				prnode.@owner = prj.owner;
				projectsXml.appendChild(prnode);
			}
			trace ("svg projects xml = "+projectsXml);
			return projectsXml;
		}
		
		public function getProjectByName( name : String ) : Object 
		{
			for each( var project : Object in _projects )
			{
				if( project.label == name )
				{
					return project;
				}
			}
			return null;	
			
		}
		[Bindable]
		public function get projects() : Array
		{
			return _projects;
		}
		public function set projects( value : Array ) : void
		{
			_projects = value;
		}
		
		public function getFirstProject(): *
		{
			return _projects[0];
		}
		
		public function getProjectNatures() : Array
		{
			var arr : Array = new Array;
			for (var i: uint = 0; i< this.PROJECT_NATURES.length; i++)
			{
				var o : Object = new Object;
				//o.label = Conf.languageManager.getLanguage(this.PROJECT_NATURES[i]);
				o.label = PROJECT_NATURES[i];
				o.data = i;
				arr.push(o);
			}
			return arr;
		}
		
		public function getProjectNature( p : Project ) : String
		{
			return p.nature;
		}
		
		public function getProjectOwner( p : Project ) : int
		{
			return p.owner;
		}
	}
}