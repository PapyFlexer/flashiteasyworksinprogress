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
	import com.flashiteasy.api.core.elements.IButtonElementDescriptor;
	
	/**
	 * @private
	 */
	 
	[ParameterSet(description="XMLArray", type="Reflection", groupname="Texte")]
	/**
	 * 
	 * @author gillesroquefeuil
	 */
	public class XMLArrayParameterSet extends AbstractParameterSet {
		
		private var _xml_array : Array;
		
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
		}
		[Parameter(type="xml", defaultValue="Entrez votre texte",  row="0", sequence="0", label="xml")]
		/**
		 * 
		 * @return 
		 */
		public function get xml_array():Array{
			return _xml_array;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set xml_array( value:Array ):void{
			_xml_array=value;
		}
	}
}
