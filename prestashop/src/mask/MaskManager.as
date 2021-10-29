package mask
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	import mx.controls.ComboBox;
	import mx.controls.Image;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	import mx.states.AddChild;
	import mx.utils.DisplayUtil;
	
	import utils.DisplayListUtils;

	public class MaskManager
	{
		private static var workbench : UIComponent;
		private static var workbenchMask : DisplayObject;
		private static var phoneImage : DisplayObject;
		private static var maskChooser : ComboBox;
		private static var assetPath : String = "assets/";
		
		[Embed(source="assets/mask/template_iphone_4.png")]
		public static var iphone4 : Class;
		
		[Embed(source="assets/mask/basemaski5.jpg")]
		public static var iphone5 : Class;
		
		public static function initMaskCombo( box : ComboBox ) : void
		{
			maskChooser = box;
			box.dataProvider = new Array("iphone 4","iphone 5");
			box.selectedIndex = 0;
			box.addEventListener(Event.CHANGE , maskSelected );
		}
		
		private static function maskSelected( e : Event ) : void
		{
			changeMask();
		}
		
		public static function changeMask(): void
		{
			var choice : String = maskChooser.selectedItem.toString();
			
			trace (workbenchMask != null);
			DisplayListUtils.removeAllChildren(workbench);
			
			if( choice == "iphone 4")
			{
				phoneImage = new iphone4();	
				workbenchMask = new iphone4();	
				changeMaskSizeAndCenter(500,800);
			}
			else if( choice == "iphone 5")
			{
				phoneImage = new iphone5();	
				workbenchMask = new iphone5();	
				changeMaskSizeAndCenter(500,800);
			}
			workbench.addChild(phoneImage);
			workbench.addChild( workbenchMask);
			workbench.mask = workbenchMask;
		}

		public static function changeMaskSizeAndCenter( width : Number , height : Number ) : void 
		{
			workbenchMask.width = width;
			workbenchMask.height = height;
			phoneImage.width = width;
			phoneImage.height = height;
		}
		
		public static function init(workbench : UIComponent ) : void
		{
			MaskManager.workbench = workbench;
			changeMask();
		}
	}
}