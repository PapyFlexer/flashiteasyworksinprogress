/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.selection
{
	import com.flashiteasy.api.core.project.XMLFile;
	
	/**
	 * The <code><strong>XMLFileList</strong></code> class is the
	 * pseudo-singleton class
	 * that manages and keeps track of all the XML files
	 * associated to the project.
	 * These files are kind of 'templates' or 'element groups libraries'.
	 * Acts as a Singleton
	 */
	public class XMLFileList
	{
		private static var instance:XMLFileList;
		/**
		 * 
		 * @default 
		 */
		protected static var allowInstantiation:Boolean=false;
		
		private var files : Array = []; 
		private var names : Array = [];
		
		/**
		 * Constructor singleton
		 */
		public function XMLFileList()
		{
			if (!allowInstantiation)
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}

		/**
		 * Singleton implementation
		 * @return a single XMLFileList instance
		 */
		public static function getInstance():XMLFileList
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new XMLFileList();
				allowInstantiation=false;
			}
			return instance;
		}
		
		/**
		 * Initializes the list
		 */
		public function reset():void
		{
			files = [];
			names = [];
		}
		
		/**
		 * Pushes a new XMLFile instance in the list
		 * @param xml XMLFile instance
		 * 
		 * @see com.flashiteasy.api.core.project.XMLFile
		 */
		public function addXML( xml : XMLFile ) : void 
		{
			files.push(xml);
			names.push(xml.name);
		}
		
		/**
		 * Returns an XMLFile instance based on its name
		 * @param name
		 * @return 
		 */
		public function findXML( name : String ) : XMLFile
		{
			for each ( var xml : XMLFile in files ) 
			{
				if( xml.name == name )
				{
					return xml;
				}
			}
			return null;
		}
		
		/**
		 * Returns the list of XMLFiles names
		 * @return 
		 */
		public function getXMLNames() : Array 
		{
			return names;	
		}
		
		/**
		 * Removes an XMLFile instance from the XMLFileList
		 * @param xml
		 */
		public function removeXML( xml : XMLFile ) : void 
		{
			var i : int ;
			for ( i=0 ; i<files.length ; i ++ )
			{
				if( xml == files[i])
				{
					files.splice(i,1);
					names.splice(i,1);
					return ;
				}
			}
		}

	}
}