package com.flashiteasy.admin.motion
{
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.motion.IStoryboardPlayer;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Storyboard;
	import com.flashiteasy.api.core.project.storyboard.Transition;
	import com.flashiteasy.api.core.project.storyboard.Update;
	import com.flashiteasy.api.motion.AbstractStoryboardPlayer;
	
	import flash.utils.getQualifiedClassName;
	
	// TimeLine Player : emulating timer with a HSlider...
	public class TimeLineStoryBoardPlayerImpl extends AbstractStoryboardPlayer implements IStoryboardPlayer
	{
		[Bindable]		
		private var _currentTime:int;
		public function get currentTime():int
		{
			return _currentTime;
		}
		public function set	currentTime(value:int):void {
			_currentTime = value;
		}	
		// A map used to store the transition statuses
		
		override public function start( s : Storyboard, time:int = 0 ) : void
		{
			super.start( s );
			// Iterating through the stories
			//for each( var story : Story in getStoryboard().getStories() )
			for each( var story : Story in getStoryboard().getStories() )
			{
				startStory( story );
			}
		}
		
		//private function startStory( s : Story ) : void
		public function startStory( s : Story ) : void
		{
			// For each update
			
			for each( var update : Update in s.getUpdates() )
			{
				startUpdate( s, update, findParameterSet( s.getElementDescriptor().getParameterSet(), update.getParameterSetName() ), update.getPropertyName(),_currentTime );
			}
		}
		
		private function findParameterSet( topLevelParameterSet : IParameterSet, parameterSetName : String ) : IParameterSet
		{
			if( topLevelParameterSet is CompositeParameterSet )
			{
				for each( var pSet : IParameterSet in CompositeParameterSet( topLevelParameterSet ).getParametersSet() )
				{
					if( getQualifiedClassName( pSet ) .split("::")[1] == parameterSetName )
					{
						return pSet;
					}
				}
				
			}
			return null;
		}
		
		private function startUpdate( s : Story,  u : Update, parameterSet : IParameterSet, propertyName : String, value:int ) : void
		{
			if( parameterSet == null )
			{
				trace("Parameter set for update #" + u.getId() + " is null.");
				return;
			}
			for each( var t : Transition in u.getTransitions() )
			{
				//t.startFromTimeLine(_currentTime);
			}
		}
		
		override public function stop( s:Storyboard) : void
		{
			trace("Update is force-ended.");
		}
	}
}