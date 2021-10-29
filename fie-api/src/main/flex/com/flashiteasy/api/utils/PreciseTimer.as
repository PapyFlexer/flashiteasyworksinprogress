package com.flashiteasy.api.utils
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class PreciseTimer extends EventDispatcher
	{
		private const INSPECT_TIME:int = 100;
		private var _timer:Timer;
		private var _startTime:int = 0;
		private var _delay:int = 0;
		private var _repeatCount:int = 0;
		private var _continueForever:Boolean;


		public function PreciseTimer(delay:int, repeatCount:int=0)
		{
			_delay = delay;
			_repeatCount = repeatCount;
			_continueForever = repeatCount <= 0;
			init();

		}


		private function init():void
		{

			_timer = new Timer(INSPECT_TIME,0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);

		}


		public function start():void
		{

			_startTime = getTimer();
			_timer.start();

		}


		public function stop():void
		{

			_timer.stop();

		}

		public function reset():void
		{

			_timer.reset();

		}

		public function set delay(delay:int):void
		{
			_delay = delay;
//			_timer.delay = _delay;

		}


		public function get delay():int
		{
			return _delay;

		}
		private var _running:Boolean;


		public function get running():Boolean
		{
			return _timer.running;

		}
		private function onTimer(e:TimerEvent):void
		{
			var timer:int = getTimer();
			var durations:int = timer - _startTime;
			if (durations > _delay)
			{
				if (_continueForever)
				{
					dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				}
				else if (_repeatCount-- == 1)
				{
					stop();
					dispatchEvent(new TimerEvent(TimerEvent.TIMER));
					dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				}
				else
				{
					dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				}
				_startTime=timer-(durations-_delay);

			}
		}
	}
}