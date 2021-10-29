package com.flashiteasy.admin.components.filterComponents
{
	import flash.events.IEventDispatcher;
	

	
	
	/**
	 * Defines the common methods and properties that the application's 
	 * filter panels expose for getting data out of the panels.
	 * 
	 * All filter panels should implement this interface and be a display
	 * object.
	 */
	public interface IFilterPanel extends IEventDispatcher
	{
		/**
		 * Resets the filter panel to its original settings.
		 */
		function resetForm():void;
		/**
		 * Set value of the filter panel from the value of a filter object
		 **/
		 
		function setValues ( filter : * ) : void ;
		
		/**
		 * Gets a filter factory that generates the bitmap filter
		 * with the settings and filter type specified by the 
		 * filter panel and its current settings.
		 */
		function get filterFactory():IFilterFactory;
	}
}