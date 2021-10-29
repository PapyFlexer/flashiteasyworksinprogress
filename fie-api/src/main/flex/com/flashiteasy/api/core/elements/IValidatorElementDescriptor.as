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
	
	/**
	 * The <code><strong>IValidatorElementDescriptor</strong></code> interface defines methods shared by elements accepting validators
	 */
	public interface IValidatorElementDescriptor
	{
		
		function setValidator( type : String ) : void;
		function validateString( str : String ) : Boolean;
		function setValidatorEnable( enable : Boolean ):void
		function getErrorString() : String;
		function get validator() : IValidatorElementDescriptor;
		function set validator( value : IValidatorElementDescriptor ) :void
	}
}