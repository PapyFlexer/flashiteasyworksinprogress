package factory
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.UIComponent;

	public class ElementFactory
	{
		[Embed(source="assets/images/product_default.gif")]
		public static var defaultImage : Class;
		private static var defaultSize : int = 100;
		
		public static function getNewName(type : String): String
		{
			if( type== "texte" )
			{
				return "texte";
			}
			else if( type == "image" )
			{
				return "image";
			}
			else if( type == "carre")
			{
				return "carre"
			}
			else
			{
				return null;
			}
		}
		
		public static function createElement(name:String,position : Point ):DisplayObject
		{
			if(name== "texte")
			{
				var text : TextField = new TextField;
				text.text = "Entrez votre texte";
				text.multiline = true;
				text.width = defaultSize;
				text.height = defaultSize;
				text.x = position.x;
				text.y = position.y;
				return text;
			}
			else if( name == "image")
			{
				var img : DisplayObject = new defaultImage();
				img.width = defaultSize;
				img.height = defaultSize;
				img.x = position.x;
				img.y = position.y;
				return img;
			}
			else if( name == "carre")
			{
				var square:UIComponent = new UIComponent();
				square.width = defaultSize;
				square.height = defaultSize;
				square.graphics.lineStyle(3,0x00ff00);
				square.graphics.beginFill(0x0000FF);
				square.graphics.drawRect(0,0,defaultSize,defaultSize);
				square.graphics.endFill();
				square.x = position.x;
				square.y = position.y;
				return square
			}
			else
			{
				return null;
			}
		}
		
	}
}