/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;
	import com.flashiteasy.api.core.elements.IBackgroundImageElementDescriptor;
	
	/**
	 * Descriptor class for the <code><strong>Rectangle</strong></code> control.
	 * <p>Simple rectagle with a colorable oe an image background.
	 * </p>
	 */
	public class RectElementDescriptor extends SimpleUIElementDescriptor implements  IBackgroundImageElementDescriptor,IBackgroundColorableElementDescriptor
	{
		

		
		/**
		 * @private
		 * @param angle
		 * @param angle2
		 */
		public function rotate(angle : Number,angle2:Number):void{
			getFace().rotation=angle+angle2;
		}
		
		/**
		 * @private
		 * @param propToTween
		 * @param startValue
		 * @param endValue
		 * @param easeFunction
		 */
		public function setTween( propToTween : String, startValue : Number, endValue: Number, easeFunction:String ) : void{

			//TweenLite.to(this.getFace(), 5, { (propToTween as String):endValue , ease:easeFunction });
				
		}
		
		protected override function drawContent():void{
				end();
		}
		
		// What a pity that ActionScript does not support Generics...
		override public function getDescriptorType() : Class
		{
			return RectElementDescriptor;
		}


	}
}