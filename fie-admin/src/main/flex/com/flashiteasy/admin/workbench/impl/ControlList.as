package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.utils.IconUtility;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.admin.conf.Conf;
	import mx.controls.List;
	
	public class ControlList
	{
		private var _list:List;
		
		public function init(list:List):void
		{
			this._list=list;
			_list.labelFunction=getLabel;
			_list.iconFunction=getIcon;
			_list.dragEnabled=true;
		}
		
		private function getIcon ( o:Object ) : Class 
		{
			var defaultImgUrl:String = "assets/brick.png";
			var imgUrl:String = "assets/"+String(o).split("::")[1].split("ElementDescriptor")[0]+"_icon.png";
			
			return IconUtility.getClass(_list, imgUrl, defaultImgUrl);
			//return String(o).split("::")[1].split("ElementDescriptor")[0];
		}
		
		private function getLabel ( o:Object ) : String 
		{
			return Conf.languageManager.getLanguage(String(o).split("::")[1].split("ElementDescriptor")[0]);
		}
		
		public function update():void
		{
			_list.dataProvider=IocContainer.getControls();
		}
	}
}