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
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.display.BlendMode;

	[ParameterSet(description="null",type="Reflection", groupname="Effects")]
	/**
	 * The <code><strong>BlendModeParameterSet</strong></code> is the parameterSet
	 * that handles the control's blend mode (ie: add, substract, product, layer ...).
	 * The metadata sets its editors via reflection in the Effect group, using 
	 * a Combo for the blend modes.
	 */
	public class BlendModeParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var bl:String="normal";

		/**
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().blendMode=blend_mode;
			}
		}

		[Parameter(type="Combo",defaultValue="normal", row="0", sequence="0", label="Blend_mode")]
		/**
		 * The control's blend mode. 
		 */
		public function get blend_mode():String
		{
			return bl;
		}

		/**
		 * 
		 * @private
		 */
		public function set blend_mode(value:String):void
		{
			bl=value;
		}

		/**
		 * Returns the array of blend modes as a dataprovider for the Combo editor.
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return ArrayUtils.getConstant(flash.display.BlendMode);
		}
	}
}