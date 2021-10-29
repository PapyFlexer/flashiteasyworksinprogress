/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

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
	import com.flashiteasy.api.core.elements.ILoopElementDescriptor;

	[ParameterSet(description="null",type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>LoopParameterSet</strong></code> is the parameterSet
	 * that handles the looping of a sound, a video or an animation.
  	 * 
	 */
	public class LoopParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			super.apply( target );
			if( target is ILoopElementDescriptor )
			{
				ILoopElementDescriptor( target ).setLoop(loop); 
			}
		}
		
		
		private var _loop : Boolean = false ;
		
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="0",label="Loop")]
		/**
		 * Loops an animation, a sound or a video
		 */
		public function get loop() : Boolean
		{
			return _loop;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set loop (value : Boolean) : void
		{
			_loop = value;
		}
		
	}
}