/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IBorderElementDescriptor;

	[ParameterSet(description="Border",type="Reflection", groupname="Block_Decoration")]
	/**
	 * The <code><strong>BlendModeParameterSet</strong></code> is the parameterSet
	 * that handles the control's borders.
	 * The metadata sets its editors via reflection in the Decoration group, using 
	 * a checkbox to activate border, a colorpicker for the border color and 4 NumericSteppers.
	 */
	public class BorderParameterSet extends AbstractParameterSet
	{
		
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			if(target is IBorderElementDescriptor )
			{
				IBorderElementDescriptor(target).setBorder(enable,color,borderTop,borderBottom,borderLeft,borderRight );
			}
		}
		
		private var _enable : Boolean = false;
		private var _color : Number ;
		private var _borderTop:int=0;
		private var _borderBottom :int=0;
		private var _borderLeft : int = 0;
		private var _borderRight : int = 0;
		
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="0" ,label="Enable")]
		/**
		 * Border enabler, uses a checkbox 
		 */
		public function get enable():Boolean
		{
			return _enable;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set enable(value:Boolean) : void 
		{
			_enable = value ;	
		}
		[Parameter(type="Color", defaultValue="NaN",  row="0", sequence="1", label="Color")]
		/**
		 * Border color
		 */
		public function get color():Number
		{
			return _color;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set color(value:Number):void
		{
			_color=value;
		}
		[Parameter(type="Number",defaultValue="0",min="0",max="50",row="1",sequence="2",label="TopShort")]
		/**
		 * Top border 
		 */
		public function get borderTop():int
		{
			return _borderTop;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set borderTop(value:int):void
		{
			_borderTop=value;
		}		
		[Parameter(type="Number",defaultValue="0",min="0",max="50",row="1",sequence="3",label="BottomShort")]
		/**
		 * Bottom border 
		 */
		public function get borderBottom():int
		{
			return _borderBottom;
		}
		/**
		 * 
		 * @private
		 */
		public function set borderBottom(value:int):void
		{
			_borderBottom = value;	
		}
		[Parameter(type="Number",defaultValue="0",min="0",max="50",row="2",sequence="4",label="LeftShort")]
		/**
		 * Left border 
		 */
		public function get borderLeft():int
		{
			return _borderLeft;
		}
		/**
		 * 
		 * @private
		 */
		public function set borderLeft(value:int):void
		{
			_borderLeft=value;
		}
		[Parameter(type="Number",defaultValue="0",min="0",max="50",row="2",sequence="5",label="RightShort")]
		/**
		 * Right border
		 */
		public function get borderRight():int
		{
			return _borderRight;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set borderRight(value:int):void
		{
			_borderRight=value;
		}
	}
}