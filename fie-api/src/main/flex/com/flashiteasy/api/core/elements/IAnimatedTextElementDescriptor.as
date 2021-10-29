package com.flashiteasy.api.core.elements
{
	public interface IAnimatedTextElementDescriptor extends ITextElementDescriptor
	{
		function setAnimatedTextInTransition( transitionIn : String ):void;
		function setAnimatedTextOutTransition( transitionOut : String ):void;
		function setAnimatedTextSeparationType( separationType : String ):void;
		function setAnimatedTextIterationMode( iterationMode : String ):void;
		function setAnimatedTextDelayBeforeStart( delayBeforeStart : uint ):void;
		function setAnimatedTextInterval( interval : uint ):void;
	}
}