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
	import com.flashiteasy.api.core.elements.ISoundElementDescriptor;

	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>SoundParameterSet</strong></code> is the parameterSet
	 * that handles the source of an impoited sound file.
	 */

	public class SoundParameterSet extends AbstractParameterSet
	{
		private var _source : String;
		
		/**
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is ISoundElementDescriptor )
			{
				ISoundElementDescriptor( target ).setSound( source );
			}
		}
		
		[Parameter(type="Source", defaultValue="null", row="0", sequence="0", label="Source")]
		/**
		 * Sets the source file of the sound
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
		
	}
}