/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils {
	/**
	 * @private 
	 * @author gillesroquefeuil
	 */
	import com.flashiteasy.api.core.FieUIComponent;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	/**
	 * @private 
	 * @author gillesroquefeuil
	 */
	public class Carrousel extends FieUIComponent {

  		/**
  		 * @private 
  		 */
  		public function Carrousel(){
  			this.addEventListener(Event.REMOVED_FROM_STAGE, clear);
  			
  		}
        private var _center:Point;
 
        private var _radius:Point;
        private var _speed:Number=0.05;
        private var angles:Dictionary=new Dictionary();
        private var display_order:Array=new Array;
        private var interval:Array=new Array;
        private var pi:Number=Math.PI;
  		/**
  		 * 
  		 * @param value
  		 */
  		public function set center(value:Point):void{
  			_center=value;
  		}
  		
  		// Demarre le carrousel
  		
  		/**
  		 * 
  		 */
  		public function init():void{
 /*  			var i:int=0;
 			_center=new Point(this.width/2, this.height/2);   
            _radius=new Point(150,30);
            var num:int=this.numChildren;
            for(i=0;i<num;i++){
         		this.getChildAt(i).x=Math.cos(i*((Math.PI*2)/num))*_radius.x +_center.x;
         		this.getChildAt(i).y=Math.sin(i*((Math.PI*2)/num)) *_radius.y +_center.y;
         		angles[this.getChildAt(i)]=((i*((Math.PI*2)/num)));	
         		this.getChildAt(i).addEventListener(Event.ENTER_FRAME,onEnter,false,0,true);
         		display_order.push(this.getChildAt(i));
         		//interval.push(setInterval(moved,40,this.getChildAt(i)));
			}
			this.addEventListener(Event.ENTER_FRAME,sortChild,false,0,true);
 */			
 		 }
  		/**
  		 * 
  		 * @param value
  		 */
  		public function set radius(value:Point):void{
  			_radius=value;
  		}
  		
  		/**
  		 * 
  		 * @param value
  		 */
  		public function set speed(value:int):void{
  			_speed=value;
  		}
        private function clear(e:Event):void{
        	while(interval.length>0)
        		clearInterval(interval.pop());
        }
 		  private function moved(obj:FieUIComponent):void{
 		  	var angle:Number=angles[obj]+_speed;
            var cos:Number=Math.cos(angle);
            var sin:Number=Math.sin(angle);
            
            // Swap depth
            
            /*if(sin<-0.9){
            	this.addChildAt(obj,0);
            }
            if(sin>0.9){
            	this.addChild(obj);
            	
            }*/
            
            angles[obj]=angle;
            obj.x=cos*_radius.x +_center.x;
            obj.y=sin*_radius.y +_center.y;
 		  }
 /* 		  private function onEnter(evt:Event):void{
            var obj:FieUIComponent=FieUIComponent(evt.currentTarget); 
            var angle:Number=angles[obj]+_speed;
            var cos:Number=Math.cos(angle);
            var sin:Number=Math.sin(angle);
            if(sin<-0.9){
            	this.addChildAt(obj,0);
            }
            if(sin>0.9){
            	this.addChild(obj);
            	
            }
            angles[obj]=angle;
            obj.x=cos*_radius.x +_center.x;
            obj.y=sin*_radius.y +_center.y;

        }
  */		 private function sortChild(e:Event):void{
 		 	display_order.sortOn("y", Array.NUMERIC);
 		 }
	}
 		 

}
