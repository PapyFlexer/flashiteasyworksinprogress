package com.flashiteasy.admin.utils
{

	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.api.utils.DisplayListUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public class Selection
	{

		private var container:UIComponent;
		public var indicator:Canvas=new Canvas();


		// -- coordonnée de selection ---

		private var startSelect:Point;
		private var endSelect:Point;

		private static var instance:Selection;
		private static var allowInstantiation:Boolean=false;

		public function Selection()
		{
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}
		}

		public static function getInstance():Selection
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new Selection();
				allowInstantiation=false;

			}
			return instance;
		}
		
		public function reset() : void
		{
			instance = null;
			delete this;
		}
		
		
		public function register(container:UIComponent):void
		{
			this.container=container;
			//this.container.addEventListener( MouseEvent.MOUSE_DOWN , beginSelection );
			Ref.ADMIN_STAGE.addEventListener(MouseEvent.MOUSE_DOWN, beginSelection, true);
			//stage.addEventListener( MouseEvent.MOUSE_DOWN , beginSelection);
			Ref.ADMIN_STAGE.addEventListener(MouseEvent.MOUSE_UP, endSelection, true);
			//stage.addEventListener( MouseEvent.MOUSE_UP , endSelection );
			//this.container.addEventListener( MouseEvent.MOUSE_UP , endSelection );
			indicator.mouseEnabled=false;
		}

		private function beginSelection(e:MouseEvent):void
		{

			if ((e.target as DisplayObject) == container || container.contains(e.target as DisplayObject))
			{
				container.addEventListener(MouseEvent.MOUSE_MOVE, selectionMove);
				indicator.name="select";
				indicator.styleName="select";
				var p:Point=container.globalToLocal((e.target as DisplayObject).localToGlobal(new Point(e.localX, e.localY)));
				indicator.x=p.x;
				indicator.y=p.y;
				indicator.width=0;
				indicator.height=0;
				container.addChild(indicator);
			}
		}

		private function selectionMove(e:MouseEvent):void
		{
			if ((e.target as DisplayObject) == container || container.contains(e.target as DisplayObject))
			{
				var p:Point=container.globalToLocal((e.target as DisplayObject).localToGlobal(new Point(e.localX, e.localY)));
				indicator.width=p.x - indicator.x;
				indicator.height=p.y - indicator.y;
			}

		}

		private function endSelection(e:MouseEvent):void
		{
			if ((e.target as DisplayObject) == container || container.contains(e.target as DisplayObject))
			{

				container.removeEventListener(MouseEvent.MOUSE_MOVE, selectionMove);
				if (container.contains(indicator))
					container.removeChild(indicator);
			}

		}

		public function highLightContainer(container:UIComponent, block:DisplayObject):void
		{
			indicator.name="select";
			indicator.styleName="select";
			var bounds:Rectangle=DisplayListUtils.getRealBounds(block, container);
			indicator.width=bounds.width;
			indicator.height=bounds.height;
			indicator.x=bounds.x;
			indicator.y=bounds.y;
			container.addChild(indicator);
		}

		public function removeHighLight():void
		{
			if (indicator.parent != null)
				indicator.parent.removeChild(indicator);
		}

	}
}