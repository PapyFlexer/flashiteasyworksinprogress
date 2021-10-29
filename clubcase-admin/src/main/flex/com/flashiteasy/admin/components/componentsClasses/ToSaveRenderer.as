package com.flashiteasy.admin.components.componentsClasses
{
	//import mx.controls.treeClasses.TreeItemRenderer; 
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.workbench.impl.NavigationTree;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import mx.collections.*;
	import mx.controls.treeClasses.*;

	public class ToSaveRenderer extends TreeItemRenderer
	{
		public function ToSaveRenderer()
		{
			super();
		}
		// Override the updateDisplayList() method 
        // to set the text for each tree node.      
        override protected function updateDisplayList(unscaledWidth:Number, 
            unscaledHeight:Number):void {
       
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if(super.data)
            {
            	var navitem:NavigationTree = ApplicationController.getInstance().getNavigation();
            	var pageUrl:String = navitem.createUrlFromItem(TreeListData(super.listData).item);
            	var page:Page = BrowsingManager.getInstance().getPageByUrl(BrowsingManager.getInstance().getProject(), pageUrl);
            	
                if(ApplicationController.getInstance().getIsInSaveList(page))
                {
                   super.label.text =  TreeListData(super.listData).label + "*";
                       // super.label.setColor(0xFF0000);
                }
                else
                {
                	super.label.text =  TreeListData(super.listData).label;
                       // super.label.setColor(0x000000);
                }
            }
        }

		
	}
}