package com.flashiteasy.admin.utils
{
	import mx.controls.ComboBox;
	import mx.utils.ObjectUtil;
	
	public class FlexComponentsUtils
	{
		public static function setSimpleComboSelection(combo:ComboBox,val:String):void
		{
			var length:uint = combo.dataProvider.length;
			
			for (var i:uint = 0; i < length; i++)
			{
				if (combo.dataProvider.getItemAt(i).toLowerCase() == val.toLowerCase())
				{
					combo.selectedIndex = i;
					return;
				}
			}
			combo.selectedIndex = -1;
			combo.validateNow();
			combo.text = val;
		}
		
		public static function removeDuplicates( ac :Array ) : Array {
		    for(var i:uint=0; i <(ac.length-1); i++)
		    {
				var item:* = ac[i];
				for(var j:uint = (i+1); j <ac.length; j++)
				{
					var compareItem:* = ac[j];
					var result:int = ObjectUtil.compare(item, compareItem);
					if(result == 0)
					{
						ac.splice(j, 1);
						j-=1;
					}
				}
			}
			return ac;
		}
		
	}
}