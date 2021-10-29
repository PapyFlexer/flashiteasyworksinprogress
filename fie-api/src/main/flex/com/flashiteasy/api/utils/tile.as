﻿package com.flashiteasy.api.utils{	/**	 * Copyright(C) 2007 Schell Scivally	 *	 * Animation is an Actionscript 3 class made to address the limitations of the builtin	 * MovieClip class.	 * 	 * This file is one part of efnxAS3classes.	 * 	 * efnxAS3classes are free software; you can redistribute it and/or modify	 * it under the terms of the GNU General Public License as published by	 * the Free Software Foundation; either version 3 of the License, or	 * (at your option) any later version.	 * 	 * efnxAS3classes are distributed in the hope that it will be useful,	 * but WITHOUT ANY WARRANTY; without even the implied warranty of	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	 * GNU General Public License for more details.	 * 	 * You should get a copy of the GNU General Public License	 * at <http://www.gnu.org/licenses/>	 */	 	/////////////////////////////////////////////////////////////////////////	//	tile is a class that tiles a bitmap x by y pixels inside a sprite //	///////////////////////////////////////////////////////////////////////		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	// usage: bar:tile = new tile("pathToImageOrBitmapDataReference", initialXtileAmount:int = 0, initialYtileAmount:int = 0);  //	//		  addChild(bar);          				 ////////////////////////////////////////////////////////////////////////////	//		  bar.resize(someColumnsX, someRowsY);  //	/////////////////////////////////////////////////		import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.display.Sprite;	import flash.geom.Rectangle;	import flash.geom.Point;	import flash.display.Loader;	import flash.net.URLRequest;	import flash.events.Event;	import flash.events.IOErrorEvent;	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		/**	 * 	 * @private	 */	public class tile extends Sprite	{		public var bitmap:Bitmap = new Bitmap();		public var bitmapData:BitmapData;		public var loaded:Boolean = false;				public static var numClass:int;				private var loader:Loader = new Loader();		private var initTileDimensions:Point;		private var minimumSize:Point = new Point();		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		public function tile(object:*, initialTileX:int = 0, initialTileY:int = 0):void		{			if(object is BitmapData)			{				numClass++;				name = "tile("+numClass+")";				trace(name + "::init: " + object + " is BitmapData");				bitmapData = BitmapData(object).clone();				bitmap.bitmapData = bitmapData;				addChild(bitmap);				minimumSize.x = bitmapData.width;				minimumSize.y = bitmapData.height;				loaded = true;				resize(initialTileX, initialTileY);			}else if(object is String)			{				numClass++;				name = "tile("+numClass+")";				trace(name + "::init: " + object + " is String");				var url:URLRequest = new URLRequest(object);				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error, false, 0, true);				loader.load(url);				initTileDimensions = new Point(initialTileX, initialTileY);			}else			{				throw new Error(name + "::init: object to tile must be a string [path to image] or bitmapData.");			}					}//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		private function loadComplete(event:Event):void		{			bitmapData = Bitmap(loader.content).bitmapData.clone();			bitmap.bitmapData = bitmapData;			addChild(bitmap);			trace(name + "::loadComplete: bitmap Dimensions:" + bitmap.width, bitmap.height);			minimumSize.x = bitmap.width;			minimumSize.y = bitmap.height;			loaded = true;			resize(initTileDimensions.x, initTileDimensions.y);		}//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		private function error(IOErrorEvent:Event):void		{			throw new Error(name + "::error: Error #1: There was an error accessing the image file");		}//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		public function resize(xx:int = 0, yy:int = 0):void		{			trace(name + "::resize: init x,y: "+xx,yy );			if(!loaded) throw new Error(name + "::resize: Error #2: image is not done loading, just pass the resize value with the constructor.");			if(xx <= 0)			{				xx = minimumSize.x;			}			if(yy <= 0)			{				yy = minimumSize.y;			}			trace(name + "::resize: result x,y: "+xx,yy );						var bmd:BitmapData = bitmapData.clone();			bitmap.bitmapData = new BitmapData(xx, yy, true, 0x00000000);						for(var j:int = 0; j*bmd.height<yy; j++)			{				for(var i:int = 0; i*bmd.width<xx; i++)				{					bitmap.bitmapData.copyPixels(bmd, new Rectangle(0, 0, bmd.width, bmd.height), new Point(i*bmd.width, j*bmd.height));				}			}		}//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		public function kill():void		{			numClass--;			delete this;		}//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	}//end class}//end package
