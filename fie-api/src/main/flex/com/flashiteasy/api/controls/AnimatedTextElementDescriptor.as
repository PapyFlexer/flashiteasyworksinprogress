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
	import com.caurina.transitions.Tweener;
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;
	import com.flashiteasy.api.core.elements.IPaddingElementDescriptor;
	import com.flashiteasy.api.core.elements.ITextElementDescriptor;
	import com.flupie.textanim.TextAnim;
	import com.flupie.textanim.TextAnimBlock;
	import com.flupie.textanim.TextAnimMode;
	import com.flupie.textanim.TextAnimSplit;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;


	/**
	 * Descriptor class for the <code><strong>Text</strong></code> element.
	 */

	public class AnimatedTextElementDescriptor extends SimpleUIElementDescriptor implements IBackgroundColorableElementDescriptor, ITextElementDescriptor, IPaddingElementDescriptor
	{
		
		private var textAnim : TextAnim;

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
		
		private var _transitionIn : String = "zoomIn";
		private var _transitionOut : String = "zoomIn";
		private var _separationType : String = TextAnimSplit.WORDS;
		private var _iterationMode : String = TextAnimMode.FIRST_LAST;
		private var _delayBeforeStart : uint = 0;
		private var _interval : uint = 100;
		
		private var tw : Tweener
		
		private var inFx : Function = zoomIn;
		private var outFx : Function = zoomIn;
		
		private function rotate3D(block:TextAnimBlock) : void 
		{
			block.scaleX = block.scaleY = 3;	
			block.rotationY = -90;
			Tweener.addTween( block, {rotationY:0, scaleX:1, scaleY:1, time:1, transition:"easeoutquart"} );
		}

		private function fromLeft(block:TextAnimBlock) : void 
		{
			block.alpha = 0;
			block.x = block.posX + 150;
			Tweener.addTween( block, {x:block.posX, alpha:1, time:1, transition:"easeoutback"} );
		}

		private function fromRight(block:TextAnimBlock) : void 
		{
			block.alpha = 0;
			block.x = block.posX - 150;
			Tweener.addTween( block, {x:block.posX, alpha:1, time:1, transition:"easeoutback"} );
		}


		private function rotateIn(block:TextAnimBlock) : void 
		{
			block.alpha = 0;
			block.rotation = -180;
			block.scaleX = block.scaleY = 0;	
			Tweener.addTween(block, {rotation:0, scaleX:1, scaleY:1, alpha:1, time:1, transition:"easeoutback"});
		}

		private function zoomIn(block:TextAnimBlock):void 
		{
			block.scaleX = block.scaleY = 0;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:1, transition:"easeoutelastic"});
		}



		protected override function initControl():void{
			tf=new TextField();
			face.addChild(tf);
			/* textAnim = new TextAnim( tf, true );
			textAnim.split = TextAnimSplit.WORDS;
			textAnim.mode = TextAnimMode.FIRST_LAST; */
		}
		
		public function setAnimatedTextInTransition( inTransition : String ) : void
		{
			switch( inTransition)
			{
				case "zoomIn" :
				inFx = zoomIn;
				break;

				case "fromLeft" :
				inFx = fromLeft;
				break;

				case "fromRight" :
				inFx = fromRight;
				break;
				
				default :
				inFx = rotate3D;
			}
			textAnim.blocksVisible = false;
			textAnim.effects = inFx;
			trace ("affecting txtFx in");
		}
		
		public function setAnimatedTextOutTransition( inTransition : String ) : void
		{
			//	
		}

		public function setAnimatedTextSeparationType( separationType : String ) : void
		{
			textAnim.split = separationType;
		}

		public function setAnimatedTextIterationMode( iterationMode : String ):void
		{
			textAnim.mode = iterationMode;	
		}
		
		public function setAnimatedTextDelayBeforeStart( delayBeforeStart : uint ) : void
		{
			textAnim.delay = delayBeforeStart;
		}
		
		public function setAnimatedTextInterval( interval : uint ) : void
		{
			textAnim.interval = interval;
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
			//tf.visible = false;
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
		 * text animation in
		 */
		public function get transitionIn() : String
		{
			return _transitionIn;
		}
		/**
		 * 
		 * @private
		 */
		public function set transitionIn( value : String ) : void
		{
			_transitionIn = value;
		}



		/**
		 * text animation out
		 */
		public function get transitionOut() : String
		{
			return _transitionOut;
		}
		/**
		 * 
		 * @private
		 */
		public function set transitionOut( value : String ) : void
		{
			_transitionOut = value;
		}

		
		/**
		 * text separation type
		 */
		public function get separationType() : String
		{
			return _separationType;
		}


		/**
		 * 
		 * @private
		 */
		public function set separationType( value : String ) : void
		{
			_separationType = value;
		}


		/**
		 * text separation type
		 */
		public function get iterationMode() : String
		{
			return _iterationMode;
		}


		/**
		 * 
		 * @private
		 */
		public function set iterationMode( value : String ) : void
		{
			_iterationMode = value;
		}


		/**
		 * text anim delay
		 */
		public function get delayBeforeStart() : uint
		{
			return _delayBeforeStart;
		}


		/**
		 * 
		 * @private
		 */
		public function set delayBeforeStart( value : uint ) : void
		{
			_delayBeforeStart = value;
		}



		/**
		 * text anim interval
		 */
		public function get interval() : uint
		{
			return _interval;
		}


		/**
		 * 
		 * @private
		 */
		public function set interval( value : uint ) : void
		{
			_interval = value;
		}


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
/* 			textAnim.interval = interval;
			textAnim.effects = zoomIn;
			trace ( "TWEENS :: "+Tweener.getTweens(tf));
			textAnim.start(delayBeforeStart);
 */
			textAnim = new TextAnim(tf);
			textAnim.mode = TextAnimMode.CENTER_EDGES;
			textAnim.blocksVisible = false;
			textAnim.effects = myEffect;
			textAnim.start();


 			end();
		}
		public function myEffect(block:TextAnimBlock):void 
		{
			block.scaleX = block.scaleY = 0;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:1, transition:"easeoutelastic"});
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
			return AnimatedTextElementDescriptor;
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


