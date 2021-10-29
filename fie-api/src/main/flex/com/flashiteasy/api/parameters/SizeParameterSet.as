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
	import com.flashiteasy.api.core.elements.ISizableElementDescriptor;
	
	[ParameterSet(description="Size", type="Reflection", groupname="Dimension")]
	/**
	 * The <code><strong>MaskParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control.It comes in 7 modes : 6 inner masks
	 * and an external one :
	 */
	public class SizeParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			if ( target is ISizableElementDescriptor )
			{
				ISizableElementDescriptor( target ).setActualSize( width, height, is_percent_w, is_percent_h  );
			}
		}
		
		private var _is_percent_w : Boolean = false ;
		private var _is_percent_h : Boolean = false ;
		
		[Parameter(type="Boolean", defaultValue="false",  row="0", sequence="1", label="%")]
		/**
		 * Enables the width to be expressed in percent relative to the control's parent container
		 */
		public function get is_percent_w():Boolean{
			return _is_percent_w;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set is_percent_w(value:Boolean):void{
			_is_percent_w=value;
		}
		
		[Parameter(type="Boolean", defaultValue="false", row="1", sequence="3", label="%")]
		/**
		 * Enables the height to be expressed in percent relative to the control's parent container
		 */
		public function get is_percent_h():Boolean{
			return _is_percent_h;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set is_percent_h(value:Boolean):void{
			_is_percent_h=value;
		}
		
		
		private var _width : Number = 100;
		
		
		[Parameter(type="Number", defaultValue="100", min="-5000", max="5000", row="0", sequence="0", label="WidthShort")]
		/**
		 * Sets the control width
		 */
		public function get width() : Number
		{
			return _width;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set width( value : Number ) : void
		{
			//_width = _is_percent_w ? Math.round(value*100)/100 : Math.round(value);
			_width = Math.round(value*100)*0.01;
		}
		
		private var _height : Number = 100;
		
		[Parameter(type="Number", defaultValue="100", min="-5000", max="5000",  row="1", sequence="2", label="HeightShort")]
		/**
		 * Sets the control's height
		 */
		public function get height() : Number
		{
			return _height;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set height( value : Number ) : void
		{
			_height = Math.round(value*100)*0.01;
		}

	}
}