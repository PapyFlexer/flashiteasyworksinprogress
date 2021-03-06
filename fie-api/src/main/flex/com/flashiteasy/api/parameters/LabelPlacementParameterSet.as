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
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IFormItemLabelElementDescriptor;
	import com.flashiteasy.api.core.elements.IRadioButtonElementDescriptor;

	[ParameterSet(description="null",type="Reflection", groupname="Form_Item")]
	/**
	 * The <code><strong>LabelPlacementParameterSet</strong></code> is the parameterSet
	 * that handles the Form Item labels placement for CheckBox and RadioButton.
	 * It works with the LabelParameterSet.
	 * 
	 * @see com.flashiteasy.api.parameters.LabelParameterSet 
	 */
	public class LabelPlacementParameterSet extends AbstractParameterSet  implements IParameterSetStaticValues
	{
		private var lp:String="left";

		override public function apply(target:IDescriptor):void
		{
			if ( target is IFormItemLabelElementDescriptor )
			{
				IFormItemLabelElementDescriptor(target).setLabelPlacement(lp);
			}
		}

		[Parameter(type="Combo",defaultValue="left", row="0", sequence="0", label="Form Item")]
		/**
		 * 
		 * @return 
		 */
		public function get labelPlacement():String
		{
			return lp;
		}

		/**
		 * 
		 * @param value
		 */
		public function set labelPlacement(value:String):void
		{
			lp=value;
		}

		/**
		 * 
		 * @param value
		 */
		public function setLabelPlacement(value:String):void
		{
			lp=value;
		}

		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return ["left","right","top","bottom"];;
		}


	}
}