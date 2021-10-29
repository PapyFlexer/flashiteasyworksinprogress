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
	 * The <code><strong>IListElementDescriptor</strong></code> interface defines methods shared by all containers that automaticall define their children positions
	 */
	public interface IListElementDescriptor extends IMarginElementDescriptor
	{
		function setType( type:String):void;
		function setCarrouselSpeed( speed : Number ) :void;
		function setAccordionHeaderSize( size : Number ):void; 
	}
}