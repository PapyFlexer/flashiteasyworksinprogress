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
	import com.flashiteasy.api.core.project.Page;
	
	import flash.events.Event;
	
	/**
	 * The <code><strong>IAction</strong></code> interface defines methods shared by actions
	 */
	public interface IAction extends IDescriptor
	{
		function apply( event : Event ) : void;
		function createAction( page : Page ) : void;
		function applyEvents() : void;
		function removeEvents() : void;
		function set triggers( value : Array ) : void;
		function get triggers() : Array;
		function set targets( value : Array ) : void;
		function get targets() : Array;
		function clone(sameId:Boolean = false):IAction;
		
		function getDescriptorType():Class;
	}
}