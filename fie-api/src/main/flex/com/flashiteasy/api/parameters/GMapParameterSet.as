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
	import com.flashiteasy.api.core.elements.IGMapElementDescriptor;
	import com.google.maps.Map;

	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>GMapParameterSet</strong></code> is the parameterSet
	 * that handles GoogleMap objects.
	 */
	public class GMapParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var _addressToGeocode : String = "85 rue du dessous des berges 75013 Paris";
		private var _apiKey : String ="ABQIAAAAy3tASEO6k5qZw4DJYTm4vBTb-vLQlFZmc2N8bgWI8YDPp5FEVBQcD36n9uU2NMHVYvAe1N7vRaBiCg";
		
		private var _initialZoom : Number = 17;
		
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IGMapElementDescriptor )
			{
				if (addressToGeocode == "")
					addressToGeocode = "85 rue du dessous des berges 75013 Paris";
				IGMapElementDescriptor( target ).setApiKey( apiKey );
				IGMapElementDescriptor( target ).setInitialZoom(_initialZoom);
				IGMapElementDescriptor( target ).setAddressToGeocode( addressToGeocode );
				IGMapElementDescriptor( target ).setMapType(mapType);
				IGMapElementDescriptor( target ).initGMap();
			}
		}
		
		[Parameter(type="String", defaultValue="ABQIAAAAy3tASEO6k5qZw4DJYTm4vBTb-vLQlFZmc2N8bgWI8YDPp5FEVBQcD36n9uU2NMHVYvAe1N7vRaBiCg", row="0", sequence="0", label="APIKey", groupName="GMap")]
		/**
		 * 
		 * @return 
		 */
		public function get apiKey():String{
			return _apiKey;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set apiKey( value:String ):void{
			_apiKey=value;
		}
		
		[Parameter(type="String", defaultValue="85 rue du dessous des berges 75013 Paris FR", row="1", sequence="1", label="Address", groupName="GMap")]
		/**
		 * 
		 * @return 
		 */
		public function get addressToGeocode():String{
			return _addressToGeocode;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set addressToGeocode( value:String ):void{
			_addressToGeocode = value;
		}
		
		[Parameter(type="Number", defaultValue="17",  min="1", max="20", row="2", sequence="2", label="Zoom", groupName="GMap")]
		/**
		 * 
		 * @return 
		 */
		public function get initialZoom():Number{
			return _initialZoom;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set initialZoom( value:Number ):void{
			_initialZoom=value;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function setInitialZoom( value : Number ) : void
		{
			initialZoom = value;
		}
		
		
		private var _mapType:String="NORMAL_MAP_TYPE";

        [Parameter(type="Combo", defaultValue="NORMAL_MAP_TYPE",row="2", sequence="3", label="Type", groupName="GMap")]
		/**
		 * Sets the map type 
		 */
		public function get mapType() : String
		{
			return _mapType;
		}

		/**
		 * 
		 * @private
		 */
		public function set mapType(value:String):void{
			_mapType=value; 
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			//var mapTypeArray : Array = [ MapType.PHYSICAL_MAP_TYPE, MapType.NORMAL_MAP_TYPE, MapType.SATELLITE_MAP_TYPE, MapType.HYBRID_MAP_TYPE ];
			
			return ["NORMAL_MAP_TYPE", "SATELLITE_MAP_TYPE", "HYBRID_MAP_TYPE", "PHYSICAL_MAP_TYPE"];
		}
		
		
	}
}