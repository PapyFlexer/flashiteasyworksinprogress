// ActionScript file
package com.senocular.display
{

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

import com.senocular.display.TransformTool;
import com.senocular.display.TransformToolControl;
import com.senocular.display.TransformToolCursor;
import com.senocular.events.TransformEvent;

// Controls
	public class TransformToolInternalControl extends TransformToolControl {
	
	public var interactionMethod:Function;
	public var referenceName:String;
	public var _skin:DisplayObject;
	
	public function set skin(skin:DisplayObject):void {
		if (_skin && contains(_skin)) {
			removeChild(_skin);
		}
		_skin = skin;
		if (_skin) {
			addChild(_skin);
		}
		draw();
	}
	
	public function get skin():DisplayObject {
		return _skin;
	}
	
	override public function get referencePoint():Point {
		if (referenceName in _transformTool) {
			return _transformTool[referenceName];
		}
		return null;
	}
		
	/*
	 * Constructor
	 */	
	public function TransformToolInternalControl(name:String, interactionMethod:Function = null, referenceName:String = null) {
		this.name = name;
		this.interactionMethod = interactionMethod;
		this.referenceName = referenceName;
		addEventListener(TransformEvent.CONTROL_INIT, init);
	}
	
	protected function init(event:Event):void {
		_transformTool.addEventListener(TransformEvent.NEW_TARGET, draw);
		_transformTool.addEventListener(TransformEvent.TRANSFORM_TOOL, draw);
		_transformTool.addEventListener(TransformEvent.CONTROL_TRANSFORM_TOOL, position);
		_transformTool.addEventListener(TransformEvent.CONTROL_PREFERENCE, draw);
		_transformTool.addEventListener(TransformEvent.CONTROL_MOVE, controlMove);
		draw();
	}
	
	public function draw(event:Event = null):void {
		if (_transformTool.maintainControlForm) {
			counterTransform();
		}
		position();
	}
	
	public function position(event:Event = null):void {
		var reference:Point = referencePoint;
		if (reference) {
			x = reference.x;
			y = reference.y;
		}
	}
	
	private function controlMove(event:TransformEvent):void 
	{
		if (interactionMethod != null && _transformTool.currentControl == this) {
			interactionMethod(event);
		}
	}
}

	
}