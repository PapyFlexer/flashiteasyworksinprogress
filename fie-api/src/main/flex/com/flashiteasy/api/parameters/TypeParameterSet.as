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
	import com.flashiteasy.api.core.elements.ITypeElementDescriptor;

	/**
	 * @private
	 * 
	 * The <code><strong>TypeCornerParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control by a rounded rectangle.It sets the bottom left,
	 * bottom right, top left and top right corners using a radius value.
	 */

	public class TypeParameterSet extends AbstractParameterSet {
		
		private var _type : String = "horizontal";
			
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is ITypeElementDescriptor )
			{
				ITypeElementDescriptor( target ).setType( type );
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get type():String{
			return _type;	
		}
		/**
		 * 
		 * @param value
		 */
		public function set type(value:String):void{
			_type=value;
		}
		
	}
}
