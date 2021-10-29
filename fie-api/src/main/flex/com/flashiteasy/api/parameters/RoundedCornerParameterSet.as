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
	import com.flashiteasy.api.core.elements.IMaskElementDescriptor;
	
	/**
	 * The <code><strong>RoundedCornerParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control by a rounded rectangle.It sets the bottom left,
	 * bottom right, top left and top right corners using a radius value.
	 */

	public class RoundedCornerParameterSet extends AbstractParameterSet
	{
		private var _topLeft:int;
		private var _topRight: int;
		private var _bottomLeft:int;
		private var _bottomRight: int;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			if( targ is IMaskElementDescriptor )
			{
				IMaskElementDescriptor( targ ).drawRoundedCornerMask(topLeft, topRight, bottomLeft, bottomRight);
			}
			super.apply( targ );
		}
		
		/**
		 * Top left corner radius 
		 */
		public function get topLeft():int
		{
			return _topLeft;
		}

		/**
		 * 
		 * @private
		 */
		public function set topLeft(value:int):void
		{
			_topLeft = value;
		}
		
		/**
		 * Top right corner radius
		 */
		public function get topRight():int
		{
			return _topRight;
		}

		/**
		 * 
		 * @private
		 */
		public function set topRight(value:int):void
		{
			_topRight = value;
		}
		
		/**
		 * Bottom left corner radius 
		 */
		public function get bottomLeft():int
		{
			return _bottomLeft;
		}

		/**
		 * 
		 * @private
		 */
		public function set bottomLeft(value:int):void
		{
			_bottomLeft = value;
		}
		
		/**
		 * Bottom right corner radius 
		 */
		public function get bottomRight():int
		{
			return _bottomRight;
		}

		/**
		 * 
		 * @private
		 */
		public function set bottomRight(value:int):void
		{
			_bottomRight = value;
		}
	}
}