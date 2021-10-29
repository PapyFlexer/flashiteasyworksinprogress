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
	
	
	/**
	 * @private
	 * The <code><strong>MaskParameterSet</strong></code> is the parameterSet
	 * that handles the masking of a control.It comes in 7 modes : 6 inner masks
	 * and an external one :
	 * <ul>
	 * <li><strong>Normal : </strong>masks the ouside of the control's bounding box</li>
 	 * <li><strong>Circle : </strong>masks the outside of a circle whose diameter is based on the control bounding box</li>
  	 * <li><strong>Ellipse : </strong>masks the ouside of an ellipse based on the control's bounding box</li>
   	 * <li><strong>roundRectangle : </strong>masks the ouside of the control's bounding box, with round corners, individually settable</li>
   	 * <li><strong>Star : </strong>masks the outside of a star based on the control's bounding box, inner radius and number of branches</li>
   	 * <li><strong>Polygon : </strong>masks the outside of a polygon based on the control's bounding box and the number of sides</li>
   	 * <li><strong>Burst : </strong>masks the ouside of a star wih rounded segments based on the control's bounding box and the number of sides</li>
   	 * <li><strong>External : </strong>takes another image control as the masking shape</li>
   	 * </ul>
 	 */
	public class MaskTargetParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var _target:String = null;
		
		override public function apply( targ: IDescriptor ) : void
		{
			super.apply( targ );
			if( targ is IMaskElementDescriptor )
			{
				IMaskElementDescriptor( targ ).drawExternalMask( target );
			}
		}
		/**
		 * 
		 * @return 
		 */
		public function get target():String
		{
			return _target;
		}

		/**
		 * 
		 * @param value
		 */
		public function set target(value:String):void
		{
			_target=value;
		}
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
				values = ["none", "normal","circle","ellipse","roundRectangle","star","polygon", "burst", "external"];
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