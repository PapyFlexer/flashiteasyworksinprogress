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
	import com.flashiteasy.api.core.elements.IXmlElementDescriptor;
	
	import flash.events.Event;
	/**
	 * 
	 * @private
	 */
	public class XmlChangeParameterSet extends AbstractParameterSet 
	{

		override public function apply( target : IDescriptor ) : void
		{
			if ( target is IXmlElementDescriptor )
			{
				IXmlElementDescriptor(target).getFace().addEventListener(trigger, doAction );
			}
			
		}

		private function doAction( event : Event ) : void
		{
			//(this.target as SimpleUIElementDescriptor).changeXML(xml);
		}

		private var _xml : String;

		/**
		 * 
		 * @return 
		 */
		public function get xml() : String
		{

			return _xml;
		}

		/**
		 * 
		 * @param value
		 */
		public function set xml( value : String ) : void
		{
			_xml = value;

		}

		private var _trigger : String;

		/**
		 * 
		 * @return 
		 */
		public function get trigger() : String
		{
			return _trigger;
		}

		/**
		 * 
		 * @param value
		 */
		public function set trigger( value : String ) : void
		{
			_trigger = value;
		}

	}
}
