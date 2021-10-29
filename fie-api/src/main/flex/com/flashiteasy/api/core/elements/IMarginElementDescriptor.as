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
	 * The <code><strong>IMarginElementDescriptor</strong></code> interface defines methods shared by visual elements that can receive margins
	 */
	public interface IMarginElementDescriptor extends IUIElementDescriptor
	{
		function setMargin( margin : Number ) : void;
	}
}