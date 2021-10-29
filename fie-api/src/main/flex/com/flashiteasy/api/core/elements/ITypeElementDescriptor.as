/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.elements {
	import com.flashiteasy.api.core.IUIElementDescriptor;

	/**
	 * The <code><strong>ITypeElementDescriptor</strong></code> interface defines methods shared by typed elements
	 */
	public interface ITypeElementDescriptor extends IUIElementDescriptor {
		function setType( type:String):void;
	}
}
