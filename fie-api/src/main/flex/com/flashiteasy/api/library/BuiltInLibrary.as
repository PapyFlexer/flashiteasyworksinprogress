/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.library
{
	import com.flashiteasy.api.action.*;
	import com.flashiteasy.api.builder.ElementBuilder;
	import com.flashiteasy.api.container.*;
	import com.flashiteasy.api.controls.*;
	import com.flashiteasy.api.controls.Validator.IsCreditCardValidator;
	import com.flashiteasy.api.controls.Validator.IsEmailValidator;
	import com.flashiteasy.api.controls.Validator.IsNoneValidator;
	import com.flashiteasy.api.controls.Validator.IsNumberValidator;
	import com.flashiteasy.api.controls.Validator.IsPhoneNumberValidator;
	import com.flashiteasy.api.controls.Validator.IsZipCodeValidator;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.elements.IValidatorElementDescriptor;
	import com.flashiteasy.api.easing.InterpolationTypes;
	import com.flashiteasy.api.editor.BackgroundColorEditor;
	import com.flashiteasy.api.editor.impl.AbstractParameterSetEditor;
	import com.flashiteasy.api.errors.ApiErrorManager;
	import com.flashiteasy.api.fieservice.transfer.vo.RemoteParameterSet;
	import com.flashiteasy.api.indexation.IndexationManager;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.motion.TimerStoryboardPlayerImpl;
	import com.flashiteasy.api.parameters.*;
	import com.flashiteasy.api.triggers.*;
	import com.flashiteasy.api.utils.MatrixUtils;
	import com.flashiteasy.api.utils.NameSpaceUtils;
	import com.flashiteasy.api.xml.impl.*;
	import com.gskinner.motion.easing.*;
	
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.NumericStepper;
	import fl.controls.SelectableList;
	import fl.video.FLVPlayback;

	/**
	 * The <code><strong>BuiltInLibrary</strong></code> is the central point
	 * `where all basic functionalities, all controls and all actions are 
	 * registered. 
	 * This is also the place where Descriptors and ParameterSets are
	 * related to define FIE objects. 
	 */
	public class BuiltInLibrary extends AbstractLibrary
	{
		/**
		 * 
		 * @default dimensionArray groups all the geometric ParameterSets : 
		 * position, alignment, size, rotation 
		 */
		public static var dimensionArray:Array = [PositionParameterSet, AlignParameterSet, SizeParameterSet, RotationParameterSet];
		/**
		 * 
		 * @default  decorationArray groups all the graphics ParameterSets : 
		 * alpha, blend-mode & background decoration
		 */
		public static var decorationArray:Array = [AlphaParameterSet, BlendModeParameterSet, FilterParameterSet, BackgroundColorParameterSet, BackgroundImageParameterSet , BorderParameterSet];
		
		/**
		 * 
		 * @default  networkArray groups all the network-related ParameterSets : 
		 * remote content
		 */
		public static var networkArray:Array =[RemoteParameterSet];
		/**
		 * 
		 * @default  mediaArray groups all the medium-related ParameterSets : wait before displaying, and resizable & full-screen abilities
		 */
		public static var mediaArray:Array = [MaskTypeParameterSet, WaitForCompletionParameterSet, MouseEnableParameterSet, FullScreenParameterSet];
		
		/**
		 * 
		 * @default  tweenableArray groups all the ParameterSets that can be tweened : basically numeric values in ParameterSet properties
		 * TODO : when implemented in API, add there all array properties in ParameterSets that can be tweened
		 */
		public static var tweenableArray:Array = ['PositionParameterSet',  'SizeParameterSet', 'RotationParameterSet', 'AlphaParameterSet', 'BackgroundColorParameterSet', 'MarginParameterSet'];
		
		/**
		 *  Loading the application with all manageable objects
		 */
		override protected function registerTypes():void
		{
			
/*	======	VISUAL ELEMENTS	======	*/


			//RECT
			IocContainer.registerType(RectElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(RectElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(mediaArray.concat(decorationArray.concat([TargetParameterSet, DragAndDropParameterSet]))));
			//TEXTE
			IocContainer.registerType(TextElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(TextElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([TargetParameterSet, TextOptionParameterSet, TextParameterSet])))));
			//TEXTE ANIME
			IocContainer.registerType(AnimatedTextElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(AnimatedTextElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([TargetParameterSet, TextOptionParameterSet, TextParameterSet, AnimatedTextParameterSet])))));
			//IMAGE
			IocContainer.registerType(ImgElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(ImgElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([ImgParameterSet, ResizableParameterSet, SmoothParameterSet])))));
			//SWF
			IocContainer.registerType(SwfElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(SwfElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([ImgParameterSet, ResizableParameterSet, SmoothParameterSet])))));

			//DailyMotion
			IocContainer.registerType(DailyMotionElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(DailyMotionElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([DailyMotionParameterSet, ResizableParameterSet, SmoothParameterSet])))));
			
			//VIDEO
			IocContainer.registerType(VideoElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(VideoElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([VideoParameterSet, ResizableParameterSet, LoopParameterSet, SmoothParameterSet])))));
			
			// CLONE
			IocContainer.registerType(CloneElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(CloneElementDescriptor, IocContainer.GROUP_PARAMETERS,dimensionArray.concat(mediaArray.concat(decorationArray.concat([ResizableParameterSet, CloneParameterSet]))));
			
			//CONTAINER
			IocContainer.registerType(BlockElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(BlockElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(mediaArray.concat(decorationArray.concat([ResizeFromChildrenParameterSet, BlockListParameterSet]))));

			//XMLCONTAINER
			IocContainer.registerType(XmlElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(XmlElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(mediaArray.concat(decorationArray.concat([XmlParameterSet, ResizeFromChildrenParameterSet, BlockListParameterSet]))));

			//LIST
			IocContainer.registerType(ListElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(ListElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(mediaArray.concat(decorationArray.concat([ BlockListParameterSet , MarginParameterSet , ListTypeParameterSet ]))));

			// essai toxify
			/* IocContainer.registerType(SmokeFxElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(SmokeFxElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([ SmokeFxparameterSet ]))))); */

			// GOOGLE MAP
			IocContainer.registerType(GMapElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(GMapElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(mediaArray.concat(decorationArray.concat([ GMapParameterSet ]))));

			//SCROLLER
			//IocContainer.registerType(ScrollerElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			//IocContainer.registerTypeList(ScrollerElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(decorationArray.concat([ScrollParameterSet])));
			



/*	======	FORM ITEMS ======	*/
			
			
			//FORM CONTAINER
			IocContainer.registerType(FormElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(FormElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(mediaArray.concat(decorationArray.concat([ResizeFromChildrenParameterSet, BlockListParameterSet]))));
			//SimpleButton
			IocContainer.registerType(SimpleButtonElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(SimpleButtonElementDescriptor , IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet, LabelParameterSet])); 
			//ColorPicker
			IocContainer.registerType(ColorPickerElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(ColorPickerElementDescriptor , IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet]));
			//TextInput
			IocContainer.registerType(TextInputElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(TextInputElementDescriptor , IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet, RestrictParameterSet, DisplayAsPassParameterSet, ValidatorTypeParameterSet]));
			//ComboBox
			IocContainer.registerType(ComboBoxElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(ComboBoxElementDescriptor , IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet, DataProviderParameterSet]));
			
			// Numeric Stepper
			IocContainer.registerType(NumericStepperElementDescriptor,IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(NumericStepperElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet, NumericStepperOptionsParameterSet]));

			// RadioButton
			IocContainer.registerType(RadioButtonElementDescriptor,IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(RadioButtonElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet, LabelParameterSet, LabelPlacementParameterSet, RadioButtonOptionsParameterSet]));
		
			// CheckBox
			IocContainer.registerType(CheckBoxElementDescriptor,IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(CheckBoxElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat([FormItemParameterSet, LabelParameterSet, LabelPlacementParameterSet]));
		
			// FLVPlayer
			IocContainer.registerType(FLVPlayerElementDescriptor,IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(FLVPlayerElementDescriptor, IocContainer.GROUP_PARAMETERS, dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([FLVSourceParameterSet, FLVPlayerParameterSet, SmoothParameterSet, ResizableParameterSet, LoopParameterSet])))));
		
			
			

