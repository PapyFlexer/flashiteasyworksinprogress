package com.flashiteasy.admin.visualEditor.handles {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author lalex,gilles,didier
	 */
	public class EditButton
		extends Sprite {

		private var _type : String;

		[Embed(source='../../../../../../resources/assets/delete.png')]
		private var Delete_ico : Class;

		[Embed(source='../../../../../../resources/assets/rotate.png')]
		private var Rotate_ico : Class;

		public function EditButton(typ : String) {
			_type = typ;
			var color : uint = 0x666666;
			switch(typ) {
				case EditType.DELETE:
					var del : Bitmap = new Delete_ico();
					del.x = -8;
					del.y = -8;
					Bitmap(del).smoothing = true;
					addChild(del);
					break;
				case EditType.ROTATE:
					var rot : Bitmap = new Rotate_ico();
					rot.x = -8;
					rot.y = -8;
					//rot.width = 16;
					//rot.height = 16;
					Bitmap(rot).smoothing = true;
					addChild(rot);
					break;
				default:
					graphics.lineStyle(0, 0xFFFFFF);
					graphics.beginFill(color);
					//graphics.drawCircle(0, 0, 4);
					graphics.drawRect(-4, -4, 8, 8);
					graphics.moveTo(0, 0);
					graphics.endFill();
					break;
			}
			//filters = [new GlowFilter(0xFFFFFF, 1, 3, 3)];
		}

		public function get type() : String {
			return _type;
		}
	}
}
