/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import fl.controls.RadioButtonGroup;

	/**
	 * Descriptor class for the <code><strong>RadioButtonGroup</strong></code> form item.
	 */
	public class RadioButtonGroupElementDescriptor extends FormItemElementDescriptor implements  IUIElementDescriptor {
		
		// component
		private var rg:RadioButtonGroup;
		
		/**
		 * @inheritDoc
		 */
		protected override function initControl():void
		{
			rg=new RadioButtonGroup("");
		}
		
		//===============================

		override public function getDescriptorType():Class
		{
			return RadioButtonGroupElementDescriptor;
		}

	}
}
