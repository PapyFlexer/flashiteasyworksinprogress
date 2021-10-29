/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.library
{
	import com.flashiteasy.api.core.project.Artifact;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * The <code><strong>LibraryLoader</strong></code> takes charge
	 * of loading the external and internal libs.
	 * 
	 */
	public class LibraryLoader extends Loader
	{
		private var _artifact : Artifact;
		
		/**
		 * Constructor : takes an 'Artifact' as argument.
		 * 
		 * @param artifact : the swf containing the object 
		 * made with the API.
		 * 
		 * @see com.flashiteasy.api.core.project.Artifact
		 */
		public function LibraryLoader( artifact : Artifact )
		{
			super();
			_artifact = artifact;
		}
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			super.load( request, context );
		}
		
		/**
		 * Returns the Artifact (external library as .swf)
		 * @return Artifact
		 */
		public function getArtifact() : Artifact
		{
			return _artifact;
		}
		
	}
}