/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.snow.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.snow.lib.ISnowableElementDescriptor;

	[ParameterSet(description="Snow", type="Reflection",  groupname="Block_Content")]
	public class SnowEmitterParameterSet extends AbstractParameterSet
	{


		override public function apply(target:IDescriptor) : void
		{
			ISnowableElementDescriptor( target ).setSnowStorm(_flakesQuantity, _flakeColor, _useMouseForWind); 
		} 

		private var _flakesQuantity : uint = 100;
		
		
		[Parameter(type="Number", defaultValue="100",  row="0", sequence="0", label="Nb")]
		public function get numberOfFlakes() : uint
		{
			return _flakesQuantity;
		}
		
		public function set numberOfFlakes( value : uint ) : void
		{
			_flakesQuantity = value;
		}
		
		private var _flakeColor:uint = 0xffffff;
		
		[Parameter(type="Color", defaultValue="0xffffff",  row="0", sequence="1", label="Color")]
		public function get flakeColor() : uint
		{
			return _flakeColor;
		}
		
		public function set flakeColor( value : uint ) : void
		{
			_flakeColor = value;
		}
		
		private var _useMouseForWind:Boolean = false;
		
		[Parameter(type="Boolean",defaultValue="false",row="1",sequence="2",label="Mouse")]
		public function get useMouseForWind() : Boolean
		{
			return _useMouseForWind;
		}
		
		public function set useMouseForWind( value : Boolean ) : void
		{
			_useMouseForWind = value;
		}
		
	}
}