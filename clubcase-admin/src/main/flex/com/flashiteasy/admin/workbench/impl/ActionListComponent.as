package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.utils.IconUtility;
	import com.flashiteasy.api.ioc.IocContainer;
	
	import mx.controls.List;

	public class ActionListComponent
	{
		private var _list:List;
		
		public function init(list:List):void
		{
			this._list=list;
			_list.labelFunction=getLabel;
			_list.iconFunction=getIcon;
			_list.dragEnabled=true;
		}
		
        private function getLabel ( o:Object ) : String 
        {
            return Conf.languageManager.getLanguage(String(o).split("::")[1].split("Action")[0]);
        }
		
		private function getIcon ( o:Object ) : Class 
		{
			var defaultImgUrl:String = "assets/brick.png";
			var imgUrl:String = "assets/"+String(o).split("::")[1].split("Action")[0]+"_icon.png";
			
			return IconUtility.getClass(_list, imgUrl, defaultImgUrl);
			//return String(o).split("::")[1].split("ElementDescriptor")[0];
		}
		
        public function update():void
        {
            trace("getting actions");
            _list.dataProvider=IocContainer.getActions();
        }
		
	}
}