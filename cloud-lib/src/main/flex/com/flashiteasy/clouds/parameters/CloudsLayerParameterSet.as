package com.flashiteasy.clouds.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;

	import com.flashiteasy.clouds.lib.ICloudableElementDescriptor;
	import com.flashiteasy.clouds.lib.CloudsElementDescriptor;

	[ParameterSet(description="Clouds", type="Reflection",  groupname="Block_Content")]
	public class CloudsLayerParameterSet extends AbstractParameterSet
	{

		override public function apply(target:IDescriptor) : void
		{
			ICloudableElementDescriptor( target ).setMovingClouds(hSpeed, vSpeed);
		} 
		
		private var _hSpeed : int = 2;
		
		
		[Parameter(type="Number", defaultValue="2", min="-10",max="10",row="0",sequence="0",label="hSpeed")]
		public function get hSpeed() : int
		{
			return _hSpeed;
		}
		
		public function set hSpeed( value : int ) : void
		{
			_hSpeed = value;
		}
		
		
		private var _vSpeed : int = 1;
		
		
		[Parameter(type="Number", defaultValue="1", min="-10",max="10",row="0",sequence="0",label="vSpeed")]
		public function get vSpeed() : int
		{
			return _vSpeed;
		}
		
		public function set vSpeed( value : int ) : void
		{
			_vSpeed = value;
		}
		
		
	}
}