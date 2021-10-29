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
	import com.flashiteasy.api.core.elements.IAlignElementDescriptor;
	import com.flashiteasy.api.core.elements.IDisplayElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * The <code><strong>IUIElementDescriptor</strong></code> interface defines methods shared by visual controls
	 */
	public interface IUIElementDescriptor extends IDescriptor , IDisplayElementDescriptor
	{
		function createControl( page : Page, parent : IUIElementContainer = null  , waitComplete : Boolean = true) : void;
		function getFace() : FieUIComponent;
		
		// getter et setter 
		
		function getContent() : Array;
		function setContent( a : Array ) : void;
		function get resizeContainer():Boolean
		function set resizeContainer(value:Boolean):void;
		
        function get isWaiting():Boolean;
        function set isWaiting( value : Boolean ) : void;
		
		function getDescriptorType():Class;

		function isLoaded():Boolean;
		function invalidate():void;
		
		function updateParameterSet( remoteParameterSet : RemoteParameterSet ) : void;
		
		function getParent():IUIElementContainer;
		function setParent(parent :IUIElementContainer):void;
		function hasParent():Boolean;
		function getContainer():DisplayObjectContainer;
		function removeFromParent():void;
		function clone(sameId:Boolean = false):IUIElementDescriptor;
		function getIndex():int;
	}
}
