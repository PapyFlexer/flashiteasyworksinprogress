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
	import com.flashiteasy.api.core.elements.IFormItemLabelElementDescriptor;
	import com.flashiteasy.api.core.elements.IRadioButtonElementDescriptor;

	[ParameterSet(description="Label", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>LabelParameterSet</strong></code> is the parameterSet
	 * that handles the Form Item labels for Button, CheckBox and RadioButton.
	 * It works with the LabelPlacementParameterSet.
	 * 
	 * @see com.flashiteasy.api.parameters.LabelPlacementParameterSet 
	 */
	public class LabelParameterSet extends AbstractParameterSet
	{
		
		private var lbl:String = "label";
		override public function apply(target: IDescriptor):void
		{
            if ( target is IFormItemLabelElementDescriptor )
            {
				IFormItemLabelElementDescriptor( target ).label = lbl
            }
		}
 		[Parameter(type="String",defaultValue="Component",row="1", sequence="1" , label="Label")]
		/**
		 * The string for label
		 */
		public function get label() : String
		{
			return lbl;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set label( value : String) : void
		{
			lbl = value;
		}
		
	}
}