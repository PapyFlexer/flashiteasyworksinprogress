package com.flashiteasy.admin.components.filterComponents.panels
{
	import com.flashiteasy.admin.components.advancedSlider;
	import com.flashiteasy.admin.components.filterComponents.IFilterFactory;
	import com.flashiteasy.admin.components.filterComponents.IFilterPanel;
	import com.flashiteasy.admin.components.filterComponents.factory.ColorMatrixFactory;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.api.utils.NumberUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;

	/**
	 * Flash'Iteasy
	 * Fie team is
	 * dany, didier, gilles
	 * & many thanks to alexis, ghazi, jean-françois
	 */
	public class ColorMatrixPanel extends Canvas implements IFilterPanel
	{
		// ------- Private vars -------
		private var _filterFactory:ColorMatrixFactory;


		// --- Presets ---
		private static const NONE:String = "none";
		private static const NEGATIVE:String = "negative";
		private static const GREYSCALE:String = "greyscale";
		private static const WARM_GREY:String = "warmGrey";
		private static const COOL_GREY:String = "coolGrey";
		private static const HARD_GREY:String = "hardGrey";
		
		
		// ------- Child Controls -------
		// Positioned and created within FilterWorkbench.fla
		/**
		 *
		 * @default
		 */
		public var presetChooser:ComboBox;
		/**
		 *
		 * @default
		 */
		public var brightnessValue:advancedSlider;
		/**
		 *
		 * @default
		 */
		public var contrastValue:advancedSlider;
		/**
		 *
		 * @default
		 */
		public var saturationValue:advancedSlider;
		/**
		 *
		 * @default
		 */
		public var hueValue:advancedSlider;
		/**
		 *
		 * @default
		 */
		public var m0:TextInput;
		/**
		 *
		 * @default
		 */
		public var m1:TextInput;
		/**
		 *
		 * @default
		 */
		public var m2:TextInput;
		/**
		 *
		 * @default
		 */
		public var m3:TextInput;
		/**
		 *
		 * @default
		 */
		public var m4:TextInput;
		/**
		 *
		 * @default
		 */
		public var m5:TextInput;
		/**
		 *
		 * @default
		 */
		public var m6:TextInput;
		/**
		 *
		 * @default
		 */
		public var m7:TextInput;
		/**
		 *
		 * @default
		 */
		public var m8:TextInput;
		/**
		 *
		 * @default
		 */
		public var m9:TextInput;
		/**
		 *
		 * @default
		 */
		public var m10:TextInput;
		/**
		 *
		 * @default
		 */
		public var m11:TextInput;
		/**
		 *
		 * @default
		 */
		public var m12:TextInput;
		/**
		 *
		 * @default
		 */
		public var m13:TextInput;
		/**
		 *
		 * @default
		 */
		public var m14:TextInput;
		/**
		 *
		 * @default
		 */
		public var m15:TextInput;
		/**
		 *
		 * @default
		 */
		public var m16:TextInput;
		/**
		 *
		 * @default
		 */
		public var m17:TextInput;
		/**
		 *
		 * @default
		 */
		public var m18:TextInput;
		/**
		 *
		 * @default
		 */
		public var m19:TextInput;
		/**
		 *
		 * @default
		 */
		public var resetButton:Button;
		private var panel:_ColorMatrixPanel;

		// ------- Constructor -------
		/**
		 *
		 */
		public function ColorMatrixPanel()
		{

			panel=new _ColorMatrixPanel;
			// create the filter factory
			_filterFactory=new ColorMatrixFactory();
			addChild(panel);
			panel.addEventListener(FlexEvent.CREATION_COMPLETE, setupChildren);
			brightnessValue=panel.brightnessValue;
			contrastValue=panel.contrastValue;
			saturationValue=panel.saturationValue;
			presetChooser=panel.presetchooser;
			hueValue=panel.hueValue;
			m0=panel.m0;
			m1=panel.m1;
			m2=panel.m2;
			m3=panel.m3;
			m4=panel.m4;
			m5=panel.m5;
			m6=panel.m6;
			m7=panel.m7;
			m8=panel.m8;
			m9=panel.m9;
			m10=panel.m10;
			m11=panel.m11;
			m12=panel.m12;
			m13=panel.m13;
			m14=panel.m14;
			m15=panel.m15;
			m16=panel.m16;
			m17=panel.m17;
			m18=panel.m18;
			m19=panel.m19;
			resetButton=panel.resetButton;
		}


		// ------- Public Properties -------
		/**
		 *
		 * @return
		 */
		public function get filterFactory():IFilterFactory
		{
			return _filterFactory;
		}


		// ------- Public methods -------
		/**
		 *
		 */
		public function resetForm():void
		{
			setMatrixForm([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);

			brightnessValue.value=0;
			contrastValue.value=0;
			saturationValue.value=0;
			hueValue.value=0;

			if (_filterFactory != null)
			{
				this.presetChooser.selectedIndex=0;
				_filterFactory.defaultMatrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
				_filterFactory.modifyFilterCustom();
			}
		}

		private var colorMatrixFilter:ColorMatrixFilter;

		/**
		 *
		 * @param filter
		 */
		public function setValues(filter:*):void
		{
			if (filter is ColorMatrixFilter)
			{
				colorMatrixFilter=ColorMatrixFilter(filter);
			}
		}

		private function initFilter():void
		{
			if (colorMatrixFilter != null)
			{

				setMatrixForm(colorMatrixFilter.matrix);
				
				_filterFactory.modifyFilterCustom(colorMatrixFilter.matrix);
				//updateFilter();

			}
		}

		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, setupChildren);
			// populate the preset chooser combo box
			var presetData:Array = [{label:Conf.languageManager.getLanguage("None"), data:NONE},{label:Conf.languageManager.getLanguage("Negative"), data:NEGATIVE},{label:Conf.languageManager.getLanguage("Greyscale"), data:GREYSCALE},{label:Conf.languageManager.getLanguage("Warm_grey"), data:WARM_GREY},{label:Conf.languageManager.getLanguage("Cool_grey"), data:COOL_GREY},{label:Conf.languageManager.getLanguage("Hard_grey"), data:HARD_GREY}];
			var presetList:ArrayCollection = new ArrayCollection(presetData);
			presetChooser.dataProvider = presetList;
			
			
			// add event listeners for child controls
			brightnessValue.addEventListener(Event.CHANGE, changePreset);
			contrastValue.addEventListener(Event.CHANGE, changePreset);
			saturationValue.addEventListener(Event.CHANGE, changePreset);
			hueValue.addEventListener(Event.CHANGE, changePreset);
			presetChooser.addEventListener(Event.CHANGE, choosePreset);

			m0.addEventListener(Event.CHANGE, changeFilterValue);
			m1.addEventListener(Event.CHANGE, changeFilterValue);
			m2.addEventListener(Event.CHANGE, changeFilterValue);
			m3.addEventListener(Event.CHANGE, changeFilterValue);
			m4.addEventListener(Event.CHANGE, changeFilterValue);
			m5.addEventListener(Event.CHANGE, changeFilterValue);
			m6.addEventListener(Event.CHANGE, changeFilterValue);
			m7.addEventListener(Event.CHANGE, changeFilterValue);
			m8.addEventListener(Event.CHANGE, changeFilterValue);
			m9.addEventListener(Event.CHANGE, changeFilterValue);
			m10.addEventListener(Event.CHANGE, changeFilterValue);
			m11.addEventListener(Event.CHANGE, changeFilterValue);
			m12.addEventListener(Event.CHANGE, changeFilterValue);
			m13.addEventListener(Event.CHANGE, changeFilterValue);
			m14.addEventListener(Event.CHANGE, changeFilterValue);
			m15.addEventListener(Event.CHANGE, changeFilterValue);
			m16.addEventListener(Event.CHANGE, changeFilterValue);
			m17.addEventListener(Event.CHANGE, changeFilterValue);
			m18.addEventListener(Event.CHANGE, changeFilterValue);
			m19.addEventListener(Event.CHANGE, changeFilterValue);

			resetButton.addEventListener(MouseEvent.CLICK, resetClick);
			initFilter();
		}

		private function choosePreset(event:Event):void
		{
			// populate the form values according to the selected preset
			switch (presetChooser.selectedItem.data)
			{
				case NONE:
					setPreset([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
					break;
				case NEGATIVE:
					setPreset([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]);
					break;
				case GREYSCALE:
					setPreset([0.31, 0.69, 0.08, 0, 0, 0.31, 0.69, 0.08, 0, 0, 0.31, 0.69, 0.08, 0, 0, 0, 0, 0, 1, 0]);
					break;
				case WARM_GREY:
					setPreset([0.39, 0.75, 0.19, 0, 0, 0.35, 0.69, 0.16, 0, 0, 0.27, 0.53, 0.13, 0, 0, 0, 0, 0, 1, 0]);
					break;
				case COOL_GREY:
					setPreset([0.31, 0.69, 0.17, 0, 0, 0.31, 0.69, 0.25, 0, 0, 0.31, 0.69, 0.31, 0, 0, 0, 0, 0, 1, 0]);
					break;
				case HARD_GREY:
					setPreset([0.4, 0.8, 0.2, 0, 0, 0.4, 0.8, 0.2, 0, 0, 0.4, 0.8, 0.2, 0, 0, 0, 0, 0, 1, 0]);
					break;
			}
		}
		
		/**
		 *
		 */
		private function setPreset(m:Array):void
		{
			setMatrixForm(m);

			brightnessValue.value=0;
			contrastValue.value=0;
			saturationValue.value=0;
			hueValue.value=0;

			if (_filterFactory != null)
			{
				_filterFactory.modifyFilterCustom(m);
				_filterFactory.defaultMatrix =  m;
			}
			//brightnessValue.value=_filterFactory.getBrightness()*100;
			//contrastValue.value=_filterFactory.getContrast()*100;
			//saturationValue.value=(_filterFactory.getSaturation()-1)*100;
			//hueValue.value=_filterFactory.getHue()*.55;
		}
		
		private function changePreset(event:Event):void
		{
			// update the filter
			_filterFactory.modifyFilterBasic(brightnessValue.value, contrastValue.value, saturationValue.value, hueValue.value);

			// populate the form values with the new matrix
			setMatrixForm(_filterFactory.matrix);
		}


		private function changeFilterValue(event:Event):void
		{
			// verify that the values are valid
			if (m0.text.length <= 0)
			{
				return;
			}
			if (m1.text.length <= 0)
			{
				return;
			}
			if (m2.text.length <= 0)
			{
				return;
			}
			if (m3.text.length <= 0)
			{
				return;
			}
			if (m4.text.length <= 0)
			{
				return;
			}
			if (m5.text.length <= 0)
			{
				return;
			}
			if (m6.text.length <= 0)
			{
				return;
			}
			if (m7.text.length <= 0)
			{
				return;
			}
			if (m8.text.length <= 0)
			{
				return;
			}
			if (m9.text.length <= 0)
			{
				return;
			}
			if (m10.text.length <= 0)
			{
				return;
			}
			if (m11.text.length <= 0)
			{
				return;
			}
			if (m12.text.length <= 0)
			{
				return;
			}
			if (m13.text.length <= 0)
			{
				return;
			}
			if (m14.text.length <= 0)
			{
				return;
			}
			if (m15.text.length <= 0)
			{
				return;
			}
			if (m16.text.length <= 0)
			{
				return;
			}
			if (m17.text.length <= 0)
			{
				return;
			}
			if (m18.text.length <= 0)
			{
				return;
			}
			if (m19.text.length <= 0)
			{
				return;
			}

			// reset the brightness/contrast/saturation/hue controls
			brightnessValue.value=0;
			contrastValue.value=0;
			saturationValue.value=0;
			hueValue.value=0;

			// update the filter
			var matrix:Array=[Number(m0.text), Number(m1.text), Number(m2.text), Number(m3.text), Number(m4.text), Number(m5.text), Number(m6.text), Number(m7.text), Number(m8.text), Number(m9.text), Number(m10.text), Number(m11.text), Number(m12.text), Number(m13.text), Number(m14.text), Number(m15.text), Number(m16.text), Number(m17.text), Number(m18.text), Number(m19.text)];
			
			_filterFactory.modifyFilterCustom(matrix);
			_filterFactory.defaultMatrix=matrix;
		}


		private function resetClick(event:MouseEvent):void
		{
			resetForm();
		}


		// ------- Utility methods -------
		private function setMatrixForm(matrix:Array):void
		{
			m0.text=NumberUtils.roundDecimalToPlace(matrix[0],2).toString();
			m1.text=NumberUtils.roundDecimalToPlace(matrix[1],2).toString();
			m2.text=NumberUtils.roundDecimalToPlace(matrix[2],2).toString();
			m3.text=NumberUtils.roundDecimalToPlace(matrix[3],2).toString();
			m4.text=NumberUtils.roundDecimalToPlace(matrix[4],2).toString();
			m5.text=NumberUtils.roundDecimalToPlace(matrix[5],2).toString();
			m6.text=NumberUtils.roundDecimalToPlace(matrix[6],2).toString();
			m7.text=NumberUtils.roundDecimalToPlace(matrix[7],2).toString();
			m8.text=NumberUtils.roundDecimalToPlace(matrix[8],2).toString();
			m9.text=NumberUtils.roundDecimalToPlace(matrix[9],2).toString();
			m10.text=NumberUtils.roundDecimalToPlace(matrix[10],2).toString();
			m11.text=NumberUtils.roundDecimalToPlace(matrix[11],2).toString();
			m12.text=NumberUtils.roundDecimalToPlace(matrix[12],2).toString();
			m13.text=NumberUtils.roundDecimalToPlace(matrix[13],2).toString();
			m14.text=NumberUtils.roundDecimalToPlace(matrix[14],2).toString();
			m15.text=NumberUtils.roundDecimalToPlace(matrix[15],2).toString();
			m16.text=NumberUtils.roundDecimalToPlace(matrix[16],2).toString();
			m17.text=NumberUtils.roundDecimalToPlace(matrix[17],2).toString();
			m18.text=NumberUtils.roundDecimalToPlace(matrix[18],2).toString();
			m19.text=NumberUtils.roundDecimalToPlace(matrix[19],2).toString();
		}
	}
}