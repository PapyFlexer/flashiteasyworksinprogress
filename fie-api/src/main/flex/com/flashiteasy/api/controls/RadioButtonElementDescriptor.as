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
	import com.flashiteasy.api.core.elements.IRadioButtonElementDescriptor;

	
	import fl.controls.RadioButton;
	
	/**
	 * Descriptor class for the <code><strong>RadioButton</strong></code> form item.
	 */
	public class RadioButtonElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor,IFormItemLabelElementDescriptor,ILabelElementDescriptor,IRadioButtonElementDescriptor {
		
		
		// component
		private var rb:RadioButton;
		
		private var group : String;
		
		protected override function initControl():void
		{
			rb=new RadioButton();
			rb.label="RadioButton";
			rb.labelPlacement="left";
			face.addChild(rb);
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
		 * 
		 * @inheritDoc
		 */
		public override function set name(value:String):void{
			super.name=value;
		}


		/**
		 * Sets the label of the radio button 
		 * @return string used to dispaly the radio button label
		 */
		public function get label():String{
			return rb.label;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set label(value:String):void{
			rb.label=value;
			//rb.textField.text=value;
		}

		/**
		 * Sets the name of the radiobuttongroup. All rb sharing this groupe will react together
		 * @param value
		 */
		public function setGroup(value:String):void
		{
			group = value;
			rb.groupName=value;
		}
		
		public function getGroup():String
		{
			return group;
		}
		
		/**
		 * Sets the label of the radio button
		 * @param value the label of the radio button
		 */
		public function setLabelText(value:String):void
		{
			rb.label=value;
		}
		
		
		/**
		 * Set the radio button label placement
		 * @param value the string depicting the placement (top, bottom, left, right)
		 */
		public function setLabelPlacement(value:String):void
		{
			rb.labelPlacement=value;
		}

		/**
		 * @inheritDoc
		 */
		override public function getValue():String
		{
			//return  rb.group.selection.name; 
			 if(rb.selected){
				return rb.label;	
			}
			else
				return ""; 
		}

		/**
		 * @inheritDoc
		 */
		 override public function resetValues():void
		 {
		 	rb.selected = false;
		 }
		 
		/**
		 * @inheritDoc
		 */
		 override public function displayError( s : String ):void
		 {
		 	rb.setStyle("borderColor", 0xCC0000);
		 	// apply the errorString
		 	getParameterSet().apply(this);
		 	//var errStr : String = FormItemElementDescriptor(this).validator.getErrorString()
		 }
		 
		
		//===============================

		override public function getDescriptorType():Class
		{
			return RadioButtonElementDescriptor;
		}

	}
}
