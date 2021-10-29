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
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	
	[ParameterSet(description="null",type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>WaitForCompletionParameterSet</strong></code> is the parameterSet
	 * that handles the fact that a control waits for all its parameters to be instanciated and
	 * treated before triggering its rendering on stage.
	 * For controls that have long files to load - video, large image, ... - 
	 * this parameter should setto false
	 */

	public class WaitForCompletionParameterSet extends AbstractParameterSet
	{
		private var _waitComplete:Boolean=true;
		override public function apply(target: IDescriptor):void
		{
  			SimpleUIElementDescriptor( target ).waitComplete = _waitComplete;
  			
		}
		[Parameter(type="Boolean", defaultValue="true", row="0", sequence="0", label="Wait_for_content")]
		/**
		 * Enables the wait for completion parameter
		 */
		public function get waitComplete():Boolean{
			return _waitComplete;
		}
		/**
		 * 
		 * @private
		 */
		public function set waitComplete(value:Boolean):void{
			_waitComplete=value;
		}
		
	}
}