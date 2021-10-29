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
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.errors.ApiErrorManager;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ElementDescriptorUtils;
	import com.flashiteasy.api.utils.PreciseTimer;
	import com.flashiteasy.api.utils.StoryboardUtils;
	
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;


	/**
	 *
	 * The <code><strong>Story</strong></code> class represnts an animation.
	 *
	 */

	public class Story
	{
		/**
		 *
		 * ===================================
		 * 			PRIVATE VARS
		 * ===================================
		 *
		 */
		private var elementDescriptor:IDescriptor; // the target of the animation
		private var updates:Array=[]; // Array of updates (parameterSet & Prop)
		private var _page:Page;
		private var _uuid:String; // so we can target the story independantly
		private var _maxTime:int=0; // so we can loop one story individually
		private var _minTime:int=0; // so we can loop one story to its moving begin time (option)
		private var _loop:Boolean=false; // loopable prop
		private var _autoPlay:Boolean=false; // timer stories have autoPlay set to true;
		private var timer:PreciseTimer;
		private var _autoPlayOnUnload:Boolean=false;

		private var _isPlaying:Boolean=false;
		public var pauseTime:Number = 0;
		public var linkedReverseStory:Story = null;
		public var reverseStory:Story = null;

		private var refTime:Number = 0;
		
		private var _isRelative : Boolean = false;

		/**
		 *
		 * @param id 			:	Strings that states the Story (animation) identifier
		 * @param descriptor	:	IDescriptor, Face (visual control) that will be animated
		 * @param loop			:	Boolean, loops the Story if true
		 * @param type			:	String, type of the animation,cf StoryTypes.as
		 */
		public function init(id:String, descriptor:IDescriptor, loopable:Boolean, autoPlayable:Boolean, autoPlayableOnUnload:Boolean):void
		{
			this.uuid=id;
			this.elementDescriptor=descriptor;
			this.loop=loopable;
			this.autoPlay=autoPlayable;
			this.autoPlayOnUnload=autoPlayableOnUnload;
		}

		/**
		 * this func adds a listener to the story so that it can be looped if needed
		 */
		public function createLoopListener():void
		{
			if (timer == null)
			{
				timer=new PreciseTimer(this.maxTime);
				timer.addEventListener(TimerEvent.TIMER, playLoop);
			}

		}

		/**
		 *
		 * @param e TimerEvent (loop managing)
		 */
		private function playLoop(e:TimerEvent):void
		{
			var ttt:int;
			//trace ("FieEvent.STORY_ENDED dispatched on "+this.uuid);
			//this.getPage().dispatchEvent(new FieEvent(FieEvent.STORY_ENDED));
			timer.stop();
			timer.reset();
			if (timer.delay != maxTime)
				timer.delay=maxTime;
			if (this.loop)
			{
				start();
			}
			else
			{
				_isPlaying=false;
				_isPaused=false
			}
		}

		/**
		 *
		 * @param page	: Page, the page where the story is played
		 */
		public function createStory(page:Page):void
		{
			this._page=page;
			StoryList.getInstance().addStory(this, page);
		}

		public function start(time:int=0):void
		{
			_isPaused=false;
			if (this.elementDescriptor != null)
			{
				pauseTime=0;
				refTime=new Date().getTime() - time;
				var update:Update;
				for each (update in updates)
				{
					update.start(time);
				}
				if (timer != null)
				{
					timer.stop();
					timer.reset();
					timer.start();
				}
				_isPlaying=true;
				_isPaused=false;
			}
			else
			{
				ApiErrorManager.getInstance().dispatchEvent(new FieEvent(FieEvent.ERROR_STORY_NO_TARGET,{uuid:uuid}));
			}
		}


		public function goToTimeAndStop(time:int=0):void
		{
			var update:Update;
			if (_loop)
			{
				time=time % _maxTime
			}
			if (timer != null)
			{
				timer.stop();
				timer.reset();

			}
			for each (update in updates)
			{
				if (time >= _minTime)
					update.goToTimeAndStop(time);
			}
			_isPlaying=false;
			_isPaused=true;
		}

		public function stop():void
		{
			if (timer != null)
			{
				timer.stop();
			}
			for each (var update:Update in getUpdates())
			{
				update.stop();
			}
			_isPlaying=false;
			_isPaused=true;
			refTime=0;
		}

		/**
		 *
		 * Stops everything
		 *
		 * @param s
		 */
		public function resetOriginalValues():void
		{
			for each (var update:Update in getUpdates())
			{
				
				var parameter:IParameterSet=ElementDescriptorUtils.findParameterSet(getElementDescriptor(), update.getParameterSetName());
				update.originalValue = parameter[update.getPropertyName()];
			}
		}
		/**
		 *
		 * Stops everything
		 *
		 * @param s
		 */
		public function reset():void
		{
			if (timer != null)
			{
				timer.stop();
			}
			for each (var update:Update in getUpdates())
			{
				update.reset();
			}
			_isPlaying=false;
			_isPaused=true;
			refTime=0;
		}

		private var temporaryTime:Number;
		private var _isPaused:Boolean=true;

		public function pause():void
		{
			if(refTime != 0)
			{
				pauseTime = new Date().getTime() - refTime > maxTime ? maxTime : new Date().getTime() - refTime;
			}
			else
			{
				pauseTime = minTime;
			}
			if(isNaN(pauseTime))
			{
				trace("PROBLEM");
			}
			
			for each (var u:Update in getUpdates())
			{
				u.pause();
			}
			if (timer != null && timer.running)
				timer.stop();
			_isPlaying=false;
			_isPaused=true;
			temporaryTime=new Date().getTime();
			synchronizeLinkedStory();

		}

		public function resume():void
		{
			var decalTime : Number = new Date().getTime() - refTime - temporaryTime;

			if (_isPaused)
			{
				var t:uint=new Date().getTime() - temporaryTime;


				if (timer != null && !timer.running)
				{
					refTime=refTime + t;
					timer.delay=Math.abs(maxTime - pauseTime);
					timer.start();
				}
				/*
				for each (var u:Update in getUpdates())
				{
					//u.resume();
					trace("pauseTime :: " + pauseTime);
					u.goToTimeAndPlay(pauseTime);
				}
				*/
				isPlaying=true;
				trace("Storie Start :: "+this.uuid+ " pause at :: "+pauseTime);
				start(pauseTime);
			}
			else
			{
				/*pauseTime=0;
				trace("starting ");
				this.start();*/
			}

			_isPaused=false;
		}
		
		private function synchronizeLinkedStory() : void
		{
			if(this.linkedReverseStory != null)
			{
				linkedReverseStory.isPaused = _isPaused;
				linkedReverseStory.pauseTime = maxTime - pauseTime;
				linkedReverseStory.temporaryTime = temporaryTime;
			}
		}
		/**
		 * destroys the Story
		 */
		public function destroy(reset:Boolean=true):void
		{
			stop();
			if(StoryList.getInstance().getStory(uuid, _page) != null)
			{
				StoryList.getInstance().removeStoryById(uuid, _page);
				destroyReversed();
			}
			
			for each (var update:Update in updates)
			{
				update.destroy(reset);
			}
			updates=[];
		}
		
		private function destroyReversed() :void
		{
			if(this.linkedReverseStory != null)
			{
				linkedReverseStory.stop();
				for each (var linkedReverseUpdate:Update in linkedReverseStory.getUpdates())
				{
					linkedReverseUpdate.destroy(false);
				}
				linkedReverseStory.updates=[];
			}
			if(this.reverseStory != null)
			{
				reverseStory.stop();
				for each (var linkedUpdate:Update in reverseStory.getUpdates())
				{
					linkedUpdate.destroy(false);
				}
				reverseStory.updates=[];
			}
		}

		public function toggle():void
		{
			_isPaused ? resume() : pause();
		}

		public function clone():Story
		{
			var s:Story=new Story();
			s.init(this.uuid, this.elementDescriptor, this.loop, this.autoPlay, this.autoPlayOnUnload);
			
			for each (var update:Update in this.getUpdates())
			{
				var transArray : Array = new Array;
				var newupdate:Update=new Update;
				newupdate.init(update.getParameterSetName(), update.getPropertyName(), update.getId(), s);
				var transitions:Array=update.getTransitions();
				for each (var transition:Transition in transitions)
				{
					
					var trans:Transition = new Transition;
					trans.init(newupdate.getParameterSet(), newupdate.getPropertyName(), s, newupdate);
					trans.beginValue = transition.beginValue;
					trans.endValue = transition.endValue;
					trans.begin = transition.begin;
					trans.end = transition.end;
					trans.easingClass = transition.easingClass;
					trans.easingType = transition.easingType;
					//trans.originalValue = null;
					transArray.push( trans );
				}
				newupdate.setTransitions(transArray);
				s.addUpdate(newupdate);
			}
			StoryList.getInstance().removeStory(s, _page);
			return s;
		}

		/**
		 *
		 * ====================
		 * 	GETTERS & SETTERS
		 * ====================
		 *
		 */

		/**
		 *
		 * @return the instance of the page in which the Story takes place
		 */
		public function getPage():Page
		{
			return _page;
		}

		/**
		 *
		 * @return the instance of the page in which the Story takes place
		 */
		public function setPage(page:Page):void
		{
			_page=page;
		}


		/**
		 * this function adds an Update (@see Update.as)
		 * @param update, Update : a part of the Story that targets a specific ParameterSet and its property
		 * (@example : to tween a face from left to right, Update targets "PositionParameterSet" and its property "x");
		 */
		public function addUpdate(update:Update):void
		{
			update.story=this;
			updates.push(update);
			calculateTimes();
		}

		public function calculateTimes():void
		{
			var o:Object=StoryboardUtils.computeStoryDuration(this);
			minTime=o['begin'];
			maxTime=o['end'];
		}

		/**
		 *
		 * @return  Array, the list of Updates in the Story
		 */
		public function getUpdates():Array
		{
			return updates;
		}

		/**
		 *
		 * @return elementDescriptor, the IDescriptor of the face targetted (animated), getterFunction
		 */
		public function getElementDescriptor():IDescriptor
		{
			return elementDescriptor;
		}

		/**
		 * @return identifier of the face targeted, getter
		 */
		public function get target():String
		{
			return elementDescriptor.uuid;
		}


		/**
		 *
		 * @param value String name of the face
		 */
		public function set uuid(value:String):void
		{
			_uuid=value;
		}

		/**
		 *
		 * @return String name of the face
		 */
		public function get uuid():String
		{
			return _uuid;
		}

		/**
		 *
		 * @param value the IDescriptor of the face targetted (animated), setterFunction
		 */
		public function setElementDescriptor(value:IDescriptor):void
		{
			var descriptor:IDescriptor = elementDescriptor;
			this.elementDescriptor=value;
			for each (var update:Update in this.updates)
			{
				var parameterName:String=update.getParameterSetName();
				var property:String=update.getPropertyName();
				update.getParameterSet()[property] = update.originalValue;
				update.getParameterSet().apply(descriptor);
				//refresh(descriptor);
				var parameter:IParameterSet=ElementDescriptorUtils.findParameterSet(elementDescriptor, parameterName);
				update.originalValue = parameter[property];
				update.changeParameter(parameter, property, parameterName);
			}
			//this.init(this.uuid, this.elementDescriptor, this.loop, this._autoPlay, this._autoPlayOnUnload);
		}

		/**
		 *
		 * @return last keyframe time in millliseconds, getter
		 */
		public function get maxTime():int
		{
			return _maxTime;
		}

		/**
		 *
		 * @param value last keyframe time in millliseconds, setter
		 */
		public function set maxTime(value:int):void
		{
			_maxTime=value;
			//if(_loop)
			//{
			removeLoopListener();
			createLoopListener();
			//}
		}

		/**
		 *
		 * @return first keyframe time in millliseconds, getter
		 */
		public function get minTime():int
		{
			return _minTime;
		}

		/**
		 *
		 * @param value first keyframe time in millliseconds, setter
		 */
		public function set minTime(value:int):void
		{
			_minTime=value;
		}

		/**
		 *
		 * @returns the autoPlay prop, getter
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		/**
		 *
		 * @param value last keyframe time in millliseconds, setter
		 */
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay=value;
		}


		/**
		 *
		 * @returns the autoPlay prop, getter
		 */
		public function get autoPlayOnUnload():Boolean
		{
			return _autoPlayOnUnload;
		}

		/**
		 *
		 * @param value last keyframe time in millliseconds, setter
		 */
		public function set autoPlayOnUnload(value:Boolean):void
		{
			_autoPlayOnUnload=value;
		}

		/**
		 *
		 * @return 	Boolean, getter
		 */
		public function get loop():Boolean
		{
			return _loop;
		}

		/**
		 *
		 * @param value Boolean, setter
		 */
		public function set loop(value:Boolean):void
		{
			removeLoopListener();
			_loop=value;
			//if(value)
			//{
			createLoopListener();
			//}
		}

		/**
		 *
		 * @return 	Boolean, getter
		 */
		public function get isPaused():Boolean
		{
			return _isPaused;
		}

		/**
		 *
		 * @param value Boolean, setter
		 */
		public function set isPaused(value:Boolean):void
		{
			_isPaused=value;
		}/**
		 *
		 * @return 	Boolean, getter
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		/**
		 *
		 * @param value Boolean, setter
		 */
		public function set isPlaying(value:Boolean):void
		{
			_isPlaying=value;
		}

		public function get isRelative() : Boolean
		{
			return _isRelative;
		}

		public function set isRelative( value : Boolean  ) : void
		{
			_isRelative = value;
		}
		/**
		 *
		 * @param value  _timeToPause(int) : the time when to stop the animation, in milliseconds
		 */
		public function set timeToPause(value:Number):void
		{
			for each (var u:Update in updates)
			{
				u.timeToPause = value;
			}
		}

		public function removeLoopListener():void
		{
			if (timer != null)
			{
				timer.removeEventListener(TimerEvent.TIMER, playLoop);
				timer.stop();
				timer=null;
			}
		}

		public function removeUpdate(update:Update):void
		{
			update.stop();
			ArrayUtils.removeElement(updates, update);
			update.destroy()
			if (updates.length == 0)
			{
				destroy();
			}
		}

		/**
		 *
		 * ===================
		 * 	HELPERS FUNCS
		 * ===================
		 *
		 */
		public function getAllKeyframes():Array
		{
			var keyframesArray:Array=new Array;
			for each (var update:Update in updates)
			{
				for each (var trans:Transition in update.getTransitions())
				{
					keyframesArray.push(trans.begin);
					keyframesArray.push(trans.end);
				}
			}
			return ArrayUtils.removeDuplicate(keyframesArray);
		}



		public function addUpdateAtKeyframe(parameterSetName:String, propertyName:String, propertyValue:*, prevValue:*, time:uint, easingClass:String="Linear", easingType:String="easeOut"):void
		{
			var update:Update=new Update;
			//update.init(parameterSetName, propertyName, uuid + "0", this);
			update.init(parameterSetName, propertyName, uuid, this);
			update.originalValue = prevValue;
			var transition1:Transition=new Transition;
			var transition2:Transition=new Transition;
			var ClassReference:Class=getDefinitionByName("com.gskinner.motion.easing." + easingClass) as Class;
			// on a 3 cas : soit le temps est avant le minTime, soit après le maxTime, soit entre les deux
			// entre les deux

			if (_loop)
			{
				time=time % _maxTime
			}
			if (time > minTime && time < maxTime)
			{
				transition1.begin=minTime;
				transition1.beginValue=prevValue;
				transition1.end=transition2.begin=time;
				transition1.endValue=transition2.beginValue=propertyValue;
				transition2.end=maxTime;
				transition2.endValue=_loop ? prevValue : propertyValue;
				transition1.easingClass=transition2.easingClass=ClassReference;
				transition1.easingType=transition2.easingType=easingType;
				// on affecte les 2 transitions :
				update.setTransitions([transition1, transition2]);
			}
			// avant
			else if (time <= minTime)
			{
				transition1.begin=time
				transition1.beginValue=propertyValue;
				//transition1.originalValue=prevValue;
				transition1.end=maxTime;
				transition1.endValue=prevValue;
				transition1.easingClass=ClassReference;
				transition1.easingType=easingType;
				update.originalValue=prevValue;
				update.setTransitions([transition1]);
				// on rafraichit le minTime
				minTime=time;
			}
			// apres
			else
			{
				transition1.begin=minTime
				transition1.beginValue=prevValue;
				transition1.end=time;
				transition1.endValue=propertyValue;
				transition1.easingClass=ClassReference;
				transition1.easingType=easingType;
				update.setTransitions([transition1]);
				// on rafraichit le maxTime
				maxTime=time;
			}
			this.addUpdate(update);
		}

	}
}