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
	import com.flashiteasy.api.core.elements.IMarginElementDescriptor;

	[ParameterSet(description="Margin",type="Reflection",groupname="Block_Content")]
	/**
	 * 
	 * The <code><strong>MarginParameterSet</strong></code> is the parameterSet
	 * that handles text control margin
	 */
	public class MarginParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			super.apply( target );
			if( target is IMarginElementDescriptor )
			{
				IMarginElementDescriptor( target ).setMargin( margin ); 
			}
		}
		
		private var _margin:Number=0;
		
		[Parameter(type="Number",defaultValue="0",row="0",sequence="0",label="Margin")]
		/**
		 * The margin of the text. 
		 */
		public function get margin():Number
		{
			return _margin;
		}
		/**
		 * 
		 * @param value
		 */
		public function set margin(value:Number):void{
			_margin=value;
		}
		
	}
}