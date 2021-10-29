package edition
{

	

	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.UIComponent;
	
	import transform.ControlSetScaleCorners;
	import transform.ControlSetStandard;
	import transform.TransformTool;
	
	import utils.MatrixUtils;

	public class SelectionManager
	{
		public function SelectionManager()
		{
		}
		
		private var startPosition:Point;
		private var workspace : UIComponent;
		private var tool:TransformTool = new TransformTool(new ControlSetScaleCorners());
		private var startWidth:Number;
		private var startHeight:Number;
		private var startRotation:Number;
		private var selection:Boolean= false;
		private var target:DisplayObject;
		
		public function init( dispatcher : UIComponent ): void
		{
			workspace = dispatcher ;
			workspace.addEventListener(MouseEvent.CLICK , clickHandler);
		}
		
		
		private function clickHandler( event : MouseEvent ) : void
		{
			trace("phase " + event.currentTarget + " " + event.target);
			target = event.target as DisplayObject;
			trace(ElementList.getInstance().contains(target) + " " + target);
			if( ElementList.getInstance().contains(target) )
			{
				this.target = target;
				tool.target = target;
				workspace.addChild(tool);/*
				startWidth=target.width;
				startHeight=target.height;
				startRotation=target.rotation;
				tool.startWidth = startWidth;
				tool.startHeight = startHeight;
				tool.addEventListener(TransformEvent.TRANSFORM_TARGET, updateSelection);
				tool.addEventListener(TransformEvent.CONTROL_UP, saveChanges);*/
				//target.addEventListener(MouseEvent.MOUSE_DOWN, tool.select);
				tool.setTarget(target,null);
			}
			else if(target == tool)
			{
				trace("lol");
				return;
			}
			else
			{
				this.target = null;
				tool.setTarget(null);
			}
		}
		
		private function updateSelection( e : Event ) : void 
		{
			/*
			var width:Number;
			var height:Number;
			var _globalMatrix:Matrix=tool.toolMatrix;
			var angle:Number=MatrixUtils.getAngle(_globalMatrix);
			var topLeft:Point=tool.boundsTopLeft;
			var topRight:Point=tool.boundsTopRight;
			var bottomLeft:Point=tool.boundsBottomLeft;
			width=Math.round(Math.sqrt((topRight.x - topLeft.x) * (topRight.x - topLeft.x) + (topRight.y - topLeft.y) * (topRight.y - topLeft.y)));
			height=Math.round(Math.sqrt((bottomLeft.x - topLeft.x) * (bottomLeft.x - topLeft.x) + (bottomLeft.y - topLeft.y) * (bottomLeft.y - topLeft.y)));
			
			// Calcul de la position de base du selecteur
			
			startPosition=tool.localToGlobal(new Point());
			
			// Decalage en X et Y 
			
			var move_x:int=Math.round(tool.localToGlobal(tool.boundsTopLeft).x - startPosition.x);
			var move_y:int=Math.round(tool.localToGlobal(tool.boundsTopLeft).y - startPosition.y);
			var move_point:Point=new Point();
			var parentMatrix:Matrix;
			var elementPosition:Point;
			
			target.width = width;
			target.height = height;
			
			/*var localPoint:Point=workspace.globalToLocal(tool.localToGlobal(topLeft));
			target.x = localPoint.x;
			target.y = localPoint.y;
			*/
		}
		
		private function saveChanges(e:Event):void
		{
			/*var topLeft:Point=tool.boundsTopLeft;
			var topRight:Point=tool.boundsTopRight;
			var bottomLeft:Point=tool.boundsBottomLeft;

			target.width = Math.round(Math.sqrt((topRight.x - topLeft.x) * (topRight.x - topLeft.x) + (topRight.y - topLeft.y) * (topRight.y - topLeft.y)));;
			target.height = Math.round(Math.sqrt((bottomLeft.x - topLeft.x) * (bottomLeft.x - topLeft.x) + (bottomLeft.y - topLeft.y) * (bottomLeft.y - topLeft.y)));
			startWidth = target.width;
			startHeight=target.height;
			tool.startWidth=startWidth;
			tool.startHeight=startHeight;*/
		}
		
		private function drawSelector():void
		{
			
		}
	}
}