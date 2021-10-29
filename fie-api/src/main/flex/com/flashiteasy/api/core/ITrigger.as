/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core
{
	/**
	 * The <code><strong>IAction</strong></code> interface defines methods shared by actions
	 */
	public interface ITrigger
	{
        function prepare ( targets : Array, action : IAction ) : void;
        function unload ( targets : Array, action : IAction ) : void;
        function set uuid( value : String ): void;
        function get uuid() : String;
        function get events() : Array;
        function set events ( value : Array ) : void;
	}
}