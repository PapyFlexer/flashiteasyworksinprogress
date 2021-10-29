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
	/**
	 * The <code><strong>ConvertUtils</strong></code> class is
	 * an utility class dealing with conversions.
	 */
	public class ConvertUtils
	{
		/**
		 * Returns a percentile
		 * @param origin
		 * @param difference
		 * @param precision
		 * @return 
		 */
		public static function getPercent(origin:Number, difference:Number, precision:int=100):Number
		{
			return Math.round((difference * 100 / origin) * precision) / precision;
		}

	}
}
