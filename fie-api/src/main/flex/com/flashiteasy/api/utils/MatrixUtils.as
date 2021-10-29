/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The <code><strong>MatrixUtils</strong></code> class is
	 * an utility class dealing with matrix calculations
	 */
	public class MatrixUtils
	{
		/**
		 * Returns an angle in degrees representing the matrix passed as argument apparent angle
		 * @param m the angled matrix
		 * @return 
		 */
		public static function getAngle(m:Matrix):Number
		{
			var px:Point = new flash.geom.Point(0, 1);
			px = m.deltaTransformPoint(px);

			return Math.round( (180/Math.PI) * Math.atan2(px.y, px.x) - 90);
		}

	}
}