/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IVideoElementDescriptor;

	[ParameterSet(description="Source", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>VideoParameterSet</strong></code> is the parameterSet
	 * that handles the displaying of a video. 
	 * TODO : implement player skins
	 */
	public class VideoParameterSet extends AbstractParameterSet
	{
		private var _source : String;
		private var _pauseAtStart : Boolean;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target : IDescriptor ) : void
		{
			super.apply( target );
			if( target is IVideoElementDescriptor )
			{
				IVideoElementDescriptor( target ).setVideo( source );
			}
		}
		[Parameter(type="Source", defaultValue="null", row="0", sequence="0", label="Source")]
		/**
		 * Sets the video source
		 */
		public function get source():String{
			
			return _source;	
		}
		
		/**
		 * 
		 * @private
		 */
		public function set source( value:String ):void{
			_source=value;
		}

		[Parameter(type="Boolean", defaultValue="false", row="1", sequence="2", label="Pause at start")]
		/**
		 * Sets the video source
		 */
		public function get pauseAtStart() : Boolean
		{
			return _pauseAtStart;
		}

		public function set pauseAtStart( value : Boolean ) : void
		{
			_pauseAtStart = value;
		} 

		
	}
}