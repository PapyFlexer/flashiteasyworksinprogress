package com.flashiteasy.admin.customLoader
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	public class ProgressBar extends Loader
	{
		// Logo picture
		[Embed(source="../../../../../resources/assets/newlogoIco.png")]
		[Bindable]
		private var logoClass: Class;		
		private var Logo: Bitmap;
		
		private var m_Ready: Boolean;
		private var m_Progress: Number;
		private var m_BitmapData: BitmapData;

		private static var PictureWidth: int = 128;  // Logo picture width
		private static var PictureHeight: int = 128; // Logo picture height
		private static var LeftMargin: int = 1;      // Left Margin
		private static var RightMargin: int = 1;     // Right Margin
		private static var TopMargin: int = 1;       // Top Margin
		private static var BottomMargin: int = 1;    // Bottom Margin
		private static var Spacing: int = 0;       	 // Spacing between logo and progress bar
		private static var ProgressHeight: int = 14; // Progress bar height
		private static var ProgressWidth: int = 200; // Progress bar width
		
		private static var ProgressBarBackground: uint = 0xDEDEDE;
		private static var progressBarOuterBorder: uint = 0x323232;
		private static var ProgressBarColor: uint = 0xBBBBBB;
		private static var ProgressBarInnerColor: uint = 0xFFFFFF;
		
		public function ProgressBar(): void{
			super();
			m_Progress = 0;
			Logo = new logoClass as Bitmap;
			this.addEventListener(Event.RENDER, renderEventHandler);
		}
		private function renderEventHandler(event: Event): void{
			
		}
		public function refreshProgressBar(): void{			
			m_BitmapData = drawProgress(); // Create the bitmapdata object
			var encoder: PNGEncoder = new PNGEncoder();
			var byteArray: ByteArray = encoder.encode(m_BitmapData); // Encode the bitmapdata to a bytearray
			this.loadBytes(byteArray); // Draw the bitmap on the loader object
		}		
		public function getWidth(): Number{
			return LeftMargin + PictureWidth + Spacing + ProgressWidth + RightMargin;
		}
		public function getHeight(): Number{
			return TopMargin + PictureHeight + BottomMargin;
		}
		private function drawProgress(): BitmapData{
			// Create the bitmap class object
			var bitmapData: BitmapData = new BitmapData(getWidth(), getHeight(), true, 0);
			
			// Draw the Progress Bar
			var sprite: Sprite = new Sprite();
			var graph: Graphics = sprite.graphics;
			
			// Draw the progress bar background
			graph.beginFill(ProgressBarBackground);
			graph.lineStyle(1, progressBarOuterBorder, 1, true);
			var containerWidth: Number = ProgressWidth;
			var px: int = getWidth() - RightMargin - ProgressWidth;
			var py: int = (getHeight() - ProgressHeight) / 2;
			graph.drawRoundRect(px, py, containerWidth, ProgressHeight, 6);
			containerWidth -= 4;
			var progressWidth: Number = containerWidth * m_Progress / 100;
			graph.beginFill(ProgressBarColor);
			graph.lineStyle(1, ProgressBarInnerColor, 1, true);
			graph.drawRoundRect(px + 2, py + 2, progressWidth, ProgressHeight - 4, 6);
			
			//Construct the Text Field Object and put the progress value in it
			var format:TextFormat = new TextFormat();
			format.color = 0x666666;
			format.font = "Arial";


			var textField: TextField = new TextField();
			textField.setTextFormat(format);
			textField.htmlText = "<b>" + m_Progress.toFixed(0) + "%</b>";
			//Create a BitmapData object and take the Width and height of the TextField text.
			var textBitmapData: BitmapData = new BitmapData(textField.textWidth + 5, textField.textHeight);
			//Set the BitmapData object background color to the background color of the progress bar
			textBitmapData.floodFill(0, 0, ProgressBarBackground);
			//Draw the TextFiel object in the BitmapData object
			textBitmapData.draw(textField);
			//Construct the matrix object
			//The matrix object is used to place the text			
			var textBitmapMatrix: Matrix = new Matrix();			
			textBitmapMatrix.translate(px + (containerWidth) / 2, py + (ProgressHeight - textBitmapData.height) / 2);
			
			//Draw the sprite object on the parent BitmapData
			bitmapData.draw(sprite);
			
			//Draw the text on the parent BitmapData 
			bitmapData.draw(textBitmapData, textBitmapMatrix, null, null, null, false);
			
			//Draw the Logo
			bitmapData.draw(Logo.bitmapData, null, null, null, null, true);
			return bitmapData;					
		}		
		public function set ready(value: Boolean): void{
			m_Ready = value;			
			this.visible = !value;			
		}
		public function get ready(): Boolean{
			return m_Ready;			
		}
		public function set progress(value: Number): void{
			m_Progress = value;			
		}
		public function get progress(): Number{
			return m_Progress;
		}		
	}
}