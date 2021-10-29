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
	/**
	 * The <code><strong>Artifact</strong></code> class represents an object loaded at runtime into the API. 
	 * It is characterized by a group id, a artifact id and a version 
	 */
	public class Artifact
	{
		
		private var _groupId : String;
		private var _artifactId : String;
		private var _version : String;

		/**
		 * @return the groupId
		 */
		public function get groupId() : String
		{
			 return _groupId;
		}
		/**
		 * 
		 * @param value
		 */
		public function set groupId( value : String		 ) : void
		{
			_groupId = value;
		}
		
		
		/**
		 * @return the artifactId
		 */
		public function get artifactId() : String
		{
			 return _artifactId;
		}
		/**
		 * 
		 * @param value
		 */
		public function set artifactId( value : String		 ) : void
		{
			_artifactId = value;
		}
		
		
		/**
		 * @return the version
		 */
		public function get version() : String
		{
			 return _version;
		}
		/**
		 * 
		 * @param value
		 */
		public function set version( value : String ) : void
		{
			_version = value;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getLongName() : String
		{
			return groupId + ":" + artifactId + ":" + version;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getCanonicalUrl() : String
		{
			return groupId.replace(/\./g, "_") + "_" + artifactId + "_" + version + ".swf";
		}

		
		/**
		 * Constructor
		 * @param groupId
		 * @param artifactId
		 * @param version
		 */
		public function Artifact( groupId : String, artifactId : String, version : String )
		{
			this.groupId = groupId;
			this.artifactId = artifactId;
			this.version = version;
		}

	}
}