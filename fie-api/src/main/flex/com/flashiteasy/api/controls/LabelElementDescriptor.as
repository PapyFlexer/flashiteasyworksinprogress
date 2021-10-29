/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.ILabelElementDescriptor;
	
	import fl.controls.Label;
	
	/**
	 * Descriptor class for the <code><strong>Labels</strong></code> used in form items (radio button, checkbox, button, ...).
	 */

	public class LabelElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor,ILabelElementDescriptor
	{
		
		//private var txt:String="toto";
		
		
		/**
		 * Constructor
		 */
		public function LabelElementDescriptor()
		{
			super();
		}
		/**  @inheritDoc   **/
		protected override function initControl():void
		{
			lbl=new Label();
			face.addChild(lbl);
		}
		
		/**  @inheritDoc   **/
		protected override function onSizeChanged():void
		{
			lbl.height = face.height;
			lbl.width = face.width;
		}
		
		/*
		===============================
		
		GETTERS & SETTERS
		
		===============================
		*/
		/**  @private  **/
		private var lbl:Label;
		/**
		 * The string that fills the label
		 */
		public function get label():String
		{
			return lbl.text;
		}

		/**  @private  **/
		public function set label(value:String):void
		{
			lbl.text = value;
		}

	}
}