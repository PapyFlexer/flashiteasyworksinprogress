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
	import com.flashiteasy.api.controls.Validator.IsEqualValidator;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;

	/**
	 * 
	 * @private
	 */
	public class IsEqualParameterSet extends AbstractParameterSet
	{
		/**
		 * 
		 */
		private var _target: String;
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( targ: IDescriptor ) : void
		{
			if( targ is IsEqualValidator )
			{
				IsEqualValidator( targ ).target = _target;
			}
			super.apply( targ );
		}
		
		/**
		 * Top left corner radius 
		 */
		public function get target():String
		{
			return _target;
		}

		/**
		 * 
		 * @private
		 */
		public function set target(value:String):void
		{
			_target = value;
		}
		
		
	}
}