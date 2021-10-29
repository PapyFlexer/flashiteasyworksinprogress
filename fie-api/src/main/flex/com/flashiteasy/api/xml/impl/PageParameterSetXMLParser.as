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
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.xml.IParameterSetParser;

	/**
	 * The <code><strong>PageParameterSetXMLParser</strong></code> class is
	 * a parsing utility class parsing dealing with pages parameterSets
	 */
	public class PageParameterSetXMLParser implements IParameterSetParser
	{

		/**
		 * Fills an XML with a ParameterSet and its parent Descriptor.
		 * @param xml
		 * @param instance
		 * @param parent
		 */
		public function fill(xml:XML, instance:IParameterSet, parent:IDescriptor=null):void
		{
			if(xml!=null)
			{
				//var p : Page = new Page();
				//p.link = xml.child("page").text();
				instance["page"]=xml.child("page").text();
			}
		}
		
	}
}