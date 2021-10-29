package com.flashiteasy.admin.workbench
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.controls.ButtonElementDescriptor;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.Container;
	
	/**
	 * Control a workbench instance.
	 */
	public interface IWorkbench extends IEventDispatcher
	{
		/**
		 * Initialize the workbench using specific containers to host the application components.
		 */ 
		function reset( container : Container ) : void;
		function destroy() : void;
		
		/**
		 * Load an external FIE application and check its compatibility.
		 */
		function loadApplication( baseUrl : String, applicationName : String ) : void;
		function getApplication() : AbstractBootstrap;
		
		/**
		 * Set the reference to the component which handles the element edition.
		 */
		function setElementEditor( editor : IElementEditor ) : void;
		function removeIndicator( index: int ):void;
		function bind():void;
		function openEditMode(button : ButtonElementDescriptor ):void;
	}
}