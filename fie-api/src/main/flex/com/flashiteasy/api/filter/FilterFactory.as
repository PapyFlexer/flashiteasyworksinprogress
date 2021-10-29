/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.filter
{
	import flash.filters.*;
	
	/**
	 * The <code><strong>FilterFactory</strong></code> is used to add filters to controls on stage
	 * Filters use CompositeParameterSets so their creation is a little more complicated
	 * than the average ParameterSets 
	 */
	public class FilterFactory
	{
		
		/**
		 * Utility that converts <code>'false'</code> and <code>'true'</code> 
		 * string values to Boolean value.
		 * @param s the string passed
		 * @return true if the string'true" has been sent, false otherwise.
		 */
		public static function stringToBoolean(s : String ) : Boolean
		{
			if( s == "true")
				return true;
			else
				return false;
		}
		/**
		 * Filter instanciation
		 * @param type the Class of the filter
		 * @param args the array of arguments, its length depending of the filter type used
		 * @return the new filter instanciation, with its arguments set.
		 * 
		 * Possible filters are
		 * <ul>
		 * <li>BevelFilter</li>
		 * <li>ColorMatrixFilter</li>
		 * <li>DropShadowFilter</li>
		 * <li>BlurFilter</li>
		 * <li>GradientBevelFilter</li>
		 * <li>6</li>
		 * <li>7</li>
		 * <li>GlowFilter</li>
		 * <li>ConvolutionFilter</li>
		 * <li>10</li>
		 * </ul>
		 * 
		 */
		public static function createFilter( type : Class, args : Array ) : * {
                
                switch( type ) {
                        case BevelFilter:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9],args[10],stringToBoolean(args[11]));
                        case ColorMatrixFilter:
                                return new ColorMatrixFilter(args);
                        case DropShadowFilter:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], stringToBoolean(args[8]), stringToBoolean(args[9]),stringToBoolean(args[10]));
                        case BlurFilter:
                                return new type(args[0], args[1], args[2]);
                        case GradientBevelFilter:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9] , stringToBoolean(args[10]));
                      	case GradientGlowFilter:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9] , stringToBoolean(args[10]));
                        case 6:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5]);
                        case 7:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
                        case GlowFilter:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], stringToBoolean(args[6]), stringToBoolean(args[7]));
                        case ConvolutionFilter:
                                return new type(args[0], args[1], args[2], args[3], args[4], stringToBoolean(args[5]), stringToBoolean(args[6]), args[7], args[8]);
                        case 10:
                                return new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
                        default:
                                return null;
                }
        }
	}
}