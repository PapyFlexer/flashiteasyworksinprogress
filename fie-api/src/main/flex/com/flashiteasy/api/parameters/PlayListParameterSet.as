package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.action.PlayListAction;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	
	import flash.events.Event;

	
	[ParameterSet(description="null",type="Reflection" , groupname="Block_Content")]
	public class PlayListParameterSet extends AbstractParameterSet
	{
		private var _xml : String = "";
		
		override public function apply( target: IDescriptor ) : void
		{
			
				PlayListAction( target ).setXML( xml );
				PlayListAction( target ).apply(new Event(Event.COMPLETE));
		}
		
		[Parameter(type="String", row="0", sequence="0", label="XML_File")]
		/**
		 * 
		 * @return 
		 */
		public function get xml():String
		{
			return _xml;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set xml( value:String ):void
		{
			_xml=value;
		}
	}
}