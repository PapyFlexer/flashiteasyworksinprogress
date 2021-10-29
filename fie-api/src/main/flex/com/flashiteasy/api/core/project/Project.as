/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core.project
{
	import flash.utils.Dictionary;
	
	/**
	 * The <code><strong>Project</strong></code> class represents the collection of documents (pages, contents, actions, external libs and so on...)
	 * that make a whole FIE document. It can be a website, an online presentation, a banner, ...
	 */
	public class Project extends PageList
	{
		private var externalLibraries : Array = new Array();
		
		private var paramDictionary : Dictionary = new Dictionary();
		
		private var _nature : String;
		
		private var _owner : int;
		

		/**
		 * Adds an external library (made with FIE API) to the project.
		 * @param a the artifact class (external library, developped by the present API) to be added to the project
		 */
		public function addExternalLibrary( a : Artifact ) : void
		{
			externalLibraries.push( a );
		}
		
		/**
		 * Lists all the external libraries loaded into the project
		 * @return an array of externalLibs
		 */
		public function getExternalLibraries() : Array
		{
			return externalLibraries;
		}
		
		/**
		 * Adds a parameter (key/value pair) to the project.
		 * @param key a string depicting the parameter
		 * @param value the value to which the parameter is equal.
		 */
		public function addParameter( key : String, value : String ) : void
		{
			paramDictionary[key] = value;
		}
		
		/**
		 * Returns a project parameter value, using its key. 
		 * @param key the parameter key whose value we want to get.
		 * @return a string representing the value of the parameter
		 */
		public function getParameter( key : String ) : String
		{
			if ( !paramDictionary.hasOwnProperty( key ) )
			{
				throw new Error('parameter ' + key + ' do not exist in project.xml ');
			} 
			else
			{
				return paramDictionary[key];
			}
		}
		
		/**
		 * 
		 * @return the nature of the project (site/presentation/banner);
		 */
		public function get nature( ) : String
		{
			return _nature;
		}
		
		public function set nature( value : String) : void
		{
			_nature = value;
		}

		/**
		 * 
		 * @return the nature of the project (site/presentation/banner);
		 */
		public function get owner( ) : int
		{
			return _owner;
		}
		
		public function set owner( value : int) : void
		{
			_owner = value;
		}

	}
}