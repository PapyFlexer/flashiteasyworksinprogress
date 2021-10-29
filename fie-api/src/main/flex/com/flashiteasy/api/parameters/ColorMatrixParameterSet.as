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
	import com.flashiteasy.api.core.elements.IColorMatrixElementDescriptor;

	/**
	 * @private
	 * The <code><strong>ColorMatrixParameterSet</strong></code> is the parameterSet
	 * that handles the color matrix transformation that can be applied to controls.
	 * @warning This button is not fully implemented yet : it has no editor in admin mode
	 * So use with caution... 
	 * 
	 */	
	public class ColorMatrixParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			super.apply( target );
			if( target is IColorMatrixElementDescriptor )
			{
				 IColorMatrixElementDescriptor( target ).setColorMatrix( matrix ); 
			}
		}
		
		private var _matrix:String = "[1,0,0,0,0," + 
										"0,1,0,0,0," + 
										"0,0,1,0,0," + 
										"0,0,0,1,0]";
		
		/**
		 * 
		 * @return 
		 */
		public function get matrix():String{
			return _matrix;
		}
		/**
		 * 
		 * @param value
		 */
		public function set matrix(value:String):void{
			_matrix=value;
		}
		
	}
}