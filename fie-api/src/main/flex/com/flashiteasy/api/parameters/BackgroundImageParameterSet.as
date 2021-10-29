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
	import com.flashiteasy.api.core.elements.IBackgroundImageElementDescriptor;

	[ParameterSet(description="Background_Image", type="Reflection", groupname="Block_Decoration")]
	/**
	 * The <code><strong>AlignParameterSet</strong></code> is the parameterSet
	 * that handles the control's background image, its alpha and a repetirion type.
	 * The metadata sets its editors via reflection in the Decoration group, using 
	 * a Slider for alpha and a source editor (browser) for the image.
	 * <p>
	 * The background image fills the control bounding box, regardless of its original proportions.
	 * </p>
	 * @warning : the repetition mode (repeat property) remains to code. 
	 */
	public class BackgroundImageParameterSet extends AbstractParameterSet
	{
		override public function apply(target: IDescriptor):void
		{
			super.apply( target );
			if( target is IBackgroundImageElementDescriptor )
			{
				IBackgroundImageElementDescriptor( target ).setBackgroundImage( source , alpha ,repeat ); 
			}
		}
		
		private var _alpha : Number = 1;
		[Parameter(type="Slider",defaultValue="1", min="0", max="1", interval="0.01", row="1", sequence="1", label="Alpha")]
		/**
		 * Background image transparency 
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set alpha(value:Number):void
		{
			_alpha = value ;	
		}
		
		private var _source: String;
		
		[Parameter(type="Source", defaultValue="null", row="0", sequence="0", label="Source")]
		/**
		 * Background image source. 
		 */
		public function get source():String{
			return _source;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set source( value:String ):void{
			_source=value;
		}
		
		private var _repeat:String;
		
		/**
		 * 
		 * @return 
		 */
		public function get repeat():String{
			return _repeat;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set repeat( value:String ):void{
			_repeat=value;
		}
		
	}
}