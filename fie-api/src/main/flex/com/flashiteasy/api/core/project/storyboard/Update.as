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
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ElementDescriptorUtils;
	import com.flashiteasy.api.utils.StoryboardUtils;
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * The <code><strong>Update</strong></code> class represents a single element of a Story, concerning a single target.
	 */

	public class Update
	{
		/**
		 * 
		 * ===================================
		 * 			PRIVATE VARS
		 * ===================================
		 * 
		 */

		
		private var transitions : Array = [];
		private var keyFrames : Array = [];
		private var parameterSetName : String;
		private var propertyName : String;
		private var id : String;
		private var _story:Story;
		private var parameter : IParameterSet;
		private var _originalValue : *;
		
		
		/**
		 * 
		 * This function initializes the update, charging it with its properties
		 * 
		 * @param parameterSetName 	:	String, the ParameterSet to tween (@example 'RotationParameterSet').
		 * @param propertyName		:	String, the property ffrom the ParameterSet that will be teened (must be numeric)
		 * @param id				: 	int, update's id
		 * @param story				:	Story, the owner of the update
		 */
		public function init( parameterSetName : String, propertyName : String, id : String, story:Story ) : void
		{
			this.parameterSetName = parameterSetName;
			this.propertyName = propertyName;
			this.id = id;
			_story = story
			parameter = ElementDescriptorUtils.findParameterSet(story.getElementDescriptor() , parameterSetName );
			_originalValue = parameter[propertyName];
		}
		/**
		 * This function adds a Transition to the Update
		 * 
		 * @param t Transition to be added (defined by at least two keyframes on timeline)
		 */
		public function addTransition( t : Transition ) : void
		{
			t.story = _story;
			t.init(parameter, this.propertyName, _story, this);
			transitions.push( t );
			
		}
		
		/**
		 * 
		 * @param t
		 */
		public function removeTransition( t : Transition ) : void
		{
			// TODO
			for each (var tr : Transition in this.transitions)
			{
				if (tr == t)
				{
					ArrayUtils.removeElement( transitions , tr ) ;
					t.destroy(true);
					if(transitions.length == 0 )
					{
						destroy();
					}
					else
					{
						_story.calculateTimes();
						_story.start();
					}
				}
			}
		}
		
		/**
		 * 
		 */
		public function removeAllTransitions() : void
		{
			transitions = [];
		}
		
		public function hasTransition():Boolean
		{
			return transitions.length > 0 ;
		}

		/**
		 * 
		 * ===================
		 * 	GETTERS & SETTERS
		 * ===================
		 * 
		 */
		/**
		 * 
		 * @param value
		 */
		public function setTransitions( value : Array ) : void
		{
			transitions = value;
			
			for each (var t:Transition in transitions)
			{
				if(!t.inited && story.getElementDescriptor() != null)
				t.init(parameter,propertyName,story,this);
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getTransitions() : Array
		{
			return transitions;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getId() : String
		{
			return id;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getParameterSetName() : String
		{
			return parameterSetName;
		}
		
		public function getParameterSet(): IParameterSet
		{
			return parameter;
		}
		
		
		/**
		 * 
		 * @return 
		 */
		public function getPropertyName() : String
		{
			return propertyName;
		}

		/**
		 * 
		 * @return  Story, the owner of the Update, getter
		 */
		public function get story():Story
		{
			return _story;
		}
		
		/**
		 * 
		 * @param value Story, the owner of the Update, setter
		 */
		public function set story(value:Story):void
		{
			_story = value;
		}
		
		/**
		 * 
		 * ===================
		 * 	HELPERS FUNCS
		 * ===================
		 * 
		 */

		/**
		 * 
		 * @param time : the delay of the update, default=0
		 */
		public function start(time:int = 0):void
		{
			for each (var t:Transition in transitions)
			{
				t.start(time );
			}
		}
		
		// Change the parameterSet and property of the update and reset the animation
		
		public function changeParameter ( parameter : IParameterSet , property : String, parameterName:String ) : void  
		{
			
			var descriptor : IDescriptor = this.story.getElementDescriptor();
			//first get back original
			parameter[propertyName] = originalValue;
			parameter.apply(descriptor);
			
			this.parameter = parameter ;
			this.propertyName = property ;
			this.parameterSetName = parameterName ;
			var resetValue : Boolean = true;
			//parameterSet.apply(descriptor);
			//refresh(descriptor);
			//var originalValue = ElementDescriptorUtils.findParameterSet(this.story.getElementDescriptor(), parameterSetName)[propertyName];
			//Changing each transitions and resetValue of the control with the first transition
			for each (var t:Transition in transitions)
			{
				if(resetValue)
				{
					//t.resetValue();
				}
				//t.originalValue = originalValue;
				trace("t.originalValue : "+t.originalValue);
				//t.originalValue = this.story.getElementDescriptor().getParameterSet()
				resetValue = false;
				t.init(parameter,propertyName,story,this,resetValue);
				t.start(0 );
			}
		}
		
		/**
		 * 
		 * @param time : where the update must go
		 */
		public function goToTimeAndPlay(time:int = 0):void
		{
			var t:Transition;
			for each (t in transitions)
			{
				//trace("transition :: "+t.endValue);
				if(!t.inited)
				{
					t.start();
					t.stop();
					
				}
				t.goToTimeAndStart(time);
			}
		}
		/**
		 * 
		 * @param time : where the update must go
		 */
		public function goToTimeAndStop(time:int = 0):void
		{
			var t:Transition;
			for each (t in transitions)
			{
				//trace("transition :: "+t.endValue);
				if(!t.inited)
				{
					t.start();
					t.stop();
					
				}
				t.goToTimeAndStop(time);
			}
		}
		
		public function calculateMaxTime():int
		{
			var maxTime : int = 0 ;
			for each ( var t : Transition in transitions ) 
			{
				if(t.end > maxTime )
				{
					maxTime = t.end ;
				}
			}
			return maxTime ;
		}
		
		public function stop():void
		{
			for each (var t:Transition in transitions)
			{
				t.stop();
			}
		}
		
		public function changeAllKeyFrameTime(time:Number) : void
		{
			var timeDifference:Number = time-Transition(transitions[0]).begin;
			for each(var transition:Transition in transitions )
			{
				//check for not disturbing order
				if((transition.begin+timeDifference)>transition.end)
				{
					transition.end += timeDifference;
					transition.begin += timeDifference;
				}
				else
				{
					transition.begin += timeDifference;
					transition.end += timeDifference;
					
				}
			}
			story.maxTime=StoryboardUtils.computeStoryDuration(story)["end"];
			story.minTime=StoryboardUtils.computeStoryDuration(story)["begin"];
			
		}
		
		public function changeKeyFrameTime( index : int , time : Number ) : void 
		{
			var transition : Transition ;
			if( index == 0 )
			{
				transition = transitions[0];
				transition.begin = Number ( time );

			}
			else
			{
				var previousKeyFrame : Number = Transition(transitions[0]).begin;
				var i : int = 0;
				for each( transition in transitions )
				{

					if( previousKeyFrame != transition.begin )
					{
						i++;
					}
					if( i == index )
					{
						transition.begin=time;
					}
					i++;
					previousKeyFrame = transition.end;
					if( i == index ) 
					{
						transition.end = time ;
					}
					
				}
			}
			story.maxTime=StoryboardUtils.computeStoryDuration(story)["end"];
			story.minTime=StoryboardUtils.computeStoryDuration(story)["begin"];
		}
		
		public function divideTransition( transIndex : uint, time : uint, value : *, easingClass:String = null, easingType:String = null ):void
		{
			var transition1 : Transition = new Transition;
			var transition2 : Transition = new Transition;
			var transition : Transition = Transition(transitions[transIndex]);
			// equations
			transition1.easingClass = easingClass == null ? transition.easingClass : getDefinitionByName("com.gskinner.motion.easing."+easingClass) as Class;
			transition2.easingClass = transition.easingClass;
			transition1.easingType = easingType == null ? transition.easingType : easingType;
			transition2.easingType = transition.easingType;
			// d??but
			transition1.begin = transition.begin;
			transition1.beginValue = transition.beginValue;
			// milieu
			transition1.end = transition2.begin = time;
			transition1.endValue = transition2.beginValue = value;
			//fin
			transition2.end = transition.end;
			transition2.endValue = transition.endValue;
			// on retire la transition originale et on ajoute les deux autres
			transitions.splice(transIndex, 1, transition1, transition2);
			transition1.init(this.parameter,this.propertyName,story, this);
			transition2.init(this.parameter,this.propertyName,story,this);
		}
		
		public function addKeyFrameAtTime( time : uint, value : *, easingClass:String = null, easingType:String = null) : void
		{
			var transition : Transition ;
			//this._story.loop
			if(_story.loop)
			{
				time = time%_story.maxTime;
			}
			// on suppose que le temps pass?? en argument est bien compris entre 2 keyframes existantes
			if (time < this._story.maxTime && time > this._story.minTime)
			{
				// quel est l'index de la transition correspondante au temps pass?? en argument ?
				var i : int = -1;
				for each ( transition in transitions )
				{
					i++;
					if ( time > transition.begin && time< transition.end)
					{
						divideTransition(i, time, value, easingClass, easingType);
						return void;
					}
				}
			}
			
			// sinon, on est soit avant,
			else if (time < story.minTime)
			{
				transition = new Transition;
				transition.begin = time
				transition.beginValue = value;
				transition.end = Transition( transitions[0]).begin;
				transition.endValue = Transition( transitions[0]).beginValue;
				transition.easingClass = easingClass == null ? Transition( transitions[0]).easingClass : getDefinitionByName("com.gskinner.motion.easing."+easingClass) as Class;

				//transition.easingClass = Transition( transitions[0]).easingClass;
				transition.easingType = easingType == null ? Transition( transitions[0]).easingType : easingType;
				// on ajoute ?? l'array de transitions
				transitions.unshift(transition);
				// et on moodifie la story en cons??quence
				transition.init(this.parameter,this.propertyName,story, this);
				story.minTime=time;
			}
			// ... soit apr??s.
			else
			{
				transition = new Transition;
				transition.begin = Transition( transitions[transitions.length - 1]).end;
				transition.beginValue = Transition( transitions[transitions.length - 1]).endValue;
				transition.end = time;
				transition.endValue = value;
				transition.easingClass = Transition( transitions[transitions.length - 1]).easingClass;
				transition.easingType = Transition( transitions[transitions.length - 1]).easingType;
				// on ajoute ?? l'array de transitions
				transitions.push(transition);
				// et on moodifie la story en cons??quence
				transition.init(this.parameter,this.propertyName,story, this);
				story.maxTime=time;
			} 
		}
		
		public function changeKeyframeValue(transIndex : uint, value : *, begin : Boolean) : void
		{
			begin ? Transition(transitions[transIndex]).beginValue = value : Transition(transitions[transIndex]).endValue = value;
		}
		
		public function changeKeyframeEasing(transIndex : uint, easingClass:String = "Linear", easingType : String = "easeOut") : void
		{
			
			var ClassReference:Class = getDefinitionByName("com.gskinner.motion.easing."+easingClass) as Class;
			Transition(transitions[transIndex]).easingClass = ClassReference;
			Transition(transitions[transIndex]).easingType = easingType;
		}
		
		public function reset():void
		{
			var reset : Boolean = true;
			for each (var t:Transition in transitions)
			{
				t.stop();
				t.resetValue();
			}
		}
		
		public function destroy( reset : Boolean = true ):void
		{
			for each (var t:Transition in transitions)
			{
				if(reset)
				{
					if ( t.begin == _story.minTime )
					{
						t.destroy( true ); // reset the value of the parameterSet
					}
					else
					{
						//t.destroy();
						t.destroy(true);
					}
				}
				else
				{
					t.destroy();
				}
				transitions=[];
				story.removeUpdate(this);
			}
			
		}
		
		public function pause():void
		{
			for each (var t:Transition in transitions)
			{
				t.pause();
			}
		}
		
		public function resume() : void
		{
			for each (var t:Transition in transitions)
			{
				t.resume();
			}
		}
		
		/**
		 *
		 * @param value  _timeToPause(int) : the time when to stop the animation, in milliseconds
		 */
		public function set timeToPause(value:Number):void
		{
			for each (var t:Transition in transitions)
			{
				t.timeToPause = value;
			}
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
			return _originalValue;
		}

	}
}