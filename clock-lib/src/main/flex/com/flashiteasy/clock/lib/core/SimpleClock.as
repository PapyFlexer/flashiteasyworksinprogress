package com.flashiteasy.clock.lib.core

{
	import flash.display.Sprite;

	public class SimpleClock extends Sprite implements IClock
	{
		import com.flashiteasy.clock.lib.core.AnalogClockFace; 
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		/**
		 * The time display component.
		 */
		public var cadran:AnalogClockFace;
		
		/**
		 * The Timer that acts like a heartbeat for the application.
		 */
		public var ticker:Timer;
		
		public static const millisecondsPerMinute:int = 1000 * 60;
        public static const millisecondsPerHour:int = 1000 * 60 * 60;
        public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		
		/**
		 * Sets up a SimpleClock instance.
		 */
		public function initClock(faceSize:Number = 200):void 
		{
		    // sets the invoice date to today’s date
            var invoiceDate:Date = new Date();
            
            // adds 30 days to get the due date
            var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
            var dueDate:Date = new Date(invoiceDate.getTime() + (30 * millisecondsPerDay));

            var oneHourFromNow:Date = new Date(); // starts at the current time
		    oneHourFromNow.setTime(oneHourFromNow.getTime() + millisecondsPerHour);
		    
			// Creates the clock face and adds it to the Display List
			cadran = new AnalogClockFace(Math.max(20, faceSize));
			cadran.init();
			this.addChild(cadran);
			
			// Draws the initial clock display
			cadran.draw();

			// Creates a Timer that fires an event once per second.
        	ticker = new Timer(1000); 
        	
        	// Designates the onTick() method to handle Timer events
            ticker.addEventListener(TimerEvent.TIMER, onTick);
            
            // Starts the clock ticking
            ticker.start();
        }

		/**
		 * Called once per second when the Timer event is received.
		 */
        public function onTick(evt:TimerEvent):void 
        {
        	cadran.draw();
        }		
	}
}