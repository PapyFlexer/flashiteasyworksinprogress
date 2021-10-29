package com.flashiteasy.admin.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import mx.controls.ColorPicker;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	import mx.events.ColorPickerEvent;
	import mx.events.DropdownEvent;
	import mx.managers.PopUpManager;
	use namespace mx_internal;

	public class FieColorPicker extends ColorPicker
	{

		private var _hasNoColor:Boolean=true;
		private var _hasAdvancedColor:Boolean=true;

		private var dropDownNoColor:DisplayObject=null;
		private var dropDownColorType:String="noColor";
		private var dropDownNoColorPreview:DisplayObject=null;

		private var colorWheel:DisplayObject=null;

		private var popAdvancedColor:advancedColorPicker=null;

		private var paddingTop:Number=2;
		private var paddingRight:Number=5;
		private var paddingLeft:Number=0;
		private var paddingBottom:Number=0;
		private var buttonSize:Number=10;
		private var buttonWidth:Number=10;
		private var backgroundNoColor:Number=0xFFFFFE;

		[Embed(source='../../../../../resources/assets/colorWheel.png')]
		private var colorWheel_ico:Class;

		//[Embed(source='../../../../../resources/assets/NoColorPicker.png')]
		//private var NoColorPicker_ico:Class;

		[Embed(source='../../../../../resources/assets/NoColor.png')]
		private var NoColor_ico:Class;

		[Embed(source='../../../../../resources/assets/NoColorPreview.png')]
		private var NoColorPreview_ico:Class;

		private var noColor:Object=null;


		/*[Embed(source="kingnarestyle.swf",symbol="ColorPicker_noColorUpSkin")]
		private var noColorUpSkin:Class;
		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_noColorDownSkin")]
		private var noColorDownSkin:Class;
		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_noColorOverSkin")]
		private var noColorOverSkin:Class;
		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_noColorDisabledSkin")]
		private var noColorDisabledSkin:Class;

		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_upSkin")]
		private var upSkin:Class;
		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_downSkin")]
		private var downSkin:Class;
		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_overSkin")]
		private var overSkin:Class;
		[Embed(source="kingnarestyle.swf",symbol="ColorPicker_disabledSkin")]
		private var disabledSkin:Class;*/

		public function FieColorPicker()
		{
			addEventListener(DropdownEvent.OPEN, openColorPickerHandler);

			addEventListener(ColorPickerEvent.CHANGE, changePickerHandler);
			//dataProvider = mx.core.Application.application.globalColors.concat(mx.core.Application.application.siteLoader.site.customColors);
		}

		public function addSwatches(col:Object):void
		{
		/*parentApplication.siteLoader.site.customColors.push(col);
		   ListCollectionView(dataProvider).addItem(col);
		 dropdown.invalidateSize();*/
		}

		private function rollOverItemHandler(event:ColorPickerEvent):void
		{
			if (!dropDownNoColorPreview.visible)
				return;
			dropDownNoColorPreview.visible=false;
			showTextField=true;
		}

		private function rollOutItemHandler(event:ColorPickerEvent):void
		{
			if (!dropDownNoColorPreview.visible && !isNaN(Number(dropDownColorType)))
				return;
			dropDownNoColorPreview.visible=isNaN(Number(dropDownColorType));
			showTextField=!isNaN(Number(dropDownColorType));
			setFocus();
		}

		private function openColorPickerHandler(e:DropdownEvent):void
		{
			setSize();
			dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT));
		}

		private function advancedColorHandler(event:MouseEvent):void
		{

			popAdvancedColor=advancedColorPicker(PopUpManager.createPopUp(mx.core.Application.application as DisplayObject, advancedColorPicker, true));
			PopUpManager.centerPopUp(popAdvancedColor as IFlexDisplayObject);
			popAdvancedColor.showCloseButton=true;
			popAdvancedColor.oldColor=selectedColor;
			popAdvancedColor.newColor=selectedColor;
			if (!isNaN(Number(dropDownColorType)))
			{
				popAdvancedColor.imageColorPicker.selectedColor=selectedColor;
				popAdvancedColor.updateColor();
			}
			popAdvancedColor.targetedColorPicker=this;
			close();
		}

		private function noColorHandler(event:MouseEvent):void
		{
			dropDownColorType="noColor";
			close();
			dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT));
			setColorValue(dropDownColorType);
			dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE));
		}

		protected function changePickerHandler(event:ColorPickerEvent):void
		{
			if (selectedColor != backgroundNoColor)
			{
				dropDownColorType=String(selectedColor);
			}
			setColorValue(dropDownColorType);
			changeSkins();
		}

		override public function set percentWidth(prc:Number):void
		{
		}

		public function getColorValue():*
		{
			selectedColor=isNaN(Number(dropDownColorType)) ? backgroundNoColor : uint(dropDownColorType);
			dropDownColorType=isNaN(Number(dropDownColorType)) ? "noColor" : String(selectedColor);
			changeSkins();
			return dropDownColorType;
		}

		public function setColorValue(val:*):void
		{
			if (isNaN(Number(val)))
			{
				this.selectedIndex=-1;
			}
			dropDownColorType=isNaN(Number(val)) ? "noColor" : val;
			selectedColor=isNaN(Number(val)) ? backgroundNoColor : uint(val);
			changeSkins();
		}

		public function get hasNoColor():Boolean
		{
			return _hasNoColor;
		}

		public function set hasNoColor(val:Boolean):void
		{
			if (val == _hasNoColor)
				return;
			_hasNoColor=val;
		}


		public function get hasAdvancedColor():Boolean
		{
			return hasAdvancedColor;
		}

		public function set hasAdvancedColor(val:Boolean):void
		{
			if (val == _hasAdvancedColor)
				return;
			_hasAdvancedColor=val;
		}

		/**************************************************
		 * SKINNING FUNCTIONS
		 */

		protected function changeSkins():void
		{
			if (dropDownColorType == "noColor")
			{
				setStyle("styleName", "noColorPicker");
				/*setStyle("upSkin", noColorUpSkin);
				setStyle("downSkin", noColorDownSkin);
				setStyle("overSkin", noColorOverSkin);
				setStyle("disabledSkin", noColorDisabledSkin);*/
			}
			else
			{
				setStyle("styleName", undefined);
				/*setStyle("upSkin", upSkin);
				setStyle("downSkin", downSkin);
				setStyle("overSkin", overSkin);
				setStyle("disabledSkin", disabledSkin);*/
			}
		}

		/***************************************************
		 ************ DRAWING FUNCTIONS ********************
		 ***************************************************
		 */
		private function setSize():void
		{
			paddingTop=dropdown.getStyle("paddingTop");
			paddingLeft=dropdown.getStyle("paddingLeft");
			paddingRight=dropdown.getStyle("paddingRight");
			paddingBottom=dropdown.getStyle("paddingBottom");
			buttonSize=dropdown.getStyle("previewHeight");
			buttonWidth=dropdown.getStyle("previewWidth");

			if (!dropDownNoColor)
			{
				dropDownNoColor=drawNoColor();
				if (dropDownNoColor != null)
				{
					dropDownNoColor.addEventListener(MouseEvent.CLICK, noColorHandler);
					addEventListener(ColorPickerEvent.ITEM_ROLL_OVER, rollOverItemHandler);
					addEventListener(ColorPickerEvent.ITEM_ROLL_OUT, rollOutItemHandler);
				}
			}

			if (!colorWheel)
			{
				colorWheel=drawColorWheel();
				if (colorWheel != null)
					colorWheel.addEventListener(MouseEvent.CLICK, advancedColorHandler);
			}
			if (!dropDownNoColorPreview)
			{
				if (dropDownNoColor != null)
					dropDownNoColorPreview=drawNoColorPreview();
			}
		}

		private function drawNoColor():DisplayObject
		{
			var clip:DisplayObject=null;
			if (_hasNoColor)
			{
				var nocol:Bitmap=new NoColor_ico;
				var noColorButton:Sprite=new Sprite;
				noColorButton.addChild(nocol);
				noColorButton.x=dropdown.width - buttonSize - paddingRight;
				noColorButton.y=paddingTop;
				noColorButton.width=noColorButton.height=buttonSize;
				clip=dropdown.addChild(noColorButton);
			}
			return clip;
		}

		private function drawColorWheel():DisplayObject
		{
			var clip:DisplayObject=null;
			if (_hasAdvancedColor)
			{
				var X:Number=_hasNoColor ? 2 * (buttonSize + paddingRight) : buttonSize + paddingRight;
				var col:Bitmap=new colorWheel_ico();
				Bitmap(col).smoothing=true;
				var colorWheelButton:Sprite=new Sprite;
				colorWheelButton.addChild(col);
				colorWheelButton.x=dropdown.width - X;
				colorWheelButton.y=paddingTop;
				colorWheelButton.width=colorWheelButton.height=buttonSize;
				clip=dropdown.addChild(colorWheelButton);
			}
			return clip;
		}

		private function drawNoColorPreview():DisplayObject
		{

			var clip:DisplayObject;
			if (_hasNoColor)
			{
				var nocolprev:Bitmap=new NoColorPreview_ico;
				var noColorPreview:Sprite=new Sprite;
				noColorPreview.addChild(nocolprev);
				noColorPreview.x=paddingLeft;
				noColorPreview.y=paddingTop;
				noColorPreview.width=buttonWidth;
				noColorPreview.height=buttonSize;
				clip=dropdown.addChild(noColorPreview);
			}
			return clip;
		}
	}
}
