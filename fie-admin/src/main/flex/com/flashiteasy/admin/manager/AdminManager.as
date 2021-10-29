package com.flashiteasy.admin.manager
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.ICommand;
	import com.flashiteasy.admin.commands.IRedoableCommand;
	import com.flashiteasy.admin.commands.IUndoableCommand;
	import com.flashiteasy.admin.commands.menus.AlignCommand;
	import com.flashiteasy.admin.commands.menus.DegroupCommand;
	import com.flashiteasy.admin.commands.menus.DistributeCommand;
	import com.flashiteasy.admin.commands.menus.GroupCommand;
	import com.flashiteasy.admin.commands.menus.SpaceCommand;
	import com.flashiteasy.admin.commands.menus.SwapDepthCommand;
	import com.flashiteasy.admin.components.style.StyleEditor;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.event.ProjectEvent;
	import com.flashiteasy.admin.fieservice.IndexationService;
	import com.flashiteasy.admin.popUp.AdminLibraryManager;
	import com.flashiteasy.admin.popUp.FileBrowser;
	import com.flashiteasy.admin.popUp.IndexationEditor;
	import com.flashiteasy.admin.popUp.MessagePopUp;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.admin.popUp.ProjectChooser;
	import com.flashiteasy.admin.popUp.components.BitmapExportComponent;
	import com.flashiteasy.admin.popUp.components.FontInfoComponent;
	import com.flashiteasy.admin.popUp.components.VersionComponent;
	import com.flashiteasy.admin.uicontrol.ControlGroupPanel;
	import com.flashiteasy.admin.uicontrol.menu.XMLContainerList;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.admin.workbench.impl.StoryElementEditorImpl;
	import com.flashiteasy.admin.xml.XmlSave;
	import com.flashiteasy.admin.xml.XmlSerializer;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.utils.ElementDescriptorUtils;
	import com.flashiteasy.api.utils.FontLoader;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	
	import mx.containers.VBox;
	import mx.controls.HorizontalList;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.ItemClickEvent;

	public class AdminManager
	{
		public function AdminManager()
		{
		}

		private var alert:MessagePopUp;
		private var _isOpen:Boolean=true;
		private var _closedGroupList:Array=[];

		public function openStyleEditor():void
		{

			var styleBox:StyleEditor=new StyleEditor;
			var p:PopUp=new PopUp(Application.application as DisplayObject);
			p.getWindow().title = Conf.languageManager.getLanguage("Style_Editor");
			p.addChild(styleBox);
			p.display();
		}

		public function openIndexationEditor():void
		{
			var indexationBox:IndexationEditor=new IndexationEditor;
			var p:PopUp=new PopUp(Application.application as DisplayObject);
			p.getWindow().title = Conf.languageManager.getLanguage("Indexation");
			p.addChild(indexationBox);
			p.display();
		}

		public function transformToHTML():void
		{
			alert = new MessagePopUp(Conf.languageManager.getLanguage("Loading metadata..."), mx.core.Application.application as DisplayObject, true);
			doTransformHtml();
		}
		
		private function doTransformHtml():void
		{
			alert.closePopUp();
			var p:Page=BrowsingManager.getInstance().getCurrentPage();
			var manager:IndexationService=new IndexationService;
			//manager.saveHTML( p , XMLUtils.mergeXML(p));
			manager.saveHTML(p, XmlSerializer.serializePage(PageUtils.getFirstPage(p), "html", p, PageUtils.getPageLevel(p)));
				
		}

		public function openLibraryManager():void
		{
			var libraryWindow:AdminLibraryManager=new AdminLibraryManager
			var p:PopUp=new PopUp(Application.application as DisplayObject);
			
			p.getWindow().title = Conf.languageManager.getLanguage("Librairies");
			p.addChild(libraryWindow);
			p.display();
		}


		public function openVersionManager():void
		{
			var versionWindow:VersionComponent=new VersionComponent;
			var p:PopUp=new PopUp(Application.application as DisplayObject);
			p.getWindow().title = Conf.languageManager.getLanguage("Version");
			p.addChild(versionWindow);
			p.display()
		}


		public function openBitmapExporter():void
		{
			var bmpExportWindow:BitmapExportComponent = new BitmapExportComponent;
			var p:PopUp=new PopUp(Application.application as DisplayObject);
			
			p.getWindow().title = Conf.languageManager.getLanguage("Image_Export");
			p.addChild(bmpExportWindow);
			p.display();
		}


		public function getClosedGroupList():Object
		{
			return _closedGroupList;
		}

		public function getGroupIsOpen(group:String):Boolean
		{
			return (_closedGroupList.indexOf(group) == -1);
		}

		public function setClosedGroupList(group:String, opened:Boolean):void
		{
			if (!opened)
			{
				if (_closedGroupList.indexOf(group) == -1)
				{
					_closedGroupList[_closedGroupList.length]=group;
				}
			}
			else if (_closedGroupList.indexOf(group) != -1)
			{
				_closedGroupList.splice(_closedGroupList.indexOf(group), 1);
			}
		}

		public var changedParameterList:Array;
		public var previousValueList:Object;
		public var changedDescriptor:ParameterSetEditionDescriptor;
		public var focusOutEnabled:Boolean=true;

		public function checkForCommitParameterChange():void
		{
			//We check if a parameter of the descriptor has changed and is different than the actual one
			//If so we validate the previous change
			if (changedDescriptor != null && changedParameterList != null)
			{
				if (ApplicationController.getInstance().getElementEditor() is StoryElementEditorImpl)
				{

					trace("checkParameterChange Setting new command in story " + changedParameterList);
					ApplicationController.getInstance().getElementEditor().resetParameterChangeBatchCommand();

				}
				else
				{
					trace("checkParameterChange Setting new command ");

					ApplicationController.getInstance().getCommand().addCommand(ApplicationController.getInstance().getElementEditor().parameterChangeBatchCommand);
					ApplicationController.getInstance().getElementEditor().resetParameterChangeBatchCommand();
				}
				changedParameterList=null;
				changedDescriptor=null;
				previousValueList=null;
				focusOutEnabled=false;
			}
			else
			{
				focusOutEnabled=true;
			}
			_lastAlignItemClicked=null;
		}


		private var _lastAlignItemClicked:Object=null;

		public function alignHandler(event:ItemClickEvent):void
		{
			var controls:Array=VisualSelector.getInstance().getSelectedElements();
			if (controls.length > 1 && _lastAlignItemClicked != event.item)
			{
				_lastAlignItemClicked=event.item;
				if (event.target.id == "alignh")
				{
					switch (event.index)
					{
						case 0:
							ApplicationController.getInstance().getCommand().addCommand(new AlignCommand(controls, "left"));
							break;
						case 1:
							ApplicationController.getInstance().getCommand().addCommand(new AlignCommand(controls, "centerh"));
							break;
						case 2:
							ApplicationController.getInstance().getCommand().addCommand(new AlignCommand(controls, "right"));
							break;
					}
				}
				else
				{
					switch (event.index)
					{
						case 0:
							ApplicationController.getInstance().getCommand().addCommand(new AlignCommand(controls, "top"));
							break;
						case 1:
							ApplicationController.getInstance().getCommand().addCommand(new AlignCommand(controls, "centerv"));
							break;
						case 2:
							ApplicationController.getInstance().getCommand().addCommand(new AlignCommand(controls, "bottom"));
							break;
					}
				}
			}
		}

		public function distributeHandler(event:ItemClickEvent):void
		{
			var controls:Array=VisualSelector.getInstance().getSelectedElements();
			if (controls.length > 1 && _lastAlignItemClicked != event.item)
			{
				_lastAlignItemClicked=event.item;
				if (event.target.id == "distributeh")
				{

					switch (event.index)
					{
						case 0:
							ApplicationController.getInstance().getCommand().addCommand(new DistributeCommand(controls, "left"));
							break;
						case 1:
							ApplicationController.getInstance().getCommand().addCommand(new DistributeCommand(controls, "centerh"));
							break;
						case 2:
							ApplicationController.getInstance().getCommand().addCommand(new DistributeCommand(controls, "right"));
							break;
					}
				}
				else
				{
					switch (event.index)
					{
						case 0:
							ApplicationController.getInstance().getCommand().addCommand(new DistributeCommand(controls, "top"));
							break;
						case 1:
							ApplicationController.getInstance().getCommand().addCommand(new DistributeCommand(controls, "centerv"));
							break;
						case 2:
							ApplicationController.getInstance().getCommand().addCommand(new DistributeCommand(controls, "bottom"));
							break;
					}
				}
			}
		}

		public function spaceHandler(event:ItemClickEvent):void
		{
			var controls:Array=VisualSelector.getInstance().getSelectedElements();
			if (controls.length > 1 && _lastAlignItemClicked != event.item)
			{
				_lastAlignItemClicked=event.item;
				switch (event.index)
				{
					case 0:
						if (controls.length > 1)
						{
							ApplicationController.getInstance().getCommand().addCommand(new SpaceCommand(controls, "h"));
						}
						break;
					case 1:
						if (controls.length > 1)
						{
							ApplicationController.getInstance().getCommand().addCommand(new SpaceCommand(controls, "v"));
						}
						break;
				}
			}
		}

		public function groupHandler(event:ItemClickEvent):void
		{
			var controls:Array=VisualSelector.getInstance().getSelectedElements();
			switch (event.index)
			{
				case 0:
					if (controls.length > 1)
					{
						ApplicationController.getInstance().getCommand().addCommand(new GroupCommand(controls));
					}
					break;
				case 1:
					ApplicationController.getInstance().getCommand().addCommand(new DegroupCommand(controls[0] as IUIElementContainer));
					break;
			}
		}

		public function swapDepthHandler(event:ItemClickEvent):void
		{

			var descriptor:IUIElementDescriptor=VisualSelector.getInstance().getSelectedElement();
			if (descriptor != null)
			{
				switch (event.index)
				{
					case 0:
						toRear(descriptor);
						break;
					case 1:
						sendBackward(descriptor);
						break;
					case 2:
						bringForward(descriptor);
						break;
					default:
						toFront(descriptor);
						break;
				}
			}
		}

		public function undo():void
		{
			Ref.adminManager.checkForCommitParameterChange();
			if (ApplicationController.getInstance().getCommand().hasPreviousCommand())
			{
				var command:ICommand=ApplicationController.getInstance().getCommand().getPreviousCommand();
				IUndoableCommand(command).undo();
			}
		}

		public function redo():void
		{
			Ref.adminManager.checkForCommitParameterChange();
			if (ApplicationController.getInstance().getCommand().hasNextCommand())
			{
				(ApplicationController.getInstance().getCommand().getNextCommand() as IRedoableCommand).redo();
			}
		}

		public function saveXML():void
		{
			//Alert.show("Prepare_for_saving...");
			XmlSave.saveCurrentPage();
		}

		public function openAvailableProjects():void
		{
			var pjm:ProjectManager=ProjectManager.getInstance();
			pjm.loadInformation();
			pjm.addEventListener(ProjectEvent.PROJECTS_INFO_LOADED, onProjectsListed);
		}

		private function onProjectsListed(e:ProjectEvent):void
		{
			trace("opening projects choice PopUp");
			var pc:ProjectChooser=new ProjectChooser;
			var firstOpening:Boolean = AbstractBootstrap.getInstance() == null ? true : false;
			var p:PopUp=new PopUp(Application.application as DisplayObject, firstOpening, true, true, true,!firstOpening);
			p.addChild(pc);
			p.display();
		}

		public function loadTest():void
		{
			ApplicationController.getInstance().getWorkbench().reset(Ref.workspaceContainer);
			ApplicationController.getInstance().getElementEditor().reset(Ref.editorContainer);
			ApplicationController.getInstance().getControlList().init(Ref.controlList);
			ApplicationController.getInstance().getActionList().init(Ref.actionList);
			ApplicationController.getInstance().getWorkbench().loadApplication(Conf.APP_ROOT, "FieApp");
			var blockPanel:ControlGroupPanel=new ControlGroupPanel;
			blockPanel.groupname=Conf.languageManager.getLanguage("Page_Blocks");
			blockPanel.addChild(ApplicationController.getInstance().getBlockList().getUIComponent());

			Ref.controlContainer.addChild(blockPanel);
			var pagePanel:ControlGroupPanel=new ControlGroupPanel;
			pagePanel.groupname=Conf.languageManager.getLanguage("Project_Pages");
			pagePanel.addChild(ApplicationController.getInstance().getNavigation().getUIComponent());
			pagePanel.addChild(ApplicationController.getInstance().getXMLContainerList());
			Ref.controlContainer.addChild(pagePanel);
			Ref.actionContainer.addChild(ApplicationController.getInstance().getActionEditor().getUIComponent());
			Ref.storyContainer.addChild(ApplicationController.getInstance().getStoryEditor().getUIComponent());

		}


		private var _pagePanel:ControlGroupPanel;
		private var _pageComponent:VBox;
		private var _xmlComponent:XMLContainerList;
		private var _blockPanel:ControlGroupPanel;
		private var _blockComponent:UIComponent;
		private var _actionComponent:HorizontalList;
		private var _storyComponent:HorizontalList;

		public function loadProjectFromChooser(appRoot:String, appName:String, appType:String):void

		{
			if (AbstractBootstrap.getInstance() == null)
			{
				_blockPanel=new ControlGroupPanel;
				_blockPanel.groupname=Conf.languageManager.getLanguage("Page_Blocks");
				_blockComponent=ApplicationController.getInstance().getBlockList().getUIComponent();
				_blockPanel.addChild(_blockComponent);
				Ref.controlContainer.addChild(_blockPanel);
				_pagePanel=new ControlGroupPanel;
				_pagePanel.groupname=Conf.languageManager.getLanguage("Project_Pages");
				_pageComponent=ApplicationController.getInstance().getNavigation().getUIComponent();
				_pagePanel.addChild(_pageComponent);
				_xmlComponent=ApplicationController.getInstance().getXMLContainerList();
				_pagePanel.addChild(_xmlComponent);
				Ref.controlContainer.addChild(_pagePanel);
				_actionComponent=ApplicationController.getInstance().getActionEditor().getUIComponent();
				_storyComponent=ApplicationController.getInstance().getStoryEditor().getUIComponent();
				Ref.actionContainer.addChild(_actionComponent);
				Ref.storyContainer.addChild(_storyComponent);
			}
			else
			{
				ApplicationController.getInstance().reset();
				_pagePanel.removeChild(_pageComponent);
				if(_pagePanel.contains(_xmlComponent))
					_pagePanel.removeChild(_xmlComponent);
				
				_blockPanel.removeChild(_blockComponent);
				if(Ref.actionContainer.contains(_actionComponent))
					Ref.actionContainer.removeChild(_actionComponent);
				if(Ref.storyContainer.contains(_storyComponent))
					Ref.storyContainer.removeChild(_storyComponent);

				_pageComponent=ApplicationController.getInstance().getNavigation().getUIComponent();
				_xmlComponent=ApplicationController.getInstance().getXMLContainerList();
				_blockComponent=ApplicationController.getInstance().getBlockList().getUIComponent();

				_actionComponent=ApplicationController.getInstance().getActionEditor().getUIComponent();
				_storyComponent=ApplicationController.getInstance().getStoryEditor().getUIComponent();
				
				_pagePanel.addChild(_pageComponent);
				_pagePanel.addChild(_xmlComponent);
				_blockPanel.addChild(_blockComponent);
				Ref.actionContainer.addChild(_actionComponent);
				Ref.storyContainer.addChild(_storyComponent);

			}
			ApplicationController.getInstance().getWorkbench().reset(Ref.workspaceContainer);
			ApplicationController.getInstance().getElementEditor().reset(Ref.editorContainer);
			ApplicationController.getInstance().getControlList().init(Ref.controlList);
			ApplicationController.getInstance().getActionList().init(Ref.actionList);
			ApplicationController.getInstance().getWorkbench().loadApplication(appRoot, "FieApp");
			if(userIsRookie)
			{
				Application.application.editorContainer.width=0;
				if(Application.application.contains(Application.application.Controls))
					Ref.controlContainer.removeChild(Application.application.Controls);
				if(Application.application.contains(_blockPanel))	
				Ref.controlContainer.removeChild(_blockPanel);
				_pagePanel.removeChild(_xmlComponent);
				Ref.actionContainer.removeChild(_actionComponent);
				Ref.storyContainer.removeChild(_storyComponent);
			}

		}
		
		private var _userIsRookie:Boolean = false;
		
		public function get userIsRookie():Boolean
		{
			return _userIsRookie;
		}
		public function set userIsRookie(value:Boolean) : void
		{
			_userIsRookie = value;
		}
		
		public function startBrowser():void
		{
			var file:FileBrowser=new FileBrowser(Conf.APP_ROOT + "/font/ttf", Application.application as DisplayObject, false, false, true, false, true);
			var fontInfo:FontInfoComponent=new FontInfoComponent;
			fontInfo.familyValue=FontLoader.getFontFamilies();
			fontInfo.init(file.browser.ba);
			file.browser.fileBox.addChild(fontInfo);
		}

		public function keyDown(event:KeyboardEvent):void
		{
			trace("key :: " + event.keyCode);
			//Here we check controlKey that is the same for Mac-Command and PC-control
			//Could use charCode return 0 in the 2 cases
			//CouldUse short cut keyCode CTRL+Z= 26 and CTRL+Y=25 but that would oblige Mac users to use CTRL instead of COMMAND
			var controlPressed:Boolean=event.ctrlKey;
			if (controlPressed)
			{
				//Could use keyCode Z = 90 but in combination with CTRL it return 26
				var curKeyCode:int=event.keyCode;
				var curCharCode:int=event.charCode;
				//trace("CurrentKeyCode "+curKeyCode+"curCharCode"+curCharCode);
				if (curCharCode == 122 || curCharCode == 26)
				{
					Ref.adminManager.undo();
				}
				else if (curCharCode == 121 || curCharCode == 25)
				{
					Ref.adminManager.redo();
				}
				else if (curCharCode == 115 || curCharCode == 19)
				{
					Ref.adminManager.saveXML();
				}
					///Could be a way of moving element with keyboard but it's confusing with flex components
				/*else if(curKeyCode == Keyboard.UP)
				   {
				   VisualSelector.getInstance().tool.y-=1;
				   VisualSelector.getInstance().tool.currentControl=VisualSelector.getInstance().tool.moveControl;
				   VisualSelector.getInstance().tool.apply();
				   trace("ArrowUP");
				   }
				   else if(curKeyCode == Keyboard.DOWN)
				   {
				   VisualSelector.getInstance().tool.y+=1;
				   VisualSelector.getInstance().tool.currentControl=VisualSelector.getInstance().tool.moveControl;
				   VisualSelector.getInstance().tool.apply();
				   trace("ArrowDOWN");
				   }
				   else if(curKeyCode == Keyboard.RIGHT)
				   {
				   VisualSelector.getInstance().tool.x+=1;
				   VisualSelector.getInstance().tool.currentControl=VisualSelector.getInstance().tool.moveControl;
				   VisualSelector.getInstance().tool.apply();
				   trace("ArrowRIGHT");
				   }
				   else if(curKeyCode == Keyboard.LEFT)
				   {
				   VisualSelector.getInstance().tool.x-=1;
				   VisualSelector.getInstance().tool.currentControl=VisualSelector.getInstance().tool.moveControl;
				   VisualSelector.getInstance().tool.apply();
				   trace("ArrowLEFT");
				 }*/
			}
		}

		public function serializePage():void
		{
			trace("current page " + XmlSerializer.serializePage(BrowsingManager.getInstance().getCurrentPage()));
		}

		public function toFront(descriptor:IUIElementDescriptor):void
		{
			var elementDepth:int=ElementDescriptorUtils.getDescriptorDepth(descriptor);
			if (elementDepth < descriptor.getFace().parent.numChildren - 1)
			{
				var command:ICommand=new SwapDepthCommand(descriptor, "front");
				ApplicationController.getInstance().getCommand().addCommand(command);
			}
		}

		public function toRear(descriptor:IUIElementDescriptor):void
		{
			var elementDepth:int=ElementDescriptorUtils.getDescriptorDepth(descriptor);
			if (elementDepth > 0)
			{
				var command:ICommand=new SwapDepthCommand(descriptor, "rear");
				ApplicationController.getInstance().getCommand().addCommand(command);
			}
		}

		public function bringForward(descriptor:IUIElementDescriptor):void
		{

			var o:Object=descriptor.getFace().parent;
			var elementDepth:int=ElementDescriptorUtils.getDescriptorDepth(descriptor);
			if (elementDepth < descriptor.getFace().parent.numChildren - 1)
			{
				var command:ICommand=new SwapDepthCommand(descriptor, "forward");
				ApplicationController.getInstance().getCommand().addCommand(command);
			}
		}

		public function sendBackward(descriptor:IUIElementDescriptor):void
		{
			var elementDepth:int=ElementDescriptorUtils.getDescriptorDepth(descriptor);
			if (elementDepth > 0)
			{
				var command:ICommand=new SwapDepthCommand(descriptor, "backward");
				ApplicationController.getInstance().getCommand().addCommand(command);
			}
		}

		private function openProjectChoiceWindow():void
		{

		}

	}
}