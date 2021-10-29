package com.flashiteasy.admin.components.componentsClasses
{
	//import mx.controls.treeClasses.TreeItemRenderer; 
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.uicontrol.menu.XMLContainerList;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.XMLFileList;
	
	import mx.collections.*;
	import mx.controls.listClasses.*;

	public class ToSaveListRenderer extends ListItemRenderer
	{
		public function ToSaveListRenderer()
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
            	
            	var xmlitem:XMLContainerList = ApplicationController.getInstance().getXMLContainerList();
            	var page:Page=XMLFileList.getInstance().findXML(super.listData.label);
            	// BrowsingManager.getInstance().
                if(ApplicationController.getInstance().getIsInSaveList(page))
                {
                   super.label.text =  super.listData.label + "*";
                       // super.label.setColor(0xFF0000);
                }
                else
                {
                	super.label.text =  super.listData.label;
                       // super.label.setColor(0x000000);
                }
            }
        }

		
	}
}