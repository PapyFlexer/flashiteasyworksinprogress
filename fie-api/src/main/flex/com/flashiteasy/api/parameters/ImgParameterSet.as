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
	import com.flashiteasy.api.core.elements.IImgElementDescriptor;

	[ParameterSet(description="null", type="Reflection", groupname="Block_Content")]
	/**
	 * The <code><strong>ImgParameterSet</strong></code> is the parameterSet
	 * that handles the Image control..
	 * The metadata sets its editors via reflection in the Content group, using 
	 * a source component in admin mode (browser).
  	 * 
	 */
	public class ImgParameterSet extends AbstractParameterSet //implements IRemoteParameterSet
	{
		
		private var _source : String;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			if( target is IImgElementDescriptor )
			{
				IImgElementDescriptor( target ).setImage( source );
			}
		}
		
		[Parameter(type="Source", defaultValue="null", row="0", sequence="0", label="Source")]
		/**
		 * The local path of the image (file browser in admin mode).  
		 */
		public function get source():String{
			return _source;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set source( value:String ):void{
			_source=value;
		}
		
	}
}