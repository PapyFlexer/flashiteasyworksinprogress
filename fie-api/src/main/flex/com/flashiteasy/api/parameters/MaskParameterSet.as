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
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IMaskElementDescriptor;
	import com.flashiteasy.api.selection.ElementList;
	
	[ParameterSet(description="Mask",type="Reflection",groupname="Block_Content")]
	/**
	 * The <code><strong>MaskParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control.It comes in 7 modes : 6 inner masks
	 * and an external one :
	 * <ul>
	 * <li><strong>Normal : </strong>masks the ouside of the control's bounding box</li>
 	 * <li><strong>Circle : </strong>masks the outside of a circle whose diameter is based on the control bounding box</li>
  	 * <li><strong>Ellipse : </strong>masks the ouside of an ellipse based on the control's bounding box</li>
   	 * <li><strong>roundRectangle : </strong>masks the ouside of the control's bounding box, with round corners, individually settable</li>
   	 * <li><strong>Star : </strong>masks the ouside of a star based on the control's bounding box, inner radius and number of branches</li>
   	 * <li><strong>Polygon : </strong>masks the ouside of a polygon based on the control's bounding box and the number of sidhes</li>
   	 * <li><strong>External : </strong>takes another image control as the masking shape</li>
   	 * </ul>
 	 */
	public class MaskParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var _type : String = "normal";
		//private var _maskObject:Object = null;
		private var _enable : Boolean = false;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			super.apply( targ );
			if( targ is IMaskElementDescriptor )
			{
				IMaskElementDescriptor( targ ).setMask( type );
			}
		}
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="0",label="Enable")]
		/**
		 * Mask enabler 
		 */
		public function get enable():Boolean{
			return _enable;
		}
		/**
		 * 
		 * @private
		 */
		public function set enable(value:Boolean):void{
			_enable=value;
		}
		[Parameter(type="Combo",defaultValue="normal", row="0" , sequence="1", label="Type")]
		/**
		 * 
		 * Mask type
		 */
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set type( value:String ):void{
			_type=value;
		}
		/*[Parameter(type="List",labelField="uuid",row="1",sequence="2",label="Target",defaultValue="null")]
		public function get target():String
		{
			return _target;
		}

		public function set target(value:String):void
		{
			_target=value;
		}*/
		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name : String ) : Array 
		{
			var values:Array;
			switch(name){
				case "type" :
				values = ["none", "normal","circle","ellipse","roundRectangle","star","polygon","burst", "external"];
				break;
				case "target" :
				values = ElementList.getInstance().getElementsAsString(BrowsingManager.getInstance().getCurrentPage());
				break;
				
			}
			return values;
			//return ["normal","circle","ellipse","roundRectangle","star","polygon"];
		}

	}
}