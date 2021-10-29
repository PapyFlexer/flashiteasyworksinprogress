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
	import com.flashiteasy.api.core.elements.IXmlElementDescriptor;
	import com.flashiteasy.api.selection.XMLFileList;

	[ParameterSet(description="null",type="Reflection" , groupname="Block_Content")]
	/**
	 * 
	 * @private
	 */
	public class XmlParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var _xml : String = "";
		
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IXmlElementDescriptor )
			{
				IXmlElementDescriptor( target ).setXml( xml );
			}
		}
		
		[Parameter(type="Combo", row="0", sequence="0", label="XML_File")]
		/**
		 * 
		 * @return 
		 */
		public function get xml():String
		{
			return _xml;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set xml( value:String ):void
		{
			_xml=value;
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return XMLFileList.getInstance().getXMLNames();
		}
		
	}
}