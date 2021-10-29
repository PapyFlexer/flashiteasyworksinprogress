package com.flashiteasy.admin.uicontrol
{
	import com.flashiteasy.api.container.FormElementDescriptor;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import mx.controls.ComboBox;

	public class FormComboBox extends ComboBox
	{
		private var _dp : Array;
		
		public function FormComboBox()
		{
			super();
			labelField = "uuid";
		}
		
		
		override public function set dataProvider(value:Object):void
		{
			if (value is Array)
			{
				_dp = ArrayUtils.clone(value as Array)
				_dp.unshift( { uuid : "Select..." } );
			}
			super.dataProvider = _dp;
		}
		
		public function getSelectedFormName() : String
		{
			return (selectedItem as FormElementDescriptor).uuid;
		}
		
		public function setSelectedForm( formName : String ) : void
		{
			for( var i : int = 1; i < _dp.length && formName != null; i++ )
			{
				if( _dp[i].uuid == formName )
				{
					selectedIndex = i;
					return;
				}
			}
			selectedIndex = 0;
		}
	}
}