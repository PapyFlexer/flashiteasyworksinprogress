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
	import com.flashiteasy.api.core.elements.IResizableElementDescriptor;
	
	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>ResizableParameterSet</strong></code> is the parameterSet
	 * that handles the resizing of a control.It sets horizontal and vertical alignment, 
	 * as well as the resizing mode (none, scale, fit)
	 */
	public class ResizableParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		override public function apply(target:IDescriptor):void
		{
			super.apply( target );
			if( target is IResizableElementDescriptor )
			{
				IResizableElementDescriptor( target ).setResize( resizable , mode); 
			}
		}
		
		private var _resizable : Boolean=true;
		private var _mode : String="fit";
		
		/**
		 * Enables the resize mode of the control 
		 */
		public function get resizable() : Boolean
		{
			return _resizable;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set resizable( value : Boolean) : void
		{
			_resizable = value;
		}
		[Parameter(type="Combo",defaultValue="fit", row="0", sequence="1", label="Content_size")]
		/**
		 * Setrs the resize mode
		 */
		public function get mode() : String
		{
			return _mode;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set mode( value : String ) : void
		{
			_mode = value;
		}
		/**
		 * Lists the resize mode
		 * @param name
		 * @return 
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
				case "mode" :
				values = ["scale","no_scale","fit"];
				break;
				
			}
			return values;
		}
		

	}
}