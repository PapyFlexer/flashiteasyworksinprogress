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
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.ITextElementDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.text.TextFieldAutoSize;

	[ParameterSet(description="Options", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>textOptionParameterSet</strong></code> is the parameterSet
	 * that handles most of the rich text control options : word wrapping, multiline,
	 * autoSize, border size and border color, .
	 */

	public class TextOptionParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		
		private var _autoSize:String=TextFieldAutoSize.CENTER;
		private var _border:Boolean=false;
		private var bc:int=0x000000;
		private var _multiLines:Boolean=true;
		private var _wordWrap:Boolean=true;
		private var _selectable:Boolean=false;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
            if ( target is ITextElementDescriptor )
            {
				ITextElementDescriptor( target ).setAutoSize( autoSize );
				ITextElementDescriptor( target ).setTextBorder( border , borderColor ); 
				ITextElementDescriptor( target ).setOptions( multiLines, wordWrap , selectable);  
            }
		}
		[Parameter(type="Combo", defaultValue="normal",  row="0", sequence="0", label="Autosize")]
		/**
		 * Sets autoSize mode 
		 */
		public function get autoSize():String{
			return _autoSize;
		}
		/**
		 * 
		 * @param value
		 */
		public function set autoSize(value:String):void{
			_autoSize=value;
		}
		[Parameter(type="Boolean", defaultValue="false", row="1", sequence="2", label="Multiline")]
		/**
		 * Enables multilines option
		 */
		public function get multiLines():Boolean{
			return _multiLines;
		}
		/**
		 * 
		 * @private
		 */
		public function set multiLines(value:Boolean):void{
			_multiLines=value;
		}
		[Parameter(type="Boolean", defaultValue="false",  row="1", sequence="4", label="Selectable")]
		/**
		 * Enables WordWrap
		 */
		public function get selectable():Boolean{
			return _selectable;
		}
		/**
		 * 
		 * @private
		 */
		public function set selectable(value:Boolean):void{
			_selectable=value;
		}
		[Parameter(type="Boolean", defaultValue="false",  row="1", sequence="3", label="WordWrap")]
		/**
		 * Enables WordWrap
		 */
		public function get wordWrap():Boolean{
			return _wordWrap;
		}
		/**
		 * 
		 * @private
		 */
		public function set wordWrap(value:Boolean):void{
			_wordWrap=value;
		}
		[Parameter(type="Boolean", defaultValue="false", row="0", sequence="1", label="Border")]
		/**
		 * Enables the text control border rendering
		 */
		public function get border():Boolean{
			return _border;
		}
		/**
		 * 
		 * @private
		 */
		public function set border(value:Boolean):void{
			_border=value;
		}
		/**
		 * Sets the text control border color
		 */
		public function get borderColor():int{
			return bc;
		}
		/**
		 * 
		 * @private
		 */
		public function set borderColor(value:int):void{
			bc=value;
		}
		/**
		 * Lists Flash textField autoSize modes
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return ArrayUtils.getConstant(flash.text.TextFieldAutoSize);
		}
	}
}
