/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	
	import fl.controls.ColorPicker;
	
	/**
	 * Descriptor class for the <code><strong>ColorPicker</strong></code>  (form Item component).
	 * @inheritDoc
	 */
	public class ColorPickerElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor {
		
		private var cp:ColorPicker;

		protected override function initControl():void
		{
			cp=new ColorPicker();
			face.addChild(cp);
		}
		
		/**
		 * 
		 * @return 
		 */
		override public function check():Boolean
		{
			// always checked (no validators);
			return true;
		}


		override public function getValue():String
		{
			return ""+cp.selectedColor;
		}
		
		protected override function onSizeChanged():void
		{
			cp.height = face.height;
			cp.width = face.width;
		}
		//===============================

		override public function getDescriptorType():Class
		{
			return ColorPickerElementDescriptor;
		}

	}
}
