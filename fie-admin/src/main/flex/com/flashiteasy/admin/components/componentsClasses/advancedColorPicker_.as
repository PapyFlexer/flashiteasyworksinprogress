package fie.admin.components.componentsClasses
{
	import com.yahoo.astra.mx.controls.ColorPlaneAndSliderPicker;
	import com.yahoo.astra.utils.HSBColor;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.containers.Canvas;
	import mx.containers.TitleWindow;
	import mx.controls.RadioButton;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.ColorPickerEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;

	/**
	 * @author didierreyt
	 */
	public class advancedColorPicker_ extends TitleWindow
	{
		public var hueField:TextInput;
		public var brightnessField:TextInput;
		public var saturationField:TextInput;
		public var redField:TextInput;
		public var greenField:TextInput;
		public var blueField:TextInput;
		public var hexField:TextInput;
		public var CMYColor:HSBColor;

		[Bindable]
		public var _newColor:Number;
		[Bindable]
		public var _oldColor:Number=0xCCCCCC;

		public var hueRadio:RadioButton;
		public var brightnessRadio:RadioButton;
		public var saturationRadio:RadioButton;
		public var redRadio:RadioButton;
		public var blueRadio:RadioButton;
		public var greenRadio:RadioButton;

		public var previousColor:Canvas;
		public var imageColorPicker:ColorPlaneAndSliderPicker;



		public function advancedColorPicker_()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}

		private function creationCompleteHandler(event:FlexEvent):void
		{

			var elt:UIComponent;
			/*for each(elt in [hexField, hueField, brightnessField, saturationField, redField, greenField, blueField]) {
			   registerControl(elt);
			   }
			   registerControl(hueRadio, ItemClickEvent.ITEM_CLICK);
			   registerControl(brightnessRadio, ItemClickEvent.ITEM_CLICK)
			   registerControl(saturationRadio, ItemClickEvent.ITEM_CLICK);
			   registerControl(redRadio, ItemClickEvent.ITEM_CLICK);
			   registerControl(greenRadio, ItemClickEvent.ITEM_CLICK);
			 registerControl(blueRadio, ItemClickEvent.ITEM_CLICK)*/
			registerControl(previousColor, ItemClickEvent.ITEM_CLICK);
			registerControl(imageColorPicker, ColorPickerEvent.CHANGE);
		}

		private function registerControl(ctrl:UIComponent, eventType:String=null):void
		{
			if (eventType == null)
				eventType=FocusEvent.FOCUS_OUT;
			ctrl.addEventListener(eventType, controlChangeHandler);
		}

		private function controlChangeHandler(event:Event):void
		{
			switch (event.target)
			{

			}
			updateColor(event.target);
		}



		[Inspectable]
		private function updateColor(myUpdatedComponent:Object):void
		{
			_newColor=imageColorPicker.selectedColor;
		}

		[Bindable]
		public function set newColor(color:Number):void
		{
			_newColor=imageColorPicker.selectedColor;
		}

		public function CloseMe():void
		{

		}

		public function adSwatch():void
		{

		}

		public function get newColor():Number
		{
			return _newColor;
		}

		public function get oldColor():Number
		{
			return _oldColor;
		}

		[Bindable]
		public function set oldColor(color:Number):void
		{
			_oldColor=color;
			imageColorPicker.selectedColor=color;
			_newColor=_oldColor=_oldColor;
		}
	}
}

