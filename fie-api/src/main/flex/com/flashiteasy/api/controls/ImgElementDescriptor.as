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
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;
	import com.flashiteasy.api.core.elements.IColorMatrixElementDescriptor;
	import com.flashiteasy.api.core.elements.IImgElementDescriptor;
	import com.flashiteasy.api.core.elements.IResizableElementDescriptor;
	import com.flashiteasy.api.core.elements.ISizableElementDescriptor;
	import com.flashiteasy.api.core.elements.ISmoothElementDescriptor;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 *
	 * Descriptor class for the <strong>Image Control</strong>.
	 * Sets the source of the image, its background color, its resize mode and its smoothing.
	 */
	public class ImgElementDescriptor extends SimpleUIElementDescriptor implements  IImgElementDescriptor, IResizableElementDescriptor, ISizableElementDescriptor, ISmoothElementDescriptor
	{
		protected var _mode:String;

		// === Variables pour le chargement de l image

		protected var img:Loader;

		// ==== parameters

		protected var isResizable:Boolean;
		protected var loaded:Boolean=false;
		protected var smooth:Boolean;
		protected var source:String;
		protected var tempImg:Loader;
		private var actualLoader:Loader;
		private var paddingBottom:Number;
		private var paddingLeft:Number;
		private var paddingRight:Number;

		// ==== Variable padding ==========

		private var paddingTop:Number;

		// === Fonctions specifiques aux images 

		/**
		 * Changes the image source
		 * @param URL
		 */
		public function changeImage(URL:String):void
		{
			removeBitmap();
			removeImage();
			setImage(URL);
		}

		// === Fonctions generiques aux controls ====

		override public function destroy():void
		{
			removeImage();
			img=null;
			tempImg=null;
			actualLoader=null;
			super.destroy();
		}

		override public function getContent():Array
		{
			var ar:Array=new Array();
			ar.push(source);
			return ar;
		}

		//===============================

		override public function getDescriptorType():Class
		{
			return ImgElementDescriptor;
		}


		/**
		 *
		 * @return a boolean stating if the control is empty or not
		 */
		public function hasImage():Boolean
		{
			if (source == null)
				return false;
			return true;
		}

		/**
		 *
		 * @return a boolean stating the validity of the image
		 */
		public function isValid():Boolean
		{
			return loaded;
		}

		override public function remove(e:Event):void
		{
			super.remove(e);
			removeImage();
		}

		/**
		 * Removes the image from the control
		 */
		public function removeImage():void
		{
			if (source != null)
			{
				loaded=false;
				img.unload();
				tempImg.unload();
				tempImg.contentLoaderInfo.removeEventListener(Event.COMPLETE, init, false);
				tempImg.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageError, false);
				img.contentLoaderInfo.removeEventListener(Event.COMPLETE, init, false);
				img.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageError, false);
				source=null;
				if (img.parent != null)
				{
					face.removeChild(img);
				}
				if (tempImg.parent != null)
				{
					face.removeChild(tempImg);
				}
			}
		}


		override public function setContent(a:Array):void
		{
			source=a.pop();
			changeImage(source);
		}


		/**
		 * Sets the source of the image control.
		 * @param source url string.
		 */
		public function setImage(source:String):void
		{
			if (source != null && this.source != source)
			{
				if (loaded)
				{
					if (actualLoader == img)
					{
						actualLoader=tempImg;
					}
					else
					{
						actualLoader=img;
					}
				}
				loaded=false;
				this.source=source;

				var toAdd:String=AbstractBootstrap.getInstance().getBaseUrl() + "/";
				var ul:URLRequest=new URLRequest();
				if (this.source.indexOf("http") != -1)
				{
					var vars:URLVariables=new URLVariables;
					toAdd+="php/proxy.php";
					vars["proxy"]=this.source;
					ul.data=vars;
					ul.url=toAdd;
					ul.method="POST";
				}
				else
				{
					ul.url=toAdd + this.source;
				}
				actualLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, init, false);
				actualLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, init, false, 0, true);
				actualLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageError, false);
				actualLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageError, false, 0, true);
				actualLoader.load(ul);
			}
		}

		/**
		 * Sets the padding of the image control
		 * @param paddingLeft numeric value, 0 by default
		 * @param paddingRight numeric value, 0 by default
		 * @param paddingTop numeric value, 0 by default
		 * @param paddingBottom numeric value, 0 by default
		 */
		public function setPadding(paddingLeft:Number, paddingRight:Number, paddingTop:Number, paddingBottom:Number):void
		{
			this.paddingLeft=paddingLeft;
			this.paddingRight=paddingRight;
			this.paddingBottom=paddingBottom;
			this.paddingTop=paddingTop;
		}

		/**
		 * States if the image must be resized or not, and if yes which size mode is used (normal, fit, scale)
		 * @param resize
		 * @param mode
		 */
		public function setResize(resize:Boolean, mode:String):void
		{
			isResizable=resize;
			_mode=mode;
		}

		/**
		 * Sets the image smoothing
		 * @param value
		 */
		public function setSmooth(value:Boolean):void
		{
			smooth=value;

		}

		// ======== Fonctions complete =========

		override protected function drawContent():void
		{
			if (source == null || source == "")
			{
				//trace ("ending in draw content for img control " + this.uuid);
				end();
			}
			else
			{
				if (isResizable && loaded && actualLoader.contentLoaderInfo.bytesLoaded > 0)
				{
					var ratioW:Number=Math.abs(width) / actualLoader.contentLoaderInfo.width;
					var ratioH:Number=Math.abs(height) / actualLoader.contentLoaderInfo.height;
					var ratioMin:Number=Math.min(ratioH, ratioW);
					var ratioMax:Number=Math.max(ratioH, ratioW);

					if (_mode == "scale")
					{
						actualLoader.content.scaleX=ratioMin;
						actualLoader.content.scaleY=ratioMin;

					}
					else if (_mode == "fit")
					{
						actualLoader.content.scaleX=ratioW;
						actualLoader.content.scaleY=ratioH;
					}
					else
					{

						actualLoader.content.scaleX=1;
						actualLoader.content.scaleY=1;
					}
					actualLoader.content.scaleX=width < 0 ? -Math.abs(actualLoader.content.scaleX) : Math.abs(actualLoader.content.scaleX);
					actualLoader.content.scaleY=height < 0 ? -Math.abs(actualLoader.content.scaleY) : Math.abs(actualLoader.content.scaleY);

					if (actualLoader.content is Bitmap)
					{
						Bitmap(actualLoader.content).smoothing=smooth;
					}

					if (actualLoader == img)
					{
						if (tempImg.parent != null)
						{

							tempImg.unload();
							tempImg.contentLoaderInfo.removeEventListener(Event.COMPLETE, init, false);
							tempImg.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageError, false);
							face.removeChild(tempImg);
						}
					}
					else
					{
						if (img.parent != null)
						{

							img.unload();
							img.contentLoaderInfo.removeEventListener(Event.COMPLETE, init, false);
							img.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imageError, false);
							face.removeChild(img);
						}
					}
				}

			}
		}

		override protected function end():void
		{
			super.end();
			drawBorder();
		}

		protected function imageError(e:IOErrorEvent):void
		{
			trace("error loading... " + e.currentTarget + " uuid :: " + this.uuid + " src :: " + this.source);
			removeImage();
			end();
		}

		protected function init(e:Event):void
		{

			if (actualLoader.parent == null)
			{
				face.addChild(actualLoader);
			}
			loaded=true;
			drawContent();
			end();
		}


		override protected function initControl():void
		{
			img=new Loader();
			tempImg=new Loader();
			actualLoader=img;
		}

		override protected function onSizeChanged():void
		{
			drawContent();
		}
	}
}