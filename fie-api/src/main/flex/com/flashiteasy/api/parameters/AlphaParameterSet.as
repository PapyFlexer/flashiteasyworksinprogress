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

	[ParameterSet(description="null",type="Reflection", groupname="Effects")]
	/**
	 * The <code><strong>AlphaParameterSet</strong></code> is the parameterSet
	 * that handles the control transparency.
	 * The metadata sets its editors via reflexion in the Effects group, using 
	 * 1 slider (see alpha getter/setter ans its metadata at line 36).
	 */
	public class AlphaParameterSet extends AbstractParameterSet
	{
		override public function apply(target: IDescriptor):void
		{
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().alpha = alpha; 
			}
			//}
		}
		
		private var _alpha:Number=1;
		/**
		 * The editor's slider properties
		 */
		[Parameter(type="Slider",defaultValue="1", min="0", max="1", interval="0.01", row="0", sequence="0", label="Alpha")]
		/**
		 * Control's transparency
		 */
		public function get alpha():Number{
			return _alpha;
		}
		/**
		 * 
		 * @private
		 */
		public function set alpha(value:Number):void{
			_alpha=value;
		}
	}
}