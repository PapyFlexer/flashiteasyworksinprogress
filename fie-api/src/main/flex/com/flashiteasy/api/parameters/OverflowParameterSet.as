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
	import com.flashiteasy.api.core.elements.IContentScale;
	
	/**
	 * The <code><strong>OverflowParameterSet</strong></code> is the parameterSet
	 * that handles container overflow when set to automatic resize 
	 */
	public class OverflowParameterSet extends AbstractParameterSet {
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			super.apply( target );
			if( target is IContentScale )
			{
				IContentScale( target ).setOverflow( overflow ); 
			}
				
		}
		
		private var _overflow:String="none";
		
		/**
		 * The overflow mode, expressed as a string
		 */
		public function get overflow():String{
			return _overflow;
		}
		/**
		 * 
		 * @private
		 */
		public function set overflow(value:String):void{
			_overflow=value;
		}
	}
}
