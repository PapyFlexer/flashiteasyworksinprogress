package com.flashiteasy.admin.workbench.impl
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.menus.ActionCreationCommand;
	import com.flashiteasy.admin.commands.menus.ElementCreationCommand;
	import com.flashiteasy.admin.commands.menus.StoryCreationCommand;
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.edition.IElementEditorPanel;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.popUp.InputStringPopUp;
	import com.flashiteasy.admin.popUp.MessagePopUp;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.admin.uicontrol.ButtonEditor;
	import com.flashiteasy.admin.utils.EditorUtil;
	import com.flashiteasy.admin.utils.Selection;
	import com.flashiteasy.admin.visualEditor.VisualSelector;
	import com.flashiteasy.admin.workbench.IElementEditor;
	import com.flashiteasy.admin.workbench.IWorkbench;
	import com.flashiteasy.admin.xml.XmlSave;
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.container.DynamicListElementDescriptor;
	import com.flashiteasy.api.container.XmlElementDescriptor;
	import com.flashiteasy.api.controls.ButtonElementDescriptor;
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.errors.ApiErrorManager;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ElementDescriptorFinder;
	import com.flashiteasy.api.utils.NameUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	/**
	 * Default implementation of the <code>Workbench</code> interface.
	 * Use a loader to retrieve remote resources.
	 */
	public class DefaultWorkbenchImpl extends EventDispatcher implements IWorkbench
	{
		private var workbenchContainer:Container;
		private var loader:URLLoader;
		private var _baseUrl:String;
		private var childDomain:ApplicationDomain;
		private var currentDomain:ApplicationDomain;
		private var namePopUp:InputStringPopUp;
		private var elementEditor:IElementEditor;


		private var externalApplication:AbstractBootstrap;
		// As the external application is a Sprite (it does not implement IUIComponent)
		// we need to wrap it inside an UIComponent
		private var wrapper:UIComponent=new UIComponent();
		private var currentPage:Page;
		public static var ADMIN_STAGE:Stage;

		// Liste des indicateurs de selection

		private var indicators:Array=new Array();

		private var highlightedBlock:IUIElementContainer;
		private var p:int=1;

		public function getApplication():AbstractBootstrap
		{
			return externalApplication ;
		}
		public function reset(container:Container):void
		{
			//workbenchContainer;
			workbenchContainer=container;
			workbenchContainer.removeAllChildren();


			loader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			initializeEventHandlers();

			workbenchContainer.addEventListener(DragEvent.DRAG_ENTER, dragAccept, false, 0, true);
			BrowsingManager.getInstance().addEventListener(FieEvent.RESIZE_STAGE_CONTAINER, refreshSiteContainer);
			VisualSelector.getInstance().init(workbenchContainer, elementEditor);
		}

		public function destroy():void
		{
			loader.removeEventListener(Event.COMPLETE, externalApplicationLoaded, false);
			loader=null;
			workbenchContainer.removeEventListener(DragEvent.DRAG_ENTER, dragAccept, false);
			BrowsingManager.getInstance().removeEventListener(FieEvent.RESIZE_STAGE_CONTAINER, refreshSiteContainer);
			wrapper.removeEventListener(MouseEvent.CLICK, triggerVisualElementEdit, true);
			removeApiErrorListener();
		/*wrapper.removeChild(externalApplication);
		   workbenchContainer.removeChild(wrapper);
		   workbenchContainer.removeAllChildren();
		   Ref.workspacePanel.removeChild(workbenchContainer);
		 Ref.workspacePanel.validateNow();*/
			 //delete this;
		}

		private function refreshSiteContainer(e:FieEvent):void
		{
			var multiplier : Number = workbenchContainer.scaleX > 1 ? workbenchContainer.scaleX : 1;
			workbenchContainer.width=e.info.width < AbstractBootstrap.CLIENT_STAGE.stageWidth ? AbstractBootstrap.CLIENT_STAGE.stageWidth*multiplier : e.info.width*multiplier;
			workbenchContainer.height=e.info.height < AbstractBootstrap.CLIENT_STAGE.stageHeight ? AbstractBootstrap.CLIENT_STAGE.stageHeight*multiplier : e.info.height*multiplier;
			
			workbenchContainer.validateNow();
		}

		private function workbenchClick(e:MouseEvent):void
		{
			elementEditor.clearElementEditor();
		}

		/* -------------------------------------------------------------------------- */ /* Drag & Drop Handling */ /* -------------------------------------------------------------------------- */

		private function dragAccept(event:DragEvent):void
		{
			if (event.dragInitiator == Ref.controlList || event.dragInitiator == Ref.actionList)
			{
				var dropTarget:Canvas=event.currentTarget as Canvas;
				DragManager.acceptDragDrop(dropTarget);
				DragManager.showFeedback(DragManager.COPY);
				if (event.dragInitiator == Ref.controlList)
				{
					dropTarget.addEventListener(MouseEvent.MOUSE_OVER, dragOverHandler, false, 0, true);
				}
				dropTarget.addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false, 0, true);
				dropTarget.addEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false, 0, true);
			}
		}

		private function dragOverHandler(e:MouseEvent):void
		{
			var face:DisplayObject=e.target as DisplayObject;
			// set the container to highlight 
			highlightSelection(face);

			// HightLight the container 

			if (highlightedBlock != null)
			{
				// highlight le bloc selectionne
				Selection.getInstance().highLightContainer(workbenchContainer, highlightedBlock.getFace());
			}
			else
			{
				Selection.getInstance().removeHighLight();
			}
			e.stopPropagation();
			e.stopImmediatePropagation();
		}


		// Function used to set the container to highlight when dragging over a displayObject in the workbench 

		private function highlightSelection(face:DisplayObject):void
		{
			// Check if the face is an elementDescriptor
			//trace("current page on highlight "+currentPage.link);
			var descriptor:IUIElementDescriptor=ElementDescriptorFinder.findUIElementDescriptor(face, currentPage) as IUIElementDescriptor;

			//trace("current page on highlight after "+currentPage.link);
			if (descriptor != null)
			{
				// highlight every container except XMLelementDescriptor

				if (descriptor is IUIElementContainer && !(descriptor is XmlElementDescriptor) && !(descriptor is DynamicListElementDescriptor))
				{
					highlightedBlock=(descriptor as IUIElementContainer);
				}
				else
				{
					// check if the parent can get highlighted

					if (descriptor.getParent() != null)
					{
						highlightSelection(descriptor.getParent().getFace());
					}
					else
					{
						highlightSelection(null);
					}

				}
			}
			else
			{
				// The face is not a descriptor , check if the parent can get highlighted

				if (!(face is AbstractBootstrap) && face != null)
				{
					highlightSelection(face.parent);
				}
				else
				{
					// Dragging over abstractBootstrap , select the first level element ( page container or nothing ) 
					if (currentPage.hasContainer())
					{
						// selectionne le container de la page parent dans le cas d'une sous page
						highlightedBlock=IUIElementContainer(ElementList.getInstance().getElement(currentPage.container, currentPage.getParent()));
					}
					else
						highlightedBlock=null;
				}
			}
		}

		/**
		 * Handles drag exit event
		 */
		private function dragExitHandler(e:DragEvent):void
		{
			(e.currentTarget as DisplayObject).removeEventListener(DragEvent.DRAG_DROP, dragDropHandler);
			(e.currentTarget as DisplayObject).removeEventListener(MouseEvent.MOUSE_OVER, dragOverHandler);
			(e.currentTarget as DisplayObject).removeEventListener(DragEvent.DRAG_EXIT, dragExitHandler);
			Selection.getInstance().removeHighLight();
			highlightedBlock=null;
		}

		// Variables stockant les informations necessaire a la creation d'un control

		private var src:String
		private var type:String;
		private var lbl:String;
		private var dropPoint:Point=new Point();
		private var uuid:String;

		/**
		 * Handles drag drop event
		 */
		private function dragDropHandler(e:DragEvent):void
		{
			(e.currentTarget as DisplayObject).removeEventListener(DragEvent.DRAG_DROP, dragDropHandler);
			(e.currentTarget as DisplayObject).removeEventListener(MouseEvent.MOUSE_OVER, dragOverHandler);
			(e.currentTarget as DisplayObject).removeEventListener(DragEvent.DRAG_EXIT, dragExitHandler);

			src=e.dragSource.dataForFormat("items")[0];
			if (src.indexOf(".controls:") != -1)
			{
				type="control";
				lbl=src.split("::")[1].split("ElementDescriptor")[0];
			}
			else if (src.indexOf(".action:") != -1)
			{
				type="action";
				lbl=src.split("::")[1].split("Action")[0];
			}
			else if (src.indexOf(".story:") != -1)
			{
				type="story";
				lbl=src.split("::")[1].split("ElementDescriptor")[0];
			}
			else
			{
				type="container";
				lbl=src.split("::")[1].split("ElementDescriptor")[0];
			}

			var uuidArray:Array=ElementList.getInstance().getElementsId(currentPage);
			namePopUp=new InputStringPopUp();
			namePopUp.description=Conf.languageManager.getLanguage("Control_Id");
			namePopUp.label=Conf.languageManager.getLanguage("Id") + ": ";
			namePopUp.setInputDefaultValue(EditorUtil.findUniqueName(lbl, NameUtils.getAllNames(currentPage)));
			namePopUp.addEventListener(InputStringPopUp.SUBMIT, namePopUpHandler);
			namePopUp.addEventListener(PopUp.CLOSED, creationCancel);
			//uuid = EditorUtil.findUniqueName("control",uuidArray);
			if (highlightedBlock == null)
			{
				dropPoint=workbenchContainer.globalToLocal(new Point(e.stageX, e.stageY));
			}
			else
			{
				dropPoint=highlightedBlock.getFace().globalToLocal(new Point(e.stageX, e.stageY));
			}
		}

		/* -------------------------------------------------------------------------- */ /* Name PopUp Handling */ /* -------------------------------------------------------------------------- */

		private function creationCancel(e:Event):void
		{
			namePopUp.removeEventListener(PopUp.CLOSED, creationCancel);
			namePopUp.removeEventListener(InputStringPopUp.SUBMIT, namePopUpHandler);
			Selection.getInstance().removeHighLight();
		}

		private function namePopUpHandler(e:Event):void
		{
			uuid=namePopUp.getInput();
			var uuidArray:Array=NameUtils.getAllNames(currentPage);
			if (ArrayUtils.containsString(uuid, uuidArray))
			{
				namePopUp.setError(Conf.languageManager.getLanguage("The_Id_") + uuid + Conf.languageManager.getLanguage("_is_already_in_use_f"));
			}
			else
			{
				namePopUp.closePopUp();
				namePopUp.removeEventListener(PopUp.CLOSED, creationCancel);
				namePopUp.removeEventListener(InputStringPopUp.SUBMIT, namePopUpHandler);
				switch (type)
				{

					case "story":
						createStory();
						break;

					case "action":
						createAction();
						break;

					default:
						createElement();
						break;
				}
			}
		}

		/**
		 * Create a visual component
		 */
		private function createElement():void
		{
			// Creation du control 
			ApplicationController.getInstance().getCommand().addCommand(new ElementCreationCommand(type, src, uuid, highlightedBlock));
			var descriptor:SimpleUIElementDescriptor=(ElementList.getInstance().getElement(uuid, BrowsingManager.getInstance().getCurrentPage()/*currentPage*/) as SimpleUIElementDescriptor);

			// changement de la position par rapport a celle de la souris

			var positionParameter:PositionParameterSet=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), descriptor) as PositionParameterSet;
			positionParameter.x=dropPoint.x;
			positionParameter.y=dropPoint.y;
			positionParameter.apply(descriptor);
			descriptor.invalidate();

			// Selection du bloc cree

			elementEditor.editIfFace(descriptor.getFace());
			Selection.getInstance().removeHighLight();

			// Mise a jour du changement de position dans le XML

			elementEditor.parameterSetUpdated(positionParameter);
			highlightedBlock=null;
		}

		/**
		 * Creates an action
		 */
		private function createAction():void
		{
			ApplicationController.getInstance().getCommand().addCommand(new ActionCreationCommand(type, src, uuid));
			var action:IAction=ActionList.getInstance().getAction(uuid, currentPage);

			//elementEditor.edit
		}

		/**
		 * Creates an animation (story)
		 */
		private function createStory():void
		{
			ApplicationController.getInstance().getCommand().addCommand(new StoryCreationCommand(type, src, uuid));
			var s:Story=StoryList.getInstance().getStory(uuid, currentPage);

			//elementEditor.edit
		}

		public function setElementEditor(editor:IElementEditor):void
		{
			elementEditor=editor;
		}

		public function loadApplication(baseUrl:String, applicationName:String):void
		{
			_baseUrl=baseUrl;
			loader.load(new URLRequest(baseUrl + "/" + applicationName + ".swf"));
		}

		/**
		 * Initialize the loader callbacks.
		 */
		protected function initializeEventHandlers():void
		{
			// Using an anonymous event handler to avoid signature degradation
			loader.addEventListener(Event.COMPLETE, externalApplicationLoaded, false, 0, false);
		}

		protected function externalApplicationLoaded(e:Event):void
		{
			trace("Application loaded, injecting the context.");
			var bytes:ByteArray=(e.target as URLLoader).data;
			var subloader:Loader=new Loader();
			subloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onChildApplicationComplete);
			var context:LoaderContext=new LoaderContext();
			context.applicationDomain=ApplicationDomain.currentDomain;
			subloader.loadBytes(bytes, context);
		}

		private function onChildApplicationComplete(e:Event):void
		{
			// FIXME Assert the content is an instance of AbstractBootstrap.
			externalApplication=e.target.content;
			externalApplication.setBaseUrl(_baseUrl);
			//Adding listener that will be removed on complete just for updating control and navigation list when project is parsed
			BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_CHANGE, changeFirstPage);
			externalApplication.setStage(Ref.ADMIN_STAGE);

			if (workbenchContainer.contains(wrapper))
			{
				wrapper.removeChild(externalApplication);
				wrapper.removeEventListener(MouseEvent.CLICK, triggerVisualElementEdit, true);
				workbenchContainer.removeChild(wrapper);
			}

			wrapper.addChild(externalApplication);
			wrapper.width=(e.target as LoaderInfo).width;
			wrapper.height=(e.target as LoaderInfo).height;
			trace("onChildApplicationComplete  wrapper.w : "+wrapper.width+" wrapper.h : "+wrapper.height);
			workbenchContainer.minHeight=wrapper.height;
			workbenchContainer.minWidth=wrapper.width;
			wrapper.minHeight = wrapper.height;
			wrapper.minWidth = wrapper.width;
			configureListeners(wrapper);
			workbenchContainer.addChild(wrapper);
		}


		private function changeFirstPage(e:Event):void
		{
			//update list when the first page load and directly removing listener
			e.target.removeEventListener(FieEvent.PAGE_CHANGE, changeFirstPage);
			addApiErrorListener();
			currentPage=BrowsingManager.getInstance().getCurrentPage();
			ApplicationController.getInstance().getNavigation().setPageList(AbstractBootstrap.getInstance().getProject());
			ApplicationController.getInstance().getNavigation().update(true);
			ApplicationController.getInstance().getControlList().update();
			ApplicationController.getInstance().getActionList().update();
			ApplicationController.getInstance().getStoryEditor().update();
			ApplicationController.getInstance().getBlockList().update();
			ApplicationController.getInstance().getActionEditor().update();
			ApplicationController.getInstance().getXMLContainerList().update();
			Application.application.currentState="view";
			Application.application.changeState();
			BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_CHANGE, changePage);
			BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_UNLOAD, unloadPage);
			BrowsingManager.getInstance().addEventListener(FieEvent.PAGE_REMOVED, refreshBlockList);
		/**
		 *  moved into "stories edition" state
		 *  Ref.stageTimeLine.init();
		 *
		 *
		 * **/
		}

		private function unloadPage(e:Event):void
		{

			/*if(currentPage!=BrowsingManager.getInstance().getCurrentPage())
			{
			changePage(e);
			}*/
			if (Application.application.currentState == "stories")
				AbstractBootstrap.getInstance().getTimerStoryboardPlayer().reset(BrowsingManager.getInstance().getCurrentPage().getStoryboard());
			XmlSave.temporarySave();
			if (Application.application.currentState != "view")
			{
				Application.application.currentState="view";
				Application.application.changeState();
			}
		}

		private function refreshBlockList(e:Event):void
		{
			/*if(currentPage!=BrowsingManager.getInstance().getCurrentPage())
			{
			changePage(e);
			}
			else
			{*/
			ApplicationController.getInstance().getBlockList().update(true);
			//}
		}

		private function changePage(e:Event):void
		{
			currentPage=BrowsingManager.getInstance().getCurrentPage();
			trace("currentPage on change page"+currentPage.link);
			ApplicationController.getInstance().getBlockList().update(true);
			ApplicationController.getInstance().getActionEditor().update();
			ApplicationController.getInstance().getStoryEditor().update();
			ApplicationController.getInstance().getNavigation().updateSelection(e);
			VisualSelector.getInstance().flushElements();
		}

		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(MouseEvent.CLICK, triggerVisualElementEdit, true);
		}

		private function triggerVisualElementEdit(event:MouseEvent):void
		{
			// We do not mind the current target, which is supposed to be
			// an AbstractBoostrap instance.

			if (event.shiftKey || event.ctrlKey)
			{
				elementEditor.editIfFace(event.target as DisplayObject, true);
			}
			else
			{
				elementEditor.editIfFace(event.target as DisplayObject, false);
			}
			workbenchContainer.horizontalScrollPolicy="off";
		}


		private function triggerActionEdit(event:MouseEvent):void
		{

		}

		public var indicator:Canvas=new Canvas();


		public function getEditor(name:String):void
		{
			var position:Canvas=new Canvas();
			var panel:IElementEditorPanel=EditorUtil.retrieveEditor(new PositionParameterSet());
			var control:*=Ref.ADMIN_STAGE.getChildByName("x");

		}

		public function removeIndicator(index:int):void
		{
			VisualSelector.getInstance().removeElement(index);
		}

		public function bind():void
		{
			VisualSelector.getInstance().bind();
		}

		public function openEditMode(button:ButtonElementDescriptor):void
		{
			VisualSelector.getInstance().flushElements();
			wrapper.removeChild(externalApplication);
			wrapper.addChild(new ButtonEditor(button));
			trace("open mode");
		}
		
		public function addApiErrorListener():void
		{
			
			ApiErrorManager.getInstance().addEventListener(FieEvent.ERROR_ACTION_NO_TARGET, handleApiErrors);
			ApiErrorManager.getInstance().addEventListener(FieEvent.ERROR_ACTION_NO_TRIGGER, handleApiErrors);
			ApiErrorManager.getInstance().addEventListener(FieEvent.ERROR_STORY_NO_TARGET, handleApiErrors);
		}

		public function removeApiErrorListener( ) : void
		{
			ApiErrorManager.getInstance().removeEventListener(FieEvent.ERROR_ACTION_NO_TARGET, handleApiErrors);
			ApiErrorManager.getInstance().removeEventListener(FieEvent.ERROR_ACTION_NO_TRIGGER, handleApiErrors);
			ApiErrorManager.getInstance().removeEventListener(FieEvent.ERROR_STORY_NO_TARGET, handleApiErrors);
		}
		
		private function handleApiErrors( e : FieEvent) : void
		{
			var popError:MessagePopUp;
			switch ( e.type )
			{
				case  FieEvent.ERROR_STORY_NO_TARGET :
					popError = new MessagePopUp("the story : "+e.info.uuid+" "+"have no target !",null,false,true,false);
					popError.showOk();
					popError.display();
					trace ("[FieEvent.ERROR_STORY_NO_TARGET!!!]");
					break;
				case  FieEvent.ERROR_ACTION_NO_TRIGGER :
					popError = new MessagePopUp("the action : "+e.info.uuid+" "+"have no trigger !",null,false,true,false);
					popError.showOk();	
					popError.display();
					trace ("[FieEvent.ERROR_ACTION_NO_TRIGGER!!!]");
					break;
				case  FieEvent.ERROR_ACTION_NO_TARGET :	
					popError = new MessagePopUp("the action : "+e.info.uuid+" "+"have no target !",null,false,true,false);
					popError.showOk();	
					popError.display();
					trace ("[FieEvent.ERROR_ACTION_NO_TARGET!!!]");
					break;
				default :
					trace ("[uncaught FieError!!!]");
			}
				
		}

	}
}