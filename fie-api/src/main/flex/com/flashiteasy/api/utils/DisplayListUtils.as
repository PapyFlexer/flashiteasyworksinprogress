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
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	
	import fl.core.UIComponent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The <code><strong>DisplayListUtils</strong></code> class is
	 * an utility class dealing with DisplayList.
	 */
	public class DisplayListUtils
	{
		/**
		 * Returns a DisplayObject cated control
		 * @param container parent container
		 * @param name name of the control (uuid)
		 * @return 
		 */
		public static function findControl(container:DisplayObjectContainer,name:String = ""):DisplayObject
		{
		    var child:DisplayObject;
		    var child2:DisplayObject;
		    for (var i:uint=0; i < container.numChildren; i++)
		    {
		        child = container.getChildAt(i);
		        if( child.name == name)
		        {
		        	return child;
		        }
		        if (child is DisplayObjectContainer)
		        {
		            child2= findControl( (child as DisplayObjectContainer) , name )
		            if( child2 != null )
		            {
		            	return child2;
		            }
		        }
		    }
		    return null;
		}
		
		/**
		 * Returns the bounds of a display object, including filters effects
		 * @param ob
		 * @param parent
		 * @return 
		 */
		public static function getTrueBounds(ob:DisplayObject, parent:DisplayObject=null):Rectangle{
				var bound:Sprite = new Sprite();
				bound.graphics.beginFill(0x000000,0.5);
				bound.graphics.drawRect(0,0,ob.width,ob.height);
				bound.graphics.endFill();
				var mesure:DisplayObject = Sprite(ob).addChild(bound);
				if(ob.width<0)
				{
					bound.x-=ob.width;
					bound.width=ob.width;
				}
				if(ob.height<0)
				{
					bound.y-=ob.height;
					bound.height=ob.height;
				}
				if(parent ==null)
				{
					parent=ob;
				}
				var targetBounds :Rectangle = mesure.getBounds(ob);
				Sprite(ob).removeChild(mesure);
				return targetBounds;
		}
		
		/**
		 * Concatenat special matrix from a DisplayObject
		 * @param target
		 * @return 
		 */
		public static function customConcatenatedMatrix(target:DisplayObject):Matrix 
		{
			var concatenatedMatrix :Matrix = target.transform.matrix;
			var parent : DisplayObject = target.parent ;
			while(parent != null)
			{
				//Here we stop at the root.Application and take it's concatenedMatrix for avoiding a bug 
				//with Flex components having surely a temporary matrix
				if(parent is AbstractBootstrap)
				{
					concatenatedMatrix.concat(parent.transform.concatenatedMatrix);
					break;
				}
				else
				{
					concatenatedMatrix.concat(parent.transform.matrix);
				}
				parent = parent.parent ;
			}
			return concatenatedMatrix;
		}
		
		/**
		 * Gets calculated (rendered) bounds (as a Rectangle)  of a DisplayObject inside its Container
		 * @param ob
		 * @param parent
		 * @return 
		 */
		public static function getRealBounds(ob : DisplayObject , parent : DisplayObjectContainer= null ) : Rectangle
		{
			var shape : Shape = new Shape ;
			shape.alpha=0;
			shape.graphics.beginFill(0x000000,0.5);
			shape.graphics.drawRect(0,0,ob.width,ob.height);
			shape.graphics.endFill();
			Sprite(ob).addChild(shape);
			var bounds : Rectangle = shape.getBounds(parent);
			Sprite(ob).removeChild(shape);
			//bounds.width = Math.abs(ob.width);
			//bounds.height = Math.abs(ob.height);
			return bounds;
		}
		
		/**
		 * Removes all children from a DOC
		 * @param ob
		 */
		public static function removeAllChildren(ob:DisplayObjectContainer):void{
			while( ob.numChildren > 0 )
    		 ob.removeChildAt( 0 );
		}
		
		/**
		 * Draws a control's bounds on stage
		 * @param d
		 */
		public static function drawBounds(d:UIComponent):void{
			d.graphics.lineStyle(0, 0x0000FF, 1);
			d.graphics.moveTo(0,0);
			d.graphics.lineTo(d.width, 0);
			d.graphics.lineTo(d.width, d.height);
			d.graphics.lineTo(0, d.height);
			d.graphics.lineTo(0,0);
		}
		
		/**
		 * Get real bounds other method
		 * @param container
		 * @param processFilters
		 * @return 
		 */
		public static function getDisplayObjectBoundingRectangle(container:DisplayObjectContainer, processFilters:Boolean = false ):Rectangle
		{
			var final_rectangle:Rectangle = processDisplayObjectContainer(container, processFilters);
			// translate to local
			var local_point:Point = container.globalToLocal(new Point(final_rectangle.x, final_rectangle.y));
			final_rectangle = new Rectangle(local_point.x, local_point.y, final_rectangle.width, final_rectangle.height);		   
			return final_rectangle;
		}

		/**
		 * Calculates the bounding for a group of elements
		 * @param container
		 * @param processFilters
		 * @return 
		 */
		private static function processDisplayObjectContainer(container:DisplayObjectContainer, processFilters:Boolean = false ):Rectangle {
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
				throw new Error("No displayobject was passed as an argument");
		}

			return result_rectangle;
		}
		
	}
}