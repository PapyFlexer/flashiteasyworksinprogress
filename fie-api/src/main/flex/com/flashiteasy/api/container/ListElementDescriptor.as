/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.container {
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IListElementDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ControlUtils;
	import com.flashiteasy.api.utils.DictionaryUtils;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * The <code><strong>ListElementDescriptor</strong></code> container is different inasmuch it contains elements that are automatically placed.
	 * The different modes of automatic placement are - as yet for now - HorizontalTiling, VerticalTiling, carrousel, etc.
	 */
	public class ListElementDescriptor extends BlockElementDescriptor implements IListElementDescriptor
	{
		private var margin:Number = 0;
		private var type:String;

		

		// Type d affichage de la liste ( horizontal ou vertical )
		
		/**
		 * The type of automatic placement
		 * @param type
		 */
		public function setType(type:String):void
		{
			this.type=type;
			if(isLoaded())
			{
				layoutList();
			}
		}

		
		// Marge entre les elements de la liste
		
		/**
		 * Sets the inner (or outer for negative alues) margin of the container.
		 * @param margin
		 */
		public function setMargin( margin : Number ):void
		{
			this.margin=margin;
			if(isLoaded())
			{
				layoutList();
			}
		}
		
		/**
		 * Sets the spped at which the Carrousel is turning.
		 * TODO : calculat speed relatively to mouseX position
		 * @param speed
		 */
		public function setCarrouselSpeed( speed : Number ) : void 
		{
			this.carrouselSpeed = speed;
		}
		
		// Array containing processed children 
		
		private var displayedElements : Array = [];
		
		// calculate the position of the child
		
		protected override function layoutControl(el:IUIElementDescriptor):void 
		{
			// Unlock child to be able to move it
			SimpleUIElementDescriptor(el).lockPosition(false);
			
			// Calculate child position and apply it
			var nextCoordinate : Point = getNextPosition(SimpleUIElementDescriptor(el));
			SimpleUIElementDescriptor(el).setY( nextCoordinate.y ) ;
			SimpleUIElementDescriptor(el).setX( nextCoordinate.x , true ) ;
			
			// add the element to displayedElements to notify it has been processed 
			displayedElements.push(el);
			face.addChild(el.getFace());
			
			// prevent child from beeing moved by external action
			// don t lock in carrousel type since children is moving on enter_frame 
			if( type != "carrousel")
			{
				
				SimpleUIElementDescriptor(el).lockPosition(true);
			}
		}
		
		/**
		 *  The <coe></code> method cycles through the container children and effects the necessary resizing based on basic (and editable) rules.
		 */
		protected function layoutList():void 
		{
			removeCarrouselListener();
			displayedElements=[];
			for each ( var el : IUIElementDescriptor in child_list )
			{
				layoutControl(el);
			}
			if( type == "carrousel") 
			{	
				animateCarrousel();
			}
			else if ( type == "vAccordion" || type == "hAccordion" )
			{
				initAccordion();
			}
		}
		
		private var angles : Dictionary = new Dictionary(true);
		private var carrouselSpeed : Number = 0.05;
		
		// Start Carrousel
		
		private function animateCarrousel():void
		{
			face.addEventListener(Event.ENTER_FRAME,onEnter,false,0,true);
		}
		
		// Stop carrousel
		
		private function removeCarrouselListener():void
		{
			if( face.hasEventListener(Event.ENTER_FRAME))
			{
				face.removeEventListener(Event.ENTER_FRAME,onEnter);
			}
			angles = new Dictionary(true);
		}
		
		private function arrange():void 
		{
		   child_list.sortOn("y", Array.NUMERIC);
		    var i:int = child_list.length;
		    while(i--){
		        if (face.getChildAt(i) != child_list[i].getFace()) {
		            face.setChildIndex(child_list[i].getFace(), i);
		        }
		    }
		}

		private function onEnter(e:Event ) : void 
		{
			var control : SimpleUIElementDescriptor ;
			var angle:Number;
			var cos:Number;
			var sin:Number;
			var center : Point = new Point( width*0.5 , height*0.5);
			for each( control in child_list ) 
			{
				angle =angles[control] + ( computeSpeed() * carrouselSpeed );
	            cos=Math.cos(angle);
	            sin=Math.sin(angle);
	            angles[control]=angle;
           		control.setX(int((cos*center.x +center.x)- control.width*0.5) );
            	control.setY(int((sin*center.y +center.y)-control.height*0.5),true);
			}
			// arrange children indexes 
			arrange();
		}
		
		// calculates the carrousel speed, from -0.20 to 0.20, based on x position of mouse
		private function computeSpeed():Number
		{
			var speed : Number;
			var amount : Number;
			if (face.mouseX > face.x + face.width)
			{
				amount = 1;
			}
			else if (face.mouseX< face .x)
			{
				amount = -1;	
			}
			else
			{
				amount = (face.mouseX - face.width/2) / face.width;
			}
			return amount;
		}
		
		// Calculate the position of the next child
		
		private function getNextPosition( el : SimpleUIElementDescriptor ) : Point
		{
			var nextX : int = 0 ;
			var nextY : int = 0 ;
			var control : SimpleUIElementDescriptor
			
			if( type == "vertical" || type == null )
			{
				for each ( control in displayedElements )
				{
					nextY += control.height;
					nextY += margin;
				}
			}
			if( type == "horizontal" )
			{
				for each ( control in displayedElements )
				{
					nextX += control.width;
					nextX += margin;
				}
			}
			if( type == "tile" )
			{
				if(displayedElements.length != 0 )
				{
					var previousElement : SimpleUIElementDescriptor = displayedElements[displayedElements.length-1];
					if( (  previousElement.width + previousElement.x + margin ) + el.width < width )
					{
						nextX = previousElement.width + previousElement.x + margin ;
						nextY = previousElement.y;
					}
					else
					{
						var tallerElement : SimpleUIElementDescriptor = previousElement ;
						for each( var element : SimpleUIElementDescriptor in displayedElements )
						{
							if( element.y == previousElement.y )
							{
								if( element.height > tallerElement.height )
								{
									tallerElement = element ;
								}
							}
						}
						nextY= tallerElement.y + tallerElement.height+margin;
					}
				}
				
			}
			if( type =="carrousel" ) 
			{
				var center : Point = new Point(this.width/2, this.height/2);
				var index : int = displayedElements.length ;
				var numChildren : int = child_list.length;
				nextX = Math.cos(index*(Math.PI*2)/numChildren)*(width/2) +center.x;
				nextY = Math.sin(index*(Math.PI*2)/numChildren) *(height/2) +center.y;
				nextX -= el.width/2;
				nextY -= el.height/2;
				angles[el]=index*(Math.PI*2)/numChildren;	
			}
			if ( type == "hAccordion")// || type == "vAccordion" )
			{
				var i : uint = 0
				for ( i=0; i<child_list.length; i++ )
				{
					nextX += headerSize;
					nextY += headerSize;
					
				}
			}
			if ( type == "vAccordion")// || type == "vAccordion" )
			{
				var j : uint = 0
				for ( j=0; j<child_list.length; j++ )
				{
					nextY += headerSize;
					nextY += headerSize;
				}
			}
			return new Point(nextX , nextY ) ;
		}
		
		protected override function onChildRemoved( el : IUIElementDescriptor):void
		{
			ArrayUtils.removeElement( displayedElements , el );
			layoutList();
		}
		
		protected override function onControlLoaded():void
		{
			layoutList();
		}
		
		protected override function onChildResized( el : IUIElementDescriptor):void
		{
			layoutList();
		}
		
		protected override function onSizeChanged():void
		{
			if(type == "tile")
			{
				layoutList();
			}
		}
		
		public override function destroy():void
		{
			removeCarrouselListener();
			super.destroy();
		}
		
		
		/**
		 * 
		 * ACCORDION METHODS
		 * 
		 */
		 
		private var masks : Dictionary;
		private var headers : Dictionary;
		private var accordionInited : Boolean = false;
		
		private const dist : int = 10;							// distance in pixels between items
		private const speed : int = 10;							// speed of animation	
		
		//private var child_list:Array = new Array();			// hold reference to all clips
		private var expandTimer:Number = 0;						// hold reference to growing anim timer
		private var reduceTimer:Number = 0;						// hold reference to reducing anim timer

		// private properties set for getter setter
		private var _oExpandVal:IUIElementDescriptor = null;	// hold reference to growing object
	 	private var _oReduceVal:IUIElementDescriptor = null;	// hold reference to reducing object
	 	private var _currentControl:IUIElementDescriptor=null// used in loops	
		private var _currentIndex : uint;
		
		// public properties
		public  var itemWidth:int = 100;						// clip initial width
		public  var itemHeight:int = 100;						// clip initial height
		public  var headerSize:int = 20;						// clip target stretched height/width
		public  var maskSprite:Sprite;							// mask sprite
		public  var headerSprite : Sprite

		
		private function addMask( el : IUIElementDescriptor, rang:uint ) : void
		{
			// references
			var spr : Sprite = el.getFace() as Sprite;
			// crate mask sprite
			maskSprite = new Sprite();
			maskSprite.name = "maskSprite"+rang;
			maskSprite.graphics.beginFill(0xFF00FF, 0.4);
			if (type == "hAccordion")
			{
				itemWidth = headerSize;
				itemHeight = spr.height;
			}
			else if (type == "vAccordion")
			{
				itemWidth = spr.width;
				itemHeight = headerSize;
			}
			maskSprite.graphics.drawRect(3,3,itemWidth-6,itemHeight-6);
			maskSprite.graphics.endFill();
			maskSprite.x = spr.x;
			maskSprite.y = spr.y;
			getFace().addChild( maskSprite );
			// add mask to clip
			
			spr.mask = maskSprite;
			masks[maskSprite] = el;
			trace ("mask created for item (rang "+rang+") "+el.uuid+"  element : "+spr.x+"/"+spr.y+"/"+spr.width+"/"+spr.height+"  mask : "+maskSprite.x+"/"+maskSprite.y+"/"+maskSprite.width+"/"+maskSprite.height);
			trace ("maskParent = "+ maskSprite.parent.name);
		}
		
		private function addHeader( el : IUIElementDescriptor, rang : uint ) : void
		{
			// references
			var spr : Sprite = el.getFace() as Sprite;
			headerSprite = new Sprite();
			headerSprite.name = "headerSprite"+rang;
			//header["ref"] = el;
			headerSprite.graphics.beginFill( 0x000000, 0.5 );
			headerSprite.graphics.drawRect( 2, 2, 16, 16 );
			headerSprite.graphics.endFill();
/* 			 if ( type == "hAccordion" )
			{
				headerSprite.height = el.getFace().height;
			}
			else if ( type == "vAccordion" )
			{
				headerSprite.width = el.getFace().width;
			} 
			//headerSprite.addEventListener(MouseEvent.CLICK,onHeaderClick)
 */			spr.addChild( headerSprite );
			headers[headerSprite] = el;
		} 

		
		public function initAccordion():void
		{
			if (accordionInited != true)
			{
				masks = new Dictionary(true);
				headers = new Dictionary(true);
				var control : IUIElementDescriptor;
				for (var i:uint=0; i<child_list.length; i++)
				{
					control =  IUIElementDescriptor( child_list[i] );
					addMask( control, i );
					addHeader( control, i );
				}
				initAccordionPosition();
				//trace ("init accordion with selectedItem = "+ child_list[0].uuid);
				accordionInited = true;
				// set reference to this clip as growing Item
				//setExpand( child_list[0] );
				//setReduce( child_list[1] )
				//openAccordionChild(0);
			}
		 }
		private function initAccordionPosition():void
		{
			for (var i:uint=0; i<child_list.length; i++)
			{
				var decal : int = i*dist
				var obj : IUIElementDescriptor  = child_list[i];
				var spr : Sprite = obj.getFace() as Sprite;
				var msk : Sprite = DictionaryUtils.getKey(masks, obj);
				var hdr : Sprite = DictionaryUtils.getKey(headers, obj);
				if ( type == "hAccordion" )
				{
					spr.x = i*headerSize + decal;
					msk.x = i*headerSize + decal;
				}
				else if ( type == "vAccordion" )
				{
					spr.y = i*headerSize + decal;
					msk.y = i*headerSize + decal;
				}
			}
		}
		
		
		public function openAccordionChild( childIndex:uint = 0):void
		{
			trace ("openAccordionChild on index="+childIndex);
			var obj : IUIElementDescriptor;
			var spr : Sprite;
			var msk : Sprite;
			var i : int;
		
			for(i=1;i<child_list.length;i++){
				obj = child_list[i];
				//spr = Sprite(obj.getFace().getChildByName("headerSprite"+i));
				spr = DictionaryUtils.getKey(headers, obj);
				spr.addEventListener(MouseEvent.CLICK, handleOpenClick);
				spr.buttonMode=true;
			}
			obj = child_list[childIndex];
			//spr = Sprite(obj.getFace().getChildByName("headerSprite"+childIndex))
			spr = DictionaryUtils.getKey(headers, obj);
			spr.buttonMode=false;
			spr.removeEventListener(MouseEvent.CLICK, handleOpenClick);
			for(i=childIndex+1; i<child_list.length;i++){
				obj = child_list[i];
				spr = obj.getFace();
				msk = DictionaryUtils.getKey(masks, obj);
				
				////////////////////////
				if ( type == "hAccordion" )
				{
					var sprTweenH : GTween = new GTween(spr,1, {x:obj.width-(child_list.length-i)*headerSize},{ease:Sine.easeInOut});
					var mskTweenH : GTween = new GTween(msk,1, {x:obj.width-(child_list.length-i)*headerSize},{ease:Sine.easeInOut});
				}
				else if ( type == "vAccordion" )
				{
					//ar twV : GTween = new GTween(spr,1, {y:obj.height-(child_list.length-i)*headerSize},{ease:Sine.easeInOut});
					var sprTweenV : GTween = new GTween(spr,1, {y:obj.height-(child_list.length-i)*headerSize},{ease:Sine.easeInOut});
					var mskTweenV : GTween = new GTween(msk,1, {y:obj.height-(child_list.length-i)*headerSize},{ease:Sine.easeInOut});
				}

			}
			for(i=1; i<=childIndex;i++){
				obj = child_list[i];
				spr = obj.getFace();
				msk = DictionaryUtils.getKey(masks, obj);
				////////////////////////
				if ( type == "hAccordion" )
				{
					//var twHH : GTween = new GTween(spr,1, {x:(i-1)*headerSize},{ease:Sine.easeInOut});
					var sprTweenH : GTween = new GTween(spr,1, {x:(i-1)*headerSize},{ease:Sine.easeInOut});
					var mskTweenH : GTween = new GTween(msk,1, {x:(i-1)*headerSize},{ease:Sine.easeInOut});
				}
				else if ( type == "vAccordion" )
				{
					//var twVV : GTween = new GTween(spr,1, {y:(i-1)*headerSize},{ease:Sine.easeInOut});
					var sprTweenV : GTween = new GTween(spr,1, {y:(i-1)*headerSize},{ease:Sine.easeInOut});
					var mskTweenV : GTween = new GTween(msk,1, {y:(i-1)*headerSize},{ease:Sine.easeInOut});
				}
			}
			_currentIndex=childIndex;
		}

		private function handleOpenClick(evt:Event) : void
		{
			var selectedHeader : Sprite = Sprite( evt.currentTarget );
			_currentControl = headers[selectedHeader] as IUIElementDescriptor;
			//var childIndex : uint = _currentControl.uuid.substr(-1) as Number;
			var childIndex : uint = selectedHeader.name.substr(-1) as Number;
			trace ("triggering item index="+selectedHeader.name);
			//trace("headerSprite click on "+ _currentControl.uuid);
			/* if(evt.target.panelNumber){
				openAccordionChild(childIndex);
			} */
		}


		public function setAccordionHeaderSize( size : Number ):void
		{
			headerSize = size;
		} 
		
		public override function getDescriptorType() : Class
		{
			return ListElementDescriptor;
		}
	}
}

