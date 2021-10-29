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
	import com.flashiteasy.api.core.elements.IResizableElementDescriptor;

	/**
	 * The <code><strong>ResizeContainerParameterSet</strong></code> is the parameterSet
	 * that handles the containers resizing
	 */
	public class ResizeContainerParameterSet extends AbstractParameterSet {
		
		override public function apply(target:IDescriptor):void
		{
			if ( target is IResizableElementDescriptor )
			{
				IResizableElementDescriptor(target).resizeContainer=resizeContainer;
			}
		}
		
		private var _resizable : Boolean = true;
		
		/**
		 * Enables the resize container functionality 
		 */
		public function get resizeContainer() : Boolean
		{
			return _resizable;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set resizeContainer (value: Boolean) : void
		{
			_resizable = value;
		}
	}
}
