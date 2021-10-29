/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * The <code><strong>DisplayObjectUtils</strong></code> class is
	 * an utility class dealing with DisplayObjects
	 */
	public class DisplayObjectUtils
	{
		
		
		/**
		 * Returns an object bounds as a rectangle
		 * @param container
		 * @param processFilters
		 * @return 
		 */
		public static function getDisplayObjectBoundingRectangle(container:DisplayObjectContainer, processFilters:Boolean):Rectangle
		{
			var final_rectangle:Rectangle = processDisplayObjectContainer(container, processFilters);
			// translate to local
			var local_point:Point = container.globalToLocal(new Point(final_rectangle.x, final_rectangle.y));
			final_rectangle = new Rectangle(local_point.x, local_point.y, final_rectangle.width, final_rectangle.height);		   
			return final_rectangle;
		}

		/**
		 * Processes a DisplayObjectContainer 
		 * @param container
		 * @param processFilters
		 * @return 
		 */
		private static function processDisplayObjectContainer(container:DisplayObjectContainer, processFilters:Boolean):Rectangle {
			var result_rectangle:Rectangle = null;
			// Process if container exists
			if (container != null) {
			var FieAdmin:int = 0;
			var displayObject:DisplayObject;

				// Process each child DisplayObject
				for(var childIndex:int = 0; childIndex < container.numChildren; childIndex++){
						displayObject = container.getChildAt(childIndex);

						//If we are recursing all children, we also get the rectangle of children within these children.
						if (displayObject is DisplayObjectContainer) {

								// Let's drill into the structure till we find the deepest DisplayObject
								var displayObject_rectangle:Rectangle = processDisplayObjectContainer(displayObject as DisplayObjectContainer, processFilters);
	
								// Now, stepping out, uniting the result creates a rectangle that surrounds siblings
								if (result_rectangle == null) { 
										result_rectangle = displayObject_rectangle.clone(); 
								} else {
										result_rectangle = result_rectangle.union(displayObject_rectangle);
								}											   
						}											   
				}

				// Get bounds of current container, at this point we're stepping out of the nested DisplayObjects
				var container_rectangle:Rectangle = container.getBounds(container.stage);

				if (result_rectangle == null) { 
						result_rectangle = container_rectangle.clone(); 
				} else {
						result_rectangle = result_rectangle.union(container_rectangle);
				}


				// Include all filters if requested and they exist
				if ((processFilters == true) && (container.filters.length > 0)) {
						var filterGenerater_rectangle:Rectangle = new Rectangle(0,0,result_rectangle.width, result_rectangle.height);
						var bmd:BitmapData = new BitmapData(result_rectangle.width, result_rectangle.height, true, 0x00000000);

						var filter_minimumX:Number = 0;
						var filter_minimumY:Number = 0;

						var filtersLength:int = container.filters.length;
						for (var filtersIndex:int = 0; filtersIndex < filtersLength; filtersIndex++) {										  
								var filter:BitmapFilter = container.filters[filtersIndex];

								var filter_rectangle:Rectangle = bmd.generateFilterRect(filterGenerater_rectangle, filter);

								filter_minimumX = filter_minimumX + filter_rectangle.x;
								filter_minimumY = filter_minimumY + filter_rectangle.y;

								filterGenerater_rectangle = filter_rectangle.clone();
								filterGenerater_rectangle.x = 0;
								filterGenerater_rectangle.y = 0;

								bmd = new BitmapData(filterGenerater_rectangle.width, filterGenerater_rectangle.height, true, 0x00000000);											  
						}

						// Reposition filter_rectangle back to global coordinates
						filter_rectangle.x = result_rectangle.x + filter_minimumX;
						filter_rectangle.y = result_rectangle.y + filter_minimumY;

						result_rectangle = filter_rectangle.clone();
				}							   
		} else {
				throw new Error("No display object was passed as an argument");
		}

			return result_rectangle;
		}
	}
}