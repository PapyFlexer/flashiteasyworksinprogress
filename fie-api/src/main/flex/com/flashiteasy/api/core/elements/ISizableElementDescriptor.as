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
	 * The <code><strong>ISizableElementDescriptor</strong></code> interface defines resizing methods shared by all visual controls
	 */
	public interface ISizableElementDescriptor 
	{
		function setActualSize( w : Number, h : Number, isPercentW : Boolean, isPercentH : Boolean ) : void;
		function get percentWidth():Boolean;
		function get percentHeight():Boolean ;
		function get width():Number;
		function get height():Number;
	}
}