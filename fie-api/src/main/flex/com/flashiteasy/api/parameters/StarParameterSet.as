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
	 * The <code><strong>StarParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control by a star.It sets the 
	 * number of branches and the inner radius of the star mask.
	 */

	public class StarParameterSet extends AbstractParameterSet
	{
		private var _innerDiameter:int;
		private var _numberOfBranch:int;
		private var _angle:int;

		/**
		 * @inheritDoc
		 */
		override public function apply(targ:IDescriptor):void
		{
			super.apply(targ);
			if (targ is IMaskElementDescriptor)
			{
				IMaskElementDescriptor(targ).drawStarMask(numberOfBranch, innerDiameter, angle);
			}
		}

		/**
		 * Sets the start angle of the star mask 
		 */
		public function get angle():int
		{
			return _angle;
		}

		/**
		 * 
		 * @private
		 */
		public function set angle(angle:int):void
		{
			_angle=angle;
		}

		/**
		 * Sets the inner diameter of the star mask
		 */
		public function get innerDiameter():int
		{
			return _innerDiameter;
		}

		/**
		 * 
		 * @private
		 */
		public function set innerDiameter(value:int):void
		{
			_innerDiameter=value;
		}

		/**
		 * SSets the number of branches of the star mask
		 */
		public function get numberOfBranch():int
		{
			return _numberOfBranch;
		}

		/**
		 * 
		 * @private
		 */
		public function set numberOfBranch(value:int):void
		{
			_numberOfBranch=value;
		}
	}
}