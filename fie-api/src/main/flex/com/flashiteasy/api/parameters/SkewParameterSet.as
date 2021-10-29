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

	/**
	 * The <code><strong>MaskParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control.It comes in 7 modes : 6 inner masks
	 * and an external one :
	 */
	public class SkewParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			//super.apply(target);
			//target.getFace().blendMode=blend_mode;
		}
		
		private var _XSkew : Number ;
		
		/**
		 * Sets the control's skewing along XAxis
		 */
		public function get XSkew():Number{
			return _XSkew;
		}
		/**
		 * @private
		 */
		public function set XSkew(value:Number):void{
			_XSkew = value;
		}
		
		private var _YSkew : Number ;
		
		/**
		 * Sets the control's skewing along YAxis
		 */
		public function get YSkew():Number{
			return _YSkew;
		}
		/**
		 * 
		 * @private
		 */
		public function set YSkew(value:Number):void{
			_YSkew = value;
		}
	}
}