/*	======	DYNAMIC ELEMENTS ======	*/

			
			// DYNAMIC LIST
			IocContainer.registerType( DynamicListElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent );
			IocContainer.registerTypeList(DynamicListElementDescriptor, IocContainer.GROUP_PARAMETERS,  dimensionArray.concat(networkArray.concat(mediaArray.concat(decorationArray.concat([XmlParameterSet, ListTypeParameterSet, BlockListParameterSet , MarginParameterSet, DynamicListParameterSet])))));
			
			
			
/*	======	ACTIONS ======	*/
			
			
			// EXTERNAL BROWSING ACTION
			IocContainer.registerType(ExternalBrowsingAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(ExternalBrowsingAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, ExternalLinkParameterSet]);
			
			// INTERNAL BROWSING ACTION
			IocContainer.registerType(InternalBrowsingAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(InternalBrowsingAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, InternalLinkParameterSet]);
			
			// PLAY STORY ACTION
			IocContainer.registerType(PlayStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlayStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PlayStoryParameterSet])
			
			// PLAY TO STORY ACTION
			IocContainer.registerType(PlayToStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlayToStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PlayToStoryParameterSet])
					
			// PLAY REVERSE STORY ACTION
			IocContainer.registerType(PlayReversedStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlayReversedStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PlayStoryParameterSet])
						
			// STOP STORY ACTION
			IocContainer.registerType(PauseStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PauseStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PauseStoryParameterSet])
			
			// TOGGLE STORY ACTION
			IocContainer.registerType(TogglePlayableStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(TogglePlayableStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, ToggleStoryParameterSet])
			
			// TOGGLE Reverse STORY ACTION
			IocContainer.registerType(ToggleReverseStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(ToggleReverseStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, ToggleReverseStoryParameterSet])
			
			// PLAY RELATIVE STORY ACTION
			IocContainer.registerType(PlayRelativeStoryAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlayRelativeStoryAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PlayToStoryParameterSet])
			
			// PLAY SOUND ACTION
			IocContainer.registerType(PlaySoundAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlaySoundAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PlaySoundParameterSet]);
			
			// PAUSE SOUND ACTION
			IocContainer.registerType(PauseSoundAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PauseSoundAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PauseSoundParameterSet]);
			
			// PLAY PLAYABLE ELEMENT ACTION
			IocContainer.registerType(PlayPlayableElementAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlayPlayableElementAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, PlayPlayableElementParameterSet]);
			
			// STOP PLAYABLE ELEMENT ACTION
			IocContainer.registerType(StopPlayableElementAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(StopPlayableElementAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, StopPlayableElementParameterSet]);
			
			// TOGGLE PLAYABLE ELEMENT ACTION
			IocContainer.registerType(TogglePlayableElementAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(TogglePlayableElementAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, TogglePlayableElementParameterSet]);
			
			// SEND and RESET FORM ACTIONs
			IocContainer.registerType(SendFormAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(SendFormAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, SendFormParameterSet, PHPParameterSet]);
			IocContainer.registerType(ResetFormAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(ResetFormAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, SendFormParameterSet]);
			
			// FULL SCREEN ELEMENT ACTION
			IocContainer.registerType(FullScreenElementAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(FullScreenElementAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, FullScreenActionParameterSet]);
				
			// DESTROY ACTION
			IocContainer.registerType(DestroyElementAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(DestroyElementAction, IocContainer.GROUP_PARAMETERS, [TargetsParameterSet, TriggerParameterSet, DestroyElementsParameterSet]);
				
				
			// PlayListACTION
			IocContainer.registerType(PlayListAction, IocContainer.GROUP_ACTIONS, Action);
			IocContainer.registerTypeList(PlayListAction, IocContainer.GROUP_PARAMETERS, [PlayListParameterSet]);
			


/*	======	ELEMENTS SERIALIZATION ======	*/


			// register serialization of the same objects so we can load and save pages
			IocContainer.registerType(SizeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(BackgroundColorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(BackgroundImageParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PositionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(TraceBehaviorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ImgParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(DailyMotionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ResizableParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(BlockListParameterSet, IocContainer.GROUP_SERIALIZATION, BlockListParameterSetXMLParser);
			IocContainer.registerType(DragAndDropParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(TextParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(AnimatedTextParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(MaskParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(AlignParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(AlphaParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(BlendModeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ColorMatrixParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(TargetParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(VideoParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(XmlParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(StartTransitionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(FilterParameterSet, IocContainer.GROUP_SERIALIZATION, FilterParameterSetXMLParser);
			IocContainer.registerType(SoundParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(FullScreenParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ListTypeParameterSet, IocContainer.GROUP_SERIALIZATION, FilterParameterSetXMLParser);
			IocContainer.registerType(MarginParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(LoopParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(SmoothParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ActionBehaviorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(XMLArrayParameterSet, IocContainer.GROUP_SERIALIZATION, XMLArrayParameterSetXMLParser);
			IocContainer.registerType(TypeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(SoundOptionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(TextOptionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(RotationParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(RemoteParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(SkewParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(WaitForCompletionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(TargetsParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(TriggerParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayClassParameterSetXMLParser);
			IocContainer.registerType(ExternalLinkParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(InternalLinkParameterSet, IocContainer.GROUP_SERIALIZATION, PageParameterSetXMLParser);
			IocContainer.registerType(BorderParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PlayStoryParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(PlayToStoryParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(PauseStoryParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(ToggleStoryParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(ToggleReverseStoryParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(PlayPlayableElementParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(StopPlayableElementParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(TogglePlayableElementParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(DestroyElementsParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(SendFormParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ResizeFromChildrenParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PlaySoundParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PauseSoundParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(FullScreenActionParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(MaskTypeParameterSet, IocContainer.GROUP_SERIALIZATION, CompositeParameterSetXMLParser);
			IocContainer.registerType(RoundedCornerParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(StarParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(BurstParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PolygonParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(MaskTargetParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ChangeValueParameterSet , IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(RadioButtonOptionsParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(TextInputParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(FormItemParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ValidatorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ValidatorTypeParameterSet, IocContainer.GROUP_SERIALIZATION, CompositeParameterSetXMLParser);
			IocContainer.registerType(ValidatorTargetParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PlayListParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(FLVPlayerParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser); 
			IocContainer.registerType(FLVSourceParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser); 
			
			/*IocContainer.registerType(IsNoneParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(IsNumberParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(IsPhoneNumberParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(IsCreditCardParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(IsEmailParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(IsEqualParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(IsZipCodeParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);*/
			
			IocContainer.registerType(RestrictParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(DisplayAsPassParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(PHPParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(NumericStepperOptionsParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(LabelParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(ArrayParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(DataProviderParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(LabelPlacementParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(CloneParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
			IocContainer.registerType(MouseEnableParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(GMapParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
			IocContainer.registerType(DynamicListParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);

			//IocContainer.registerType(ScrollParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);


			IocContainer.registerTypeList(ValidatorTypeParameterSet, IocContainer.GROUP_PARAMETERS, [ValidatorParameterSet, ValidatorTargetParameterSet]);
 
            // Registering required classes
            IocContainer.registerSimpleType(MouseTrigger);
            IocContainer.registerSimpleType(KeyBoardTrigger);
            IocContainer.registerSimpleType(TimerTrigger);
			IocContainer.registerSimpleType(ElementBuilder);
			IocContainer.registerSimpleType(MatrixUtils);
			IocContainer.registerSimpleType(BackgroundColorEditor);
			IocContainer.registerSimpleType(AbstractParameterSetEditor);
			IocContainer.registerSimpleType(TimerStoryboardPlayerImpl);
			IocContainer.registerSimpleType(IValidatorElementDescriptor);
			
			
			// gskinner easing equations
			IocContainer.registerSimpleType(InterpolationTypes);
			IocContainer.registerSimpleType(Back);
			IocContainer.registerSimpleType(Bounce);
			IocContainer.registerSimpleType(Back);
			IocContainer.registerSimpleType(Circular);
			IocContainer.registerSimpleType(NumericStepper);
			IocContainer.registerSimpleType(Circular);
			IocContainer.registerSimpleType(Cubic);
			IocContainer.registerSimpleType(Elastic);
			IocContainer.registerSimpleType(Exponential);
			IocContainer.registerSimpleType(Linear);
			IocContainer.registerSimpleType(Quadratic);
			IocContainer.registerSimpleType(Quartic);
			IocContainer.registerSimpleType(Quintic);
			IocContainer.registerSimpleType(Sine);
			/// validators
			IocContainer.registerSimpleType(ValidatorTypeParameterSet);
			IocContainer.registerSimpleType(IsNoneValidator)
			IocContainer.registerSimpleType(IsCreditCardValidator);
			IocContainer.registerSimpleType(IsEmailValidator);
			IocContainer.registerSimpleType(IsNumberValidator);
			IocContainer.registerSimpleType(IsPhoneNumberValidator)
			IocContainer.registerSimpleType(IsZipCodeValidator);
			
			IocContainer.registerSimpleType(NumericStepper)
			IocContainer.registerSimpleType(ComboBox)
			IocContainer.registerSimpleType(SelectableList)
			IocContainer.registerSimpleType(TextInputParameterSet);
			IocContainer.registerSimpleType(Label);
			IocContainer.registerSimpleType(FLVPlayback);
			
			IndexationManager;
			StoryTrigger;
			IsEqualParameterSet;
			ApiErrorManager;
			ToggleReverseStoryAction;
			NameSpaceUtils;
		}
	}
}