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
	import com.flashiteasy.api.core.elements.IFormElementDescriptor;
	import com.flashiteasy.api.core.elements.INumericStepperElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	
	import fl.controls.NumericStepper;

	/**
	 * Descriptor class for the <code><strong>NumericStepper</strong></code> form item.
	 */
	public class NumericStepperElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor,IFormElementDescriptor,INumericStepperElementDescriptor {

		// component
		private var ns:NumericStepper;

		/**
		 * 
		 * @inheritDoc
		 */
		protected override function initControl():void{
			
			ns=new NumericStepper();
			face.addChild(ns);
			
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
		 * Maximum property of the NumericStepper
		 * @return Maximum value
		 */
		public function get maximum():Number{
			return ns.maximum;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set maximum(value:Number):void{
			ns.maximum=value;
		}
		
		/**
		 * Minimum property of the NumericStepper
		 * @return Minimum value
		 */
		public function get minimum():Number{
			return ns.minimum;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set minimum(value:Number):void{
			ns.minimum=value;
		}
		

		
		/**
		 * Sets the stepsize of the NumericStepper
		 * @return Maximum value
		 */
		public function set  stepSize(value:Number):void{
			ns.stepSize=value;
		}
		override public function getValue():String{
			return ""+ns.value;
		}
		
		protected override function onSizeChanged():void
		{
			ns.height = face.height;
			ns.width = face.width;
		}
		
		 override public function resetValues():void
		 {
		 	ns.value = 0;
		 }
		 
		 override public function displayError( s : String ):void
		 {
		 	ns.setStyle("backgroundColor", 0xCC0000);
		 		this.getParameterSet().apply(this);
		 }
		 
		
		override public function getDescriptorType():Class
		{
			return NumericStepperElementDescriptor;
		}
	}
}
