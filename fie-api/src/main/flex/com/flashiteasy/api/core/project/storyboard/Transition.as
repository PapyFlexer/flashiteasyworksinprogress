/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 *
 */
package com.flashiteasy.api.core.project.storyboard
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	import com.gskinner.motion.easing.Linear;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	/**
	 *
	 * The <code><strong>Transition</strong></code>  class is instanciated by Updates and is defined by 2 timed keyframes.
	 * It has a begin time and an end time, a begin value and an end value that will be tweened
	 * using its last properties (_easingClass and method that will manage the interpolation against a timeline).
	 *
	 */
	public class Transition
	{

		/**
		 *
		 * ===================================
		 * 			PRIVATE VARS
		 * ===================================
		 *
		 */

		private var _begin:int;
		private var _end:int;

		private var _beginValue:*;
		private var _endValue:*;

		private var _easingClass:Class;
		private var method:Function;

		private var timer:Timer;
		private var delayTimer:Timer;
		private var easing:*;

		private var _descriptor:IDescriptor;
		private var parameterSet:IParameterSet;
		private var propertyName:String;
		private var startTime:Number;

		private var _story:Story;

		private var _currentTime:Number;
		 
		private var _pauseTime:Number;



		/**
		 *
		 * ===================================
		 * 			PUBLIC VARS
		 * ===================================
		 *
		 */

		private var _easingType:String;

		/**
		 *
		 * @default
		 */
		public static const FPS:int=30;


		/**
		 *
		 * This function starts the transition
		 *
		 * @param descriptor 	:	The Face to be tweened
		 * @param parameterSet 	:	The ParameterSet of the face to tween
		 * @param propertyName 	:	The property from ParameterSet of the face to tween
		 * @param story			: 	The parent Story
		 */

		private var timers:Array=[];
		private var _inited:Boolean=false;
		private var _update:Update=null;

		/**
		 *
		 * @return
		 */
		public function get update():Update
		{
			return _update;
		}

		/**
		 *
		 * @return
		 */
		public function set update(value:Update):void
		{
			_update=value;
		}
		/**
		 *
		 * @return
		 */
		public function get inited():Boolean
		{
			return _inited;
		}

		/**
		 *
		 * @return
		 */
		public function set inited(inited:Boolean):void
		{
			_inited=inited;
		}

		/**
		 *
		 * @param start
		 */
		public function start(start:int=0):void
		{
			startTime=new Date().getTime() - start;
			/*if(timer != null )
			   {
			   timer.removeEventListener(TimerEvent.TIMER,onFps);
			   timer.removeEventListener(TimerEvent.TIMER, onTransitionBegin );
			   timer.stop();
			   timer=null;
			 }*/
			 if (begin > start)
			{
				if (timer != null)
				{
					timer.stop();
					timer.reset();
				}
				if (delayTimer == null)
				{
					delayTimer=new Timer(begin-start, 1);
					delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTransitionBegin);
				}
				delayTimer.delay=begin-start;
				delayTimer.reset();
				delayTimer.start();
			}
			else
			{
				if (beginValue != endValue) // )
				{
					var putFirstFrame : Boolean = start == 0;
					if(!putFirstFrame)
					{
						//this.progress(start);
					trace("trans "+this.story.uuid);
					}
					//On start we send true to have no flick and set beginValue before first frame
					beginEasing(putFirstFrame);
					startFps();
				}
				else
				{
					this.easingEnd();
				}
			}

		}

		/**
		 * Initializes the Transition, using ithe target the animation is applied to (IDescriptor), the parameterSets to tween(IParameterSet) and the property from the parameterSet that is tweened. Finally it references the story that owns the present transition.
		 * @param descriptor
		 * @param parameterSet
		 * @param propertyName
		 * @param story
		 */
		public function init(parameterSet:IParameterSet, propertyName:String, story:Story, update:Update, resetOriginalValue:Boolean=false):void
		{

			_inited=true;
			this._story=story;
			this.parameterSet=parameterSet;
			this.propertyName=propertyName;
			_update = update;
			isRelative = story.isRelative;
			//this.descriptor=descriptor;

			// keep the original value of the parameter
			
			/*if (_originalValue == null || resetOriginalValue)
			{
				_originalValue=parameterSet[propertyName];
			}*/
		}
		
		
		/**
		 *
		 * This function starts the transition when played from the animation editor
		 * administration state : ie it works with a slider that emulates a timer
		 *
		 * @param descriptor 	:	The Face to be tweened
		 * @param parameterSet 	:	The ParameterSet of the face to tween
		 * @param propertyName 	:	The property from ParameterSet of the face to tween
		 * @param story			: 	The parent Story
		 */
		public function goToTimeAndStop(currentTime:int):void
		{
			stopTimeLine(currentTime);
		}

		/**
		 *
		 * This function starts the transition when played from the animation editor
		 * administration state : ie it works with a slider that emulates a timer
		 *
		 * @param descriptor 	:	The Face to be tweened
		 * @param parameterSet 	:	The ParameterSet of the face to tween
		 * @param propertyName 	:	The property from ParameterSet of the face to tween
		 * @param story			: 	The parent Story
		 */
		public function goToTimeAndStart(currentTime:int):void
		{
			startTimeLine(currentTime);
		}

		/**
		 * This function is called by the previous one and manages the display
		 * of the animation when using a slider to emulate time
		 * @param currentTime
		 */
		private function stopTimeLine(currentTime:int):void
		{
			var decal : Number;
			if (timer != null)
			{
				timer.stop();
				timer.reset();
			}
			if (delayTimer != null)
			{
				decal = delayTimer.delay;
				delayTimer.stop();
				delayTimer.reset();
			}
			if (currentTime > end && end == this.story.maxTime)
			{
				this.easingEnd();
			}
			else
			{


				if (currentTime >= _begin && currentTime <= _end)
				{
					this.progress(currentTime);
				}

			}
		}

		/**
		 * This function is called by the previous one and manages the display
		 * of the animation when using a slider to emulate time
		 * @param currentTime
		 */
		private function startTimeLine(currentTime:int):void
		{

			startTime=new Date().getTime() - currentTime;
			if (begin > currentTime)
			{
				if (timer != null)
				{
					timer.stop();
					timer.reset();
				}
				if (delayTimer == null)
				{
					delayTimer=new Timer(begin, 1);
					delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTransitionBegin);
				}
				trace(" delay " + begin);
				delayTimer.delay=begin;
				delayTimer.reset();
				delayTimer.start();
			}
			else
			{

				if (currentTime >= end)
				{
					trace("currentTime >= end uuid"+this.story.uuid);
					this.easingEnd();
				}
				else
				{
					trace("onstartTimeline uuid"+this.story.uuid+" time "+currentTime+" begin "+begin +" end "+end);
					beginEasing();
					startFps();
				}
			}

		}

		/**
		 * starts the animation
		 */
		private function startFps(time:int=0):void
		{
			// Create a new timer aligned with theorical fps and starting it
			if (timer == null)
			{
				timer=new Timer(1000 / FPS);
				timers.push(timer);
				timer.addEventListener(TimerEvent.TIMER, onFps);
			}
			//timer.
			timer.start();
		}


		/**
		 * manages the type of interpolation and easing
		 */

		private var _isRelative:Boolean=false;
		private var _originalValue:*;

		private function beginEasing(setFace:Boolean = false):void
		{


			// Initialize the easing class and use it to set the initial value

			if (beginValue == null || isRelative == true)
			{
				trace("beginValue = null :: " + beginValue);
				beginValue=parameterSet[propertyName];
				isRelative=true;
			}
			else
			{
				if(setFace)
				{
					parameterSet[propertyName]= beginValue; //);
					parameterSet.apply(descriptor);
					refresh(descriptor);
				}
				//isRelative=false;
			}
			if (endValue == null)
			{
				endValue=originalValue;
			}
		}


		// set the parameterSet to it s original value

		/**
		 *
		 *
		 *
		 */

		private var realValue:*=null;

		public function resetValue():void
		{

			if (originalValue != null)// && IUIElementDescriptor(descriptor).getFace() != null)
			{
				trace("_originalValue :: "+originalValue);
				parameterSet[propertyName]= originalValue;
				parameterSet.apply(descriptor);
				refresh(descriptor);
			}

		}


		/**
		 *
		 * @param t : TimerEvent
		 */
		public function onTransitionBegin(t:TimerEvent):void
		{
			if (IUIElementDescriptor(descriptor).getFace() != null)
			{
				delayTimer.stop();
				delayTimer.reset();
				if (beginValue != endValue)
				{
					beginEasing();
					startFps();
				}
				else
				{
					this.easingEnd();
				}
			}
			else
			{
				destroy();
			}
		}
		private var _timeToPause : Number;
		/**
		 *
		 * @param t : TimerEvent
		 */
		public function onFps(t:TimerEvent):void
		{
			_currentTime=(new Date()).getTime() - startTime;
			if (_currentTime >= end)
			{
				stop();
				this.easingEnd();

			}
			else
			{
				if(_currentTime >= _timeToPause && !isNaN(Number(_timeToPause)))
				{
					//story.pauseTime = _timeToPause;
					//story.isPaused = true;
					story.pause();
					_timeToPause = undefined;
				}
				else
				{
					this.progress(_currentTime);
				}
			}
		}

		/**
		 *
		 * @param descriptor : IDescriptor, the face tweened must be correctly displayed on stage
		 */
		protected function refresh(descriptor:IDescriptor):void
		{
			if (descriptor is IUIElementDescriptor && IUIElementDescriptor(descriptor).getFace() != null)
			{
				if(parameterSet is RemoteParameterSet)
					AbstractBootstrap.getInstance().getBusinessDelegate().triggerPageRemoteStack(BrowsingManager.getInstance().getCurrentPage());

				IUIElementDescriptor(descriptor).invalidate();
			}
		}

		/**
		 *
		 * @param currentTime : Number, the currentTime of the animation
		 */
		protected function progress(currentTime:Number):void
		{
			var update:Boolean = true;
			if (!isNaN(Number(beginValue)))
			{
				var ratio:Number=(currentTime - begin) / (end - begin);
				var ratioAfterEasing:Number=method.apply(easing, [ratio, 0, 0, 0]);
				if (isRelative)
				{
					parameterSet[propertyName]=Number(beginValue) + ((Number(endValue) - Number(beginValue)) * ratioAfterEasing);
					//parameterSet[propertyName]=Number(beginValue) + (Number(endValue) * ratioAfterEasing);
				}
				else
				{
					parameterSet[propertyName]=Number(beginValue) + ((Number(endValue) - Number(beginValue)) * ratioAfterEasing);
				}
			}
			else
			{
				update = parameterSet[propertyName] != beginValue;
				parameterSet[propertyName]=beginValue;
			}
			if(update)
			{
				//trace("progress currentTime :: "+currentTime);
			parameterSet.apply(descriptor);
			refresh(descriptor);
			}
		}


		/**
		 * manages the ending of the transition
		 */
		protected function easingEnd():void
		{
			var update : Boolean = true;
			if (!isRelative)
			{
				update = parameterSet[propertyName] != endValue;
				parameterSet[propertyName] = endValue;
			}
			else
			{

				trace("easingEendisRelative :: " + endValue);
				//parameterSet[ propertyName ] = Number(endValue) + Number(beginValue);
				//beginValue = null;
				update = parameterSet[propertyName] != endValue;
				parameterSet[propertyName]= endValue;
			}
			if(update)
			{
				parameterSet.apply(descriptor);
				refresh(descriptor);
			}
		}

		/**
		 * manages the stopping of the transition
		 */
		public function stop():void
		{
			if (timer != null)
			{
				timer.removeEventListener(TimerEvent.TIMER, onFps);
				timer.stop();
				timer.reset();
				timer=null;
			}
			if (delayTimer != null)
			{
				delayTimer.removeEventListener(TimerEvent.TIMER, onTransitionBegin);
				delayTimer.stop();
				delayTimer=null;
			}
		}

		/**
		 *
		 * @param reset
		 */
		public function destroy(reset:Boolean=false):void
		{
			stop();
			if (reset)
			{
				resetValue();
			}

			if (timer != null)
			{
				timer.removeEventListener(TimerEvent.TIMER, onFps);
				timer.stop();
				timer=null;
			}
			if (delayTimer != null)
			{
				delayTimer.removeEventListener(TimerEvent.TIMER, onTransitionBegin);
				delayTimer.stop();
				delayTimer=null;
			}

		}

		/**
		 *
		 * ===================================
		 * 			GETTERS & SETTERS
		 * ===================================
		 *
		 */



		/**
		 *
		 * @return Story, the Story owning the transition
		 */
		public function get story():Story
		{
			return _story;
		}

		/**
		 *
		 * @param value Story, the Story owning the transition
		 */
		public function set story(value:Story):void
		{
			_story=value;
		}
