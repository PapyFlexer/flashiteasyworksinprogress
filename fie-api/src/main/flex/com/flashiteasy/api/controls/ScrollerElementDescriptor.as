/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.elements.IScrollElementDescriptor;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	/**
	 * Descriptor class for the <code><strong>Scroller</strong></code> UI control.
	 */
	public class ScrollerElementDescriptor extends SimpleUIElementDescriptor implements IScrollElementDescriptor {

		private var scrollTarget:SimpleUIElementDescriptor;
		private var scrollTargetXPosition:Number;
		private var scrollTargetYPosition:Number;
		private var type:String="horizontal";
		
		// taille du mask du slider
		
		private var mask:Sprite=new Sprite();
		private var maskWidth:Number;
		private var maskHeight:Number;
		
		// Variable pour load les images
		
		private var imgLoaded:int=0;
		private var imgReady:Boolean=false;
		private var targetReady:Boolean=false;
		
		private var arrowImg:Loader=new Loader();
		private var arrowImg2:Loader= new Loader();
		private var thumbSprite:Sprite = new Sprite();
		private var thumbImg:Loader=new Loader();
		private var trackImg:Loader=new Loader();
		private var trackLength:Number;
		
		// limite drag
		
		private var dragBound:Rectangle;
		
		// mouvement par clic
		
		private var pas:Number;
		
		/**
		 * @inheritDoc
		 */
		protected override function initControl():void
		{
			var baseUrl : String = AbstractBootstrap.getInstance().getBaseUrl();
			var ul:URLRequest=new URLRequest( baseUrl + "media/scroll_arrow.png");
			var ul2:URLRequest=new URLRequest( baseUrl + "media/scroll_thumb.png");
			arrowImg.load(ul);
			arrowImg2.load(new URLRequest( baseUrl + "media/scroll_arrow.png"));
			thumbImg.load(ul2);
			trackImg.load(new URLRequest( baseUrl + "media/scroll_track.png"));
			arrowImg.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete,false,0,true);
			arrowImg2.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete,false,0,true);
			thumbImg.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete,false,0,true);
			trackImg.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete,false,0,true);
		}
		
		private function loadComplete(e:Event) : void {
			imgLoaded++;
			e.target.removeEventListener(Event.COMPLETE,loadComplete);
			if(imgLoaded==4){
				imgReady=true;
				if(targetReady)
					createScroll();
			}
			 
		}

		/**
		 * Sets the target (Block element on stage) the scroller is applied to.
		 * @param scrollTarget the name of the control on stage that has to be scrolled
		 * @param type
		 */
		public function setScrollTarget( scrollTarget:String , type:String ) : void {
			if(scrollTarget!=null){
				this.scrollTarget = SimpleUIElementDescriptor(ElementList.getInstance().getElement(scrollTarget,getPage()));
				this.type=type;
			}
		}

		/**
		 * Sets the mask for the scroller
		 * @param maskSize thge size of the scroller, horizontally or vertically (or both) applied.
		 */
		public function setScrollSize(maskSize:Number) : void {
			if(type=="horizontal"){
				this.maskWidth=maskSize;
			}
			else{
				this.maskHeight=maskSize;
			}
		}
		
		/**
		 * Sets the type of the scroller : horizontal, vertical, both or auto.
		 * @param type
		 */
		public function setScrollType(type:String):void{
			this.type=type;
		}
		
		// Fonctions onComplete
		/**
		 * @inheritDoc
		 */
		override protected function onComplete():void{
			
			
			if(scrollTarget!=null){

				if(scrollTarget.isLoaded()){
					targetReady=true;
					if(imgReady) 
						createScroll();
				}
				else 
				{
					scrollTarget.addEventListener(FieEvent.COMPLETE, targetComplete);
				}
			}
			else
				trace("epic fail");
			//createScroll();
			super.onComplete();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applySize() : void
		{
			super.applySize();
			
			// Dessine le decor de fond
			
			Sprite( getFace() ).graphics.clear();
			Sprite( getFace() ).graphics.lineStyle(1,0x000000);
			Sprite( getFace() ).graphics.beginFill(0xFFFFFF, 1);
			Sprite( getFace() ).graphics.drawRect( 0, 0, width, height);
			Sprite( getFace() ).graphics.endFill();
			

		}
		
		
		private function targetComplete(e:Event) : void {
			scrollTarget.removeEventListener(FieEvent.COMPLETE, targetComplete);
			targetReady=true;
			if(imgReady)
				createScroll();
		}

		private function createScroll() : void{
			
			var t:int=getTimer();
			//if(scrollTarget.height < scrollTarget.getFace().height){
			if(type=="vertical"){
				maskWidth=this.target.getFace().width;
				createVerticalScroll();
			}
			//if(scrollTarget.width<scrollTarget.getFace().width){
			if(type=="horizontal"){
				maskHeight=this.target.getFace().height;
				createHorizontalScroll();
			}
			end();
			trace("end scroll creation" + (getTimer()-t));
		}
		
		private function createVerticalScroll ():void{
			
			setActualSize(arrowImg.width, maskHeight,false,false);
			applySize();
			
			// Rotation des fleches 
			
			rotateCenter(arrowImg,180);
			
			// positionnement de la fleche droite
			
			arrowImg2.y=height-arrowImg2.height;
			
			// Creation du thumb
			
			thumbSprite.addChild(thumbImg);
			thumbSprite.y=arrowImg.height;
			thumbSprite.height=arrowImg.height;
			
			// Contour du thumb
			
			thumbSprite.graphics.clear();
			thumbSprite.graphics.lineStyle(0,0x000000);
			thumbSprite.graphics.drawRect(0, 0, thumbSprite.width,thumbSprite.height/thumbSprite.scaleY);
			thumbSprite.graphics.endFill();
			
			// Creation du track
			
			trackImg.width=arrowImg.width;
			trackImg.height=height-(arrowImg.height*2);
			trackImg.y=arrowImg.height;
			
			// Ajout des elements dans la scrollBar
			
			getFace().addChild(arrowImg);
			getFace().addChild(arrowImg2);
			getFace().addChild(thumbSprite);
			getFace().addChildAt(trackImg,0);
			
			// rectangle delimitant le drag
			
			dragBound=new Rectangle(0,arrowImg.height,0,height-(arrowImg.height*3));
			
			trackLength=height-(arrowImg.height*3);
			thumbSprite.addEventListener(MouseEvent.MOUSE_DOWN, drag,true,0,true);
			thumbSprite.addEventListener(MouseEvent.MOUSE_UP, drop,true,0,true);
			scrollTarget.getFace().mask=null;
			
			mask.x=scrollTarget.getFace().x;
			mask.y=scrollTarget.getFace().y;
			mask.graphics.clear();
			mask.graphics.beginFill(0x0000FF, 1);
			mask.graphics.drawRect(0, 0, maskWidth, maskHeight);
			mask.graphics.endFill();
			scrollTarget.getFace().mask=mask;
			
			// Met la taille de la cible a la taille du mask
			
			scrollTarget.getFace().width=maskWidth;
			scrollTarget.getFace().height=maskHeight;
			scrollTargetXPosition=scrollTarget.getFace().x;
			scrollTargetYPosition=scrollTarget.getFace().y;
			scrollTarget.hasScroll = true;
			
			// Calcul du deplacement lors des clic sur les fleches 
			
			pas=trackLength/60;
			
			// Ajout de listener 
			
			// Deplacement du mask lorsque la target bouge
			scrollTarget.getFace().addEventListener(FieEvent.MOVED, updateMask,false,0,true);
			
			// Click sur la scrollbar
			arrowImg.addEventListener(MouseEvent.MOUSE_DOWN, leftClick,false,0,true);
			arrowImg2.addEventListener(MouseEvent.MOUSE_DOWN, rightClick,false,0,true);
			trackImg.addEventListener(MouseEvent.CLICK,trackClick,false,0,true);
			
		}
		private function createHorizontalScroll():void{
			
			// Affichage des composants de la scrollBar
			
			setActualSize(maskWidth, arrowImg.height,false,false);
			applySize();
			
			// Rotation des fleches 
			
			rotateCenter(arrowImg,90);
			rotateCenter(arrowImg2,-90);
			
			// positionnement de la fleche droite
			
			arrowImg2.x=width-arrowImg2.width;
			
			// Creation du thumb
			
			thumbSprite.addChild(thumbImg);
			thumbSprite.x=arrowImg.width;
			thumbSprite.height=height;
			
			// Contour du thumb
			
			thumbSprite.graphics.clear();
			thumbSprite.graphics.lineStyle(0,0x000000);
			thumbSprite.graphics.drawRect(0, 0, thumbSprite.width,4);
			thumbSprite.graphics.endFill();
			
			// Creation du track
			
			trackImg.width=width-(arrowImg.width*2);
			trackImg.height=height;
			trackImg.x=arrowImg.width;
			
			// Ajout des elements dans la scrollBar
			
			getFace().addChild(arrowImg);
			getFace().addChild(arrowImg2);
			getFace().addChild(thumbSprite);
			getFace().addChildAt(trackImg,0);
			
			// rectangle delimitant le drag
			
			dragBound=new Rectangle(arrowImg.width,0,width-(arrowImg.width*3),0);
			
			trackLength=width-(arrowImg.width*3);
			thumbSprite.addEventListener(MouseEvent.MOUSE_DOWN, drag,true,0,true);
			thumbSprite.addEventListener(MouseEvent.MOUSE_UP, drop,true,0,true);
			scrollTarget.getFace().mask=null;
			
			mask.x=scrollTarget.getFace().x;
			mask.y=scrollTarget.getFace().y;
			mask.graphics.clear();
			mask.graphics.beginFill(0x0000FF, 1);
			mask.graphics.drawRect(0, 0, maskWidth, maskHeight);
			mask.graphics.endFill();
			//scrollTarget.getFace()..addChild(mask);
			scrollTarget.getFace().mask=mask;
			
			// Met la taille de la cible a la taille du mask
			
			scrollTarget.getFace().width=maskWidth;
			scrollTarget.getFace().height=maskHeight;
			scrollTargetXPosition=scrollTarget.getFace().x;
			scrollTargetYPosition=scrollTarget.getFace().y;
			scrollTarget.hasScroll = true;
			
			
			// Calcul du deplacement lors des clic sur les fleches 
			
			pas=trackLength/60;
			
			// Ajout de listener 
			
			// Deplacement du mask lorsque la target bouge
			scrollTarget.getFace().addEventListener(FieEvent.MOVED, updateMask,false,0,true);
			
			// Click sur la scrollbar
			arrowImg.addEventListener(MouseEvent.MOUSE_DOWN, leftClick,false,0,true);
			arrowImg2.addEventListener(MouseEvent.MOUSE_DOWN, rightClick,false,0,true);
			trackImg.addEventListener(MouseEvent.CLICK,trackClick,false,0,true);
		}
		
		// Click sur le track
		
		private function trackClick(e:MouseEvent):void{
			if(type=="horizontal"){
			// Modification de la position du thumb et deplacement de la target
			// decalage a gauche
			if( (e.localX*e.currentTarget.scaleX)>thumbSprite.x) {
				thumbSprite.x+=(maskWidth/scrollTarget.width)*trackLength;
			}
			// decalage a droite
			else if( (e.localX*e.currentTarget.scaleX)<thumbSprite.x)
				thumbSprite.x-=(maskWidth/scrollTarget.width)*trackLength;
			// thumb colle a droite
			
			if(thumbSprite.x>(trackLength+arrowImg.width)){
				thumbSprite.x=trackLength+(arrowImg.width);
			}
			// thumb colle a gauche
			if(thumbSprite.x<arrowImg.width)
				thumbSprite.x=arrowImg.width;
			//deplacement de la target
			move((thumbSprite.x-arrowImg.width)/trackLength);
			}
			else{
				// Modification de la position du thumb et deplacement de la target
				// decalage a gauche
				if( (e.localY*e.currentTarget.scaleY)>thumbSprite.y) {
					thumbSprite.y+=(maskHeight/scrollTarget.height)*trackLength;
				}
				// decalage a droite
				else if( (e.localY*e.currentTarget.scaleY)<thumbSprite.y)
					thumbSprite.y-=(maskHeight/scrollTarget.height)*trackLength;
				// thumb colle a droite
			
				if(thumbSprite.y>(trackLength+arrowImg.height)){
					thumbSprite.y=trackLength+(arrowImg.height);
				}
				// thumb colle a gauche
				if(thumbSprite.y<arrowImg.height)
					thumbSprite.y=arrowImg.height;
				//deplacement de la target
				move((thumbSprite.y-arrowImg.height)/trackLength , "y");
			}
		}
		
		// click sur la fleche droite ( decalage a droite )
		private function rightClick(e:MouseEvent):void{
			if(type=="horizontal"){
			thumbSprite.x+=pas;
			if(thumbSprite.x>trackLength+arrowImg.width)
				thumbSprite.x=trackLength+arrowImg.width;
			move((thumbSprite.x-arrowImg.width)/trackLength);
			}
			else{
				thumbSprite.y+=pas;
				if(thumbSprite.y>trackLength+arrowImg.height)
					thumbSprite.y=arrowImg.height;
				move((thumbSprite.y-arrowImg.height)/trackLength,"y");
			}
			
		}
		// click sur la fleche gauche ( decalage a gauche )
		
		private function leftClick(e:MouseEvent):void{
			if(type=="horizontal"){
				thumbSprite.x-=pas;
				if(thumbSprite.x<arrowImg.width)
					thumbSprite.x=arrowImg.width;
				move((thumbSprite.x-arrowImg.width)/trackLength);
			}
			else{
				thumbSprite.y-=pas;
				if(thumbSprite.y<arrowImg.height)
					thumbSprite.y=arrowImg.height;
				move((thumbSprite.y-arrowImg.height)/trackLength,"y");
			}
			
			
		}
		private function drop(e:MouseEvent) : void {
			e.stopPropagation(); 
			e.currentTarget.stopDrag();
			while(e.currentTarget.hasEventListener(Event.ENTER_FRAME))
				e.currentTarget.removeEventListener(Event.ENTER_FRAME, updateScroll);
		}

		private function drag(e:MouseEvent) : void {
			e.stopPropagation(); 
			e.currentTarget.startDrag(false,dragBound);
			if(!e.currentTarget.hasEventListener(Event.ENTER_FRAME))
				e.currentTarget.addEventListener(Event.ENTER_FRAME, updateScroll, false,0,true);
		}
		
		private function updateScroll(e:Event):void{
			if(type=="horizontal")
				move((thumbSprite.x-arrowImg.width)/trackLength);
			else
				move((thumbSprite.y-arrowImg.height)/trackLength,"y");
		}
		
		// Met a jour la position du mask si la cible change de position
		
		private function updateMask(e:Event):void{
				
				
				scrollTarget.getFace().mask=null;
				scrollTargetXPosition=scrollTarget.getFace().x;
				scrollTargetYPosition=  scrollTarget.getFace().y;
				mask.x=scrollTarget.getFace().x;
				mask.y=scrollTarget.getFace().y;
				scrollTarget.getFace().mask=mask;
		}


		// Fonctions utilisé par le scroller
		
		// deplacement de la cible en fonction de la position indique en %
		
		private function move(position:Number,axis:String="x"):void{
			if(getFace()!=null){
				if(axis =="x")
					scrollTarget.getFace().x=-((scrollTarget.width-maskWidth)*position)+scrollTargetXPosition;
				else
					scrollTarget.getFace().y=-((scrollTarget.height-maskHeight)*position)+scrollTargetYPosition;
			}
		}
		
		private function rotateCenter(myMC:DisplayObject,angle:int):void{
			var point:Point=new Point(myMC.x+myMC.width/2, myMC.y+myMC.height/2);
			var m:Matrix=myMC.transform.matrix;
			m.tx -= point.x;
			m.ty -= point.y;
			m.rotate (angle*(Math.PI/180));
			m.tx += point.x;
			m.ty += point.y;
			myMC.transform.matrix= m;
		}
		
		override public function removeListener():void{
			super.removeListener();
			arrowImg.removeEventListener(MouseEvent.CLICK, leftClick);
			arrowImg2.removeEventListener(MouseEvent.CLICK, rightClick);
			trackImg.removeEventListener(MouseEvent.CLICK, trackClick);
			thumbSprite.removeEventListener(MouseEvent.MOUSE_DOWN, drag);
			thumbSprite.removeEventListener(MouseEvent.MOUSE_UP, drop);
			thumbSprite.removeChildAt(0);

		}
		override public function getDescriptorType() : Class
		{
			return ScrollerElementDescriptor;
		}
 
	}
}