/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters {
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.INumericStepperElementDescriptor;
	
	[ParameterSet(description="null",type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>NumericStepperOptionsParameterSet</strong></code> is the parameterSet
	 * that handles the Numeric Stepper form item options : maximum and minimum values, as well as the step size. 
 	 */

	public class NumericStepperOptionsParameterSet extends AbstractParameterSet {
		
		private var max:Number=100;
		private var min:Number=0;
		private var step:Number=1;
		private var value:Number;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			if(target is INumericStepperElementDescriptor)
			{
				super.apply( target );
				INumericStepperElementDescriptor (target).maximum=maximum;
				INumericStepperElementDescriptor (target).minimum=minimum;
				INumericStepperElementDescriptor (target).stepSize=stepSize;
			}

		}
		
		[Parameter(type="Number",defaultValue="100",min="-1000",max="1000",row="0",sequence="0",label="Max")]
		/**
		 * Maximum value of the Numeric Stepper 
		 */
		public function get maximum():Number{
			return max;
		}
		/**
		 * 
		 * @private
		 */
		public function set maximum(value:Number):void{
			max=value;
		}
		[Parameter(type="Number",defaultValue="0",min="-1000",max="1000",row="0",sequence="1",label="Min")]
		/**
		 * Minimum value of the Numeric Stepper 
		 */
		public function get minimum():Number{
			return min;
		}
		/**
		 * 
		 * @private
		 */
		public function set minimum(value:Number):void{
			min=value;
		}
		[Parameter(type="Number",defaultValue="1",min="1",max="1000",row="1",sequence="2",label="Step")]
		/**
		 * Step value of the Numeric Stepper  
		 */
		public function get stepSize():Number{
			return step;
		}
		/**
		 * 
		 * @private
		 */
		public function set stepSize(value:Number):void{
			step=value;
		}
		
	}
}
