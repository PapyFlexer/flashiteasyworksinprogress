package com.flashiteasy.clock.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.clock.lib.IClockableElementDescriptor;

	[ParameterSet(description="Clock", type="Reflection",  groupname="Content")]
	public class ClockParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		override public function apply(target:IDescriptor) : void
		{
			IClockableElementDescriptor( target ).setClock( type);
		} 
		
		private var _type : String = null;
		private var _useAlarm : Boolean = false;
		
		
		[Parameter(type="Combo",defaultValue="simple", row="0" , sequence="1", label="Type")]
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
		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name : String) : Array 
		{
			return ["simple","alarm"];
		}
	}
}