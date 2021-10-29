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
	public class RestrictParameterSet extends AbstractParameterSet
	{
		private var _restrString : String
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			super.apply( targ );
			if (targ is TextInputElementDescriptor)
			{
				TextInputElementDescriptor(targ).getTextInput().restrict = restrStr;
			}
			//restrStr = targ.
		}
		
		[Parameter(type="String", defaultValue="",row="0", sequence="0", label="Restrict", groupname="Form Item")]
		/**
		 * Sets the restrict string for the TextInout form item
		 * @default "A-Z a-z 0-9"
		 */
		public function get restrStr() : String
		{
			return _restrString;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set restrStr( value : String ) : void
		{
			_restrString = value;
		}
	}
}