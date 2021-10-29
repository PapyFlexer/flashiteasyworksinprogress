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
	import com.flashiteasy.api.core.elements.IResizeFromChildrenElementDescriptor;

	[ParameterSet(description="Resize", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>ResizeFromChildrenParameterSet</strong></code> is the parameterSet
	 * that handles the resizing of a container, based on its children'sizings.
	 */
	public class ResizeFromChildrenParameterSet extends AbstractParameterSet
	{
		override public function apply(target:IDescriptor):void
		{
			if(target is IResizeFromChildrenElementDescriptor)
			{
				IResizeFromChildrenElementDescriptor(target).resizeFromChildren(enable);
			}
		}
		
		private var _enable : Boolean 
		[Parameter(type="Boolean",defaultValue="false",row="0",label="enable")]
		/**
		 * Enabvles the 'ResizeFromChildren' mode
		 */
		public function get enable():Boolean
		{
			return _enable ;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set enable( value : Boolean ) : void 
		{
			_enable = value ;
		}
	}
}