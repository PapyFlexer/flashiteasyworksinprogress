/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core {

	/**
	 * The <code><strong>IUIElementContainer</strong></code> interface defines methods shared by all containers
	 */
	public interface IUIElementContainer extends IUIElementDescriptor
	{
		function layoutElement( elementDescriptor : IUIElementDescriptor ) : void;
		function get padding_top():int;
		function get padding_bottom():int
		function get padding_left():int;
		function get padding_right():int;
		function deleteChildren():void;
		function removeChild( el:IUIElementDescriptor , destroy:Boolean=false ):void;
		function getChildren(recursive:Boolean=false):Array;
		function getChildIndex( el : IUIElementDescriptor ) : int ;
		function swapChildAt( elementDescriptor:IUIElementDescriptor , index : int ) : void;
		function getContainerDepth () : int ;
	}
}