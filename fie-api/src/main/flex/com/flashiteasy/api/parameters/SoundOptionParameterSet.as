/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters {
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.ISoundOptionElementDescriptor;

	/**
	 * The <code><strong>SoundOptionParameterSet</strong></code> is the parameterSet
	 * that handles the looping of a sound
	 */
	public class SoundOptionParameterSet extends AbstractParameterSet {
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			super.apply( target );
			if( target is ISoundOptionElementDescriptor )
			{
				ISoundOptionElementDescriptor( target ).setLoop(loop);  
			}
		}
		
		private var _loop : Boolean = false ;
		
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="0",label="Loop")]
		/**
		 * Enables the loop
		 */
		public function get loop() : Boolean
		{
			return _loop;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set loop (value : Boolean) : void
		{
			_loop = value;
		}
		
		private var _autoStart : Boolean = false ;
		
		
	}
	
}
