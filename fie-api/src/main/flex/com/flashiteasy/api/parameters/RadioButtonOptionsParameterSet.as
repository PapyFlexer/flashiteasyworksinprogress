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
	import com.flashiteasy.api.core.elements.IRadioButtonElementDescriptor;

	[ParameterSet(description="null",type="Reflection", groupname="Form_Item")]
	/**
	 * The <code><strong>RadioButtonOptionsParameterSet</strong></code> is the parameterSet
	 * that handles the RadioButton form item options : 
	 * label, labelPlacement and group.
	 */
	public class RadioButtonOptionsParameterSet extends AbstractParameterSet
	{
		private var _group:String;
		private var _label:String;
		private var _lblPlacement:String;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			if(target is IRadioButtonElementDescriptor)
			{
				super.apply( target );
				IRadioButtonElementDescriptor(target).setGroup(this.group);
				//IRadioButtonElementDescriptor(target).label = this.label;
			}

		}
		
		[Parameter(type="String",defaultValue="RadioButtonGroup",row="0",sequence="0",label="Group")]
		/**
		 * Sets the group of the RadioButton 
		 */
		public function get group():String{
			return _group;
		}
		/**
		 * 
		 * @private
		 */
		public function set group(value:String):void{
			_group=value;
		}
		
		
	}
}