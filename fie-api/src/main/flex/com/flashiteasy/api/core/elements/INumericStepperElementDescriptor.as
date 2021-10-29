/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.elements {

	/**
	 * The <code><strong>INumericStepperElementDescriptor</strong></code> interface defines methods shared by Numeric Steppers elements
	 */
	public interface INumericStepperElementDescriptor {
		function set maximum(value:Number):void;
		function get maximum():Number;
		function set minimum(value:Number):void;
		function get minimum():Number;
		function set stepSize(value:Number):void;
	}
}
