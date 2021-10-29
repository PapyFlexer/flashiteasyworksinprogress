package com.flashiteasy.api.utils
{
	import flash.display.InteractiveObject;
	import flash.display.LoaderInfo;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	public class ClickTagger 
	{
		
		/**
		* Exemple 
		* 
		* var fallback1:String = "http://www.flashiteasy.com";
		* var fallback2:String = "http://www.tartempion.com";
		* var fallback3:String = "http://www.adobe.com";
		*  
		* var clickTagger:ClickTagger = new ClickTagger(stage.loaderInfo);
		* clickTagger.assignClickTag(button1,fallback1,1);
		* clickTagger.assignClickTag(button2,fallback2,2);
		* clickTagger.assignClickTag(button3,fallback3,3);
		*
		**/
		
		
		private var _clickTags:Array = new Array(); 
		private var _clickObjects:Array = new Array(); 
		private var _targetWindow:String = "_blank";
		private var _tagName:String = "clicktag";
		// check for local testing
		private var _playerType:String = Capabilities.playerType.toLowerCase(); 
		private var _extInterfaceAvailable:Boolean = false; 
		// true if in browser AND ExternalInterface.available
		private var _securePattern:RegExp = new RegExp("^http[s]?\:\\/\\/([^\\/]+)"); // RegExp for security check on clicktag url
		
		public function ClickTagger( loaderinfo:LoaderInfo )
		{
			for each (var p : String in loaderinfo.parameters )
			{
				// solve for case sensitivity (clickTag, ClickTag, clickTAG, etc)
				if ( p.toLowerCase().indexOf(_tagName) == 0 ) 
				{
					var tagPosition:int = 0;
					if ( p.length > _tagName.length )
					{
						tagPosition = int( p.substr( _tagName.length ) ) - 1;
					}
					_clickTags.push( {tagIndex:tagPosition, tagUrl:loaderinfo.parameters[p]} ); 
				}
			}
			_clickTags.sortOn("tagIndex", Array.NUMERIC);
		}
		
		public function assignClickTag( element : InteractiveObject, failSafeUrl : String, tagNumber : int=1 ) : void
		{
			tagNumber = tagNumber < 0 ? 0 : tagNumber - 1;
			element.addEventListener( MouseEvent.CLICK, clickOut, false, 0, true);
			_clickObjects.push( {clickElement : element, fallBack:failSafeUrl, tagIndex:tagNumber} );
		}

		private function clickOut( e : MouseEvent ) : void
		{
			var clickedIndex : int;
			var destination : String;
			
			for each ( var obj:Object in _clickObjects )
			{
				if ( e.target == _clickObjects[obj].clickElement )
				{
					clickedIndex = _clickObjects[obj].tagIndex;
					destination = _clickObjects[obj].fallBack;
					break;
				}
			}
			
			if (_playerType=="activex" || _playerType=="plugin")
			{
				if (_clickTags[clickedIndex])
				{
					if (secureTag(_clickTags[clickedIndex].tagUrl))
					{
						destination = _clickTags[clickedIndex].tagUrl;
					}
				}
				_extInterfaceAvailable = ExternalInterface.available;
			}
			
			if (_extInterfaceAvailable) 
			{
				ExternalInterface.call('window.open',destination,targetWindow);
			}
			else
			{
				navigateToURL(new URLRequest(destination),targetWindow);
			}
		}
		
		private function secureTag(targetURL:String):Boolean 
		{
			var resultObj:Object = _securePattern.exec(targetURL);
			if (resultObj == null || targetURL.length >= 4096) 
			{
				return false;
			}
			return true;
		}
		
		public function get targetWindow():String
		{
			return _targetWindow;
		}
		
		
		public function set targetWindow(value:String) : void
		{
			_targetWindow = value;
		}
	}
	
}