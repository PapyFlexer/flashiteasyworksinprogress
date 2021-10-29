/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.xml.impl
{
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.xml.IParameterSetParser;

	/**
	 * The <code><strong>ArrayStringParameterSetXMLParser</strong></code> class is
	 * a parsing utility class parsing dealing with an array of string type parameterSets
	 */
	public class ArrayStringParameterSetXMLParser implements IParameterSetParser
	{
		/**
		 * Fills an XML with a ParameterSet and its parent Descriptor.
		 * @param xml
		 * @param instance
		 * @param parent
		 */
		public function fill(xml : XML, instance : IParameterSet, parent : IDescriptor = null) : void {
			
			if(xml != null){
			for each( var node : XML in xml.children() )
			{
				if( Object( instance ).hasOwnProperty( node.name() ) )
				{
					var tmp:String;
					var filterMatrix :Array = new Array();
					if(node.children()[0].indexOf("[") != -1 ){
						tmp = node.children()[0].substr(node.children()[0].indexOf("[")+1);
						tmp = tmp.substr(0 , tmp.indexOf("]") );
						var result:Array=tmp.split( ",");
						var i:int;
						for( i=0 ; i<result.length ; i++)
						filterMatrix [i] = result[i];
						instance[node.name()] = filterMatrix;
					}
					else
						tmp = node.children()[0];
						instance[node.name()] = tmp;
					
				
				}
			}
			}
			
			
		}
	}
}
