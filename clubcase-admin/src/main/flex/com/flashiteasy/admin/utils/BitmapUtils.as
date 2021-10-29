package com.flashiteasy.admin.utils
{
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Encoder;
	
	public class BitmapUtils
	{

		/**
		 * Static utility class that creates a jpg or png file
		 * based on the selection on stage. Returns a string based ByteArray
		 * to be passed to the FileManagerService for saving purposes
		 * 
		 * As a static class, must be implemented like this :
		 * <code>
		 * import com.flashiteasy.admin.utils.BitmapUtils;
		 * BitmapUtils.generateBitmap( bloc, type);
		 * </code>
		 * @param bloc :  the selected control on stage that the bitmap will uses as template
		 * @param type :  the string stating if the bitmap must be encoded as png or jpg
		 * @return 		  the ByteArray flushed as a String
		 */

			public static function generateBitmap( bloc : Sprite, type : String="png" ) : String
			{
				
				var jpgEnc : JPEGEncoder = new JPEGEncoder;

				var pngEnc : PNGEncoder = new PNGEncoder;

				var backGroundColor : int = type == "png" ? 0x00000000 : 0xFFFFFFFF
				var bmp : BitmapData = new BitmapData( bloc.width, bloc.height, true, backGroundColor);
				bmp.draw( bloc , null, null, null, null, true);
				var ba:ByteArray = type == "png" ? pngEnc.encode(bmp) : jpgEnc.encode(bmp);
				var be:Base64Encoder=new Base64Encoder;
				be.encodeBytes(ba);
				var encodedData:String=be.flush();
				return encodedData;
				
			}
			
			
			public static function generateBitmapFromLoader( bloc : Loader, type : String="png" ) : String
			{
				var image:DisplayObject = bloc.content;
				var backGroundColor : int = type == "png" ? 0x00000000 : 0xFFFFFFFF
				var bmp:BitmapData = new BitmapData(image.width, image.height, true, backGroundColor);
				bmp.draw(image, null, null, null, null, true);
				
				
				var jpgEnc : JPEGEncoder = new JPEGEncoder;

				var pngEnc : PNGEncoder = new PNGEncoder;
				var ba:ByteArray = type == "png" ? pngEnc.encode(bmp) : jpgEnc.encode(bmp);
				var be:Base64Encoder=new Base64Encoder;
				be.encodeBytes(ba);
				var encodedData:String=be.flush();
				return encodedData;
				
			}

			public static function generateThumbnail( bloc : Sprite ) : String
			{
				
				var jpgEnc : JPEGEncoder = new JPEGEncoder;
				var backGroundColor : int = 0xFFFFFFFF ;
				trace ("thumb : width orig = "+bloc.width+", height orig="+bloc.height);
				var source : BitmapData = new BitmapData(bloc.width, bloc.height, false, backGroundColor);
				source.draw(bloc);
				var bmp : Bitmap = createThumb(source, 200, 200,  "C", true);
				var bmpdt : BitmapData = new BitmapData(200,200,true, 0xFFFFFFFF);
				bmpdt.draw( bmp , null, null, null, null, true);
				var ba:ByteArray = jpgEnc.encode(bmpdt);
				var be:Base64Encoder=new Base64Encoder;
				be.encodeBytes(ba);
				var encodedData:String=be.flush();
				
				trace ("saving thumbnail as bytecode : \n"+encodedData);
				return encodedData;
				
			}
			
		
		/**
		 * Fits a DisplayObject into a rectangular area with several options for scale 
		 * and alignment. This method will return the Matrix required to duplicate the 
		 * transformation and can optionally apply this matrix to the DisplayObject.
		 * 
		 * @param displayObject
		 * 
		 * The DisplayObject that needs to be fitted into the Rectangle.
		 * 
		 * @param rectangle
		 * 
		 * A Rectangle object representing the space which the DisplayObject should fit into.
		 * 
		 * @param fillRect
		 * 
		 * Whether the DisplayObject should fill the entire Rectangle or just fit within it. 
		 * If true, the DisplayObject will be cropped if its aspect ratio differs to that of 
		 * the target Rectangle.
		 * 
		 * @param align
		 * 
		 * The alignment of the DisplayObject within the target Rectangle. Use a constant from 
		 * the DisplayUtils class.
		 * 
		 * @param applyTransform
		 * 
		 * Whether to apply the generated transformation matrix to the DisplayObject. By setting this 
		 * to false you can leave the DisplayObject as it is but store the returned Matrix for to use 
		 * either with a DisplayObject's transform property or with, for example, BitmapData.draw()
		 */

		public static function fitIntoRect(displayObject : DisplayObject, rectangle : Rectangle, fillRect : Boolean = true, align : String = "C", applyTransform : Boolean = true) : Matrix
		{
			var matrix : Matrix = new Matrix();
			
			var wD : Number = displayObject.width / displayObject.scaleX;
			var hD : Number = displayObject.height / displayObject.scaleY;
			
			var wR : Number = rectangle.width;
			var hR : Number = rectangle.height;
			
			var sX : Number = wR / wD;
			var sY : Number = hR / hD;
			
			var rD : Number = wD / hD;
			var rR : Number = wR / hR;
			
			var sH : Number = fillRect ? sY : sX;
			var sV : Number = fillRect ? sX : sY;
			
			var s : Number = rD >= rR ? sH : sV;
			var w : Number = wD * s;
			var h : Number = hD * s;
			
			var tX : Number = 0.0;
			var tY : Number = 0.0;
			
			switch(align)
			{
				case AlignmentUtils.LEFT :
				case AlignmentUtils.TOP_LEFT :
				case AlignmentUtils.BOTTOM_LEFT :
					tX = 0.0;
					break;
					
				case AlignmentUtils.RIGHT :
				case AlignmentUtils.TOP_RIGHT :
				case AlignmentUtils.BOTTOM_RIGHT :
					tX = w - wR;
					break;
					
				default : 					
					tX = 0.5 * (w - wR);
			}
			
			switch(align)
			{
				case AlignmentUtils.TOP :
				case AlignmentUtils.TOP_LEFT :
				case AlignmentUtils.TOP_RIGHT :
					tY = 0.0;
					break;
					
				case AlignmentUtils.BOTTOM :
				case AlignmentUtils.BOTTOM_LEFT :
				case AlignmentUtils.BOTTOM_RIGHT :
					tY = h - hR;
					break;
					
				default : 					
					tY = 0.5 * (h - hR);
			}
			
			matrix.scale(s, s);
			matrix.translate(rectangle.left - tX, rectangle.top - tY);
			
			if(applyTransform)
			{
				displayObject.transform.matrix = matrix;
			}
			
			return matrix;
		}

		/**
		 * Creates a thumbnail of a BitmapData. The thumbnail can be any size as 
		 * the copied image will be scaled proportionally and cropped if necessary 
		 * to fit into the thumbnail area. If the image needs to be cropped in order 
		 * to fit the thumbnail area, the AlignmentUtils of the crop can be specified
		 * 
		 * @param image
		 * 
		 * The source image for which a thumbnail should be created. The source 
		 * will not be modified
		 * 
		 * @param width
		 * 
		 * The width of the thumbnail
		 * 
		 * @param height
		 * 
		 * The height of the thumbnail
		 * 
		 * @param align
		 * 
		 * If the thumbnail has a different aspect ratio to the source image, although 
		 * the image will be scaled to fit along one axis it will be necessary to crop 
		 * the image. Use this parameter to specify how the copied and scaled image should 
		 * be aligned within the thumbnail boundaries. Use a constant from the Alignment 
		 * enumeration class
		 * 
		 * @param smooth
		 * 
		 * Whether to apply bitmap smoothing to the thumbnail
		 */

		public static function createThumb(image : BitmapData, width : int, height : int, align : String = "C", smooth : Boolean = true) : Bitmap
		{
			var source : Bitmap = new Bitmap(image);
			var thumbnail : BitmapData = new BitmapData(width, height, false, 0x0);
			
			thumbnail.draw(image, fitIntoRect(source, thumbnail.rect, false, align, false), null, null, null, smooth);
			source = null;
			
			return new Bitmap(thumbnail, PixelSnapping.AUTO, smooth);
		}

		public static function getBiggestContainer( page : Page ) : IUIElementDescriptor
		{
			var elements:Array=ElementList.getInstance().getTopLevelElements(page);
			var control : IUIElementDescriptor;
			var maxArea : Number = 0;
			for each (var element:IUIElementDescriptor in elements)
			{
				if (element.width*element.height > maxArea)
				{
					maxArea = element.width*element.height;
					control = element
				}
				
			}
			trace ("biggest is :: "+control.uuid);
			return control;
		}
		
	}
}