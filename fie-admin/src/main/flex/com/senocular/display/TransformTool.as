package com.senocular.display
{

	import com.flashiteasy.api.utils.DisplayListUtils;
	import com.senocular.events.TransformEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	use namespace mx_internal;

	/**
	 * Creates a transform tool that allows uaers to modify display objects on the screen
	 *
	 * @usage
	 * <pre>
	 * var tool:TransformTool = new TransformTool();
	 * addChild(tool);
	 * tool.target = targetDisplayObject;
	 * </pre>
	 *
	 * While scaling corners or rotating keep shift key hold down to constrain
	 * the transformation
	 *
	 *
	 * @version 0.9.10
	 * @author  Trevor McCauley
	 * @author  http://www.senocular.com
	 * @author  modified by alessandro crugnola (http://www.sephiroth.it)
	 */

	[Event(name="newTarget",type="com.senocular.events.TransformEvent")]
	[Event(name="transformTarget",type="com.senocular.events.TransformEvent")]
	[Event(name="transformTool",type="com.senocular.events.TransformEvent")]
	[Event(name="controlInit",type="com.senocular.events.TransformEvent")]
	[Event(name="controlTransformTool",type="com.senocular.events.TransformEvent")]
	[Event(name="controlDown",type="com.senocular.events.TransformEvent")]
	[Event(name="controlMove",type="com.senocular.events.TransformEvent")]
	[Event(name="controlUp",type="com.senocular.events.TransformEvent")]
	[Event(name="controlPreference",type="com.senocular.events.TransformEvent")]
	[Event(name="registration",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleTopLeft",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleTop",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleTopRight",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleRight",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleBottomRight",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleBottom",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleBottomLeft",type="com.senocular.events.TransformEvent")]
	[Event(name="scaleLeft",type="com.senocular.events.TransformEvent")]
	[Event(name="rotationTopLeft",type="com.senocular.events.TransformEvent")]
	[Event(name="rotationTopRight",type="com.senocular.events.TransformEvent")]
	[Event(name="rotationBottomRight",type="com.senocular.events.TransformEvent")]
	[Event(name="rotationBottomLeft",type="com.senocular.events.TransformEvent")]
	[Event(name="skewTop",type="com.senocular.events.TransformEvent")]
	[Event(name="skewRight",type="com.senocular.events.TransformEvent")]
	[Event(name="skewBottom",type="com.senocular.events.TransformEvent")]
	[Event(name="skewLeft",type="com.senocular.events.TransformEvent")]
	[Event(name="cursorRegistration",type="com.senocular.events.TransformEvent")]
	[Event(name="cursorMove",type="com.senocular.events.TransformEvent")]
	[Event(name="cursorScale",type="com.senocular.events.TransformEvent")]
	[Event(name="cursorRotate",type="com.senocular.events.TransformEvent")]
	[Event(name="cursorSkew",type="com.senocular.events.TransformEvent")]

	public class TransformTool extends UIComponent
	{

		// Variables
		private var _toolInvertedMatrix:Matrix=new Matrix();
		private var _innerRegistration:Point=new Point();
		private var registrationLog:Dictionary=new Dictionary(true);

		private var targetBounds:Rectangle=new Rectangle();

		private var mouseLoc:Point=new Point();
		private var mouseOffset:Point=new Point();
		private var innerMouseLoc:Point=new Point();
		private var interactionStart:Point=new Point();
		private var innerInteractionStart:Point=new Point();
		private var interactionStartAngle:Number=0;
		private var interactionStartMatrix:Matrix=new Matrix();

		private var toolSprites:Sprite=new Sprite();
		private var lines:Sprite=new Sprite();
		private var moveControls:Sprite=new Sprite();
		private var registrationControls:Sprite=new Sprite();
		private var rotateControls:Sprite=new Sprite();
		private var scaleControls:Sprite=new Sprite();
		private var skewControls:Sprite=new Sprite();
		private var cursors:Sprite=new Sprite();
		private var customControls:Sprite=new Sprite();
		private var customCursors:Sprite=new Sprite();

		// With getter/setters
		private var _target:DisplayObject;
		private var _toolMatrix:Matrix=new Matrix();
		private var _globalMatrix:Matrix=new Matrix();

		private var _registration:Point=new Point();

		private var _livePreview:Boolean=true;
		private var _raiseNewTargets:Boolean=false;
		private var _moveNewTargets:Boolean=false;
		private var _moveEnabled:Boolean=true;
		private var _registrationEnabled:Boolean=true;
		private var _rotationEnabled:Boolean=true;
		private var _scaleEnabled:Boolean=true;
		private var _skewEnabled:Boolean=false;
		private var _outlineEnabled:Boolean=true;
		private var _customControlsEnabled:Boolean=true;
		private var _customCursorsEnabled:Boolean=true;
		private var _cursorsEnabled:Boolean=true;
		private var _rememberRegistration:Boolean=false;

		private var _constrainScale:Boolean=true;
		private var _constrainRotationAngle:Number=Math.PI / 4; // default at 45 degrees

		private var _scaleWithRegistration:Boolean;

		private var _moveUnderObjects:Boolean=false;
		private var _maintainControlForm:Boolean=true;
		private var _controlSize:uint=12;

		private var _maxScaleX:Number=Infinity;
		private var _maxScaleY:Number=Infinity;

		private var _boundsTopLeft:Point=new Point();
		private var _boundsTop:Point=new Point();
		private var _boundsTopRight:Point=new Point();
		private var _boundsRight:Point=new Point();
		private var _boundsBottomRight:Point=new Point();
		private var _boundsBottom:Point=new Point();
		private var _boundsBottomLeft:Point=new Point();
		private var _boundsLeft:Point=new Point();
		private var _boundsCenter:Point=new Point();
		private var _trueBoundsTopRight:Point=new Point();

		private var _currentControl:TransformToolControl;

		private var _moveControl:TransformToolControl;
		private var _registrationControl:TransformToolControl;
		private var _outlineControl:TransformToolControl;
		private var _scaleTopLeftControl:TransformToolControl;
		private var _scaleTopControl:TransformToolControl;
		private var _scaleTopRightControl:TransformToolControl;
		private var _scaleRightControl:TransformToolControl;
		private var _scaleBottomRightControl:TransformToolControl;
		private var _scaleBottomControl:TransformToolControl;
		private var _scaleBottomLeftControl:TransformToolControl;
		private var _scaleLeftControl:TransformToolControl;
		private var _rotationTopLeftControl:TransformToolControl;
		private var _rotationTopRightControl:TransformToolControl;
		private var _rotationBottomRightControl:TransformToolControl;
		private var _rotationBottomLeftControl:TransformToolControl;
		private var _skewTopControl:TransformToolControl;
		private var _skewRightControl:TransformToolControl;
		private var _skewBottomControl:TransformToolControl;
		private var _skewLeftControl:TransformToolControl;

		private var _moveCursor:TransformToolCursor;
		private var _registrationCursor:TransformToolCursor;
		private var _rotationCursor:TransformToolCursor;
		private var _scaleCursor:TransformToolCursor;
		private var _skewCursor:TransformToolCursor;

		private var initWidth:Number;
		private var initHeight:Number;
		private var _registrationSetByUser:Boolean=false;

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (targetChanged)
			{
				targetChanged=false;
				_registrationSetByUser=false;
				targetUpdated();
				registration=boundsCenter;
			}
		}


		private var targetChanged:Boolean;

		/**
		 * The display object the transform tool affects
		 */

		public function get target():DisplayObject
		{
			return _target;
		}

		public function get targetbound():Rectangle
		{
			return targetBounds;
		}


		public function set target(d:DisplayObject):void
		{
			// null target, set target as null
			if (d)
				if (d == this || contains(d) || (d is DisplayObjectContainer && (d as DisplayObjectContainer).contains(this)))
					return;

			_target=d;
			if (_target != null)
			{
				initWidth=_target.width;
				initHeight=_target.height;
			}
			targetChanged=true;
			invalidateSize();
			invalidateDisplayList();
		}

		private function targetUpdated():void
		{
			if (!_target)
			{
				_target=null;
				updateControlsVisible();
				dispatchEvent(new TransformEvent(TransformEvent.NEW_TARGET));
				return;
			}
			else
			{
				updateMatrix();
				setNewRegistation();
				updateControlsVisible();
				if (_raiseNewTargets)
				{
					raiseTarget();
				}
			}

			// if not moving new targets, apply transforms
			if (!_moveNewTargets)
			{
				//apply();
			}

			// send event; updates control points
			dispatchEvent(new TransformEvent(TransformEvent.NEW_TARGET));

			// initiate move interaction if applies after controls updated
			if (_moveNewTargets && _moveEnabled && _moveControl)
			{
				//
				_currentControl=_moveControl;
				_currentControl.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}

		/**
		 * When true, new targets are placed at the top of their display list
		 * @see target
		 */
		public function get raiseNewTargets():Boolean
		{
			return _raiseNewTargets;
		}

		public function set raiseNewTargets(b:Boolean):void
		{
			_raiseNewTargets=b;
		}

		/**
		 * When true, new targets are immediately given a move interaction and can be dragged
		 * @see target
		 * @see moveEnabled
		 */
		public function get moveNewTargets():Boolean
		{
			return _moveNewTargets;
		}

		public function set moveNewTargets(b:Boolean):void
		{
			_moveNewTargets=b;
		}

		/**
		 * When true, the target instance scales with the tool as it is transformed.
		 * When false, transforms in the tool are only reflected when transforms are completed.
		 */
		public function get livePreview():Boolean
		{
			return _livePreview;
		}

		public function set livePreview(b:Boolean):void
		{
			_livePreview=b;
		}

		/**
		 * Controls the default Control sizes of controls used by the tool
		 */
		public function get controlSize():uint
		{
			return _controlSize;
		}

		public function set controlSize(n:uint):void
		{
			if (_controlSize != n)
			{
				_controlSize=n;
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		/**
		 * When true, counters transformations applied to controls by their parent containers
		 */
		public function get maintainControlForm():Boolean
		{
			return _maintainControlForm;
		}

		public function set maintainControlForm(b:Boolean):void
		{
			if (_maintainControlForm != b)
			{
				_maintainControlForm=b;
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		/**
		 * When true (default), the transform tool uses an invisible control using the shape of the current
		 * target to allow movement. This means any objects above the target but below the
		 * tool cannot be clicked on since this hidden control will be clicked on first
		 * (allowing you to move objects below others without selecting the objects on top).
		 * When false, the target itself is used for movement and any objects above the target
		 * become clickable preventing tool movement if the target itself is not clicked directly.
		 */
		public function get moveUnderObjects():Boolean
		{
			return _moveUnderObjects;
		}

		public function set moveUnderObjects(b:Boolean):void
		{
			if (_moveUnderObjects != b)
			{
				_moveUnderObjects=b;
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		/**
		 * The transform matrix of the tool
		 * as it exists in its on coordinate space
		 * @see globalMatrix
		 */
		public function get toolMatrix():Matrix
		{
			return _toolMatrix.clone();
		}

		public function set toolMatrix(m:Matrix):void
		{
			updateMatrix(m, false);
			updateRegistration();
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORM_TOOL));
		}

		/**
		 * The transform matrix of the tool
		 * as it appears in global space
		 * @see toolMatrix
		 */
		public function get globalMatrix():Matrix
		{
			var _globalMatrix:Matrix=_toolMatrix.clone();
			_globalMatrix.concat(transform.concatenatedMatrix);
			return _globalMatrix;
		}

		public function set globalMatrix(m:Matrix):void
		{
			updateMatrix(m);
			updateRegistration();
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORM_TOOL));
		}

		/**
		 * The location of the registration point in the tool. Note: registration
		 * points are tool-specific.  If you change the registration point of a
		 * target, the new registration will only be reflected in the tool used
		 * to change that point.
		 * @see registrationEnabled
		 * @see rememberRegistration
		 */
		public function get registration():Point
		{
			return _registration.clone();
		}

		public function set registration(p:Point):void
		{
			_registration=p.clone();
			innerRegistration=toolInvertedMatrix.transformPoint(_registration);
			if (_rememberRegistration)
			{
				registrationLog[_target]=innerRegistration;
			}
			invalidateDisplayList();
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORM_TOOL));
		}

		public function get innerRegistration():Point
		{
			return _innerRegistration;
		}

		public function set innerRegistration(value:Point):void
		{
			_innerRegistration=value.clone();
		}

		public function get toolInvertedMatrix():Matrix
		{
			return _toolInvertedMatrix;
		}

		public function set toolInvertedMatrix(value:Matrix):void
		{
			_toolInvertedMatrix=value.clone();
		}

		/**
		 * The current control being used in the tool if being manipulated.
		 * This value is null if the user is not transforming the tool.
		 */
		public function get currentControl():TransformToolControl
		{
			return _currentControl;
		}

		public function set currentControl(control:TransformToolControl):void
		{
			_currentControl = control;
		}
		/**
		 * Allows or disallows users to move the tool
		 */
		public function get moveEnabled():Boolean
		{
			return _moveEnabled;
		}

		public function set moveEnabled(b:Boolean):void
		{
			if (_moveEnabled != b)
			{
				_moveEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see and move the registration point
		 * @see registration
		 * @see rememberRegistration
		 */
		public function get registrationEnabled():Boolean
		{
			return _registrationEnabled;
		}

		public function set registrationEnabled(b:Boolean):void
		{
			if (_registrationEnabled != b)
			{
				_registrationEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see and adjust rotation controls
		 */
		public function get rotationEnabled():Boolean
		{
			return _rotationEnabled;
		}

		public function set rotationEnabled(b:Boolean):void
		{
			if (_rotationEnabled != b)
			{
				_rotationEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see and adjust scale controls
		 */
		public function get scaleEnabled():Boolean
		{
			return _scaleEnabled;
		}

		public function set scaleEnabled(b:Boolean):void
		{
			if (_scaleEnabled != b)
			{
				_scaleEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see and adjust skew controls
		 */
		public function get skewEnabled():Boolean
		{
			return _skewEnabled;
		}

		public function set skewEnabled(b:Boolean):void
		{
			if (_skewEnabled != b)
			{
				_skewEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see tool boundry outlines
		 */
		public function get outlineEnabled():Boolean
		{
			return _outlineEnabled;
		}

		public function set outlineEnabled(b:Boolean):void
		{
			if (_outlineEnabled != b)
			{
				_outlineEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see native cursors
		 * @see addCursor
		 * @see removeCursor
		 * @see customCursorsEnabled
		 */
		public function get cursorsEnabled():Boolean
		{
			return _cursorsEnabled;
		}

		public function set cursorsEnabled(b:Boolean):void
		{
			if (_cursorsEnabled != b)
			{
				_cursorsEnabled=b;
				updateControlsEnabled();
			}
		}

		/**
		 * Allows or disallows users to see and use custom controls
		 * @see addControl
		 * @see removeControl
		 * @see customCursorsEnabled
		 */
		public function get customControlsEnabled():Boolean
		{
			return _customControlsEnabled;
		}

		public function set customControlsEnabled(b:Boolean):void
		{
			if (_customControlsEnabled != b)
			{
				_customControlsEnabled=b;
				updateControlsEnabled();
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		/**
		 * Allows or disallows users to see custom cursors
		 * @see addCursor
		 * @see removeCursor
		 * @see cursorsEnabled
		 * @see customControlsEnabled
		 */
		public function get customCursorsEnabled():Boolean
		{
			return _customCursorsEnabled;
		}

		public function set customCursorsEnabled(b:Boolean):void
		{
			if (_customCursorsEnabled != b)
			{
				_customCursorsEnabled=b;
				updateControlsEnabled();
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		/**
		 * Allows or disallows users to see custom cursors
		 * @see registration
		 */
		public function get rememberRegistration():Boolean
		{
			return _rememberRegistration;
		}

		public function set rememberRegistration(b:Boolean):void
		{
			_rememberRegistration=b;
			if (!_rememberRegistration)
			{
				registrationLog=new Dictionary(true);
			}
		}

		/**
		 * Allows constraining of scale transformations that scale along both X and Y.
		 */
		public function get constrainScale():Boolean
		{
			return _constrainScale;
		}

		public function set constrainScale(b:Boolean):void
		{
			if (_constrainScale != b)
			{
				_constrainScale=b;
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		[Bindable]
		/**
		 * Change the way the TransformTool handles with scaling
		 * If is set to true scaling will affect all the target sides, according with the current
		 * registration point. Otherwise it will only affect the current scaling control.
		 *
		 */
		public function set scaleWithRegistration(value:Boolean):void
		{
			if (value != _scaleWithRegistration)
			{
				_scaleWithRegistration=value;
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		public function get scaleWithRegistration():Boolean
		{
			return _scaleWithRegistration;
		}


		/**
		 * The angle at which rotation is constrainged when constrainRotation is true
		 */
		public function get constrainRotationAngle():Number
		{
			return _constrainRotationAngle * 180 / Math.PI;
		}

		public function set constrainRotationAngle(n:Number):void
		{
			var angleInRadians:Number=n * Math.PI / 180;
			if (_constrainRotationAngle != angleInRadians)
			{
				_constrainRotationAngle=angleInRadians;
				dispatchEvent(new TransformEvent(TransformEvent.CONTROL_PREFERENCE));
			}
		}

		/**
		 * The maximum scaleX allowed to be applied to a target
		 */
		public function get maxScaleX():Number
		{
			return _maxScaleX;
		}

		public function set maxScaleX(n:Number):void
		{
			_maxScaleX=n;
		}

		/**
		 * The maximum scaleY allowed to be applied to a target
		 */
		public function get maxScaleY():Number
		{
			return _maxScaleY;
		}

		public function set maxScaleY(n:Number):void
		{
			_maxScaleY=n;
		}

		public function get boundsTopLeft():Point
		{
			return _boundsTopLeft.clone();
		}

		public function get trueBoundsTopRight():Point
		{
			return _trueBoundsTopRight.clone();
		}

		public function get boundsTop():Point
		{
			return _boundsTop.clone();
		}

		public function get boundsTopRight():Point
		{
			return _boundsTopRight.clone();
		}

		public function get boundsRight():Point
		{
			return _boundsRight.clone();
		}

		public function get boundsBottomRight():Point
		{
			return _boundsBottomRight.clone();
		}

		public function get boundsBottom():Point
		{
			return _boundsBottom.clone();
		}

		public function get boundsBottomLeft():Point
		{
			return _boundsBottomLeft.clone();
		}

		public function get boundsLeft():Point
		{
			return _boundsLeft.clone();
		}

		public function get boundsCenter():Point
		{
			return _boundsCenter.clone();
		}

		public function get mouse():Point
		{
			return new Point(mouseX, mouseY);
		}

		public function get moveControl():TransformToolControl
		{
			return _moveControl;
		}

		public function get registrationControl():TransformToolControl
		{
			return _registrationControl;
		}

		public function get outlineControl():TransformToolControl
		{
			return _outlineControl;
		}

		public function get scaleTopLeftControl():TransformToolControl
		{
			return _scaleTopLeftControl;
		}

		public function get scaleTopControl():TransformToolControl
		{
			return _scaleTopControl;
		}

		public function get scaleTopRightControl():TransformToolControl
		{
			return _scaleTopRightControl;
		}

		public function get scaleRightControl():TransformToolControl
		{
			return _scaleRightControl;
		}

		public function get scaleBottomRightControl():TransformToolControl
		{
			return _scaleBottomRightControl;
		}

		public function get scaleBottomControl():TransformToolControl
		{
			return _scaleBottomControl;
		}

		public function get scaleBottomLeftControl():TransformToolControl
		{
			return _scaleBottomLeftControl;
		}

		public function get scaleLeftControl():TransformToolControl
		{
			return _scaleLeftControl;
		}

		public function get rotationTopLeftControl():TransformToolControl
		{
			return _rotationTopLeftControl;
		}

		public function get rotationTopRightControl():TransformToolControl
		{
			return _rotationTopRightControl;
		}

		public function get rotationBottomRightControl():TransformToolControl
		{
			return _rotationBottomRightControl;
		}

		public function get rotationBottomLeftControl():TransformToolControl
		{
			return _rotationBottomLeftControl;
		}

		public function get skewTopControl():TransformToolControl
		{
			return _skewTopControl;
		}

		public function get skewRightControl():TransformToolControl
		{
			return _skewRightControl;
		}

		public function get skewBottomControl():TransformToolControl
		{
			return _skewBottomControl;
		}

		public function get skewLeftControl():TransformToolControl
		{
			return _skewLeftControl;
		}

		public function get moveCursor():TransformToolCursor
		{
			return _moveCursor;
		}

		public function get registrationCursor():TransformToolCursor
		{
			return _registrationCursor;
		}

		public function get rotationCursor():TransformToolCursor
		{
			return _rotationCursor;
		}

		public function get scaleCursor():TransformToolCursor
		{
			return _scaleCursor;
		}

		public function get skewCursor():TransformToolCursor
		{
			return _skewCursor;
		}

		public function set startWidth(value:Number):void
		{
			this.initWidth=value;
		}

		public function set startHeight(value:Number):void
		{
			this.initHeight=value;
		}

		/**
		 * TransformTool Constructor.
		 * Creates new instances of the transform tool
		 */


		public function TransformTool()
		{
			super();
			doubleClickEnabled=true;
		}


		override protected function createChildren():void
		{
			createControls();
		}




		// Setup
		private function createControls():void
		{
			if(moveEnabled)
				_moveControl=new TransformToolMoveShape("move", moveInteraction);
			_registrationControl=new TransformToolRegistrationControl(TransformEvent.REGISTRATION, registrationInteraction, "registration");
			_rotationTopLeftControl=new TransformToolRotateControl(TransformEvent.ROTATION_TOP_LEFT, rotationInteraction, "boundsTopLeft");
			_rotationTopRightControl=new TransformToolRotateControl(TransformEvent.ROTATION_TOP_RIGHT, rotationInteraction, "boundsTopRight");
			_rotationBottomRightControl=new TransformToolRotateControl(TransformEvent.ROTATION_BOTTOM_RIGHT, rotationInteraction, "boundsBottomRight");
			_rotationBottomLeftControl=new TransformToolRotateControl(TransformEvent.ROTATION_BOTTOM_LEFT, rotationInteraction, "boundsBottomLeft");
			_scaleTopLeftControl=new TransformToolScaleControl(TransformEvent.SCALE_TOP_LEFT, scaleTopLeftInteraction, "boundsTopLeft");
			_scaleTopControl=new TransformToolScaleControl(TransformEvent.SCALE_TOP, scaleTopInteraction, "boundsTop");
			_scaleTopRightControl=new TransformToolScaleControl(TransformEvent.SCALE_TOP_RIGHT, scaleTopRightInteraction, "boundsTopRight");
			_scaleRightControl=new TransformToolScaleControl(TransformEvent.SCALE_RIGHT, scaleRightInteraction, "boundsRight");
			_scaleBottomRightControl=new TransformToolScaleControl(TransformEvent.SCALE_BOTTOM_RIGHT, scaleBottomRightInteraction, "boundsBottomRight");
			_scaleBottomControl=new TransformToolScaleControl(TransformEvent.SCALE_BOTTOM, scaleBottomInteraction, "boundsBottom");
			_scaleBottomLeftControl=new TransformToolScaleControl(TransformEvent.SCALE_BOTTOM_LEFT, scaleBottomLeftInteraction, "boundsBottomLeft");
			_scaleLeftControl=new TransformToolScaleControl(TransformEvent.SCALE_LEFT, scaleLeftInteraction, "boundsLeft");
			_skewTopControl=new TransformToolSkewBar(TransformEvent.SKEW_TOP, skewXInteraction, "boundsTopRight", "boundsTopLeft", "boundsTopRight");
			_skewRightControl=new TransformToolSkewBar(TransformEvent.SKEW_RIGHT, skewYInteraction, "boundsBottomRight", "boundsTopRight", "boundsBottomRight");
			_skewBottomControl=new TransformToolSkewBar(TransformEvent.SKEW_BOTTOM, skewXInteraction, "boundsBottomLeft", "boundsBottomRight", "boundsBottomLeft");
			_skewLeftControl=new TransformToolSkewBar(TransformEvent.SKEW_LEFT, skewYInteraction, "boundsTopLeft", "boundsBottomLeft", "boundsTopLeft");

			// defining cursors
			_moveCursor=new TransformToolMoveCursor();
			_moveCursor.addReference(_moveControl);

			_registrationCursor=new TransformToolRegistrationCursor();
			_registrationCursor.addReference(_registrationControl);

			_rotationCursor=new TransformToolRotateCursor();
			_rotationCursor.addReference(_rotationTopLeftControl);
			_rotationCursor.addReference(_rotationTopRightControl);
			_rotationCursor.addReference(_rotationBottomRightControl);
			_rotationCursor.addReference(_rotationBottomLeftControl);

			_scaleCursor=new TransformToolScaleCursor();
			_scaleCursor.addReference(_scaleTopLeftControl);
			_scaleCursor.addReference(_scaleTopControl);
			_scaleCursor.addReference(_scaleTopRightControl);
			_scaleCursor.addReference(_scaleRightControl);
			_scaleCursor.addReference(_scaleBottomRightControl);
			_scaleCursor.addReference(_scaleBottomControl);
			_scaleCursor.addReference(_scaleBottomLeftControl);
			_scaleCursor.addReference(_scaleLeftControl);

			_skewCursor=new TransformToolSkewCursor();
			_skewCursor.addReference(_skewTopControl);
			_skewCursor.addReference(_skewRightControl);
			_skewCursor.addReference(_skewBottomControl);
			_skewCursor.addReference(_skewLeftControl);

			// adding controls
			if(moveEnabled)
			addToolControl(moveControls, _moveControl);
			addToolControl(registrationControls, _registrationControl);
			addToolControl(rotateControls, _rotationTopLeftControl);
			addToolControl(rotateControls, _rotationTopRightControl);
			addToolControl(rotateControls, _rotationBottomRightControl);
			addToolControl(rotateControls, _rotationBottomLeftControl);
			addToolControl(scaleControls, _scaleTopControl);
			addToolControl(scaleControls, _scaleRightControl);
			addToolControl(scaleControls, _scaleBottomControl);
			addToolControl(scaleControls, _scaleLeftControl);
			addToolControl(scaleControls, _scaleTopLeftControl);
			addToolControl(scaleControls, _scaleTopRightControl);
			addToolControl(scaleControls, _scaleBottomRightControl);
			addToolControl(scaleControls, _scaleBottomLeftControl);
			addToolControl(skewControls, _skewTopControl);
			addToolControl(skewControls, _skewRightControl);
			addToolControl(skewControls, _skewBottomControl);
			addToolControl(skewControls, _skewLeftControl);
			addToolControl(lines, new TransformToolOutline("outline"), false);

			// adding cursors
			addToolControl(cursors, _moveCursor, false);
			addToolControl(cursors, _registrationCursor, false);
			addToolControl(cursors, _rotationCursor, false);
			addToolControl(cursors, _scaleCursor, false);
			addToolControl(cursors, _skewCursor, false);


			updateControlsEnabled();
		}

		private function addToolControl(container:Sprite, control:TransformToolControl, interactive:Boolean=true):void
		{
			control.transformTool=this;
			if (interactive)
			{
				control.addEventListener(MouseEvent.MOUSE_DOWN, startInteractionHandler, false);
			}
			container.addChild(control);
			control.dispatchEvent(new TransformEvent(TransformEvent.CONTROL_INIT));
			control.doubleClickEnabled=true;
		}

		/**
		 * Allows you to add a custom control to the tool
		 * @see removeControl
		 * @see addCursor
		 * @see removeCursor
		 */
		public function addControl(control:TransformToolControl):void
		{
			addToolControl(customControls, control);
		}

		/**
		 * Allows you to remove a custom control to the tool
		 * @see addControl
		 * @see addCursor
		 * @see removeCursor
		 */
		public function removeControl(control:TransformToolControl):TransformToolControl
		{
			if (customControls.contains(control))
			{
				customControls.removeChild(control);
				return control;
			}
			return null;
		}

		/**
		 * Allows you to add a custom cursor to the tool
		 * @see removeCursor
		 * @see addControl
		 * @see removeControl
		 */
		public function addCursor(cursor:TransformToolCursor):void
		{
			addToolControl(customCursors, cursor);
		}

		/**
		 * Allows you to remove a custom cursor to the tool
		 * @see addCursor
		 * @see addControl
		 * @see removeControl
		 */
		public function removeCursor(cursor:TransformToolCursor):TransformToolCursor
		{
			if (customCursors.contains(cursor))
			{
				customCursors.removeChild(cursor);
				return cursor;
			}
			return null;
		}

		/**
		 * Allows you to change the appearance of default controls
		 * @see addControl
		 * @see removeControl
		 */
		public function setSkin(controlName:String, skin:DisplayObject):void
		{
			var control:TransformToolInternalControl=getControlByName(controlName);
			if (control)
			{
				control.skin=skin;
			}
		}

		/**
		 * Allows you to get the skin of an existing control.
		 * If one was not set, null is returned
		 * @see addControl
		 * @see removeControl
		 */
		public function getSkin(controlName:String):DisplayObject
		{
			var control:TransformToolInternalControl=getControlByName(controlName);
			return control.skin;
		}

		private function getControlByName(controlName:String):TransformToolInternalControl
		{
			var control:TransformToolInternalControl;
			var containers:Array=new Array(skewControls, registrationControls, cursors, rotateControls, scaleControls);
			var i:int=containers.length;
			while (i-- && control == null)
			{
				control=containers[i].getChildByName(controlName) as TransformToolInternalControl;
			}
			return control;
		}


		// TODO: Interaction Handlers
		private function startInteractionHandler(event:MouseEvent):void
		{
			_currentControl=event.currentTarget as TransformToolControl;
			if (_currentControl && _target !=null )
			{
				initWidth=_target.width;
				initHeight=_target.height;

				setupInteraction();
			}
		}

		private function setupInteraction():void
		{
			updateMatrix();
			apply();
			dispatchEvent(new TransformEvent(TransformEvent.CONTROL_DOWN));

			// mouse offset to allow interaction from desired point
			mouseOffset=(_currentControl && _currentControl.referencePoint) ? _currentControl.referencePoint.subtract(new Point(mouseX, mouseY)) : new Point(0, 0);
			updateMouse();

			// set variables for interaction reference
			interactionStart=mouseLoc.clone();
			innerInteractionStart=innerMouseLoc.clone();
			interactionStartMatrix=_toolMatrix.clone();
			interactionStartAngle=distortAngle();
			if (!_registrationSetByUser)
			{
				registration=boundsCenter;
			}
			if (stage)
			{
				// setup stage events to manage control interaction
				stage.addEventListener(MouseEvent.MOUSE_MOVE, interactionHandler);
				//stage.addEventListener(MouseEvent.MOUSE_UP,   endInteractionHandler, false);
				stage.addEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, true);
			}
		}


		private function interactionHandler(event:MouseEvent):void
		{
			// define mouse position for interaction
			updateMouse();

			// use original toolMatrix for reference of interaction
			_toolMatrix=interactionStartMatrix.clone();
			// dispatch events that let controls do their thing
			dispatchEvent(new TransformEvent(TransformEvent.CONTROL_MOVE, false, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
			dispatchEvent(new TransformEvent(TransformEvent.CONTROL_TRANSFORM_TOOL, false, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));

			if (_livePreview)
			{
				// update target if applicable
				apply();
			}
			// smooth sailing
			event.updateAfterEvent();
		}

		private function endInteractionHandler(event:MouseEvent):void
		{
			if (event.eventPhase == EventPhase.BUBBLING_PHASE || !(event.currentTarget is Stage))
			{
				// ignore unrelated events received by stage
				return;
			}
			initWidth=_target.width;
			initHeight=_target.height;
			if (!_livePreview)
			{
				// update target if applicable
				apply();
			}
			// get stage reference from event in case
			// stage is no longer accessible from this instance
			var stageRef:Stage=event.currentTarget as Stage;
			stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, interactionHandler);
			//stageRef.removeEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, false);
			stageRef.removeEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, true);
			dispatchEvent(new TransformEvent(TransformEvent.CONTROL_UP, false, false, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta));
			_currentControl=null;
		}

		// Interaction Transformations
		/**
		 * Control Interaction.  Moves the tool
		 */
		public function moveInteraction(event:TransformEvent):void
		{

			var moveLoc:Point=mouseLoc.subtract(interactionStart);
			
			if (event.shiftKey)
			{
				Math.abs(moveLoc.x) > Math.abs(moveLoc.y) ? _toolMatrix.tx+=moveLoc.x : _toolMatrix.ty+=moveLoc.y;
			}
			else
			{
			_toolMatrix.tx+=moveLoc.x;
			_toolMatrix.ty+=moveLoc.y;
			}
			updateRegistration();
			completeInteraction();
		}

		/**
		 * Control Interaction.  Moves the registration point
		 */
		public function registrationInteraction(event:TransformEvent):void
		{
			// move registration point
			_registration.x=mouseLoc.x;
			_registration.y=mouseLoc.y;
			innerRegistration=toolInvertedMatrix.transformPoint(_registration);

			if (_rememberRegistration)
			{
				// log new registration point for the next
				// time this target is selected
				registrationLog[_target]=innerRegistration;
			}
			_registrationSetByUser=true;
			completeInteraction();
		}

		/**
		 * Control Interaction.  Rotates the tool
		 */
		public function rotationInteraction(event:TransformEvent):void
		{
			// rotate in global transform
			var globalMatrix:Matrix=transform.concatenatedMatrix;
			var globalInvertedMatrix:Matrix=globalMatrix.clone();
			globalInvertedMatrix.invert();
			_toolMatrix.concat(globalMatrix);

			// get change in rotation
			var angle:Number=distortAngle() - interactionStartAngle;

			if (event.shiftKey)
			{
				// constrain rotation based on constrainRotationAngle
				if (angle > Math.PI)
					angle-=Math.PI * 2;
				else if (angle < -Math.PI)
					angle+=Math.PI * 2;

				angle=Math.round(angle / _constrainRotationAngle) * _constrainRotationAngle;
			}

			// apply rotation to toolMatrix
			_toolMatrix.rotate(angle);

			_toolMatrix.concat(globalInvertedMatrix);
			completeInteraction(true);
		}


		/**
		 * Scale left
		 */
		mx_internal function scaleLeftInteraction(event:TransformEvent):void
		{
			
			var distortPoint:Point=distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.x - (_scaleWithRegistration ? innerRegistration.x : initWidth));
			var oldBounds:Point=boundsRight.clone();
			var old:Point=registration.clone();
			_toolMatrix.a+=distortPoint.x;
			_toolMatrix.b+=distortPoint.y;
			
			// check current scale in X
			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				_toolMatrix.tx+=oldBounds.subtract(boundsRight).x;
				_toolMatrix.ty+=oldBounds.subtract(boundsRight).y;
				completeInteraction(false);
				updateRegistration();
			}
		}

		/**
		 * Scale Right
		 */
		mx_internal function scaleRightInteraction(event:TransformEvent):void
		{
			var distortPoint:Point=distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.x - (_scaleWithRegistration ? innerRegistration.x : 0));
			_toolMatrix.a+=distortPoint.x;
			_toolMatrix.b+=distortPoint.y;

			if (!_scaleWithRegistration)
			{
				completeInteraction(false);
				updateRegistration();
			}
			else
			{
				completeInteraction(true);



			}
		}

		/**
		 * Scale Top
		 */
		mx_internal function scaleTopInteraction(event:TransformEvent):void
		{
			var distortPoint:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.y - (_scaleWithRegistration ? innerRegistration.y : initHeight));
			var oldBounds:Point=boundsBottom.clone();
			_toolMatrix.c+=distortPoint.x;
			_toolMatrix.d+=distortPoint.y;

			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				_toolMatrix.tx+=oldBounds.subtract(boundsBottom).x;
				_toolMatrix.ty+=oldBounds.subtract(boundsBottom).y;
				completeInteraction(false);
				updateRegistration();
			}
		}

		/**
		 * Scale Bottom
		 */
		mx_internal function scaleBottomInteraction(event:TransformEvent):void
		{
			var distortPoint:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.y - (_scaleWithRegistration ? innerRegistration.y : 0));
			_toolMatrix.c+=distortPoint.x;
			_toolMatrix.d+=distortPoint.y;

			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				updateRegistration();
			}
		}


		/**
		 * Scale bottom left
		 */
		mx_internal function scaleBottomLeftInteraction(event:TransformEvent):void
		{
			var innerMouseRef:Point=innerMouseLoc.clone();

			if (event.shiftKey)
			{
				// how much the mouse has moved from starting the interaction
				var moved:Point=innerMouseLoc.subtract(innerInteractionStart);
				// the relationship of the start location to the registration point
				var regOffset:Point=innerInteractionStart.subtract(_scaleWithRegistration ? innerRegistration : new Point(initWidth, 0));
				// find the ratios between movement and the registration offset
				var ratioH:Number=regOffset.x ? moved.x / regOffset.x : 0;
				var ratioV:Number=regOffset.y ? moved.y / regOffset.y : 0;
				// have the larger of the movement distances brought down
				// based on the lowest ratio to fit the registration offset
				if (ratioH > ratioV)
					innerMouseRef.x=innerInteractionStart.x + regOffset.x * ratioV;
				else
					innerMouseRef.y=innerInteractionStart.y + regOffset.y * ratioH;
			}

			var oldBounds:Point=boundsTopRight.clone();
			var distortH:Point=distortOffset(new Point(innerMouseRef.x, innerInteractionStart.y), innerInteractionStart.x - (_scaleWithRegistration ? innerRegistration.x : initWidth));
			var distortV:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseRef.y), innerInteractionStart.y - (_scaleWithRegistration ? innerRegistration.y : 0));

			_toolMatrix.a+=distortH.x;
			_toolMatrix.b+=distortH.y;
			_toolMatrix.c+=distortV.x;
			_toolMatrix.d+=distortV.y;

			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				_toolMatrix.tx+=oldBounds.subtract(boundsTopRight).x;
				_toolMatrix.ty+=oldBounds.subtract(boundsTopRight).y;
				completeInteraction(false);
				updateRegistration();
			}
		}


		/**
		 * Scale bottom right
		 */
		mx_internal function scaleBottomRightInteraction(event:TransformEvent):void
		{
			var innerMouseRef:Point=innerMouseLoc.clone();

			if (event.shiftKey)
			{
				// how much the mouse has moved from starting the interaction
				var moved:Point=innerMouseLoc.subtract(innerInteractionStart);
				// the relationship of the start location to the registration point
				var regOffset:Point=innerInteractionStart.subtract(_scaleWithRegistration ? innerRegistration : new Point());
				// find the ratios between movement and the registration offset
				var ratioH:Number=regOffset.x ? moved.x / regOffset.x : 0;
				var ratioV:Number=regOffset.y ? moved.y / regOffset.y : 0;
				// have the larger of the movement distances brought down
				// based on the lowest ratio to fit the registration offset
				if (ratioH > ratioV)
					innerMouseRef.x=innerInteractionStart.x + regOffset.x * ratioV;
				else
					innerMouseRef.y=innerInteractionStart.y + regOffset.y * ratioH;
			}

			var distortH:Point=distortOffset(new Point(innerMouseRef.x, innerInteractionStart.y), innerInteractionStart.x - (_scaleWithRegistration ? innerRegistration.x : 0));
			var distortV:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseRef.y), innerInteractionStart.y - (_scaleWithRegistration ? innerRegistration.y : 0));

			_toolMatrix.a+=distortH.x;
			_toolMatrix.b+=distortH.y;
			_toolMatrix.c+=distortV.x;
			_toolMatrix.d+=distortV.y;

			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				updateRegistration();
			}
		}


		/**
		 * Scale top left
		 */
		mx_internal function scaleTopLeftInteraction(event:TransformEvent):void
		{
			var innerMouseRef:Point=innerMouseLoc.clone();

			if (event.shiftKey)
			{
				// how much the mouse has moved from starting the interaction
				var moved:Point=innerMouseLoc.subtract(innerInteractionStart);
				// the relationship of the start location to the registration point
				var regOffset:Point=innerInteractionStart.subtract(_scaleWithRegistration ? innerRegistration : new Point(initWidth, initHeight));
				// find the ratios between movement and the registration offset
				var ratioH:Number=regOffset.x ? moved.x / regOffset.x : 0;
				var ratioV:Number=regOffset.y ? moved.y / regOffset.y : 0;
				// have the larger of the movement distances brought down
				// based on the lowest ratio to fit the registration offset
				if (ratioH > ratioV)
					innerMouseRef.x=innerInteractionStart.x + regOffset.x * ratioV;
				else
					innerMouseRef.y=innerInteractionStart.y + regOffset.y * ratioH;
			}

			var oldBounds:Point=boundsBottomRight.clone();
			var distortH:Point=distortOffset(new Point(innerMouseRef.x, innerInteractionStart.y), innerInteractionStart.x - (_scaleWithRegistration ? innerRegistration.x : initWidth));
			var distortV:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseRef.y), innerInteractionStart.y - (_scaleWithRegistration ? innerRegistration.y : initHeight));

			_toolMatrix.a+=distortH.x;
			_toolMatrix.b+=distortH.y;
			_toolMatrix.c+=distortV.x;
			_toolMatrix.d+=distortV.y;

			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				_toolMatrix.tx+=oldBounds.subtract(boundsBottomRight).x;
				_toolMatrix.ty+=oldBounds.subtract(boundsBottomRight).y;
				completeInteraction(false);
				updateRegistration();
			}
		}

		/**
		 * Scale top right
		 */
		mx_internal function scaleTopRightInteraction(event:TransformEvent):void
		{
			var innerMouseRef:Point=innerMouseLoc.clone();

			if (event.shiftKey)
			{
				// how much the mouse has moved from starting the interaction
				var moved:Point=innerMouseLoc.subtract(innerInteractionStart);
				// the relationship of the start location to the registration point
				var regOffset:Point=innerInteractionStart.subtract(_scaleWithRegistration ? innerRegistration : new Point(0, initHeight));
				// find the ratios between movement and the registration offset
				var ratioH:Number=regOffset.x ? moved.x / regOffset.x : 0;
				var ratioV:Number=regOffset.y ? moved.y / regOffset.y : 0;
				// have the larger of the movement distances brought down
				// based on the lowest ratio to fit the registration offset
				if (ratioH > ratioV)
					innerMouseRef.x=innerInteractionStart.x + regOffset.x * ratioV;
				else
					innerMouseRef.y=innerInteractionStart.y + regOffset.y * ratioH;
			}

			var oldBounds:Point=boundsBottomLeft.clone();
			var distortH:Point=distortOffset(new Point(innerMouseRef.x, innerInteractionStart.y), innerInteractionStart.x - (_scaleWithRegistration ? innerRegistration.x : 0));
			var distortV:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseRef.y), innerInteractionStart.y - (_scaleWithRegistration ? innerRegistration.y : initHeight));

			_toolMatrix.a+=distortH.x;
			_toolMatrix.b+=distortH.y;
			_toolMatrix.c+=distortV.x;
			_toolMatrix.d+=distortV.y;

			if (_scaleWithRegistration)
			{
				completeInteraction(true);
			}
			else
			{
				completeInteraction(false);
				_toolMatrix.ty+=oldBounds.subtract(boundsBottomLeft).y;
				completeInteraction(false);
				updateRegistration();
			}
		}



		/**
		 * Control Interaction.  Skews the tool along the X axis
		 */
		public function skewXInteraction(event:TransformEvent):void
		{
			var distortH:Point=distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.y - innerRegistration.y);
			_toolMatrix.c+=distortH.x;
			_toolMatrix.d+=distortH.y;
			completeInteraction(true);
		}

		/**
		 * Control Interaction.  Skews the tool along the Y axis
		 */
		public function skewYInteraction(event:TransformEvent):void
		{
			var distortV:Point=distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.x - innerRegistration.x);
			_toolMatrix.a+=distortV.x;
			_toolMatrix.b+=distortV.y;
			completeInteraction(true);
		}

		private function distortOffset(offset:Point, regDiff:Number):Point
		{
			// get changes in matrix combinations based on targetBounds
			var ratioH:Number=regDiff ? targetBounds.width / regDiff : 0;
			var ratioV:Number=regDiff ? targetBounds.height / regDiff : 0;
			offset=interactionStartMatrix.transformPoint(offset).subtract(interactionStart);
			offset.x*=targetBounds.width ? ratioH / targetBounds.width : 0;
			offset.y*=targetBounds.height ? ratioV / targetBounds.height : 0;
			return offset;
		}

		private function completeInteraction(offsetReg:Boolean=false):void
		{
			enforceLimits();
			if (offsetReg)
			{
				
				// offset of registration to have transformations based around
				// custom registration point
				var offset:Point=_registration.subtract(_toolMatrix.transformPoint(innerRegistration));
				_toolMatrix.tx+=offset.x;
				_toolMatrix.ty+=offset.y;
			}
			updateBounds();
		}

		// Information
		private function distortAngle():Number
		{
			// use global mouse and registration
			var globalMatrix:Matrix=transform.concatenatedMatrix;
			var gMouseLoc:Point=globalMatrix.transformPoint(mouseLoc);
			var gRegistration:Point=globalMatrix.transformPoint(_registration);

			// distance and angle of mouse from registration
			var offset:Point=gMouseLoc.subtract(gRegistration);
			return Math.atan2(offset.y, offset.x);
		}

		// Updates
		private function updateMouse():void
		{
			mouseLoc=new Point(mouseX, mouseY).add(mouseOffset);
			innerMouseLoc=toolInvertedMatrix.transformPoint(mouseLoc);
		}

		private function updateMatrix(useMatrix:Matrix=null, counterTransform:Boolean=true):void
		{
			if (_target)
			{
				//Here we use a custom function to avoid a bug in transform.ConcatenedMatrix when the _target.parent is filtered
				_toolMatrix=useMatrix ? useMatrix.clone() : DisplayListUtils.customConcatenatedMatrix(_target).clone();//_target.transform.concatenatedMatrix.clone();
				//_toolMatrix=DisplayListUtils.customConcatenatedMatrix(_target).clone();
				if (counterTransform)
				{
					// counter transform of the parents of the tool
					var current:Matrix=_target.parent is Container ? DisplayListUtils.customConcatenatedMatrix(this) : transform.concatenatedMatrix;
					current.invert();
					_toolMatrix.concat(current);
				}
				enforceLimits();
				toolInvertedMatrix=_toolMatrix.clone();
				toolInvertedMatrix.invert();
				updateBounds();
			}
		}

		private function updateBounds():void
		{
			if (_target)
			{
				//if(this.boundsCenter!=this.boundsLeft){
				targetBounds=DisplayListUtils.getTrueBounds(_target);

				_boundsTopLeft=_toolMatrix.transformPoint(new Point(targetBounds.left, targetBounds.top));
				_boundsTopRight=_toolMatrix.transformPoint(new Point(initWidth, targetBounds.top));
				var trueBoundsBottomRight:Point=_toolMatrix.transformPoint(new Point(targetBounds.right, targetBounds.bottom));
				_trueBoundsTopRight=_toolMatrix.transformPoint(new Point(targetBounds.right, targetBounds.top));
				_boundsBottomRight=_toolMatrix.transformPoint(new Point(initWidth, initHeight));
				_boundsBottomLeft=_toolMatrix.transformPoint(new Point(targetBounds.left, initHeight));
				_boundsTop=Point.interpolate(_boundsTopLeft, _boundsTopRight, .5);
				_boundsRight=Point.interpolate(_boundsTopRight, _boundsBottomRight, .5);
				_boundsBottom=Point.interpolate(_boundsBottomRight, _boundsBottomLeft, .5);
				_boundsLeft=Point.interpolate(_boundsBottomLeft, _boundsTopLeft, .5);
				_boundsCenter=Point.interpolate(_boundsTopLeft, _boundsBottomRight, .5);
				//}
			}
		}

		private function updateControlsVisible():void
		{
			// show toolSprites only if there is a valid target
			var isChild:Boolean=contains(toolSprites);
			if (_target)
			{
				if (!isChild)
				{
					addChild(toolSprites);
				}
			}
			else if (isChild)
			{
				removeChild(toolSprites);
			}
		}

		private function updateControlsEnabled():void
		{
			// highest arrangement
			updateControlContainer(customCursors, _customCursorsEnabled);
			updateControlContainer(cursors, _cursorsEnabled);
			updateControlContainer(customControls, _customControlsEnabled);
			updateControlContainer(registrationControls, _registrationEnabled);
			updateControlContainer(scaleControls, _scaleEnabled);
			updateControlContainer(skewControls, _skewEnabled);
			updateControlContainer(moveControls, _moveEnabled);
			updateControlContainer(rotateControls, _rotationEnabled);
			updateControlContainer(lines, _outlineEnabled);
			// lowest arrangement
		}

		private function updateControlContainer(container:Sprite, enabled:Boolean):void
		{
			var isChild:Boolean=toolSprites.contains(container);
			if (enabled)
			{
				// add child or sent to bottom if enabled
				if (isChild)
				{
					toolSprites.setChildIndex(container, 0);
				}
				else
				{
					toolSprites.addChildAt(container, 0);
				}
			}
			else if (isChild)
			{
				// removed if disabled
				toolSprites.removeChild(container);
			}
		}

		private function updateRegistration():void
		{
			_registration=_toolMatrix.transformPoint(innerRegistration);
		}

		private function enforceLimits():void
		{

			var currScale:Number;
			var angle:Number;
			var enforced:Boolean=false;

			// use global matrix
			var _globalMatrix:Matrix=_toolMatrix.clone();
			_globalMatrix.concat(transform.concatenatedMatrix);

			// check current scale in X
			currScale=Math.sqrt(_globalMatrix.a * _globalMatrix.a + _globalMatrix.b * _globalMatrix.b);
			if (currScale > _maxScaleX)
			{
				// set scaleX to no greater than _maxScaleX
				angle=Math.atan2(_globalMatrix.b, _globalMatrix.a);
				_globalMatrix.a=Math.cos(angle) * _maxScaleX;
				_globalMatrix.b=Math.sin(angle) * _maxScaleX;
				enforced=true;
			}

			// check current scale in Y
			currScale=Math.sqrt(_globalMatrix.c * _globalMatrix.c + _globalMatrix.d * _globalMatrix.d);
			if (currScale > _maxScaleY)
			{
				// set scaleY to no greater than _maxScaleY
				angle=Math.atan2(_globalMatrix.c, _globalMatrix.d);
				_globalMatrix.d=Math.cos(angle) * _maxScaleY;
				_globalMatrix.c=Math.sin(angle) * _maxScaleY;
				enforced=true;
			}


			// if scale was enforced, apply to _toolMatrix
			if (enforced)
			{
				_toolMatrix=_globalMatrix;
				var current:Matrix=transform.concatenatedMatrix;
				current.invert();
				_toolMatrix.concat(current);
			}
		}

		// Render
		private function setNewRegistation():void
		{
			if (_rememberRegistration && _target in registrationLog)
			{

				// retrieved saved reg point in log
				var savedReg:Point=registrationLog[_target];
				innerRegistration=registrationLog[_target];
			}
			else
			{

				// use internal own point
				innerRegistration=new Point(0, 0);
			}
			updateRegistration();
		}

		private function raiseTarget():void
		{
			// set target to last object in display list
			var index:int=_target.parent.numChildren - 1;
			_target.parent.setChildIndex(_target, index);

			// if this tool is in the same display list
			// raise it to the top above target
			if (_target.parent == parent)
			{
				parent.setChildIndex(this, index);
			}
		}

		/**
		 * Draws the transform tool over its target instance
		 */
		public function draw():void
		{
			// update the matrix and draw controls
			updateMatrix();
			dispatchEvent(new TransformEvent(TransformEvent.TRANSFORM_TOOL));
		}

		/**
		 * Applies the current tool transformation to its target instance
		 */
		public function apply():void
		{
			if (_target)
			{
				/*
				// get matrix to apply to target
				var applyMatrix:Matrix=_toolMatrix.clone();
				applyMatrix.concat(transform.concatenatedMatrix);

				// if target has a parent, counter parent transformations
				if (_target.parent)
				{
					var invertMatrix:Matrix=target.parent.transform.concatenatedMatrix;
					invertMatrix.invert();
					applyMatrix.concat(invertMatrix);
				}
				//_target.transform.matrix = applyMatrix;
				*/
				dispatchEvent(new TransformEvent(TransformEvent.TRANSFORM_TARGET));
			}
		}
	}
}