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
	
	import com.flashiteasy.api.core.project.Project;
	
	import flash.events.EventDispatcher;
	
	/**
	 * The <code><strong>ProjectData</strong></code> class is
	 * an utility class dealing with ProjectData loading. 
	 * It extends the EventDispatcher so listeners can be attached.
	 */
	public class ProjectData extends EventDispatcher
	{
		
		private static var currentProject:Project;
		private static var instance : ProjectData;
		/**
		 * Singleton implementation
		 * @default 
		 */
		protected static var allowInstantiation : Boolean = false;
		
		/**
		 * Constructor singleton : no more  than one instance
		 * @throws Error
		 */
		public function ProjectData()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		/**
		 * Resets the ProjectData object
		 */
		public function reset() : void
		{
			instance = null;
			currentProject = null;
		}
		
		/**
		 * Singleton impl.
		 * @return 
		 */
		public static function getInstance() : ProjectData
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new ProjectData();
				allowInstantiation = false;
			}
			return instance;
		}
		
		/**
		 * Sets the current project
		 * @return 
		 */
		public function getProject():Project{
			return currentProject;
		}

		/**
		 * 
		 * @private
		 */
		public function setProject( value : Project):void{
			currentProject=value;
		}
		
	}
}