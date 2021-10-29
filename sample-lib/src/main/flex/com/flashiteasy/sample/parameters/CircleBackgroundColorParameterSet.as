 /**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.sample.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;

	[ParameterSet(description="Background_Color", type="Custom", customClass="com.flashiteasy.sample.editor.impl.SimpleBackgroundColorEditorImpl", groupname="custom")]
	/**
	 * In ParameterSet classes, metadata definitions  must be employed, 
	 * one for the constructor, and one for each property 
	 * that must be editable in admin mode.
	 * Here is an example, coming from the ImgParameteerSet from API.
	 * <listing>
			package com.flashiteasy.api.parameters
			{
				import com.flashiteasy.api.core.AbstractParameterSet;
				import com.flashiteasy.api.core.IDescriptor;
				import com.flashiteasy.api.core.elements.IImgElementDescriptor;
			
				<strong><span style="color:#CC0000;">[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]</span></strong>
				public class ImgParameterSet extends AbstractParameterSet
				{
						private var _source : String;
				
				 		override public function apply( target: IDescriptor ) : void
						{
								super.apply( target );
								if( target is IImgElementDescriptor )
								{
										IImgElementDescriptor( target ).setImage( source );
								}
						}
						
						<strong><span  style="color:#CC0000;">[Parameter(type="Source", defaultValue="null", row="0", sequence="0", label="Source")]</span></strong>
						public function get source():String{
								return _source;
						}
						
						public function set source( value:String ):void{
								_source=value;
						}
					
				}
			}
	 * </listing>
	 * The metadata in the constructor  :
	 * <ul>
	 * <li><code><strong>description</strong></code> : sets the label of the editor</li>
	 * <li><code><strong>type</strong></code> : can be either 'Reflection' or 'Custom'. If Reflexion, the editor will use built-in components, based on their types. As in this example we are writing a special editor that does not use built-in, the type 'Custom' is ok.</li>
	 * <li><code><strong>customClass</strong></code> : when custom, points to the editor class</li>
  	 * </ul>
  	 * 
	 * The meta delaclared for each property
	 * (in reflection mode, the meta type determins the component to use) :
	 * <ul>
	 * <li><code><strong>Boolean</strong></code> displays a CheckBox component</li>
	 * <li><code><strong>Number</strong></code> displays a NumericStepper component</li>
	 * <li><code><strong>String</strong></code> displays a TextInput component</li>
 	 * <li><code><strong>Color</strong></code> displays a ColorPicker component</li>
 	 * <li><code><strong>Source</strong></code> displays a FileBrowser component</li>
 	 * <li><code><strong>List</strong></code> displays a DataGrid component</li>
 	 * <li><code><strong>Slider</strong></code> displays a HSlider component</li>
 	 * <li><code><strong>...</strong></code> ... </li>
 	 * </ul>
 	 */
	public class CircleBackgroundColorParameterSet extends AbstractParameterSet
	{
		/** 
		 * The apply method must systematically be overridden.
		 * 
		 * 
		 */
		override public function apply(target:IDescriptor):void
		{
			IBackgroundColorableElementDescriptor( target ).setBackgroundColor( backgroundColor, backgroundAlpha ); 
		}
		
		private var _bgColor : Number = NaN;
		 /**
		 * If the parameterSet below had been tagged as Reflection, the metas for the properties
		 * backgroundColor and backgroundAlpha would display : 
		 * <ul>
  		 * <li> a <code><strong>ColorPicker</strong></code> for META.type="Color" </li>
  		 * <li> a <code><strong>HSlider</strong></code> for META.type="Slider" </li>
  		 * </ul>
  		 * See help document for more details.
		 */
		[Parameter(type="Color", defaultValue="NaN",  row="0", sequence="0", label="Color")]
		/**
		 * 
		 * @return 
		 */
		public function get backgroundColor() : Number
		{
			return _bgColor;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set backgroundColor( value : Number ) : void
		{
			_bgColor = value;
		}
		
		private var _bgAlpha : Number=1;
		
		[Parameter(type="Slider", defaultValue="1", min="0", max="1", interval="0.01", row="0", sequence="1", label="Alpha")]
		/**
		 * 
		 * @return 
		 */
		public function get backgroundAlpha() : Number
		{
			return _bgAlpha;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set backgroundAlpha( value : Number ) : void
		{
			_bgAlpha = value;
		}
	}
}