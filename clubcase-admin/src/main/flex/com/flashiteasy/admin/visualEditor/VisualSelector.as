package com.flashiteasy.admin.visualEditor
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.CommandBatch;
	import com.flashiteasy.admin.commands.CommandQueue;
	import com.flashiteasy.admin.commands.ICommand;
	import com.flashiteasy.admin.commands.menus.ActionDeletionCommand;
	import com.flashiteasy.admin.commands.menus.ChangeParameterCommand;
	import com.flashiteasy.admin.commands.menus.ElementDestructionCommand;
	import com.flashiteasy.admin.commands.menus.StoryDeletionCommand;
	import com.flashiteasy.admin.components.FileManipulationBar;
	import com.flashiteasy.admin.components.FilePicker;
	import com.flashiteasy.admin.conf.Ref;
	import com.flashiteasy.admin.edition.IElementEditorPanel;
	import com.flashiteasy.admin.event.FieAdminEvent;
	import com.flashiteasy.admin.uicontrol.ReflectionEditorPanel;
	import com.flashiteasy.admin.uicontrol.RichTextEditorPanel;
	import com.flashiteasy.admin.utils.EditorUtil;
	import com.flashiteasy.admin.utils.GeomUtils;
	import com.flashiteasy.admin.visualEditor.handles.EditButton;
	import com.flashiteasy.admin.visualEditor.handles.EditType;
	import com.flashiteasy.admin.workbench.IElementEditor;
	import com.flashiteasy.admin.workbench.impl.StoryElementEditorImpl;
	import com.flashiteasy.api.action.Action;
	import com.flashiteasy.api.container.MultipleUIElementDescriptor;
	import com.flashiteasy.api.controls.ButtonElementDescriptor;
	import com.flashiteasy.api.controls.FLVPlayerElementDescriptor;
	import com.flashiteasy.api.controls.ImgElementDescriptor;
	import com.flashiteasy.api.controls.TextElementDescriptor;
	import com.flashiteasy.api.controls.VideoElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.parameters.FLVSourceParameterSet;
	import com.flashiteasy.api.parameters.ImgParameterSet;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.parameters.RotationParameterSet;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	import com.flashiteasy.api.parameters.TextParameterSet;
	import com.flashiteasy.api.parameters.VideoParameterSet;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.ControlUtils;
	import com.flashiteasy.api.utils.ConvertUtils;
	import com.flashiteasy.api.utils.DisplayListUtils;
	import com.flashiteasy.api.utils.MatrixUtils;
	import com.senocular.display.TransformTool;
	import com.senocular.display.TransformToolDeleteControl;
	import com.senocular.display.TransformToolEditButtonControl;
	import com.senocular.display.TransformToolEditControl;
	import com.senocular.events.TransformEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;

	public class VisualSelector
	{

		[Bindable]
		public var tool:TransformTool=new TransformTool();

		[Bindable]
		public var selectedElementExist:Boolean=false;

		[Embed(source='../../../../../resources/assets/color_swatch.png')]
		private var edit_ico:Class;

		private var workbench:Container;
		private var visualEditor:Canvas=new Canvas();
		private var editor:IElementEditor;


		private var rotationPanel:IElementEditorPanel;
		private var positionPanel:IElementEditorPanel;
		private var sizePanel:IElementEditorPanel;
		private var textPanel:IElementEditorPanel;
		private var srcPanel:IElementEditorPanel;

		private var positionParameter:PositionParameterSet=new PositionParameterSet();
		private var sizeParameter:SizeParameterSet=new SizeParameterSet();
		private var rotationParameter:RotationParameterSet=new RotationParameterSet();
		private var textParameter:TextParameterSet=new TextParameterSet();

		private var deleteButton:EditButton=new EditButton(EditType.DELETE);

		// Selection box
		private var wrapper:UIComponent=new UIComponent();

		private var startPosition:Point;

		private static var instance:VisualSelector;
		private static var allowInstantiation:Boolean=false;

		private var elements:Array=new Array();

		private var startWidth:Number;
		private var startHeight:Number;
		private var startRotation:Number;

		public function VisualSelector()
		{
			if (!allowInstantiation)
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}

		}

		public function isSelected(el:IUIElementDescriptor):Boolean
		{
			for each (var control:SelectedElement in elements)
			{
				if (control.element == el)
					return true;
			}
			return false;
		}

		// return the wrapper used to draw the selection box

		public function get selectionBox():UIComponent
		{
			return wrapper;
		}

		public function deselect(el:IUIElementDescriptor):void
		{
			var i:int=0;
			if (isSelected(el))
			{
				for each (var control:SelectedElement in elements)
				{
					if (control.element == el)
					{
						elements.splice(i, 1);
						draw();
					}
					i++;
				}
			}
		}

		public static function getInstance():VisualSelector
		{
			if (instance == null)
			{
				allowInstantiation=true;
				instance=new VisualSelector();
				allowInstantiation=false;
			}
			return instance;
		}

		public function removeElement(index:int):void
		{
			//Ref.ADMIN_STAGE.focus=null;
			elements.splice(index, 1);
			draw();
		}

		public function flushElements():void
		{

			//Ref.ADMIN_STAGE.focus=null;
			if (elements.length > 0)
			{
				elements=[];
			}
			resetWrapper();
			removeTool(tool);
			editor.clearElementEditor();
			ApplicationController.getInstance().getBlockList().clearSelection();
		}

		public function addElement(elem:IUIElementDescriptor):void
		{
			//Ref.ADMIN_STAGE.focus=null;

			if (workbench.scaleX == 1)
			{
				elements[elements.length]=new SelectedElement(elem);
				draw();
			}
			else
			{
				flushElements();
				elements[0]=new SelectedElement(elem);
				draw();
			}
		}

		private function createTool(ob:DisplayObject):void
		{
			if (tool != null)
			{
				removeTool(tool);
				tool=new TransformTool();

				tool.addEventListener(TransformEvent.TRANSFORM_TARGET, updateSelection);
				tool.addEventListener(TransformEvent.CONTROL_UP, saveChanges);
				if (Ref.adminManager.userIsRookie)
				{
					//tool.doubleClickEnabled = true;
					//tool.addEventListener(MouseEvent.DOUBLE_CLICK, editSimple);
					var editSimpleTool:TransformToolEditControl=new TransformToolEditControl();
					editSimpleTool.name="edit";
				}
				else
				{
					var deleteTool:TransformToolDeleteControl=new TransformToolDeleteControl();
					deleteTool.name="delete";

					tool.addControl(deleteTool);
				}

				// Special icon for buttons 

				if (elements.length == 1 && (elements[0] as SelectedElement).element is ButtonElementDescriptor)
				{
					var editTool:TransformToolEditButtonControl=new TransformToolEditButtonControl();
					editTool.addChild(new edit_ico);
					tool.addControl(editTool);
				}

				tool.target=ob;
				if (Ref.adminManager.userIsRookie)
				{
					//tool.doubleClickEnabled
					//tool.outlineEnabled = false;

					//editSimpleTool.addChild(new edit_ico);	
					tool.addControl(editSimpleTool);
					tool.scaleEnabled=false;
					tool.rotationEnabled=false;
					tool.registrationEnabled=false;
					tool.moveEnabled=false;
					tool.cursorsEnabled=false;
						//tool.removeControl(tool.moveControl);
						//tool.moveControl=null;
						//tool.moveCursor=null;
				}
				workbench.addChild(tool);
			}
			selectedElementExist=true;
		}

		/**
		 * Destroy selected Element
		 */
		private var actionsToDelete:Array=null;
		private var storiesToDelete:Array=null;

		public function destroyElement():void
		{
			removeTool(tool);
			editor.clearEditor();

			var toolBar:FileManipulationBar=ApplicationController.getInstance().getBlockList().getToolBar();
			toolBar.deleteButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		/*
		   var uuidlist:Array=getUuidList();
		   var dependanciesObject:Object=DestroyUtils.checkControlDependancies(uuidlist, BrowsingManager.getInstance().getCurrentPage());
		   actionsToDelete=dependanciesObject.actions;
		   storiesToDelete=dependanciesObject.stories;
		   this.workbench.setFocus();
		   if (actionsToDelete.length == 0 && storiesToDelete.length == 0)
		   {
		   var queue:CommandQueue=new CommandQueue();
		   for each (var elem:SelectedElement in elements)
		   {

		   queue.addCommand(new ElementDestructionCommand(elem.element));

		   }
		   ApplicationController.getInstance().getCommand().addCommand(queue);
		   }
		   else
		   {
		   var alertString:String=(actionsToDelete.length != 0 && storiesToDelete.length != 0) ? Conf.languageManager.getLanguage("Actions_and_stories") : actionsToDelete.length != 0 ? Conf.languageManager.getLanguage("Actions") : Conf.languageManager.getLanguage("Stories");
		   Alert.okLabel=Conf.languageManager.getLanguage("Delete_All");
		   Alert.yesLabel=Conf.languageManager.getLanguage("Delete_Actions");
		   Alert.noLabel=Conf.languageManager.getLanguage("No");
		   Alert.buttonWidth=150;
		   Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
		   Alert.show(alertString + " " + Conf.languageManager.getLanguage("use_this_element,_do_you_want_to_delete_them?"), Conf.languageManager.getLanguage("Elements_have_dependancies"), Alert.OK | Alert.YES | Alert.CANCEL, mx.core.Application.application as Sprite, removeStoryAlertHandler);

		   Alert.okLabel=Conf.languageManager.getLanguage("Ok");
		   Alert.yesLabel=Conf.languageManager.getLanguage("Yes");
		   Alert.noLabel=Conf.languageManager.getLanguage("No");
		   Alert.cancelLabel=Conf.languageManager.getLanguage("Cancel");
		 }*/

		}

		private function removeStoryAlertHandler(e:CloseEvent):void
		{
			var queue:CommandQueue=new CommandQueue();
			var elem:SelectedElement;
			var action:Action;
			var story:Story;
			switch (e.detail)
			{
				case Alert.OK:

					for each (elem in elements)
					{
						queue.addCommand(new ElementDestructionCommand(elem.element));
					}
					ApplicationController.getInstance().getCommand().addCommand(queue);

					for each (story in storiesToDelete)
					{

						//ApplicationController.getInstance().getStoryEditor().removeStory(story.uuid);
						queue.addCommand(new StoryDeletionCommand(story));
					}

					for each (action in actionsToDelete)
					{
						//ApplicationController.getInstance().getActionEditor().removeAction(action.uuid);
						queue.addCommand(new ActionDeletionCommand(action));
					}
					//ApplicationController.getInstance().getActionEditor().update();
					//ApplicationController.getInstance().getStoryEditor().update();
					break;
				case Alert.YES:

					for each (elem in elements)
					{
						queue.addCommand(new ElementDestructionCommand(elem.element));
					}
					ApplicationController.getInstance().getCommand().addCommand(queue);

					for each (action in actionsToDelete)
					{

						ApplicationController.getInstance().getActionEditor().removeAction(action.uuid);
							//queue.addCommand( new ActionDeletionCommand(action));
					}
					//ApplicationController.getInstance().getActionEditor().update();
					break;
				case Alert.NO:

					break;
				case Alert.CANCEL:

					break;
			}
			actionsToDelete=null;
			storiesToDelete=null;
			this.workbench.setFocus();
		}

		private function getUuidList():Array
		{
			var uuidList:Array=[];
			for each (var elem:SelectedElement in elements)
			{
				var control:IUIElementDescriptor=ElementList.getInstance().getElement(elem.uuid, BrowsingManager.getInstance().getCurrentPage());
				uuidList=getChildList(control, []);

			}
			return uuidList;
		}

		private function getChildList(elem:IUIElementDescriptor, uuidList:Array):Array
		{

			uuidList.push(elem.uuid);
			try
			{
				var control:MultipleUIElementDescriptor=MultipleUIElementDescriptor(ElementList.getInstance().getElement(elem.uuid, BrowsingManager.getInstance().getCurrentPage()));

				for each (var el:IUIElementDescriptor in control.getChildren())
				{
					var childControl:IUIElementDescriptor=ElementList.getInstance().getElement(el.uuid, BrowsingManager.getInstance().getCurrentPage());
					uuidList.push(el.uuid);
					try
					{
						var childContainer:MultipleUIElementDescriptor=MultipleUIElementDescriptor(childControl);
						for each (var e:IUIElementDescriptor in childContainer.getChildren())
						{
							var toAppend:Array=getChildList(e, uuidList);
							uuidList=toAppend;
						}
					}
					catch (e:Error)
					{
						//;
					}
				}

				return uuidList;
			}
			catch (e:Error)
			{
				return uuidList;
			}
			return null;
		}


		public function updatePanels():void
		{
			updateSelection(new Event(Event.CHANGE));
		}

		public function refresh():void
		{
			if (elements.length == 1)
			{
				tool.target=(elements[0] as SelectedElement).element.getFace();

			}
			else if (elements.length > 1)
			{
				draw();
			}
			updateElements();
		}

		private function refreshWrapperFromElement(e:Event):void
		{
			draw();
		}


		private var firstElementShape:Sprite=null;

		private function draw():void
		{

			//var elementFace:DisplayObject=(elements[0] as SelectedElement).element.getFace();
			if (firstElementShape != null && firstElementShape.parent != null)
			{
				firstElementShape.parent.removeChild(firstElementShape);
				firstElementShape=null;
			}
			resetWrapper();
			if (elements.length == 0)
			{
				removeTool(tool);
				editor.removeEventListener(FieAdminEvent.PARAMETER_UPDATED, refreshWrapperFromElement);
			}
			else if (elements.length == 1)
			{
				var elementFace:DisplayObject=(elements[0] as SelectedElement).element.getFace();
				///
				firstElementShape=new Sprite();
				firstElementShape.graphics.beginFill(0x000000, 0);
				firstElementShape.graphics.drawRect(0, 0, elementFace.width, elementFace.height);
				firstElementShape.graphics.endFill();
				Sprite(elementFace).addChild(firstElementShape);
				/*if (elementFace.width < 0)
				   {
				   firstElementShape.x+=elementFace.width;
				   //firstElementShape.width=elementFace.width;
				   }
				   if (elementFace.height < 0)
				   {
				   firstElementShape.y+=elementFace.height;
				   //firstElementShape.height=elementFace.height;
				 }*/


				//firstElementShape.mouseEnabled = false;
				//firstElementShape.mouseChildren = false;
				////

				createTool(elementFace);
				editor.removeEventListener(FieAdminEvent.PARAMETER_UPDATED, refreshWrapperFromElement);

			}
			else
			{
				if (!editor.hasEventListener(FieAdminEvent.PARAMETER_UPDATED))
				{
					editor.addEventListener(FieAdminEvent.PARAMETER_UPDATED, refreshWrapperFromElement, false, 0, true);
				}
				var shape:Shape;
				var bounds:Rectangle;
				var temp_matrix:Matrix;
				wrapper.transform.matrix=workbench.transform.matrix.clone();
				//var canvas_matrix:Matrix=workbench.transform.concatenatedMatrix.clone();
				//Here we use a custom function for avoiding a bug in transform.ConcatenedMatrix when the _target.parent is filtered
				var canvas_matrix:Matrix=DisplayListUtils.customConcatenatedMatrix(workbench);
				var canvas_inverted_matrix:Matrix=canvas_matrix.clone();
				canvas_inverted_matrix.invert();
				for each (var elem:SelectedElement in elements)
				{
					bounds=elem.getBounds();
					shape=new Shape();
					shape.name=elem.uuid;
					shape.graphics.beginFill(0, 0);
					shape.graphics.drawRect(0, 0, bounds.width, bounds.height);
					shape.graphics.endFill();

					// get the real selected item matrix
					// var temp_matrix2:Matrix=elem.getFace().transform.concatenatedMatrix.clone();
					//Here we use a custom function for avoiding a bug in transform.ConcatenedMatrix when the _target.parent is filtered
					temp_matrix=DisplayListUtils.customConcatenatedMatrix(elem.getFace());
					temp_matrix.concat(canvas_inverted_matrix);

					// assign to the shape 'copy' the same matrix as the selected item
					shape.transform.matrix=temp_matrix;

					// Used to fix a bug with elements with negative size
					if (elem.getFace().width < 0)
					{
						shape.scaleX=-1;
					}
					if (elem.getFace().height < 0)
					{
						shape.scaleY=-1;
					}
					wrapper.addChild(shape);
					//shape.x-=3;
					//shape.y-=30;
					shape.x+=workbench.horizontalScrollPosition;
					shape.y+=workbench.verticalScrollPosition;

				}
				workbench.addChild(wrapper);
				var wrapper_bounds:Rectangle=wrapper.getBounds(workbench);
				wrapper.width=wrapper_bounds.width;
				wrapper.height=wrapper_bounds.height;
				wrapper.graphics.beginFill(0, 0);
				wrapper.graphics.drawRect(0, 0, wrapper_bounds.width, wrapper_bounds.height);
				wrapper.graphics.endFill();
				var diffX:Number=workbench.transform.concatenatedMatrix.tx - workbench.parent.transform.concatenatedMatrix.tx;
				var diffY:Number=workbench.transform.concatenatedMatrix.ty - workbench.parent.transform.concatenatedMatrix.ty;
				wrapper.x=workbench.globalToLocal(wrapper.localToGlobal(wrapper_bounds.topLeft)).x - diffX;
				wrapper.y=workbench.globalToLocal(wrapper.localToGlobal(wrapper_bounds.topLeft)).y - diffY;
				createTool(wrapper);
				DisplayListUtils.removeAllChildren(wrapper);
				startPosition=wrapper.localToGlobal(new Point());
				startWidth=wrapper.width;
				startHeight=wrapper.height;
				startRotation=wrapper.rotation;
					//wrapper.mouseEnabled = false;
					//wrapper.mouseChildren = false;
			}
		}

		private function saveChanges(e:TransformEvent):void
		{
			if (e.currentTarget == tool)
			{
				//On change of selected Elements we verify if change of parameters have been done
				Ref.adminManager.checkForCommitParameterChange();
				if (ApplicationController.getInstance().getElementEditor() is StoryElementEditorImpl)
				{
					var param:IParameterSet;
					for each (var elem:SelectedElement in elements)
					{
						if (elem.position.x != elem.start_position.x)
						{
							Ref.adminManager.changedParameterList=["x"];
							if (Ref.adminManager.previousValueList == null)
							{
								Ref.adminManager.previousValueList=new Object;
							}
							Ref.adminManager.previousValueList[elem.uuid]=elem.start_position.x;
							param=ControlUtils.retrieveParameter(positionParameter, elem.element);
							StoryElementEditorImpl(ApplicationController.getInstance().getElementEditor()).setOverride(param);
						}
						if (elem.position.y != elem.start_position.y)
						{
							Ref.adminManager.changedParameterList=["y"];
							if (Ref.adminManager.previousValueList == null)
							{
								Ref.adminManager.previousValueList=new Object;
							}
							Ref.adminManager.previousValueList[elem.uuid]=elem.start_position.y;
							param=ControlUtils.retrieveParameter(positionParameter, elem.element);
							StoryElementEditorImpl(ApplicationController.getInstance().getElementEditor()).setOverride(param);
						}
						if (elem.size.height != elem.start_size.y)
						{
							Ref.adminManager.changedParameterList=["height"];
							if (Ref.adminManager.previousValueList == null)
							{
								Ref.adminManager.previousValueList=new Object;
							}
							Ref.adminManager.previousValueList[elem.uuid]=elem.start_size.y;
							param=ControlUtils.retrieveParameter(sizeParameter, elem.element);
							StoryElementEditorImpl(ApplicationController.getInstance().getElementEditor()).setOverride(param);
						}
						if (elem.size.width != elem.start_size.x)
						{
							Ref.adminManager.changedParameterList=["width"];
							if (Ref.adminManager.previousValueList == null)
							{
								Ref.adminManager.previousValueList=new Object;
							}
							Ref.adminManager.previousValueList[elem.uuid]=elem.start_size.x;
							param=ControlUtils.retrieveParameter(sizeParameter, elem.element);
							StoryElementEditorImpl(ApplicationController.getInstance().getElementEditor()).setOverride(param);
						}
						if (elem.rotation.rotation != elem.start_rotation)
						{
							Ref.adminManager.changedParameterList=["rotation"];
							if (Ref.adminManager.previousValueList == null)
							{
								Ref.adminManager.previousValueList=new Object;
							}
							Ref.adminManager.previousValueList[elem.uuid]=elem.start_rotation;
							param=ControlUtils.retrieveParameter(rotationParameter, elem.element);
							StoryElementEditorImpl(ApplicationController.getInstance().getElementEditor()).setOverride(param);
						}
					}
				}
				else
				{
					//Adding changeCommand
					var visualQueueCommand:CommandBatch=new CommandBatch();
					var changed:Boolean=false;
					for each (var el:SelectedElement in elements)
					{
						var positionCommand:ICommand=new ChangeParameterCommand(el.element, positionParameter, ["x", "y"], [el.position.x, el.position.y], [el.start_position.x, el.start_position.y], ApplicationController.getInstance().getElementEditor()); //
						var sizeCommand:ICommand=new ChangeParameterCommand(el.element, sizeParameter, ["height", "width"], [el.size.height, el.size.width], [el.start_size.y, el.start_size.x], ApplicationController.getInstance().getElementEditor());
						var rotationCommand:ICommand=new ChangeParameterCommand(el.element, rotationParameter, ["rotation"], [el.rotation.rotation], [el.start_rotation], ApplicationController.getInstance().getElementEditor());
						if ((el.position.x != el.start_position.x) || (el.position.y != el.start_position.y))
						{
							visualQueueCommand.addCommand(positionCommand);
							changed=true;
						}
						if ((el.size.width != el.start_size.x) || (el.size.height != el.start_size.y))
						{
							visualQueueCommand.addCommand(sizeCommand);
							changed=true;
						}
						if (el.rotation.rotation != el.start_rotation)
						{
							visualQueueCommand.addCommand(rotationCommand);
							changed=true;
						}
					}
					if (changed)
						ApplicationController.getInstance().getCommand().addCommand(visualQueueCommand);
				}

				updateWrapper();
				updateElements();
			}
		}

		private function updateWrapper():void
		{
			var topLeft:Point=tool.boundsTopLeft;
			var topRight:Point=tool.boundsTopRight;
			var bottomLeft:Point=tool.boundsBottomLeft;
			wrapper.width=Math.round(Math.sqrt((topRight.x - topLeft.x) * (topRight.x - topLeft.x) + (topRight.y - topLeft.y) * (topRight.y - topLeft.y)));
			wrapper.height=Math.round(Math.sqrt((bottomLeft.x - topLeft.x) * (bottomLeft.x - topLeft.x) + (bottomLeft.y - topLeft.y) * (bottomLeft.y - topLeft.y)));
			wrapper.rotation=MatrixUtils.getAngle(tool.globalMatrix);
			wrapper.graphics.clear();
			wrapper.graphics.beginFill(0, 0);
			wrapper.graphics.drawRect(0, 0, wrapper.width, wrapper.height);
			wrapper.graphics.endFill();
			wrapper.x=workbench.globalToLocal(tool.localToGlobal(tool.boundsTopLeft)).x; // + Panel(workbench.parent).horizontalScrollPosition ;
			wrapper.y=workbench.globalToLocal(tool.localToGlobal(tool.boundsTopLeft)).y; // + Panel(workbench.parent).verticalScrollPosition;


			//startPosition=wrapper.localToGlobal(new Point(-3,-30)); 
			startPosition=wrapper.localToGlobal(new Point()); //.add(new Point(workbench.horizontalScrollPosition,workbench.verticalScrollPosition));
			startWidth=wrapper.width;
			startRotation=wrapper.rotation;
			startHeight=wrapper.height;
			tool.startWidth=startWidth;
			tool.startHeight=startHeight;

		}

		private function resetWrapper():void
		{
			if (workbench.contains(wrapper))
			{
				workbench.removeChild(wrapper);
			}
			wrapper=new UIComponent();
		}

		private function updateElements():void
		{
			for each (var el:SelectedElement in elements)
			{
				el.actualize();
			}
		}

		public function getSelectedElements():Array
		{
			var controls:Array=[];
			for each (var el:SelectedElement in elements)
			{
				controls.push(el.element);
			}
			return controls;
		}

		public function getSelectedElement():IUIElementDescriptor
		{
			if (elements.length == 0)
			{
				return null;
			}
			else
			{
				return SelectedElement(elements[0]).element;
			}
		}

		private function removeTool(tool:TransformTool):void
		{
			if (workbench.contains(tool))
			{
				tool.target=null;
				workbench.removeChild(tool);
				tool.removeEventListener(TransformEvent.TRANSFORM_TARGET, updateSelection);
				tool.removeEventListener(TransformEvent.CONTROL_UP, saveChanges);
				tool.removeEventListener(MouseEvent.DOUBLE_CLICK, editSimple);
				tool=null;

			}
			selectedElementExist=false;
		}

		public function editSimple(e:MouseEvent):void
		{
			trace("doubleClick on tool");
			var panel:ReflectionEditorPanel;
			var control:DisplayObject;
			if (tool.target)
			{
				for each (var elem:SelectedElement in elements)
				{
					if (elem.element is TextElementDescriptor)
					{
						//param = ControlUtils.retrieveParameter(textParameter, elem.element);
						panel=ReflectionEditorPanel(EditorUtil.retrieveEditor(textParameter));
						control=panel.controlList["text"];
						RichTextEditorPanel(control).openTextEditor();

					}
					else if ((elem.element is ImgElementDescriptor) || (elem.element is VideoElementDescriptor) || (elem.element is FLVPlayerElementDescriptor))
					{
						var pSet:IParameterSet = (elem.element is ImgElementDescriptor) ? new ImgParameterSet : (elem.element is VideoElementDescriptor) ? new VideoParameterSet : new FLVSourceParameterSet;
						panel=ReflectionEditorPanel(EditorUtil.retrieveEditor(pSet));
						control=panel.controlList["source"];
						FilePicker(control).showBrowser()
					}
				}
			}
		}

		private function updateSelection(e:Event):void
		{

			var el:SelectedElement;
			var width:Number;
			var height:Number;
			var _globalMatrix:Matrix=tool.toolMatrix;
			var angle:Number=MatrixUtils.getAngle(_globalMatrix);
			var topLeft:Point=tool.boundsTopLeft;
			var topRight:Point=tool.boundsTopRight;
			var bottomLeft:Point=tool.boundsBottomLeft;
			width=Math.round(Math.sqrt((topRight.x - topLeft.x) * (topRight.x - topLeft.x) + (topRight.y - topLeft.y) * (topRight.y - topLeft.y)));
			height=Math.round(Math.sqrt((bottomLeft.x - topLeft.x) * (bottomLeft.x - topLeft.x) + (bottomLeft.y - topLeft.y) * (bottomLeft.y - topLeft.y)));
			//

			// Calcul de la position de base du selecteur

			startPosition=wrapper.localToGlobal(new Point());

			// Decalage en X et Y 

			var move_x:int=Math.round(tool.localToGlobal(tool.boundsTopLeft).x - startPosition.x);
			var move_y:int=Math.round(tool.localToGlobal(tool.boundsTopLeft).y - startPosition.y);
			var move_point:Point=new Point();
			var parentMatrix:Matrix;
			var elementPosition:Point;

			// Agrandissement de la width en % 

			var widthDiff:Number=Math.round(ConvertUtils.getPercent(startWidth, width) - 100);
			var heightDiff:Number=Math.round(ConvertUtils.getPercent(startHeight, height) - 100);


			// Selection simple
			if (elements.length == 1 && tool.currentControl != null)
			{
				if (tool.currentControl.name.indexOf("rotation") != -1)
				{
					for each (el in elements)
					{

						el.setPositionFromGlobal(tool.localToGlobal(topLeft));
						el.setGlobalRotation(angle);
						el.refresh(false);
					}
				}
				else if (tool.currentControl.name == "move")
				{
					for each (el in elements)
					{
						el.setPositionFromGlobal(tool.localToGlobal(topLeft));
						el.refresh(false);
					}
				}
				else
				{
					for each (el in elements)
					{
						if (el.getFace().rotation < -90 || el.getFace().rotation > 90)
						{
							width=topRight.x < topLeft.x ? width : -width;
							height=bottomLeft.y < topLeft.y ? height : -height;
						}
						else
						{
							width=topRight.x < topLeft.x ? -width : width;
							height=bottomLeft.y < topLeft.y ? -height : height;
						}

						el.changeSize(Math.round(width), Math.round(height));
						el.setPositionFromGlobal(tool.localToGlobal(topLeft));
						el.refresh();

					}
				}
			}

			// Multi selection

			if (elements.length > 1)
			{
				for each (el in elements)
				{
					var parentList:Array=ElementList.getInstance().getElementParenList(IUIElementDescriptor(el.element), BrowsingManager.getInstance().getCurrentPage());

					if (!isParentSelected(parentList))
					{
						if (tool.currentControl.name.indexOf("rotation") != -1)
						{
							/*

							   el.setPositionFromGlobal(tool.localToGlobal(topLeft));
							   el.setGlobalRotation(angle);
							 el.refresh(false);*/



							var rotationPoint:Point=tool.localToGlobal(tool.registration);
							var m:Matrix;
							var oldMatrix:Matrix=el.getFace().transform.matrix;
							GeomUtils.rotateAroundExternalPoint(el.getFace(), rotationPoint.x, rotationPoint.y, (angle - startRotation) + el.start_rotation);
							m=el.getFace().transform.matrix;
							el.changePosition(m.transformPoint(new Point()).x, m.transformPoint(new Point()).y);
							var newangle:Number=MatrixUtils.getAngle(m);
							el.setRotation(MatrixUtils.getAngle(m));

							m=new Matrix();
							el.getFace().transform.matrix=m;
							el.refresh(true);
						}
						else
						{
							// Recupere la matrice inverse du parent 

							parentMatrix=DisplayListUtils.customConcatenatedMatrix(el.getFace().parent);
							parentMatrix.invert();

							// Calcul les changements de positions sans les transformations du parent 

							move_point=parentMatrix.transformPoint(new Point(move_x, move_y)).subtract(new Point(parentMatrix.tx, parentMatrix.ty));

							// Calcul les changements de positions dus a un resize

							// Position de l element par rapport au selecteur
							elementPosition=el.global_start_position.subtract(wrapper.localToGlobal(new Point()));
							elementPosition.x=Math.round(elementPosition.x);
							elementPosition.y=Math.round(elementPosition.y);


							// mise a jour des elements 
							el.addPercentToDefaultSize(widthDiff, heightDiff);
							el.addValueToDefaultPosition(move_point.x + elementPosition.x * (widthDiff / 100), move_point.y + elementPosition.y * (heightDiff / 100));

							el.refresh();
						}
					}

				}

			}
			(sizePanel as ReflectionEditorPanel).update(elements[0].size);
			(positionPanel as ReflectionEditorPanel).update(elements[0].position);
			(rotationPanel as ReflectionEditorPanel).update(elements[0].rotation);

		}

		private function isParentSelected(parents:Array):Boolean
		{
			for (var i:uint=0; i < parents.length; i++)
			{
				if (isSelected(IUIElementDescriptor(parents[i])))
				{
					return true;
				}
			}
			return false;
		}

		public function init(workbench:Container, editor:IElementEditor):void
		{
			this.workbench=workbench;
			this.editor=editor;

		}

		// get references of position , size , rotation parameters editors to change their value 

		public function bind():void
		{
			positionPanel=EditorUtil.retrieveEditor(positionParameter);
			sizePanel=EditorUtil.retrieveEditor(sizeParameter);
			rotationPanel=EditorUtil.retrieveEditor(rotationParameter);
			textPanel=EditorUtil.retrieveEditor(rotationParameter);
		}



	}
}
