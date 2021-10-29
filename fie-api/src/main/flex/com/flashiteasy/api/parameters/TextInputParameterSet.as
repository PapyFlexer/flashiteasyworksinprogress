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
	import com.flashiteasy.api.core.IDescriptor;

	/**
	 * The <code><strong>TextInputParameterSet</strong></code> is the parameterSet
	 * that handles the TextInput form item.Most of its detailed functionalities
	 * come in other ParameterSet : RestrictParameterSetand those in validator package
	 */

	public class TextInputParameterSet extends FormItemParameterSet
	{
			
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			if ( target is TextInputElementDescriptor)
			{
				this.required = TextInputElementDescriptor(target).required;
				super.apply(target);
				TextInputElementDescriptor(target).drawAsteriskForRequired();
			}
		}
		
		
	}
}