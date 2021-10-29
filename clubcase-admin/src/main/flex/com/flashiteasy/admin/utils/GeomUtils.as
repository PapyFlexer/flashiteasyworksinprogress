package com.flashiteasy.admin.utils
{
	/**
	   this file is part of FLASHITEASY
	   FLASHITEASY FlashContentManagement - see http://code.google.com/p/flashiteasy/

	   FLASHITEASY is (c) 2004-2008 Didier Reyt / Gilles Roquefeuil and is released under the GPL License:

	   This program is free software; you can redistribute it and/or
	   modify it under the terms of the GNU General Public License (GPL)
	   as published by the Free Software Foundation; either version 2
	   of the License, or (at your option) any later version.

	   This program is distributed in the hope that it will be useful,
	   but WITHOUT ANY WARRANTY; without even the implied warranty of
	   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	   GNU General Public License for more details.

	   To read the license please visit http://www.gnu.org/copyleft/gpl.html
	 */

	/**
	 * Name : GeomUtils.as
	 * Package : fie.utils
	 * Version : 1.0
	 * Date :  15/09/2008
	 * Author : Didier Reyt / Gilles Roquefeuil / Alexandre Lagout
	 * URL : http://www.flashiteasy.com/
	 * Mail : gr@flashiteasy.com
	 * Mail : dr@flashiteasy.com
	 */

	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.utils.DisplayListUtils;
	import com.flashiteasy.api.utils.MatrixUtils;

	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Miscellaneous methods to manage block geometry
	 * @example No constructor, must be caled like this
	 * <listing version='3.0'>
	 * 		import fie.utils.*;
	 * 		var myPath = GeomUtils.rotatePoint(myPoint, 180, true);
	 * </listing>
	 */
	public class GeomUtils
	{

		/*
		 * Rotates elements by central point
		 * @param pnt Point : the reference point
		 * @param ang Number The rotation angle in degrees
		 * @param rad Boolean Tells if radians must be used
		 */
		public static function rotatePoint(pnt:Point, ang:Number, rad:Boolean=false):Point
		{
			if (ang == 0)
				return pnt.clone();
			var mtx:Array=getRotationMatrix(ang, rad);
			return multiplyPoint(pnt, mtx);
		}

		/*
		 * Rotates Points
		 * @param points Point : the reference points
		 * @param ang Number The rotation angle in degrees
		 * @param rad Boolean Tells if radians must be used
		 */
		public static function rotatePoints(points:Array, ang:Number, rad:Boolean=false):Array
		{
			var rotated:Array=[];
			var mtx:Array=getRotationMatrix(ang, rad);
			for each (var elt:*in points)
			{
				var pnt:Point=elt as Point;
				if (!pnt)
					throw new Error("GeomUtils.rotatePoints must have only Point instances as arguments");
				rotated.push(ang ? multiplyPoint(pnt, mtx) : pnt.clone());
			}
			return rotated;
		}

		/*
		 * Multiply the point reference by matrix
		 * @param pnt Point : the reference point
		 * @param mtx Matrix The matrix used for multiplication
		 */
		private static function multiplyPoint(pnt:Point, mtx:Array):Point
		{
			return new Point(pnt.x * mtx[0] + pnt.y * mtx[1], pnt.x * mtx[2] + pnt.y * mtx[3]);
		}

		/*
		 * Gets the rotation Matrix
		 * @param ang Number The rotation angle in degrees
		 * @param rad Boolean Tells if radians must be used
		 */
		private static function getRotationMatrix(ang:Number, rad:Boolean=false):Array
		{
			ang=rad ? ang : ang * Math.PI / 180;
			var angCos:Number=Math.cos(ang);
			var angSin:Number=Math.sin(ang);
			return [angCos, -angSin, angSin, angCos];
		}

		/*
		 * Gets the bounds of a block defined by its points
		 * @param points Array of the block points
		 * @return Rectangle the block bounds rectangle
		 */
		public static function getBounds(points:Array=null):Rectangle
		{
			if (!points || !points.length)
				return null;
			var minPoint:Point;
			var maxPoint:Point;
			for each (var elt:*in points)
			{
				var pnt:Point=elt as Point;
				if (!pnt)
					throw new Error("GeomUtils.getBounds must have only Point instances as arguments");
				if (!minPoint)
				{
					minPoint=pnt.clone();
					maxPoint=pnt.clone();
				}
				else
				{
					if (pnt.x < minPoint.x)
						minPoint.x=pnt.x;
					if (pnt.y < minPoint.y)
						minPoint.y=pnt.y;
					if (pnt.x > maxPoint.x)
						maxPoint.x=pnt.x;
					if (pnt.y > maxPoint.y)
						maxPoint.y=pnt.y;
				}
			}
			return new Rectangle(minPoint.x, minPoint.y, maxPoint.x - minPoint.x, maxPoint.y - minPoint.y);
		}

		public static function getTrueBounds(ob:DisplayObject):Rectangle
		{
			var minPoint:Point=new Point();
			var maxPoint:Point=new Point();
			var m:Matrix=ob.transform.concatenatedMatrix;
			var points:Array=[m.transformPoint(new Point()), m.transformPoint(new Point(ob.x, 0)), m.transformPoint(new Point(ob.x, ob.y)), m.transformPoint(new Point(0, ob.y))];
			minPoint=points[0];
			maxPoint=points[0];
			for each (var p:Point in points)
			{
				if (p.x < minPoint.x)
					minPoint.x=p.x;
				if (p.y < minPoint.y)
					minPoint.y=p.y;
				if (p.x > maxPoint.x)
					maxPoint.x=p.x;
				if (p.y > maxPoint.y)
					maxPoint.y=p.y;
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
		public static function getLocalRectangle(blck:Array, referenceOut:DisplayObject):Rectangle
		{

			var pointIn:Point=new Point();
			return new Rectangle;
		}

		/**
		   Determines the angle/degree between the first and second point.

		   @param first: The first Point.
		   @param second: The second Point.
		   @return The degree between the two points.
		 */
		public static function angle(first:Point, second:Point):Number
		{
			return Math.atan2(second.y - first.y, second.x - first.x) / (Math.PI / 180);
		}

		public static function rotateAroundCenter(ob:DisplayObject, angleDegrees:Number):void
		{

			//ob.rotation=angleDegrees;

			var center:Point=new Point(ob.x + ob.width / 2, ob.y + ob.height / 2);
			var m:Matrix=ob.transform.matrix;
			// var m:Matrix=new Matrix();
			m.tx-=center.x;
			m.ty-=center.y;
			/*m.a=0;
			   m.c=0;
			   m.b=0;
			 m.d=0;*/
			m.a=1;
			m.c=0;
			m.b=0;
			m.d=1;
			m.rotate(angleDegrees * (Math.PI / 180));



			m.tx+=center.x;
			m.ty+=center.y;

			ob.transform.matrix=m;

		}

		public static function getRotatedRectPoint(angle:Number, point:Point, rotationPoint:Point=null):Point
		{
			var ix:Number=(rotationPoint) ? rotationPoint.x : 0;
			var iy:Number=(rotationPoint) ? rotationPoint.y : 0;

			var m:Matrix=new Matrix(1, 0, 0, 1, point.x - ix, point.y - iy);
			m.rotate(angle);
			return new Point(m.tx + ix, m.ty + iy);
		}

		/**
		 * Rotates a matrix about a point defined inside the matrix's transformation space.
		 * This can be used to rotate a movie clip around a transformation point inside itself.
		 *
		 * @param m A Matrix instance.
		 *
		 * @param x The x coordinate of the point.
		 *
		 * @param y The y coordinate of the point.
		 *
		 * @param angleDegrees The angle of rotation in degrees.
		 * @playerversion Flash 9.0.28.0
		 * @langversion 3.0
		 * @keyword Matrix, Copy Motion as ActionScript
		 * @see flash.geom.Matrix
		 */
		public static function rotateAroundInternalPoint(ob:DisplayObject, x:Number, y:Number, angleDegrees:Number):void
		{
			var m:Matrix=ob.transform.matrix;
			var oldRotation:Number=ob.rotation;
			var newRotation:Number=angleDegrees - oldRotation;
			var point:Point=new Point(x, y);
			point=m.transformPoint(point);
			m.tx-=point.x;
			m.ty-=point.y;
			/* m.a=1;
			   m.c=0;
			   m.b=0;
			 m.d=1;*/
			m.rotate(newRotation * (Math.PI / 180));
			m.tx+=point.x;
			m.ty+=point.y;
			ob.transform.matrix=m;
		}



		/**
		 * Rotates a matrix about a point defined outside the matrix's transformation space.
		 * This can be used to rotate a movie clip around a transformation point in its parent.
		 *
		 * @param m A Matrix instance.
		 *
		 * @param x The x coordinate of the point.
		 *
		 * @param y The y coordinate of the point.
		 *
		 * @param angleDegrees The angle of rotation in degrees.
		 * @playerversion Flash 9.0.28.0
		 * @langversion 3.0
		 * @keyword Matrix, Copy Motion as ActionScript
		 * @see flash.geom.Matrix
		 */
		public static function rotateAroundExternalPoint(ob:DisplayObject, x:Number, y:Number, angleDegrees:Number):void
		{
			var m:Matrix=DisplayListUtils.customConcatenatedMatrix(ob);
			//var inverted_parent:Matrix = ob.parent.transform.concatenatedMatrix;

			var inverted_parent:Matrix;
			if (ob.parent is AbstractBootstrap)
			{
				inverted_parent=ob.parent.transform.concatenatedMatrix;
			}
			else
			{
				inverted_parent=DisplayListUtils.customConcatenatedMatrix(ob.parent);
			}
			inverted_parent.invert();

			/* m.translate( -point.x, -point.y);
			   trace(point);
			   m.rotate(angleDegrees*(Math.PI/180));

			   m.translate(point.x, point.y);
			 */
			// finally, to set the MovieClip position, use this 

			m.tx-=x;
			m.ty-=y;
			var matrixAngle:Number=MatrixUtils.getAngle(m);
			m.rotate(-matrixAngle * (Math.PI / 180));
			m.rotate(angleDegrees * (Math.PI / 180));
			m.tx+=x;
			m.ty+=y;

			m.concat(inverted_parent);
			ob.transform.matrix=m;
		}

	}
}
