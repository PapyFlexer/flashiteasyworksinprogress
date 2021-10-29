package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IDailyMotionElementDescriptor;

	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	public class DailyMotionParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		
		private var _source : String;
		private var _apiDomain : String;
		
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IDailyMotionElementDescriptor )
			{
				IDailyMotionElementDescriptor( target ).setDomain( apiDomain );
				IDailyMotionElementDescriptor( target ).setImage( source );
			}
		}
		
		[Parameter(type="String", defaultValue="null", row="0", sequence="0", label="Source")]
		public function get source():String{
			return _source;
		}
		
		public function set source( value:String ):void{
			_source=value;
		}
		
		[Parameter(type="Combo", defaultValue="dailymotion", row="1", sequence="1", label="Domain")]
		public function get apiDomain():String{
			return _apiDomain;
		}
		
		public function set apiDomain( value:String ):void{
			_apiDomain=value;
		}
		
		public function getPossibleValues(name:String):Array
		{
			var values:Array = ["dailymotion", "youtube"];
			return values;
		}
	}
}