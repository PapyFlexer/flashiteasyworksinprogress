/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */


package com.flashiteasy.api.utils
{


	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.FieUIComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *
	 * The <code><strong>Accordion</strong></code>  class is instanciated by Updates and is defined by 2 timed keyframes.
	 * It has a begin time and an end time, a begin value and an end value that will be tweened
	 * using its last properties (_easingClass and method that will manage the interpolation against a timeline).
	 *
	 */

	public class Accordion extends FieUIComponent
	{
		public function Accordion()
		{
  		//	this.addEventListener(Event.REMOVED_FROM_STAGE, clear);
		}
		
	/*	
		// private properties
		private const maxItems:int = 4;						// number of butons
		private const dist : uint = 1;								// distance in pixels between items
		private const speed : uint = 10;							// speed of animation	
		
		private var expandTimer:Number = 0;					// hold reference to growing anim timer
		private var reduceTimer:Number = 0;					// hold reference to reducing anim timer

		// private properties set for getter setter
		private var _oExpandVal:Object = null;				// hold reference to growing object
		private var _oReduceVal:Object = null;				// hold reference to reducing object

		//private var _path:Object;							// reference to Document Class
		private const maxSubItems:int = 7;					// nuber of subItmes
		private const sDist : int = 1;							//distance in pixels between sub items
		
		// public properties
		public  var w:int;									// clip initial width
		public  var h:int;									// clip initial height
		public  var dh:int;									// clip target stretched height
		public  var maskSprite:Sprite;						// mask sprite
		

		public function get getExpand():Object {
			return _oExpandVal;
		}
		
		public function set setExpand(obj:Object) : void
		{
			// assign object
			_oExpandVal = obj;
			// reste timer
			expandTimer = 0;
		}
		

		public function get getReduce():Object {
			return _oReduceVal;
		}
		
		public function set setReduce(obj:Object) : void
		{
			// assign object
			_oReduceVal = obj;
			// reste timer
			reduceTimer = 0;
		}
		
		private function addMask( el : SimpleUIElementDescriptor ):void{
			// crate mask sprite
			maskSprite = new Sprite();
			maskSprite.graphics.beginFill(0xFF00FF);
			maskSprite.graphics.drawRect(0,0,w,h);
			maskSprite.graphics.endFill();
			addChild(maskSprite);
			// add mask to clip
			this.mask = maskSprite;
		}
		
		private function onEnterFrame(event:Event):void{
			
			// animate clip growing using sin equiation
			getExpand.maskSprite.height = animateSin(getExpand.maskSprite.height,getExpand.dh,true);
			
			// animate clip reducing using sin equiation
			getReduce.maskSprite.height = animateSin(getReduce.maskSprite.height,getReduce.h,false);
			
			// make next clip position reflect previous clips
			for (var i:uint=0;i<maxItems;i++){
				// make next clip position reflect previous clips
				_childrenArray[i+1].y = _childrenArray[i].y + _childrenArray[i].maskSprite.height + dist;
			}
			
		}
		

		private function animateSin( h : Number, headerSize : int, isExpanding : Boolean) : Number
		{
			// assign initial timer accrding to argument
			var t  = (isExpanding) ? expandTimer : reduceTimer;
			
			// set varables for calulations 
			var initH : Number= h;
			var endH : int = headerSize;
			
			// start and distances to travel
			var startH  = initH;
			var distanceH = endH - initH;

			//the number of steps to take to perform a full progression of 0 to 1 for t (for the ease);
			var steps = distanceH/speed;

			//increment time
			t = parseFloat(t + 1/steps); // parseFloat helps prevent those nasty rounding errors
			
			var pos = startH + distanceH - (distanceH*Math.cos(t*Math.PI/4));
			
			// reassign timer accrding to argument
			(isExpanding) ?  expandTimer = t  :reduceTimer = t;// 
			
			// reset t to 1 if we reach 0 else reset t to 0 if we reach 1
			(t <= 0) ? t = 1 : t%= 1;

			return pos
		}
		
		private function clear():void
		{
			
		}
	}
}


	
	
/* 	// Document Class
	public class DocumentClass extends MovieClip {
		
		////////////////////////////////////
		// Constructor
		public function DocumentClass(){

			// loop and create year buttons
			for(var i:uint=0;i<=maxItems; i++){
				// create object from library
				var mcYear:YearButton= new YearButton(this);
				// set properties
				// x y position on stage
				mcYear.x= 150;
				mcYear.y= 10+(i*(mcYear.height+dist));
				// add to stage
				addChild(mcYear);
				// add to array
				_childrenArray.push(mcYear);
			}
			
			// set reference to this clip as growing Item
			setExpand = _childrenArray[0];
			// set initial reducingItem clip reference
			setReduce = _childrenArray[1];
			
			// listen to enterFrame event
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		
		
	}

	// Year buttons
	public class YearButton extends MovieClip {
		
		public function YearButton(obj:Object){
			// reference to path
			_path = obj;
			
			// define initial properties
			w = this.width;			// initial width
			h = this.height;		// initial height
			dh = 150;				// target  height
			
			// show hand cursor
			this.buttonMode = true;
			
			// loop and create Sub Items
			for(var i:uint=1;i<=maxSubItems; i++){
				// create Sub Item objects from library
				var mcProject:ProjectButton= new ProjectButton();
				// set properties
				// x y position on stage
				mcProject.x= 0;
				mcProject.y= 1+(i*(h+sDist));
				// add to stage
				addChild(mcProject);
			}
			
			// Create and Add mask covering all subItems created
			addMask();
			
			// delegate onclick event
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		// on Click action set new scaling elements
		private function onClick(event:MouseEvent):void{
			
			// dont set clips if current clip already selected
			if (_path.getExpand  != this){ 
				// see reducingItem clip reference
				_path.setReduce  = _path.getExpand;
				// set reference to this clip as growing Item
				_path.setExpand = this;
			}
		}
		
		// Creates and Adds mask
		
	}
	
	// Project buttons
	public class ProjectButton extends MovieClip {
		
		public function ProjectButton(){
			// constructor
		}*/
	}
}




 