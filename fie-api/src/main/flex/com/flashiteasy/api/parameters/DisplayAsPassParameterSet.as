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
	import com.flashiteasy.api.controls.TextInputElementDescriptor;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;

	[ParameterSet(description="null",type="Reflection", groupname="Form_Item")]
	/**
	 * The <code><strong>RestrictParameterSet</strong></code> is the parameterSet
	 * that handles the string restriction in a TextInput form item.
	 * It take the following form :
	 * <ul>
	 * <li><strong>[0-9] : </strong>Numbers only</li>
 	 * <li><strong>[A-Z] : Only capital letters</li>
   	 * <li><strong>[A-Z a-z] : </strong>only letters</li>
   	 * <li><strong>... : </strong>and so on...</li>
   	 * 
   	 * </ul>
	 */
	public class DisplayAsPassParameterSet extends AbstractParameterSet
	{
		private var _enable : Boolean
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			super.apply( targ );
			if (targ is TextInputElementDescriptor)
			{
				TextInputElementDescriptor(targ).getTextInput().displayAsPassword = enable;
			}
			//restrStr = targ.
		}
		
		[Parameter(type="Boolean", defaultValue="false",row="0", sequence="1", label="Password", groupname="Form Item")]
		/**
		 * Sets the restrict string for the TextInout form item
		 * @default "A-Z a-z 0-9"
		 */
		public function get enable() : Boolean
		{
			return _enable;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set enable( value : Boolean ) : void
		{
			_enable = value;
		}
	}
}