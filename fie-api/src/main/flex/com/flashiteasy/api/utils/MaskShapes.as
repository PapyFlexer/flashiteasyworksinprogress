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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;

	// Classe generant les differentes formes de masques

	/**
	 * The <code><strong>MaskShapes</strong></code> class is
	 * an utility class dealing with the programmatical drawing of inner masks
	 */
	public class MaskShapes
	{
		/**
		 * Draws a star in the target sprite and uses it as mask
		 * @param target the Sorite that will be masked by the star
		 * @param width
		 * @param height
		 * @param n number of branches
		 * @param r1 outer radus
		 * @param r2 inner radius
		 * @param angle start angle, expressed in degrees
		 */
		public static function star(targ : Sprite, x : Number, y : Number, points : uint, innerRadius : Number, outerRadius : Number, angle : Number = 0) : void {
			
			// check that points is sufficient to build polygon
			if(points <= 2) {
				throw ArgumentError( "draw mask star() - parameter 'points' needs to be at least 3" ); 
				return;
			}
			if (points > 2) {
				//
				var target : Graphics = targ.graphics;
				// init vars
				var step : Number, halfStep : Number, start : Number, n : Number, dx : Number, dy : Number;
				// calculate distance between points
				step = (Math.PI * 2) / points;
				halfStep = step / 2;
				// calculate starting angle in radians
				start = (angle / 180) * Math.PI;
				target.moveTo( x + (Math.cos( start ) * outerRadius), y - (Math.sin( start ) * outerRadius) );
				// draw lines
				for (n = 1; n <= points; ++n) {
					dx = x + Math.cos( start + (step * n) - halfStep ) * innerRadius;
					dy = y - Math.sin( start + (step * n) - halfStep ) * innerRadius;
					target.lineTo( dx, dy );
					dx = x + Math.cos( start + (step * n) ) * outerRadius;
					dy = y - Math.sin( start + (step * n) ) * outerRadius;
					target.lineTo( dx, dy );
				}
			}
		}


		/**
		 * Draws a polygon in the target sprite and uses it as mask
		 * @param target the Sorite that will be masked by the star
		 * @param width
		 * @param height
		 * @param n number of sides
		 * @param angle start angle, expressed in degrees
		 */
		public static function polygon(target:Sprite, width:Number, height:Number, sides:int, angle:Number):void
		{
			if (arguments.length < 5)
			{
				trace("polygon - too few parameters");
				return;
			}
			var radius : Number = Math.round(Math.min(width, height)/2*Math.cos((angle / 180) * Math.PI));
			// convert sides to positive value   
			var count:uint=Math.abs(sides);
			// check that count is sufficient to build polygon
			if (count > 2)
			{
				// init vars
				var center:Point, step:Number, start:Number, n:Number, dx:Number, dy:Number, minx:Number, miny:Number;
				// calculate span of sides
				step = Math.PI * 2 / count;
				// calculate starting angle in radians
				start=(angle / 180) * Math.PI;
				minx=width / 2 + (Math.cos(start) * (width / 2));
				miny=height / 2 - (Math.sin(start) * (height / 2));
				start = angle * Math.PI / 180;
				center = new Point(width/2,height/2);
				minx = center.x *(1 + Math.cos(start));
				miny = center.y * (1 - Math.sin(start));
				target.graphics.moveTo(minx, miny);
				// draw the polygon
				for (n=1; n <= count; n++)
				{
					dx = center.x * (1 + Math.cos(start + step*n));
					dy = center.y * (1 - Math.sin(start + step*n));
					//minx = Math.min(minx, dx);
					//miny = Math.min(miny, dy);
					target.graphics.lineTo(dx, dy);
				}
					//target.width = width;
					//target.height = height;
					//target.x=-minx*target.scaleX;
					//target.y=-miny*target.scaleY;

			}
		}

		/**
		 * Burst draws star with rounded segments between points instead of
		 * straight lines.  
		 *
		 * @param targ sprite whose graphics is where the Burst will be drawn.
		 * @param x x coordinate of the center of the burst
		 * @param y y coordinate of the center of the burst
		 * @param sides number of sides or points
		 * @param innerRadius radius of the indent of the curves
		 * @param outerRadius radius of the outermost points
		 * @param angle [optional] starting angle in degrees. (defaults to 0)
		 * 
		 */
		public static function burst(targ : Sprite, x : Number, y : Number, sides : uint, innerRadius : Number, outerRadius : Number, angle : Number = 0 ) : void 
		{
			var target:Graphics = targ.graphics;
			//trace ("drawing Burst with sides="+sides+", inner="+innerRadius+", outer="+outerRadius);
			// check that sides is sufficient to build
			if(sides <= 2) {
				throw ArgumentError( "burst() - parameter 'sides' needs to be at least 3" ); 
				return;
			}
			if (sides > 2) {
				// init vars
				var step : Number, halfStep : Number, qtrStep : Number, start : Number, n : Number, dx : Number, dy : Number, cx : Number, cy : Number;
				// calculate length of sides
				step = (Math.PI * 2) / sides;
				halfStep = step / 2;
				qtrStep = step / 4;
				// calculate starting angle in radians
				start = (angle / 180) * Math.PI;
				target.moveTo( x + (Math.cos( start ) * outerRadius), y - (Math.sin( start ) * outerRadius) );
				// draw curves
				for (n = 1; n <= sides; ++n) {
					cx = x + Math.cos( start + (step * n) - (qtrStep * 3) ) * (innerRadius / Math.cos( qtrStep ));
					cy = y - Math.sin( start + (step * n) - (qtrStep * 3) ) * (innerRadius / Math.cos( qtrStep ));
					dx = x + Math.cos( start + (step * n) - halfStep ) * innerRadius;
					dy = y - Math.sin( start + (step * n) - halfStep ) * innerRadius;
					target.curveTo( cx, cy, dx, dy );
					cx = x + Math.cos( start + (step * n) - qtrStep ) * (innerRadius / Math.cos( qtrStep ));
					cy = y - Math.sin( start + (step * n) - qtrStep ) * (innerRadius / Math.cos( qtrStep ));
					dx = x + Math.cos( start + (step * n) ) * outerRadius;
					dy = y - Math.sin( start + (step * n) ) * outerRadius;
					target.curveTo( cx, cy, dx, dy );
				}
			}
		}


	}
}