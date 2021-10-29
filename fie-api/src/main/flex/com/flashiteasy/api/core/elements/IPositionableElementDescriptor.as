/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.elements
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	/**
	 * The <code><strong>IPositionableElementDescriptor</strong></code> interface defines positionning methods shared by all visual elements
	 */
	public interface IPositionableElementDescriptor 
	{
		function setPosition( x : Number, y : Number, isPercentX : Boolean, isPercentY : Boolean) : void;
		function setTargetPosition(target:String , mode:String):void;
		function get x() : Number ;
		function get y() : Number ;
		function get realX() : Number ;
		function get realY() : Number ;
		function get percentX():Boolean;
		function get percentY():Boolean;
	}
}