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
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;
	import com.flashiteasy.api.core.elements.IPaddingElementDescriptor;
	import com.flashiteasy.api.core.elements.ITextElementDescriptor;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;


	/**
	 * Descriptor class for the <code><strong>Text</strong></code> element.
	 */

	public class TextElementDescriptor extends SimpleUIElementDescriptor implements IBackgroundColorableElementDescriptor, ITextElementDescriptor, IPaddingElementDescriptor
	{

		private var tf:TextField;
		private var text:String;
		private var textWidth:Number;
		private var textHeight:Number;

		// ===== Options texte =======

		private var wordWrap:Boolean=false;
		private var police:String="Arial";
		private var textSize:int;

		// ==== Variable padding ==========

		private var paddingTop:Number;
		private var paddingRight:Number;
		private var paddingLeft:Number;
		private var paddingBottom:Number;
		private var _defaultTextFormat:TextFormat = new TextFormat("_Arial",12,"0x000000");


		protected override function initControl():void{
			tf=new TextField();
			face.addChild(tf);
		}
		
		public function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}
		// =========== Parameter set ========================
		
		/**
		 * Initializes the text parameters : the string and the format applied to it
		 * @param text
		 * @param format
		 */
		public function initText( text : String , format : TextFormat ) : void 
		{
			tf.visible = false;
			if(format == null ) 
			{
				tf.embedFonts = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.setTextFormat(defaultTextFormat);
				//tf.setTextFormat(new TextFormat("_Arial",12,"0x000000"));
				tf.defaultTextFormat= defaultTextFormat;
				//var b : Boolean = 
			//	tf.setTextFormat(new TextFormat());
				tf.htmlText = text ;
				
				//trace( " setting text with no format " + text );
			}	
			else
			{
				//trace( " setting text with format " + text );
				tf.embedFonts = true;
				tf.htmlText = text ;
				tf.setTextFormat(format ) ;
				tf.antiAliasType = format.size>48 ? AntiAliasType.NORMAL : AntiAliasType.ADVANCED;
			}
		}

		/**
		 * Sets the autosize of the text element.
		 * @param autoSize a string depicting the autosize mode
		 */
		public function setAutoSize(autoSize:String):void
		{
			tf.autoSize=autoSize;
		}

		/**
		 * Sets the border of the text element with a contant thickness of 1 pixel.
		 * @param border a boolean that states if the border must be rendered
		 * @param borderColor the numric color value of the text element border, 0xRRGGBB
		 */
		public function setTextBorder(border:Boolean, borderColor:Number):void
		{
			tf.border=border;
			tf.borderColor=borderColor;
		}

		/**
		 * Sets text element option : multilines and wordwrap
		 * @param multiLines a boolean that activates the multiline text element option
		 * @param wordWrap a boolean that activates the wordwrap text element option
		 */
		public function setOptions(multiLines:Boolean, wordWrap:Boolean, selectable:Boolean):void
		{
			tf.selectable=selectable;
			tf.mouseEnabled=selectable;
			tf.multiline=multiLines;
			tf.wordWrap=wordWrap;
			this.wordWrap=wordWrap;
		}

		/**
		 * Sets the padding of the element
		 * @param paddingLeft
		 * @param paddingRight
		 * @param paddingTop
		 * @param paddingBottom
		 */
		public function setPadding(paddingLeft:Number, paddingRight:Number, paddingTop:Number, paddingBottom:Number):void
		{
			this.paddingLeft=paddingLeft;
			this.paddingRight=paddingRight;
			this.paddingBottom=paddingBottom;
			this.paddingTop=paddingTop;
		}

		//=========== Complete ==================


		/**
		 * @inheritDoc
		 */

		protected override function onSizeChanged():void
		{
			textWidth=tf.width;
			textHeight=tf.height;
			tf.scaleX= width<0 ?-Math.abs(tf.scaleX) : Math.abs(tf.scaleX);
			tf.scaleY= height<0 ?-Math.abs(tf.scaleY) : Math.abs(tf.scaleY);
			tf.width=Math.abs(width);
			tf.height=Math.abs(height);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function drawContent():void
		{
			//trace ("ending in draw content for text control " + this.uuid);
			tf.visible = true;
			startAnimation();
			end();
		}

		private function startAnimation():void
		{
			//
		}


		/**
		 * applies the padding
		 */
		public function applyPadding():void
		{

			// Padding Left
			if (tf.x >= 0 && tf.x < paddingLeft)
			{
				tf.x=paddingLeft;
			}

			// TextField deborde a gauche 
			if (tf.x < 0)
			{
				var tmp:Number=Math.abs(tf.x) + paddingLeft;
				// calcul du debordement
				//getFace().width+=tmp; // agrandissement de la face
				width+=tmp;

				//getFace().x-=tmp;
				tf.x=paddingLeft;
				setPosition( (getFace().x - tmp),  getFace().y, _isPercentX, _isPercentY);
				applyPosition();
			}
			if (tf.y >= 0 && tf.y < paddingTop)
			{
				tf.y=paddingTop;
			}
			if (textHeight > Math.abs(height))
			{
				//getFace().height=textHeight + paddingBottom + paddingTop;
				height=textHeight + paddingBottom + paddingTop;
				getFace().height=height;
			}
			//if((width + paddingLeft + paddingRight)<textWidth){
			if (textWidth > Math.abs(width))
			{

				//getFace().width=tf.width + paddingLeft + paddingRight;
				width=textWidth + paddingLeft + paddingRight;
				getFace().width=width;
			}
			setActualSize( width, height, _isPercentW, _isPercentH);
			applySize();
		}



		// ===== Fonctions generiques aux controls

		override public function getDescriptorType():Class
		{
			return TextElementDescriptor;
		}

		override public function setContent(a:Array):void
		{
			text=a.pop();
			tf.text=text;
		}

		override public function getContent():Array
		{
			var ar:Array=new Array();
			ar.push(text);
			return ar;
		}

		override public function destroy():void
		{
			if(face!=null)
			{
				if (face.numChildren != 0)
					face.removeChild(tf);
				tf=null;
			}
			super.destroy();
		}
	}
}


