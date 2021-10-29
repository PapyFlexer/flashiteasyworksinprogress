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
	 * The <code><strong>ArrayParameterSetXMLParser</strong></code> class is
	 * a parsing utility class parsing dealing with arrays type parameterSets
	 */
	public class ArrayParameterSetXMLParser implements IParameterSetParser
	{
		/**
		 * Fills an XML with a ParameterSet and its parent Descriptor.
		 * @param xml
		 * @param instance
		 * @param parent
		 */
		public function fill(xml:XML, instance:IParameterSet, parent:IDescriptor=null):void
		{
			if (xml != null)
			{
				for each (var node:XML in xml.children())
				{
					if (Object(instance).hasOwnProperty(node.name()) && node.valueOf()!="")
					{
						var tmp:String;
						if ( node.children().length() == 0 )
						{
							instance[node.name()]=[];
							return;
						}
						if ( node.children()[0].indexOf("[") != -1)
						{
							tmp=node.children()[0].substr(node.children()[0].indexOf("[") + 1);
							tmp=tmp.substr(0, tmp.indexOf("]"));
						}
						else
						{
							tmp=node.children()[0];
						}
						var result:Array=tmp.split(",");
						instance[node.name()]=result.slice(0);

					}
				}
			}

		}
	}
}
