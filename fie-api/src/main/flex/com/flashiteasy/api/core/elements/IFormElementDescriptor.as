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
	 * The <code><strong>IFormElementDescriptor</strong></code> interface defines methods shared by all form item elements
	 */
	public interface IFormElementDescriptor {
		function set name(value:String):void;
		function get name():String;
		function getValue():String;
		function set validator(value : IValidatorElementDescriptor):void;
		function check():Boolean;
		function get error():String;
		function set error(value:String):void;
		function get required() : Boolean;
		function set required(value : Boolean) : void;
		function resetValues():void;
		function displayError( s : String ):void;
	}
}
