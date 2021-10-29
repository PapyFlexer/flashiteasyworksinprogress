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
	import com.flashiteasy.api.core.action.IChangeParameterAction;

	[ParameterSet(description="Change_parameter",type="Reflection", groupname="Actions")]
	/**
	 * 
	 * @private
	 */
	public class ChangeValueParameterSet extends AbstractParameterSet
	{
		
		override public function apply( target : IDescriptor ) : void
		{
			if(target is IChangeParameterAction )
			{
				IChangeParameterAction(target).initNewParameterValue(_target , _parameter , _property , _value );
			}
		}
		
		private var _target : String ;
		
		/**
		 * 
		 * @param value
		 */
		public function set target( value : String ) : void 
		{
			_target = value;
		}
		
		[Parameter(type="ParameterEditor", defaultValue="",row="0", sequence="0", label="Parameter_editor")]
		/**
		 * 
		 * @return 
		 */
		public function get target():String
		{
			return _target;
		}
		
		private var _parameter : String ;
		
		/**
		 * 
		 * @param value
		 */
		public function set parameterSet( value : String ) :void 
		{
			_parameter = value ;
		}
		
		private var _property : String ;
		
		/**
		 * 
		 * @param value
		 */
		public function set property( value : String ) : void 
		{
			_property = value ;			
		}

		private var _value : Object ;
		
		/**
		 * 
		 * @param v
		 */
		public function set value ( v : Object ) : void 
		{
			_value = v;	
		}
	}
}