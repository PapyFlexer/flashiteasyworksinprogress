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
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IBackgroundColorableElementDescriptor;

	//[ParameterSet(description="Couleur de fond", type="Custom", customClass="com.flashiteasy.api.editor.impl.SimpleBackgroundColorEditorImpl")]
	[ParameterSet(description="Background_Color", type="Reflection", groupname="Block_Decoration")]
	/**
	 * The <code><strong>BackgroundColorParameterSet</strong></code> is the parameterSet
	 * that handles the coloring and transparency of a Control background.
	 * The metadata sets its editors via reflection in the Decoration group, using 
	 * a ColorPicker for the color and a Slider for transparency
	 */
	public class BackgroundColorParameterSet extends AbstractParameterSet
	{
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target:IDescriptor):void
		{
			//super.apply( target );
			if ( target is IUIElementDescriptor )
			{
				IBackgroundColorableElementDescriptor( target ).setBackgroundColor( backgroundColor, backgroundAlpha ); 
			}
		}
		
		private var _bgColor : Number = NaN;
		
		[Parameter(type="Color", defaultValue="NaN",  row="0", sequence="0", label="Color")]
		/**
		 * The background color, using a ColorPicker
		 */
		public function get backgroundColor() : Number
		{
			return _bgColor;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set backgroundColor( value : Number ) : void
		{
			_bgColor = value;
		}
		
		private var _bgAlpha : Number=1;
		
		[Parameter(type="Slider", defaultValue="1", min="0", max="1", interval="0.01", row="0", sequence="1", label="Alpha")]
		/**
		 * The background transparency, using a Slider
		 */
		public function get backgroundAlpha() : Number
		{
			return _bgAlpha;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set backgroundAlpha( value : Number ) : void
		{
			_bgAlpha = value;
		}
	}
}