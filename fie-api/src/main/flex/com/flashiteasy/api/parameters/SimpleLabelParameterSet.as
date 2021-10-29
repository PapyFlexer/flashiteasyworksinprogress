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
	import com.flashiteasy.api.core.elements.ILabelElementDescriptor;
	
	[ParameterSet(description="Label", type="Reflection", groupname="Block_Content")]
	/**
	/**
	 * The <code><strong>SimpleLabelParameterSet</strong></code> is the parameterSet
	 * that handles the form item Label.
	 */
	 
	public class SimpleLabelParameterSet  extends AbstractParameterSet 
	{
		private var _label : String;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ):void
		{
			if (target is ILabelElementDescriptor)
				ILabelElementDescriptor(target).label = _label
		}
		
		[Parameter(type="String", defaultValue="Label", label="Label")]
		/**
		 * Sets the Label string
		 */
		public function get Label() : String{
			return _label	
		}
		/**
		 * 
		 * @private
		 */
		public function set Label(value : String) : void
		{
			_label = value;
		}
	}
}