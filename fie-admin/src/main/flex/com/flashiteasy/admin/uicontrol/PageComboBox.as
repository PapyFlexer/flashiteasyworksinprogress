package com.flashiteasy.admin.uicontrol
{
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import mx.controls.ComboBox;

	public class PageComboBox extends ComboBox
	{
		private var _dp : Array;
		
		public function PageComboBox()
		{
			super();
			labelField = "link";
		}
		
		
		override public function set dataProvider(value:Object):void
		{
			if (value is Array)
			{
				_dp = ArrayUtils.clone( value as Array );
				_dp.unshift( { link : "Select" } );
			}
			super.dataProvider = _dp;
		}
		
		public function getSelectedLink() : Page
		{
			return selectedItem as Page;
		}
		
		public function setSelectedPage( p : Page ) : void
		{
			for( var i : int = 1; i < _dp.length && p != null; i++ )
			{
				if( _dp[i].link == p.link )
				{
					selectedIndex = i;
					return;
				}
			}
			selectedIndex = 0;
		}
	}
}