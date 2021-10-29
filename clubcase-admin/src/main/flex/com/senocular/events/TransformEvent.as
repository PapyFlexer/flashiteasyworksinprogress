package com.senocular.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.InteractiveObject;

	public class TransformEvent extends Event
	{
		// Event constants
		public static const NEW_TARGET:String = "newTarget";
		public static const TRANSFORM_TARGET:String = "transformTarget";
		public static const TRANSFORM_TOOL:String = "transformTool";
		public static const CONTROL_INIT:String = "controlInit";
		public static const CONTROL_TRANSFORM_TOOL:String = "controlTransformTool";
		public static const CONTROL_DOWN:String = "controlDown";
		public static const CONTROL_MOVE:String = "controlMove";
		public static const CONTROL_UP:String = "controlUp";
		public static const CONTROL_PREFERENCE:String = "controlPreference";
		
		// Skin constants
		public static const REGISTRATION:String = "registration";
		public static const SCALE_TOP_LEFT:String = "scaleTopLeft";
		public static const SCALE_TOP:String = "scaleTop";
		public static const SCALE_TOP_RIGHT:String = "scaleTopRight";
		public static const SCALE_RIGHT:String = "scaleRight";
		public static const SCALE_BOTTOM_RIGHT:String = "scaleBottomRight";
		public static const SCALE_BOTTOM:String = "scaleBottom";
		public static const SCALE_BOTTOM_LEFT:String = "scaleBottomLeft";
		public static const SCALE_LEFT:String = "scaleLeft";
		public static const ROTATION_TOP_LEFT:String = "rotationTopLeft";
		public static const ROTATION_TOP_RIGHT:String = "rotationTopRight";
		public static const ROTATION_BOTTOM_RIGHT:String = "rotationBottomRight";
		public static const ROTATION_BOTTOM_LEFT:String = "rotationBottomLeft";
		public static const SKEW_TOP:String = "skewTop";
		public static const SKEW_RIGHT:String = "skewRight";
		public static const SKEW_BOTTOM:String = "skewBottom";
		public static const SKEW_LEFT:String = "skewLeft";
		public static const CURSOR_REGISTRATION:String = "cursorRegistration";
		public static const CURSOR_MOVE:String = "cursorMove";
		public static const CURSOR_SCALE:String = "cursorScale";
		public static const CURSOR_ROTATION:String = "cursorRotate";
		public static const CURSOR_SKEW:String = "cursorSkew";

		public var localX:Number;		
		public var localY:Number;
		public var relatedObject:InteractiveObject;
		public var ctrlKey:Boolean;
		public var altKey:Boolean;
		public var shiftKey:Boolean;
		public var buttonDown:Boolean;
		public var delta:int;
		
		public function TransformEvent(
				_type:String, 
				_bubbles:Boolean = false, 
				_cancelable:Boolean = false, 
				_localX:Number = 0.0, 
				_localY:Number = 0.0, 
				_relatedObject:InteractiveObject = null, 
				_ctrlKey:Boolean = false,
				_altKey:Boolean = false, 
				_shiftKey:Boolean = false, 
				_buttonDown:Boolean = false, 
				_delta:int = 0)
		{
			super(_type, _bubbles, _cancelable);
			
			localX = _localX;
			localY = _localY;
			relatedObject = _relatedObject;
			ctrlKey = _ctrlKey;
			altKey = _altKey;
			shiftKey = _shiftKey;
			buttonDown = _buttonDown;
			delta = _delta;
		}
		
		
		public override function clone():Event
		{
			return new TransformEvent(type);
		}			
		
	}
}