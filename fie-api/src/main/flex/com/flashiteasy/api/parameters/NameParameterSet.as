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
	import com.flashiteasy.api.core.elements.IFormElementDescriptor;

	/**
	 * The <code><strong>NameParameterSet</strong></code> is the parameterSet
	 * that handles the keys held by form item when the form is submitted, while the value is held in the content of the form item. 
	 * 
 	 */
	public class NameParameterSet extends AbstractParameterSet {
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target : IDescriptor ) : void
		{
			if(target is IFormElementDescriptor)
			{
				IFormElementDescriptor(target).name=this.name;
			}
		}
		
		
		
		private var _name : String="";
		
		/**
		 * The name as the key (in key/value pairs) sent by a form when submitted 
		 */
		public function get name() : String
		{
			
			return _name;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set name( value : String ) : void
		{
			_name = value;
			
		}
	}
}
