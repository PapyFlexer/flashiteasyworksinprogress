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
	import com.flashiteasy.api.core.elements.IGMapElementDescriptor;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapType;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.overlays.Marker;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.GeocodingEvent;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;


	/**
	 *
	 * @author gillesroquefeuil
	 */
	public class GMapElementDescriptor extends ImgElementDescriptor implements IGMapElementDescriptor

	{
		private var _addressToGeocode:String;

		private var _apiKey:String;

		private var _map:Map;

		private var _mapType:String;

		private var _initialZoom:Number;
		//private const fieApiKey : String = "ABQIAAAAy3tASEO6k5qZw4DJYTm4vBRU-TjujaJdhVMC45Eoo5UQhblDPBQ_KNublXP_sDk0zzgi48Ty6BkBcA";

		private const localApiKey:String="ABQIAAAAy3tASEO6k5qZw4DJYTm4vBTb-vLQlFZmc2N8bgWI8YDPp5FEVBQcD36n9uU2NMHVYvAe1N7vRaBiCg";


		/**
		 *
		 * @return
		 */
		public function get addressToGeocode():String
		{
			return _addressToGeocode;
		}

		/**
		 *
		 * @return
		 */
		public function get apiKey():String
		{
			return _apiKey;
		}

		override public function getDescriptorType():Class
		{
			return GMapElementDescriptor;
		}


		/**
		 *
		 * @return
		 */
		public function get map():Map
		{
			return _map;
		}

		/**
		 *
		 * @private
		 */
		public function set map(value:Map):void
		{
			_map=value;
		}

		/**
		 *
		 * @return
		 */
		public function get initialZoom():Number
		{
			return _initialZoom;
		}

		/**
		 *
		 * @private
		 */
		public function set initialZoom(value:Number):void
		{
			_initialZoom=value;
		}

		/**
		 *
		 * @return
		 */
		public function get mapType():String
		{
			return _mapType;
		}

		/**
		 *
		 * @private
		 */
		public function set mapType(value:String):void
		{
			_mapType=value;
		}

		/**
		 *
		 * @param value
		 */
		public function setAddressToGeocode(value:String):void
		{
			_addressToGeocode=value;
			if (map != null)
				doGeocode();
		}

		/**
		 *
		 * @param value
		 */
		public function setApiKey(value:String):void
		{
			_apiKey=value;
		}

		/**
		 *
		 * @param value
		 */
		public function setInitialZoom(value:Number):void
		{
			_initialZoom=value;
		}

		/**
		 *
		 * @param value
		 */
		public function setMapType(value:String):void
		{
			_mapType=value;
		}
		
		
		private var mapClip:DisplayObject=null;

		/**
		 *
		 */
		public function initGMap():void
		{
			if (mapClip != null)
			{
				map.removeEventListener(MapEvent.MAP_READY, this.onGMapReady);
				face.removeChild(mapClip);
				mapClip=null;
				map=null;
			}
			map=new Map();
			map.sensor="false";
			map.key=_apiKey == null ? "ABQIAAAAy3tASEO6k5qZw4DJYTm4vBTb-vLQlFZmc2N8bgWI8YDPp5FEVBQcD36n9uU2NMHVYvAe1N7vRaBiCg" : _apiKey;
			_addressToGeocode=_addressToGeocode == null ? "85 rue du dessous des berges 75013 Paris FR" : _addressToGeocode;
			initialZoom=isNaN(_initialZoom) ? 15 : initialZoom;
			map.addEventListener(MapEvent.MAP_READY, this.onGMapReady);
			mapClip=face.addChild(map);
			end();
			//
		}

		/**
		 * @inherit doc
		 */
		override protected function onSizeChanged():void
		{
			drawContent();
		}

		/**
		 * @inherit doc
		 */
		override protected function drawContent():void
		{
			if (map == null || !face.contains(map))
			{
				//trace ("ending in draw content for img control " + this.uuid);
				end();
			}
			else
			{
				//map.setZoom( initialZoom || 100, false);	
				map.setSize(new Point(face.width, face.height));
					//end();
			}
		}

		/**
		 *
		 * @private
		 */
		private function doGeocode():void
		{
			trace("geocodin...")
			var geocoder:ClientGeocoder=new ClientGeocoder();
			geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, function(event:GeocodingEvent):void
				{
					var placemarks:Array=event.response.placemarks;
					if (placemarks.length > 0)
					{
						map.setCenter(placemarks[0].point);
						var marker:Marker=new Marker(placemarks[0].point);
						marker.addEventListener(MapMouseEvent.CLICK, function(event:MapMouseEvent):void
							{
								marker.openInfoWindow(new InfoWindowOptions({content: placemarks[0].address}));
							});
						map.addOverlay(marker);
					}
				});
			geocoder.addEventListener(GeocodingEvent.GEOCODING_FAILURE, function(event:GeocodingEvent):void
				{
					trace(event);
					trace(event.status);
				});
			geocoder.geocode(addressToGeocode);
			drawContent();
		}


		/**
		 *
		 * @private
		 */
		private function onGMapReady(event:Event):void
		{
			trace("onGMapRedy invoked")

			map.removeEventListener(MapEvent.MAP_READY, this.onGMapReady);
			map.setSize(new Point(face.width, face.height));
			map.enableScrollWheelZoom();
			map.enableContinuousZoom();
			map.addControl(new ZoomControl());
			map.addControl(new MapTypeControl);
			//var mapTypeArray : Array = [ MapType.PHYSICAL_MAP_TYPE, MapType.NORMAL_MAP_TYPE, MapType.SATELLITE_MAP_TYPE, MapType.HYBRID_MAP_TYPE ];
			var arrayType:Array=map.getMapTypes();
			map.setMapType(IMapType(MapType[_mapType])); //arrayType[getMapTypeIndex(arrayType)]));
			map.setZoom(initialZoom, false);
			doGeocode()
			//face.addChild(map);

			//end();


		}

		private function getMapTypeIndex(mapType:Array):int
		{
			for (var i:uint=0; i < mapType.length; i++)
			{
				if (_mapType == IMapType(mapType[i]).getName())
				{
					return i;
				}
			}
			return 0;
		}


		// === Fonctions generiques aux controls ====

		override public function destroy():void
		{
			map.removeEventListener(MapEvent.MAP_READY, this.onGMapReady);
			if (mapClip != null)
				face.removeChild(mapClip);
			mapClip=null;
			map=null;
			super.destroy();
		}
	}
}