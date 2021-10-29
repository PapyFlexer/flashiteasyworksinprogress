/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.container {
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IXmlElementDescriptor;
	import com.flashiteasy.api.core.project.XMLFile;
	import com.flashiteasy.api.selection.XMLFileList;

	/**
	 * The <code><strong>XmlElementDescriptor</strong></code> describes the control whose particularity is that its content is not
	 * a visual one, but a chunk of XML, fie-formatted.
	 * It's role is essentially to manage dynamic content that can be shared by all project hierarchy.
	 * When the xml code is changed, all instances of <code>XmlElementDescriptor</code> are changed dynamically.
	 * 
	 */
	public class XmlElementDescriptor extends BlockElementDescriptor implements IXmlElementDescriptor
	{
		private var xml : XMLFile;
		private var xmlName : String ;
		private var control:IUIElementDescriptor;

		/**
		 * The String that contains the xml scheme of the content or library managed.
		 * @param xml
		 */
		public function setXml( xml : String ) : void 
		{
			
			if( xmlName != xml )
			{
				if( this.xml != null ) 
				{
					this.xml.hide();
				}
				xmlName = xml ;
				xmlDisplayed = false ;
				
				if( xml == "" )
				{
					this.xml = null ;
				}
				else
				{
					this.xml = XMLFileList.getInstance().findXML( xml ).copy() ;
				}
			}
			
		}
		public function getXml():XMLFile
		{
			return xml;
		}
		
		private var xmlDisplayed : Boolean  = false ;
		protected override function drawContent():void
		{
			if(!xmlDisplayed)
			{
				xmlDisplayed = true ;
				if( xml != null ) 
				{
					xml.showInContainer(this);
				}
				//super.drawContent();
				end();
			}
			//this.resizable = false;
				//resizeFromChildren(true);
		}

		override public function destroy():void
		{
			if(xml != null )
			{
				xml.removeActions();
				xml.hide();
			}
			super.destroy();
			
		}
		
		override public function getChildren(recursive:Boolean = false):Array
		{
			var a : Array  = super.getChildren(recursive);
			trace ("XMLCont lists :: "+a.toString());
			return a;
		} 
		
		override public function getDescriptorType() : Class
		{
			return XmlElementDescriptor;
		}

	}
}
