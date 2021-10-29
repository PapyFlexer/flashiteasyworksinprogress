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
	import com.flashiteasy.api.core.elements.IFormItemLabelElementDescriptor;
	import com.flashiteasy.api.core.elements.ILabelElementDescriptor;
	
	import fl.controls.CheckBox;
	
	/**
	 * Descriptor class for the <code><strong>CheckBox</strong></code> form item control
	 */
	public class CheckBoxElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor,ILabelElementDescriptor,IFormItemLabelElementDescriptor
	{
		
		private var cb:CheckBox;

		protected override function initControl():void
		{
			cb=new CheckBox();
			cb.label = "CheckBox";
			cb.labelPlacement="left";
			face.addChild(cb);
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
		
		/**
		 * Sets the CheckBox control label
		 * @param value - the String that displays beside the component
		 */
		public function set label(value:String):void{
			cb.label=value;
			//rb.textField.text=value;
		}

		/**
		 * 
		 * @return - the String that displays beside the component
		 */
		public function get label():String{
			return cb.label;
		}
		
		/**  @inheritDoc  **/
		override public function getValue():String{
			if(cb.selected)
				return ""+cb.label+"=true";
			return null;
		}
		/**
		 * Sets the label of the CheckBox component
		 * @param value
		 */
		public function setLabelText(value:String):void
		{
			cb.label = value;
		}
		
		/**
		 * Sets the placement of the label for the CheckBox Component : top, bottom, left or right
		 * @param value
		 */
		public function setLabelPlacement(value:String):void
		{
			cb.labelPlacement = value;
		}
		
		/**  @inheritDoc  **/
		protected override function onSizeChanged():void
		{
			cb.height = face.height;
			cb.width = face.width;
		}


		/**  @inheritDoc  **/
		 override public function resetValues():void
		 {
		 	cb.selected = false;
		 }
		 
		/**  @inheritDoc  **/
		 override public function displayError( s : String ):void
		 {
		 	cb.setStyle("BorderColor", 0xCC0000);
		 }
		 
		//===============================

		override public function getDescriptorType():Class
		{
			return CheckBoxElementDescriptor;
		}


	}
}
