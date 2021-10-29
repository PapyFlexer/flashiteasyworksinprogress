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
	 * The <code><strong>IPHPElementDescriptor</strong></code> interface defines methods shared by elements treating forms submission
	 */
	public interface IPHPElementDescriptor {
		function set php(value:String):void;
		function set address(value:String):void;
		function set subject(value:String):void;
		function set successMessage(value:String):void;
		function set failureMessage(value:String):void;
		function setFormProperties(phpProp : String, addressProp : String, subjectProp : String, failureMessageProp : String, successMessageProp : String):void
	}
}
