/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.controls.FLVPlayerElementDescriptor;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;

	/**
	 * The <code><strong>FLVPlayerParameterSet</strong></code> is the parameterSet
	 * that handles the FLVPlayback component. 
	 */
	 
		
	[ParameterSet(description="Skins",type="Reflection", groupname="Player")]
	public class FLVPlayerParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{

		private var _skin : String = "SkinOverPlaySeekMute";
		private var _autoPlay : Boolean = true;
		private var _skinAutoHide : Boolean = true;
		private var _skinBackgroundColor : uint = 0xCCCCCC;
		private var _skinBackgroundAlpha : Number = 0.5;
		private var _autoRewind : Boolean = false;
		
		
		public var skinsArray : Array = ["FieUnderAll", "QTOverAllNoCaption", "MinimaFlatCustomColorAll", "MinimaFlatCustomColorPlayBackSeekCounterVolMute", "MinimaFlatCustomColorPlayBackSeekCounterVolMuteFull", "MinimaFlatCustomColorPlayBackSeekMute", "MinimaSilverAll", "MinimaSilverPlayBackSeekCounterVolMute", "MinimaSilverPlayBackSeekCounterVolMuteFull", "MinimaSilverPlayBackSeekMute", "MinimaUnderPlayBackSeekCounterVolMuteFull", "MinimaUnderPlayBackSeekCounterVolMuteNoFull", "SkinOverAll", "SkinOverAllNoCaption", "SkinOverAllNoFullNoCaption", "SkinOverAllNoFullscreen", "SkinOverAllNoVolNoCaptionNoFull", "SkinOverPlay", "SkinOverPlayCaption", "SkinOverPlayFullscreen", "SkinOverPlayMute", "SkinOverPlayMuteCaptionFull", "SkinOverPlaySeekCaption", "SkinOverPlaySeekFullscreen", "SkinOverPlaySeekMute", "SkinOverPlaySeekStop", "SkinOverPlayStopSeekCaptionVol", "SkinOverPlayStopSeekFullVol", "SkinOverPlayStopSeekMuteVol", "SkinUnderAll", "SkinUnderAllNoCaption", "SkinUnderAllNoFullNoCaption", "SkinUnderAllNoFullscreen", "SkinUnderAllNoVolNoCaptionNoFull", "SkinUnderPlay", "SkinUnderPlayCaption", "SkinUnderPlayFullscreen", "SkinUnderPlayMute", "SkinUnderPlayMuteCaptionFull", "SkinUnderPlaySeekCaption", "SkinUnderPlaySeekFullscreen", "SkinUnderPlaySeekMute", "SkinUnderPlaySeekStop", "SkinUnderPlayStopSeekCaptionVol", "SkinUnderPlayStopSeekFullVol", "SkinUnderPlayStopSeekMuteVol","Martell2010PlayerSkin","AS3BlackGrad","FlvSkin_SmoothEdgeLT","FlvSkin_SmoothEdgeDK","FlvSkin_Razor","FlvSkin_PolishedSilver","FlvSkin_FlatBox","FlvSkin_BasicDKonLT","FlvSkin_BasicLTonDK"];
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target : IDescriptor ) : void
		{
			if (target is FLVPlayerElementDescriptor)
			{
				FLVPlayerElementDescriptor(target).skinAutoHide = skinAutoHide;
				FLVPlayerElementDescriptor(target).autoRewind = autoRewind;
				FLVPlayerElementDescriptor(target).skinBackgroundColor = skinBackgroundColor;
				FLVPlayerElementDescriptor(target).skinBackgroundAlpha = skinBackgroundAlpha;
				FLVPlayerElementDescriptor(target).autoPlay = autoPlay;
				FLVPlayerElementDescriptor(target).skin = skin;
				FLVPlayerElementDescriptor(target).refreshPlayerProps();
			}
		}
		
		[Parameter(type="Boolean",defaultValue="true",row="0", sequence="0" , label="AutoHide")]
		/**
		 * The <strong>skinAutoHide</strong> property takes a boolean value (checkBox in admin mode)
		 * and deals with the skin display : when set to true, the player will disappear
		 * when mouse is out of the component.
		 */
		public function get skinAutoHide() : Boolean
		{
			return _skinAutoHide;
		}
		
		/**
		 * Private
		 */
		public function set skinAutoHide( value : Boolean ) : void
		{
			_skinAutoHide = value;
		}
		
		[Parameter(type="Boolean",defaultValue="false",row="0", sequence="1" , label="AutoRewind")]
		/**
		 * The <strong>skinAutoHide</strong> property takes a boolean value (checkBox in admin mode)
		 * and deals with the skin display : when set to true, the player will disappear
		 * when mouse is out of the component.
		 */
		public function get autoRewind() : Boolean
		{
			return _autoRewind;
		}
		
		/**
		 * Private
		 */
		public function set autoRewind( value : Boolean ) : void
		{
			_autoRewind = value;
		}
		
		[Parameter(type="Boolean",defaultValue="true",row="0", sequence="2" , label="AutoPlay")]
		/**
		 * The <strong>skinAutoHide</strong> property takes a boolean value (checkBox in admin mode)
		 * and deals with the skin display : when set to true, the player will disappear
		 * when mouse is out of the component.
		 */
		public function get autoPlay() : Boolean
		{
			return _autoPlay;
		}
		
		/**
		 * Private
		 */
		public function set autoPlay( value : Boolean ) : void
		{
			_autoPlay = value;
		}
		
        /**
         * Lists all possible skins
         * @param name
         * @return 
         */
		[Parameter(type="Combo",defaultValue="SkinOverPlaySeekMute", row="1", sequence="3", label="Skin")]
 		public function get skin() : String
 		{
 			return _skin;
 		}
 
 		public function set skin( value : String ) : void
 		{
 			_skin = value;
 		}
 

		[Parameter(type="Color",defaultValue="0xCCCCCC",row="2", sequence="4" , label="skinColor")]
		/**
		 * The <strong>skinBackgroundColor</strong> property takes a color 
		 * and applies it to the skin display.
		 */
		public function get skinBackgroundColor() : uint
		{
			return _skinBackgroundColor;
		}
		
		/**
		 * Private
		 */
		public function set skinBackgroundColor( value : uint ) : void
		{
			_skinBackgroundColor = value;
		}
		
		[Parameter(type="Slider",defaultValue="1", min="0", max="1", interval="0.01", row="2", sequence="5", label="Alpha")]
		/**
		 * The <strong>skinBackgroundAlpha</strong> property takes a color 
		 * and applies it to the skin display.
		 */
		public function get skinBackgroundAlpha() : Number
		{
			return _skinBackgroundAlpha;
		}
		
		/**
		 * Private
		 */
		public function set skinBackgroundAlpha( value : Number ) : void
		{
			_skinBackgroundAlpha = value;
		}
		
        public function getPossibleValues(name:String):Array
        {
            return skinsArray;
        }
		
	}
}