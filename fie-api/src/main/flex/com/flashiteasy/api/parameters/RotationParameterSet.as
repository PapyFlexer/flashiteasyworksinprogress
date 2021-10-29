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

	[ParameterSet(description="null",type="Reflection", groupname="Dimension")]
	/**
	 * The <code><strong>RotationParameterSet</strong></code> is the parameterSet
	 * that handles the rotation of a control.
	 */
	public class RotationParameterSet extends AbstractParameterSet
	{

		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply(target: IDescriptor):void
		{
			if ( target is IUIElementDescriptor )
			{
				IUIElementDescriptor(target).getFace().rotation=_rotation; 
			}

		}
		
		private var _rotationX:Number=0;
		//[Parameter(type="Slider",defaultValue="0", min="-360", max="360", interval="1", row="0", sequence="0", label="Rotation")]
		/**
		 * Sets the rotation around X axis (pseudo-3D) 
		 */
		public function get rotationX():Number{
			return _rotationX;
		}
		/**
		 * 
		 * @private
		 */
		public function set rotationX(value:Number):void{
			_rotationX=Math.round(value);
		}
		
		private var _rotationY : Number = 0 ;
		//[Parameter(type="Slider",defaultValue="0", min="-360", max="360", interval="1", row="1", sequence="1", label="Rotation")]
		/**
		 * Sets the rotation around Y axis (pseudo-3D) 
		 */
		public function get rotationY():Number{
			return _rotationY;
		}
		/**
		 * 
		 * @private
		 */
		public function set rotationY(value:Number):void{
			_rotationY=Math.round(value);
		}
		private var _rotation : Number = 0 ;
		[Parameter(type="Slider",defaultValue="0", min="-360", max="360", interval="1", row="1", sequence="1", label="Rotation")]
		/**
		 * 
		 * Sets the control rotation (around Z axis as usual : 2D like) 
		 */
		public function get rotation():Number{
			return _rotation;
		}
		/**
		 * 
		 * @private
		 */
		public function set rotation(value:Number):void{
			_rotation=Math.round(value);
		}
	}
		
}