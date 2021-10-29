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
	import com.flashiteasy.api.core.elements.IPositionableElementDescriptor;

	[ParameterSet(description="Position",type="Reflection",groupname="Dimension")]
	/**
	 * The <code><strong>PositionParameterSet</strong></code> is the parameterSet
	 * that deals with a control position on stage.
	 */
	public class PositionParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{

		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
            if ( target is IPositionableElementDescriptor )
            {
				IPositionableElementDescriptor(target).setPosition(x, y, is_percent_x, is_percent_y);
	
				IPositionableElementDescriptor(target).setTargetPosition(targetPosition, mode);
            }
		}

		private var _is_percent_x:Boolean;
		private var _is_percent_y:Boolean;
		private var _target:String=null;

		/**
		 * 
		 * @return 
		 */
		public function get targetPosition():String
		{
			return _target;
		}

		/**
		 * 
		 * @param value
		 */
		public function set targetPosition(value:String):void
		{
			_target=value;
		}

		private var _mode:String="bottom";

		/**
		 * 
		 * @return 
		 */
		public function get mode():String
		{
			return _mode;
		}

		/**
		 * 
		 * @param value
		 */
		public function set mode(value:String):void
		{
			_mode=value;
		}


		[Parameter(type="Boolean",defaultValue="false",row="0",sequence="1",label="%")]
		/**
		 * 
		 * @return 
		 */
		public function get is_percent_x():Boolean
		{
			return _is_percent_x;
		}

		/**
		 * 
		 * @param value
		 */
		public function set is_percent_x(value:Boolean):void
		{
			_is_percent_x=value;
		}

		[Parameter(type="Boolean",defaultValue="false",row="1",sequence="3",label="%")]
		/**
		 * 
		 * @return 
		 */
		public function get is_percent_y():Boolean
		{
			return _is_percent_y;
		}

		/**
		 * 
		 * @param value
		 */
		public function set is_percent_y(value:Boolean):void
		{
			_is_percent_y=value;
		}


		private var _x:Number=0;

		[Parameter(type="Number",defaultValue="0",min="-5000",max="5000",row="0",sequence="0",label="X")]
		/**
		 * 
		 * @return 
		 */
		public function get x():Number
		{
			return _x;
		}

		/**
		 * 
		 * @param value
		 */
		public function set x(value:Number):void
		{
			_x=Math.round(value * 100) *0.01;
		}

		private var _y:Number=0;

		[Parameter(type="Number",defaultValue="0",min="-5000",max="5000",row="1",sequence="2",label="Y")]
		/**
		 * 
		 * @return 
		 */
		public function get y():Number
		{
			return _y;
		}

		/**
		 * 
		 * @param value
		 */
		public function set y(value:Number):void
		{
			_y=Math.round(value * 100) * 0.01;

		}

		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			return ["bottom", "right"];
		}
	}
}


