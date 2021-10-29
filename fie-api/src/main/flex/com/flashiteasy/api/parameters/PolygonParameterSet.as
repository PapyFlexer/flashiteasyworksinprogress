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
	 * The <code><strong>PolygonParameterSet</strong></code> is the parameterSet
	 * that works with the MaskParameterSet to design it as a polygon.
	 */
	public class PolygonParameterSet extends AbstractParameterSet
	{
		private var _numberOfFace:int=6;
		private var _angle:int=0;

		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(targ:IDescriptor):void
		{
			super.apply(targ);
			if (targ is IMaskElementDescriptor)
			{
				IMaskElementDescriptor(targ).drawPolygonMask(numberOfFace, angle);
			}
		}

		/**
		 * Sets the number of sides of the polygon
		 */
		public function get numberOfFace():int
		{
			return _numberOfFace;
		}

		/**
		 * 
		 * @privatee
		 */
		public function set numberOfFace(numberOfFace:int):void
		{
			_numberOfFace=numberOfFace;
		}

		/**
		 * Sets  the starting angle of the polygon drawing
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
	}
}