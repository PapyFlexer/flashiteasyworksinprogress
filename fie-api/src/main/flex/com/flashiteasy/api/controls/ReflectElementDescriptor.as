package com.flashiteasy.api.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class ReflectElementDescriptor extends SimpleUIElementDescriptor
	{
		public function ReflectElementDescriptor()
		{
			super();
		}

		//the BitmapData object that will hold a visual copy of the targetted sprite
		private var srcBMP:BitmapData;
		//the BitmapData object that will hold the reflected image
		private var reflectionBMP:Bitmap;
		//the clip that will act as out gradient mask
		private var gradientMask_mc:Sprite;
		//how often the reflection should update (if it is video or animated)
		private var updateInt:Number;
		//the size the reflection is allowed to reflect within
		private var bounds:Object;
		//the distance the reflection is vertically from the mc
		private var distance:Number = 0;


		
	}
}