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
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IAlignElementDescriptor;

	[ParameterSet(description="Align_type", type="Reflection", groupname="Dimension")]
	/**
	 * The <code><strong>AlignParameterSet</strong></code> is the parameterSet
	 * that handles the control alignment, relative to its parent or the stage.
	 * The metadata sets its editors via reflexion in the Dimension group, using 
	 * 2 combos (see getPossibleValues method at line 74).
	 */
	public class AlignParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
            if ( target is IAlignElementDescriptor )
            {
				IAlignElementDescriptor( target ).setAlign( v_align , h_align ); 
            }
		}
		
		private var _v_align:String="top";
		private var _h_align:String="left";
		
		[Parameter(type="Combo",defaultValue="top", row="0", sequence="1", label="VerticalShort")]
		/**
		 * Vertical Alignment
		 */
		public function get v_align():String{
			return _v_align;
		}
		/**
		 * 
		 * @private
		 */
		public function set v_align(value:String):void{
			_v_align=value;
		}

		/**
		 * Horizontal Alignment
		 */
		[Parameter(type="Combo",defaultValue="left", row="0", sequence="0", label="HorizontalShort")]
		public function get h_align():String{
			return _h_align;
		}
		/**
		 * 
		 * @private
		 */
		public function set h_align(value:String):void{
			_h_align=value;
		}
		
		/**
		 * defines the dataprovider of the editor's combobox.
		 * @param name h_align or v_align
		 * @return a dataprovider as an array
		 */
		public function getPossibleValues(name:String):Array
		{
			var values:Array;
			switch(name){
				case "h_align" :
				values = ["left","middle","right"];
				break;
				case "v_align" :
				values = ["top","middle","bottom"];
				break;
				
			}
			return values;
		}
		
	}
}