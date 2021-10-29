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
	import com.flashiteasy.api.core.elements.IArrayElementDescriptor;
	
	/**
	 * The <code><strong>ArrayParameterSet</strong></code> is the parameterSet
	 * that handles controls defines by collections.
	 * Alternatively, is used to implement multi-targets for applying actions or controls on stage.
	 * No metadata here as it is a pseudo-abstract.
	 * 
	 */
	public class ArrayParameterSet extends AbstractParameterSet {
		
			private var _targets : Array=new Array();
		
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IArrayElementDescriptor )
			{
				IArrayElementDescriptor ( target ).setArray( array );
			
			}
		}
		
		/**
		 * the array of identical items (TODO : change this prop tp Vector:*)
		 */
		public function get array():Array{
			return _targets;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set array( value:Array ):void{
			_targets=value;
		}
	}
}
