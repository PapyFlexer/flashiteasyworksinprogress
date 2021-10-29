/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.sample.lib
{
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	
	import flash.display.Sprite;

	/**
	 * This Descriptor class takes charge of the Circle Element rendering.
	 * Custom descriptor should always extends either SimpleUIElementDescriptor,
	 * either MulitpleUIElementDescriptor (container-based elements).
	 * As it deals with Background color elements, it also implements IBackgroundColorableElementDescriptor
	 */
	public class CircleElementDescriptor extends SimpleUIElementDescriptor implements IBackgroundColorableElementDescriptor
	{

	
		/**
		 * override the <code>applySize()</code> method
		 */
		override public function applySize() : void
		{
			super.applySize();
			if(!isNaN(Number(super.bgColor))){
				Sprite( getFace() ).graphics.clear();
				Sprite( getFace() ).graphics.beginFill(super.bgColor, super.bgAlpha);
				Sprite( getFace() ).graphics.drawEllipse( 0, 0, width, height );
				Sprite( getFace() ).graphics.endFill();
			} else {
				Sprite( getFace() ).graphics.clear();
			}
			// when the modification is made, call the SImpleUIElementDescriptor method end()
			// that will tell the stage that it is ready to be rendered. 
			end();
		}
		
		
		// What a pity that ActionScript does not support Generics...
		/**
		 * 
		 * @return Class CircleElementDescriptor
		 */
		override public function getDescriptorType() : Class
		{
			return CircleElementDescriptor;
		}
		
	}
}