/**
		 *
		 * @return _timeToPause(int) : the time when to stop the animation, in milliseconds
		 */
		public function get timeToPause():Number
		{
			return _timeToPause;
		}

		/**
		 *
		 * @param value  _timeToPause(int) : the time when to stop the animation, in milliseconds
		 */
		public function set timeToPause(value:Number):void
		{
			if (value > _end)
			{
				_timeToPause=_end;
			}
			else
			{
				_timeToPause=value;
			}
		}
		/**
		 *
		 * @return _begin(int) : the time when to start the animation, in milliseconds
		 */
		public function get begin():int
		{
			return _begin;
		}

		/**
		 *
		 * @param value  _begin(int) : the time when to start the animation, in milliseconds
		 */
		public function set begin(value:int):void
		{
			if (value > _end && _end != 0)
			{
				_begin=_end;
				_end=value;
			}
			else
			{
				_begin=value;
			}
		}

		/**
		 *
		 * @return  _end(int) : the time when to end the animation, in milliseconds
		 */
		public function get end():int
		{
			return _end;
		}

		/**
		 *
		 * @param value  _end(int) : the time when to end the animation, in milliseconds
		 */
		public function set end(value:int):void
		{
			if (value < _begin && _end != 0)
			{
				end=_begin
				_begin=value;
			}
			else
			{
				_end=value;
			}
		}

		/**
		 *
		 * @return _beginValue(Number) : the value of the property at begin time
		 */
		public function get beginValue():*
		{
			return _beginValue;
		}

		/**
		 *
		 * @param value _beginValue(Number) : the value of the property at begin time
		 */
		public function set beginValue(value:*):void
		{
			_beginValue=value == "true" ? true : value == "false" ? false : value;
		}

		/**
		 *
		 * @return
		 */
		public function get endValue():*
		{
			return _endValue;
		}

		/**
		 *
		 * @param value _endValue(Number) : the value of the property at end time
		 */
		public function set endValue(value:*):void
		{
			_endValue=value == "true" ? true : value == "false" ? false : value;
		}

		/**
		 *
		 * @return Class : the type of interpolation
		 */
		public function get easingClass():Class
		{
			return _easingClass;
		}

		/**
		 *
		 * @param value the type of interpolation
		 */
		public function set easingClass(value:Class):void
		{
			_easingClass=value;
			if (_easingClass == null)
			{
				_easingClass=Linear;
			}
			if (_easingClass[_easingType] == null)
			{
				method=_easingClass["easeOut"];
			}
			else
			{
				method=_easingClass[_easingType];
			}
		}

		/**
		 *
		 * @return
		 */
		public function get easingType():String
		{
			return _easingType;
		}

		/**
		 *
		 * @param value
		 */
		public function set easingType(value:String):void
		{
			_easingType=value;
			if (_easingClass != null)
			{
				if (_easingClass[_easingType] == null)
				{
					method=_easingClass["easeOut"];
				}
				else
				{
					method=_easingClass[_easingType];
				}
			}
		}

		/**
		 *
		 * @return String that gives the interpolation type
		 */
		public function getInterpolationType():String
		{
			return String(_easingClass).split(" ")[0].substr(1);
		}


		private function setTimerToGivenTime(tmr:Timer, givenTime:uint):void
		{
			//
		}

		/**
		 *
		 * @param value _originalValue(Number) : the saved value of the property
		 */
		public function set originalValue(value:*):void
		{
			_originalValue=value;
		}

		/**
		 *
		 * @return
		 */
		public function get originalValue():*
		{
			return _update.originalValue;
		}

		public function pause() : void
		{
			if (timer!=null && timer.running) timer.stop();
			if (delayTimer != null && delayTimer.running) delayTimer.stop();
			_currentTime = new Date().getTime() - startTime;
		}

		public function resume() : void
		{
			var decalTime : Number = new Date().getTime() - startTime - _currentTime;
			startTime = startTime + decalTime;

			if (timer!=null && !timer.running) timer.start();
			if (delayTimer != null && !delayTimer.running) delayTimer.start();
			
		}
		
		public function get descriptor():IDescriptor
		{
			_descriptor = this.story.getElementDescriptor();
			return _descriptor;
		}

		public function set descriptor(value:IDescriptor):void
		{
			_descriptor = value;
		}

		public function get isRelative() : Boolean
		{
			return this.story.isRelative;
		}

		public function set isRelative( value : Boolean  ) : void
		{
			_isRelative = value;
		}
	}
}

