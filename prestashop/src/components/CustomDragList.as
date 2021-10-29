package components
{
	import utils.IconUtility;
	
	import mx.controls.Image;
	import mx.controls.List;
	import mx.core.IUIComponent;

	public class CustomDragList extends List
	{
		//[Embed(source='../../../../../resources/assets/image.png')]
		//private var image_ico:Class;

		/*
		override protected function get dragImage():IUIComponent
		{
			
            var items:Array = this.selectedItems;
            
			var defaultImgUrl:String = "assets/brick.png";
			var stringType : String = this.highlightUID.indexOf("ElementDescriptor") != -1 ? "ElementDescriptor" : "Action";
			var imgUrl:String = "assets/"+String(items[0]).split("::")[1].split(stringType)[0]+"_icon.png";
			
			
			var imageProxy:Image=new Image();
			imageProxy.source=IconUtility.getClass(imageProxy, imgUrl, defaultImgUrl);//image_ico;

			var imageHeight:Number=32;
			var imageWidth:Number=32;

			imageProxy.height=imageHeight;
			imageProxy.width=imageWidth;

			// Position the image proxy above and to the left of 
			// the mouse pointer.            
			imageProxy.x=this.mouseX;
			imageProxy.y=this.mouseY;

			imageProxy.owner=this;
			return imageProxy;
		}*/


	}
}