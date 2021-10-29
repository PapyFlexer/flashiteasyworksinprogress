package com.flashiteasy.admin.conf
{
	import com.flashiteasy.admin.browser.Browser;
	import com.flashiteasy.admin.components.CustomDragList;
	import com.flashiteasy.admin.components.StageTimeLine;
	import com.flashiteasy.admin.manager.AdminManager;
	import com.flashiteasy.admin.uicontrol.AdvancedPanel;
	import com.flashiteasy.admin.uicontrol.story.TimelineContainer;
	
	import flash.display.Stage;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	
	public class Ref
	{
		public static var browser : Browser;
		
		public static var adminManager : AdminManager;
		public static var ADMIN_STAGE : Stage;
		public static var workspaceContainer : Canvas;
		public static var editorContainer : VBox;
		public static var controlContainer : VBox;
		public static var actionContainer : HBox;
		public static var storyContainer : HBox;
		public static var timelineContainer:HBox;
		public static var controlList : CustomDragList;
		public static var actionList : CustomDragList;
		public static var storyList : CustomDragList;
		public static var timelineComponent : TimelineContainer;
		public static var stageTimeLine:StageTimeLine;
		public static var workspacePanel : AdvancedPanel;
	}
}