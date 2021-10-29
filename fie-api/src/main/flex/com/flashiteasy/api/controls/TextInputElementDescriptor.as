/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
 
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.controls.Validator.*;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IValidatorElementDescriptor;
	import com.flashiteasy.api.parameters.ValidatorParameterSet;
	import com.flashiteasy.api.parameters.ValidatorTargetParameterSet;
	import com.flashiteasy.api.parameters.ValidatorTypeParameterSet;
	
	import fl.controls.TextInput;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;


	/**
	 * Descriptor class for the <code><strong>TextInput</strong></code> form item. It can play the role of both TextField and TextArea.
	 * It also comes with a list of validators that can be applied to it.
	 */
	public class TextInputElementDescriptor extends FormItemElementDescriptor implements IUIElementDescriptor 
	{
		
		private var ti:TextInput;
		private var req_tf:TextField;
		private var _validator : IValidatorElementDescriptor;
		
		private var style : Object;
		
		/**
		 * Constructor
		 */
		public function TextInputElementDescriptor ():void
		{
			ti = this.getTextInput();
			super();
		}
		
		protected override function initControl():void
		{
			ti=new TextInput();
			req_tf=new TextField;
			face.addChild(ti);
			face.addChild(req_tf);
			
			var fmt : TextFormat = new TextFormat;
			fmt.align = TextFormatAlign.CENTER;
			fmt.font = "_sans";
			fmt.color=0xFF0000;
			fmt.size = 12;
			req_tf.defaultTextFormat = fmt;
			req_tf.width = 12;
			req_tf.height = 20;
			req_tf.x = ti.width+5;
			req_tf.y = ti.y;
			//req_tf.embedFonts = true;
			req_tf.text = "*";
			drawAsteriskForRequired();
		}
		
		override public function check() : Boolean
		{
			if (validator != null)
				return validator.validateString(this.getValue());
			else
				return true;
		}
		 
		/**
		 * 
		 * @return the TextInput value
		 */
		override public function getValue() : String {
			return ti.text;
		}
		
		protected override function onSizeChanged():void
		{
			ti.height = face.height;
			ti.width = face.width;
			req_tf.x = ti.x+ti.width+5;
			drawAsteriskForRequired();
		}
		
		override public function getDescriptorType():Class
		{
			return TextInputElementDescriptor;
		}
		
		/**
		 * Draws the red asterisk besides the TextInput when the required prop is set to true.
		 */
		public function drawAsteriskForRequired():void
		{
			req_tf.visible = this.required;
			this.getFace().invalidate();
		}

		/**
		 * @inheritDoc
		 */
		 override public function resetValues():void
		 {
		 	ti.text = "";
		 }
		 
		/**
		 * @inheritDoc
		 */
		 override public function displayError( s : String ):void
		 {
		 	ti.setStyle("backgroundColor", 0xCC0000);
		 	ti.text = s;
		 	this.getParameterSet().apply(this);
		 }
		 
		 /**
		  * Returs the instance of the TextInput component (used by validators)
		  * @return 
		  */
		 public function getTextInput() : TextInput
		 {
		 	return ti;
		 }
		
		 override public function get validator() : IValidatorElementDescriptor
		{
			if (_validator == null)
			{
				var v : IValidatorElementDescriptor;
				for each (var pset : IParameterSet in CompositeParameterSet(_params).getParametersSet());
				{
					trace ("TextInput parameterSet : "+ pset)
					if (pset is ValidatorTypeParameterSet)
					{
						for each (var p : IParameterSet in ValidatorTypeParameterSet(pset).getParametersSet())
						{
							trace ("inner pset : "+ p);
							if (p is ValidatorTargetParameterSet)
							{
								
								v = createValidator(ValidatorTargetParameterSet(p).getValidatorType(), ValidatorTargetParameterSet(p).target);
								break
							}
							else if (p is ValidatorParameterSet)
							{
								v = createValidator (ValidatorParameterSet(p).type);
								break;
							}
						}
					}				
				}
				return v;
			}
			else
			{
				return _validator;
			}
		}
		
		override public function set validator( value : IValidatorElementDescriptor ) : void
		{
			_validator = value;
		}
		
		/**
		 * Validator creation
		 * @param type
		 * @param args
		 * @return 
		 */
		public function createValidator( type : String,...args ) : IValidatorElementDescriptor 
		{
	 		 var c:Class=getDefinitionByName( "com.flashiteasy.api.controls.Validator."+type ) as Class;
			trace ("Applying validator type "+c);
			if (type == "IsEqualValidator")
			{
				return new c( this, args[0] );  
			}
			else
			{
				return new c(this);
			}
		}
		
		 
	}
}
