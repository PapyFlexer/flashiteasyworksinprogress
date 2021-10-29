/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;	
	
	/**
	 * Miscellaneous methods to manage block geometry
	 * @example No constructor, must be called like this
	 * <listing version='3.0'>
	 * 		import fie.utils.*;
	 * 		var myPath = GeomUtils.rotatePoint(myPoint, 180, true);
	 * </listing>
	 */
	/**
	 * The <code><strong>GeomUtils</strong></code> class is
	 * an utility class dealing with control geometry
	 */
	public class GeomUtils{
		
		/**
		 * Rotates elements by central point
		 * @param pnt Point : the reference point
		 * @param ang Number The rotation angle in degrees
		 * @param rad Boolean Tells if radians must be used
		 */
		public static function rotatePoint(pnt:Point, ang:Number, rad : Boolean = false) : Point {
			if (ang == 0) return pnt.clone();
			var mtx:Array = getRotationMatrix(ang, rad);
			return multiplyPoint(pnt, mtx);
		}
		/**
		 * 
		 * Rotates Points
		 * @param points Point : the reference points
		 * @param ang Number The rotation angle in degrees
		 * @param rad Boolean Tells if radians must be used
		 */
		public static function rotatePoints(points:Array, ang:Number, rad : Boolean = false) : Array {
			var rotated:Array = [];
			var mtx:Array = getRotationMatrix(ang, rad);
			for each(var elt:* in points) {
				var pnt : Point = elt as Point;
				if (!pnt) throw new Error("GeomUtils.rotatePoints must have only Point instances as arguments");
				rotated.push(ang ? multiplyPoint(pnt, mtx) : pnt.clone());
			}
			return rotated;
		}
		
		/**
		 * @private
		 * Multiply the point reference by matrix
		 * @param pnt Point : the reference point
		 * @param mtx Matrix The matrix used for multiplication
		 */
		private static function multiplyPoint(pnt:Point, mtx:Array) : Point {
			return new Point(pnt.x*mtx[0]+pnt.y*mtx[1], pnt.x*mtx[2]+pnt.y*mtx[3]);
		}
		
		/**
		 * @private
		 * Gets the rotation Matrix
		 * @param ang Number The rotation angle in degrees
		 * @param rad Boolean Tells if radians must be used
		 */
		private static function getRotationMatrix(ang:Number, rad:Boolean = false) : Array {
			ang = rad ? ang : ang*Math.PI/180;
			var angCos:Number = Math.cos(ang);
			var angSin:Number = Math.sin(ang);
			return [angCos, -angSin, angSin, angCos];
		}
		
		/**
		 * Gets the bounds of a block defined by its points
		 * @param points Array of the block points
		 * @return Rectangle the block bounds rectangle
		 */
		public static function getBounds(points:Array = null) : Rectangle {
			if (!points || !points.length) return null;
			var minPoint:Point;
			var maxPoint:Point;
			for each(var elt:* in points) {
				var pnt : Point = elt as Point;
				if (!pnt) throw new Error("GeomUtils.getBounds must have only Point instances as arguments");
				if (!minPoint) {
					minPoint = pnt.clone();
					maxPoint = pnt.clone();
				} else {
					if (pnt.x < minPoint.x) minPoint.x = pnt.x;
					if (pnt.y < minPoint.y) minPoint.y = pnt.y;
					if (pnt.x > maxPoint.x) maxPoint.x = pnt.x;
					if (pnt.y > maxPoint.y) maxPoint.y = pnt.y;
				}
			}
			return new Rectangle(minPoint.x, minPoint.y, maxPoint.x - minPoint.x, maxPoint.y - minPoint.y);
		}
		
		/*public  function makeSelectionBounds(blocks:Array, selectionPoint:Point):Rectangle {
			var refDisplayObject: DisplayObject = new DisplayObject;
			if (!blocks || !blocks.length) throw new Error ("No Selection");
			if (blocks.length>1) {
				//var selectorPoint : Point ;
				var selectorPoint : Point = refDisplayObject.globalToLocal(blocks[0].parent.localToGlobal(selectionPoint));
				var pnts : Array = [];
				var currentPadding : Number = (blocks[0].parent as Container).contentPadding || 0;
					for each(var blockKey:* in blocks) {
						var currentBlock : Block = blockKey as Block;
						pnts.push(new Point(currentBlock.layoutX + currentPadding, currentBlock.layoutY + currentPadding));
						pnts.push(new Point(currentBlock.layoutX + currentPadding + currentBlock.layoutWidth, currentBlock.layoutY + currentPadding + currentBlock.layoutHeight));
					}
					return getBounds(pnts);
					
				 
			} else {
				
					var selectionPoint : Point = globalToLocal(blocks[0].localToGlobal(new Point(0, 0)));
					return new Rectangle(selectionPoint.x, selectionPoint.y, blocks[0].blockWidth, blocks[0].blockHeight);
					
				
			}
			return new Rectangle;
		}*/
		/**
		 * Rets a local ccordinates-based Rectangle
		 * @param blck
		 * @param referenceOut
		 * @return 
		 */
		public static function getLocalRectangle(blck:Array, referenceOut:DisplayObject):Rectangle {
			
			var pointIn : Point = new Point();
			return new Rectangle;
		}
		
		/**
			Determines the angle/degree between the first and second point.
			
			@param first: The first Point.
			@param second: The second Point.
			@return The degree between the two points.
		*/
		public static function angle(first:Point, second:Point):Number {
			return Math.atan2(second.y - first.y, second.x - first.x) / (Math.PI / 180);
		}
		
		/**
		 * Rotate a DO around its center
		 * @param ob
		 * @param angleDegrees
		 */
		public static function rotateAroundCenter (ob:DisplayObject, angleDegrees :Number) :void{

		    //ob.rotation=angleDegrees;
		    
		    var center:Point=new Point(ob.x+ob.width/2, ob.y+ob.height/2);
		    var m:Matrix=ob.transform.matrix;
      		m.tx -= center.x;
     		m.ty -= center.y;
     		//m.rotate(0);
      		//m.rotate (angleDegrees*(Math.PI/180));
      		
      		m.a=Math.cos(angleDegrees*(Math.PI/180));
      		m.c=-Math.sin(angleDegrees*(Math.PI/180));
      		m.b=Math.sin(angleDegrees*(Math.PI/180));
      		m.d=Math.cos(angleDegrees*(Math.PI/180));
      		
      		m.tx += center.x;
      		m.ty += center.y;
     		ob.transform.matrix=m;
     		
		} 
		

	}
}
