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
	import com.flashiteasy.api.core.elements.ISmoothElementDescriptor;

	[ParameterSet(description="null",type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>SmoothParameterSet</strong></code> is the parameterSet
	 * that handles the smoothing of a bitmap image or video
	 */
	public class SmoothParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			super.apply( target );
			if( target is ISmoothElementDescriptor )
			{
				ISmoothElementDescriptor( target ).setSmooth(smooth); 
			}
		}
		
		
		private var _smooth : Boolean = false ;
		
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="1",label="Smooth")]
		/**
		 * Enables the smoothing to be applied to the control
		 */
		public function get smooth() : Boolean
		{
			return _smooth;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set smooth (value : Boolean) : void
		{
			_smooth = value;
		}

	}
}