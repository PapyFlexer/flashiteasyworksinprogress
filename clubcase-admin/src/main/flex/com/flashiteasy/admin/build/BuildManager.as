package com.flashiteasy.admin.build
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.api.builder.ElementBuilder;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.ioc.LibraryManager;
	
	import flash.utils.getQualifiedClassName;
	
	public class BuildManager
	{
		

		private static var allowInstantiation : Boolean = false;
		private static var instance:BuildManager;
		private var builder:ElementBuilder;
		
		public function BuildManager()
		{
			if( ! allowInstantiation )
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}
			builder=new ElementBuilder();
		}
		
		public static function getInstance():BuildManager{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new BuildManager();
				allowInstantiation = false;
			}
			return instance;
		}

		public function createElement(page:Page,type:String,id:String,name:String,parent:IUIElementContainer=null):IUIElementDescriptor
		{
			// checks if the control is provided by an external lib (sending descriptor type), and if yes, adds it to the project dependencies
			//LibraryManager.getInstance().checkForProjectDependencies(  name  );
			var control:IUIElementDescriptor = builder.createElement(page,type,id,name,parent);
			ApplicationController.getInstance().getBlockList().update();
			return control;
		}
		
		public function createAction( page:Page ,type:String, id:String, name:String ) : IAction
		{
			// checks if the control is provided by an external lib, and if yes add it to the project dependencies
			//LibraryManager.getInstance().checkForProjectDependencies( name );
			var action : IAction = builder.createAction( page, type, id, name );
			ApplicationController.getInstance().getActionEditor().update();
			return action;
		}

		public function createStory( page:Page ,type:String, id:String, name:String ) : Story
		{
			var s : Story = builder.createStory( page, type, id, name );
			ApplicationController.getInstance().getStoryEditor().update();
			return s;
		}
		
	}
}