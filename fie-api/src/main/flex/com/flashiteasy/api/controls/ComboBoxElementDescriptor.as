/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IDataProviderElementDescriptor;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;

	/**
	 * Descriptor class for the <code><strong>ComboBox</strong></code>  form item control.
	 */
	public class ComboBoxElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor, IDataProviderElementDescriptor {
		
		private var cb:ComboBox;
		//private var options:Array=new Array();
		private var labels:Array=new Array();
		private var datas:Array=new Array();
		private var dp:DataProvider;

		protected override function initControl():void
		{
			cb=new ComboBox();
			face.addChild(cb);
		}
		
		/* public function setArray(array:Array):void
		{
			options=array;
		} */
		
		/**
		 * Sets the array of labels to be displayed in the form element
		 * @param a
		 */
		public function setLabels( a: Array ) : void
		{
			labels = a;
		}
		
		/**
		 * 
		 * Sets the array of datas to be sent by the form element
		 */
		public function setDatas( a: Array ) : void
		{
			datas = a;
		}
		
		protected override function drawContent():void
		{
			dp = new DataProvider();
			
			var i:uint = 0;
			var item:Object;
			for each( var str:String in labels){
				item = new Object;
				item.label = labels[i];
				item.data = datas[i];
				dp.addItem(item);
				i++;
			}
			cb.dataProvider=dp;
		}
		
		override public function getValue():String
		{
				return cb.selectedItem.data == null ? cb.selectedItem.label : cb.selectedItem.data ;
		}
		
		protected override function onSizeChanged():void
		{
			
			/*
			if( width < 0 )
			{
				cb.width = -face.width ; cb.scaleX = -1;
			}
			else 
			{
				cb.width = face.width ; cb.scaleX = 1;
			}
			
			if( height < 0 ) 
			{
				cb.height = -face.height ; cb.scaleY = -1;
			}
			else
			{
				cb.height = face.height ; cb.scaleY = 1 ;
			}
			
			/*width < 0 ? [ cb.width = -face.width , cb.scaleX = -1 ] : [cb.width = face.width , cb.scaleX = 1];
			height < 0 ? [ cb.height = -face.height , cb.scaleY = -1  ] : [ cb.height = face.height , cb.scaleY = 1 ];
			*/
			cb.height = face.height;
			cb.width = face.width;
		}
		/**
		 * Unselects the Combo, by setting its selectedIndex to-1.
		 */
		 override public function resetValues():void
		 {
		 	cb.selectedIndex = -1;
		 }
		 
		 override public function displayError( s : String ):void
		 {
		 	cb.setStyle("BorderColor", 0xCC0000);
		 		this.getParameterSet().apply(this);
		 }
		 
		
		/**
		 * 
		 * @return 
		 */
		override public function check():Boolean
		{
			// always checked (no validators);
			return true;
		}

		//===============================

		override public function getDescriptorType():Class
		{
			return ComboBoxElementDescriptor;
		}

	}
}
