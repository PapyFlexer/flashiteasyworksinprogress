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
	public class MouseEnableParameterSet extends AbstractParameterSet
	{
		override public function apply(target: IDescriptor):void
		{
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().mouseEnabled = enableMouse;
				IUIElementDescriptor( target ).getFace().mouseChildren = enableMouseChildren; 
			}
			//}
		}
		
		private var _enableMouse:Boolean = true;
		/**
		 * Mouse interactions
		 */
		[Parameter(type="Boolean",defaultValue="true",  row="0", sequence="0", label="MouseEnable")]
		/**
		 * Mouse interaction
		 */
		public function get enableMouse() : Boolean{
			return _enableMouse;
		}
		/**
		 * 
		 * @private
		 */
		public function set enableMouse( value : Boolean ):void{
			_enableMouse = value;
		}
		
		private var _enableMouseChildren:Boolean = true;
		/**
		 * Mouse interactions
		 */
		[Parameter(type="Boolean",defaultValue="true",  row="0", sequence="1", label="MouseChildrenEnable")]
		/**
		 * Mouse children interaction
		 */
		public function get enableMouseChildren() : Boolean{
			return _enableMouseChildren;
		}
		/**
		 * 
		 * @private
		 */
		public function set enableMouseChildren( value : Boolean ):void{
			_enableMouseChildren = value;
		}
		
	}
}