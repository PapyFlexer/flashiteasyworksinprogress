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
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IMaskElementDescriptor;

	[ParameterSet(description="null",type="Reflection",groupname="Block_Content")]

	/**
	 * The <code><strong>MaskTypeParameterSet</strong></code> is a CompositeParameterSet
	 * that handles the masking of a control.
	 * @see com.flashiteasy.api.parameters.MaskParameterSet
 	 */
 	 
	public class MaskTypeParameterSet extends CompositeParameterSet
	{
		
		private var _enable : Boolean = false;
		
		/**
		 * 
		 * @iniheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			if( targ is IMaskElementDescriptor )
			{
				IMaskElementDescriptor( targ ).setMaskEnable( enable );
			}
			super.apply( targ );
		}
		
		[Parameter(type="MaskType",defaultValue="false",row="0", sequence="0",label="null")]
		/**
		 * Enables the mask 
		 */
		public function get enable():Boolean{
			return _enable;
		}
		/**
		 * 
		 * @private
		 */
		public function set enable(value:Boolean):void{
			_enable=value;
		}
	}
}