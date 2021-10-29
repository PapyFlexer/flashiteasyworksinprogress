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
	
	import flash.events.IEventDispatcher;
	
	/**
	 * The <code><strong>IDescriptor</strong></code> interface defines methods shared by Descriptors
	 */
	public interface IDescriptor extends IEventDispatcher
	{
        function getPage() : Page;
        function setPage( page:Page) : void ;
		
        function setParameterSet( value : IParameterSet ) : void;
        function getParameterSet() : IParameterSet;
        
        function applyParameters() : void;
        
        function destroy():void;
		
        function set uuid( value : String ): void;
        function get uuid() : String;
        
	}
}