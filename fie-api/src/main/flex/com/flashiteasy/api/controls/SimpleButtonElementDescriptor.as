/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls 

{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IFormItemLabelElementDescriptor;
	
	import fl.controls.Button;

	/**
	 * Descriptor class for the <code><strong>SimpleButton</strong></code> form item.
	 */
	public class SimpleButtonElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor,IFormItemLabelElementDescriptor {
		
		private var bu:Button;

		protected override function initControl():void
		{
			bu=new Button();
			face.addChild(bu);
			
		}
		
		/**
		 * Sets the label of the SimpleButton
		 */
		public function get label():String
		{
			return bu.label;
		}
		
		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			bu.label=value;
		}

		/**
		 * @inheritDoc
		 */
		override protected function onSizeChanged():void
		{
			bu.height = face.height;
			bu.width = face.width;
			bu.label = label;
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


		public function setLabelText(value:String):void
		{
			bu.label = value;
		}
		public function setLabelPlacement(value:String):void {}

		
		override public function resetValues():void
		{}
		//===============================

		override public function getDescriptorType():Class
		{
			return SimpleButtonElementDescriptor;
		}

	}
}
