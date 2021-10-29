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
	import com.flashiteasy.api.core.elements.IButtonElementDescriptor;

	/**
	 * @private
	 * 
	 * The <code><strong>ButtonParameterSet</strong></code> is the parameterSet
	 * that handles a pseudo-button control that has 3 states : normal / rollOver / selected.
	 * @warning This button is not fully implemented yet : it has no editor in admin mode
	 * So use with caution... 
	 * 
	 */	
	 
	public class ButtonParameterSet extends AbstractParameterSet
	{
		/**
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			if (target is IButtonElementDescriptor)
			{
				IButtonElementDescriptor(target).setButtonXml(xml1 , xml2 , xml3);
			}
		}

		private var xml1:XML;
		private var xml2:XML;
		private var xml3:XML;

		/**
		 * 
		 * @param value
		 */
		public function set default_xml(value:String):void
		{
			xml1=new XML(value);
		}



		/**
		 * 
		 * @param value
		 */
		public function set rollOverXml(value:String):void
		{
			xml2=new XML(value);
		}


		/**
		 * 
		 * @param value
		 */
		public function set mouseDownXml(value:String):void
		{
			xml3=new XML(value);
		}
	}
}