/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.easing
{
	import com.gskinner.motion.easing.*
	
	/**
	 * This class defines the interpolation constants (based on grant skinner interpolation classes).
	 */
	public class InterpolationTypes
	{
		/**
		 * easing types
		 */		
		public static const EASE_IN:String = "easeIn";
		/**
		 * 
		 * @default 
		 */
		public static const EASE_IN_OUT:String = "easeInOut";
		/**
		 * 
		 * @default 
		 */
		public static const EASE_OUT:String = "easeOut";
		/**
		 * 
		 * @default 
		 */
		public static const EASE_NONE:String = "easeNone"
		
		/**
		 * 
		 * @default 
		 */
		public static const EASINGS:Array = [EASE_IN, EASE_OUT, EASE_IN_OUT,EASE_NONE];


		/**
		 * interpolations types
		 */		
		public static const BACK:Class = Back;
		/**
		 * 
		 * @default 
		 */
		public static const BOUNCE:Class = Bounce;
		/**
		 * 
		 * @default 
		 */
		public static const CIRCULAR:Class = Circular;
		/**
		 * 
		 * @default 
		 */
		public static const CUBIC:Class = Cubic;
		/**
		 * 
		 * @default 
		 */
		public static const ELASTIC:Class = Elastic;
		/**
		 * 
		 * @default 
		 */
		public static const EXPONENTIAL:Class = Exponential;
		/**
		 * 
		 * @default 
		 */
		public static const LINEAR:Class = Linear;
		/**
		 * 
		 * @default 
		 */
		public static const QUADRATIC:Class = Quadratic;
		/**
		 * 
		 * @default 
		 */
		public static const QUARTIC:Class = Quartic;
		/**
		 * 
		 * @default 
		 */
		public static const QUINTIC:Class = Quintic;
		/**
		 * 
		 * @default 
		 */
		public static const SINE:Class = Sine;
		
		/**
		 * 
		 * @default 
		 */
		public static const INTERPOLATIONS:Array = [BACK,BOUNCE,CIRCULAR,CUBIC,ELASTIC,EXPONENTIAL,LINEAR,QUADRATIC,QUARTIC,QUINTIC,SINE];
	}
}