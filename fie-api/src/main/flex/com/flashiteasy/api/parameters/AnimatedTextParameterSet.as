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
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.elements.IAnimatedTextElementDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flupie.textanim.TextAnimMode;
	import com.flupie.textanim.TextAnimSplit;
	
	[ParameterSet(description="Text Animations",type="Reflection", groupname="Text_Animations")]
	/**
	 * The <code><strong>AnimatedTextParameterSet</strong></code> is the parameterSet
	 * that handles the in and oiut transition for texte A,niamtedText Blocks.
	 * The transition can be set using combos, and the text block split mode
	 * is set by a final one, between, word, letter or line
	 */
	public class AnimatedTextParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target : IDescriptor) : void
		{
            if ( target is IAnimatedTextElementDescriptor)
            {
				IAnimatedTextElementDescriptor( target ).setAnimatedTextInTransition( transitionIn ); 
				IAnimatedTextElementDescriptor( target ).setAnimatedTextOutTransition( transitionOut ); 
				IAnimatedTextElementDescriptor( target ).setAnimatedTextSeparationType( separationType );
				IAnimatedTextElementDescriptor( target ).setAnimatedTextDelayBeforeStart( delayBeforeStart );
				IAnimatedTextElementDescriptor( target ).setAnimatedTextInterval( interval ); 
            }
		}
		
		private var _transitionIn : String = "alpha";
		private var _transitionOut :String = "alpha";
		private var _separationType:String = TextAnimSplit.WORDS;//letter/word/line
		private var _iterationMode :String = TextAnimMode.FIRST_LAST;
		private var _delayBeforeStart : uint = 0;
		private var _interval : uint = 100;
		
		[Parameter(type="Combo",defaultValue="rotate3D", row="0", sequence="0", label="In")]
		/**
		 * text animation in
		 */
		public function get transitionIn() : String
		{
			return _transitionIn;
		}
		/**
		 * 
		 * @private
		 */
		public function set transitionIn( value : String ) : void
		{
			_transitionIn = value;
		}

		[Parameter(type="Combo",defaultValue="rotate3D", row="0", sequence="1", label="Out")]
		/**
		 * text animation out
		 */
		public function get transitionOut() : String
		{
			return _transitionOut;
		}
		/**
		 * 
		 * @private
		 */
		public function set transitionOut( value : String ) : void
		{
			_transitionOut = value;
		}

		
		[Parameter(type="Combo",defaultValue="WORD", row="1", sequence="2", label="separation type")]
		/**
		 * text animation out
		 */
		public function get separationType() : String
		{
			return _separationType;
		}


		/**
		 * 
		 * @private
		 */
		public function set separationType( value : String ) : void
		{
			_separationType = value;
		}
		


		[Parameter(type="Combo",defaultValue="starttoend", row="1", sequence="3", label="way")]
		/**
		 * text iteration mode
		 */
		public function get iterationMode() : String
		{
			return _iterationMode;
		}


		/**
		 * 
		 * @private
		 */
		public function set iterationMode( value : String ) : void
		{
			_iterationMode = value;
		}

		
		[Parameter(type="Number",defaultValue="0", min="0", max="20000", step="100", row="2",sequence="4",label="Delay")]
		/**
		 * text anim delay
		 */
		public function get delayBeforeStart() : uint
		{
			return _delayBeforeStart;
		}


		/**
		 * 
		 * @private
		 */
		public function set delayBeforeStart( value : uint ) : void
		{
			_delayBeforeStart = value;
		}


		[Parameter(type="Number",defaultValue="100", min="0", max="2000", step="100", row="2",sequence="5",label="Interval")]
		/**
		 * text anim delay
		 */
		public function get interval() : uint
		{
			return _interval;
		}


		/**
		 * 
		 * @private
		 */
		public function set interval( value : uint ) : void
		{
			_interval = value;
		}



		/**
		 * defines the dataprovider of the editor's comboboxes : transitions in & out, split, mode .
		 * @param name 
		 * @return a dataprovider as an array
		 */
		public function getPossibleValues(name:String):Array
		{
			var values:Array;
			switch(name){
				case "transitionOut" :
				values = ["zoomIn","fromLeft","fromRight", "rotate3D"];
				break;

				case "transitionIn" :
				values = ["zoomOut","fromLeft","fromRight", "rotate3D"];
				break;

				case "separationType" :
				values = ArrayUtils.getConstant(TextAnimSplit);
				trace ("init animated text pSet split values="+values);
				break;
				
				case "iterationMode" :
				values = ArrayUtils.getConstant(TextAnimMode);
				trace ("init animated text pSet mode values="+values);
				break;
				
			}
			return values;
		}
		
	}
}