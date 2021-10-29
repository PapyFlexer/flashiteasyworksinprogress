//package com.flashiteasy.admin.visualEditor
package com.flashiteasy.test {

	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.edition.IElementEditorPanel;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.uicontrol.ReflectionEditorPanel;
	import com.flashiteasy.admin.utils.GeomUtils;
	import com.flashiteasy.admin.utils.KeyboardStatus;
	import com.flashiteasy.admin.visualEditor.handles.EditButton;
	import com.flashiteasy.admin.visualEditor.handles.EditType;
	import com.flashiteasy.admin.workbench.IElementEditor;
	import com.flashiteasy.admin.workbench.IWorkbench;
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.parameters.RotationParameterSet;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.MatrixUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.utils.ArrayUtil;

	public class VisualSelector
	{

		private var elem:IUIElementDescriptor;
		private var workbench:Container;
		private var visualEditor:Canvas=new Canvas();
		private var selection:Canvas = new Canvas();
		private var move:Canvas=new Canvas();
		private var editor:IElementEditor;
		
		
		private var rotationPanel:IElementEditorPanel;
		private var positionPanel:IElementEditorPanel;
		private var sizePanel:IElementEditorPanel;
		
		
		private var transformationType:String;
		private var clickMousePoint:Point;
		
		private var positionParameter : PositionParameterSet;
		private var startPosition:Point;
		private var clickPosition :Point;
		private var selectionPosition:Point;
		private var visualEditorStartPosition:Point;
		private var visualEditorStartRotation:Number;
		
		private var sizeParameter : SizeParameterSet;
		private var startWidth:Number;
		private var startHeight:Number;
		
		private var rotationParameter:RotationParameterSet;
		private var startRotation:Number;
		
		private var deleteButton : EditButton = new EditButton(EditType.DELETE);
		private var rotateButton : EditButton = new EditButton(EditType.ROTATE);
		private var resizeWidthButton : EditButton = new EditButton(EditType.RESIZE_WIDTH);
		private	var resizeButton : EditButton = new EditButton(EditType.RESIZE);
		private	var resizeHeightButton : EditButton = new EditButton(EditType.RESIZE_HEIGHT);
		private var wrapper:UIComponent= new UIComponent();
		
		private var center:Point;
		private var firstAngle:Number;
		private var previousMouseDiff:Point;
		
		private static var instance:VisualSelector;
		private static var allowInstantiation : Boolean = false;
		
		private var elements :Array ;
		
		/*public function VisualSelector()
		{
			if( ! allowInstantiation )
			{
				throw new Error("Direct instantiation not allowed, please use singleton access.");
			}
			
		}*/
		
		public static function getInstance() : VisualSelector
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new VisualSelector();
				allowInstantiation = false;
			}
			return instance;
		}
		
		public function addElement(elem:IUIElementDescriptor):void{
			elements[elements.length]=elem;
		}
		
		public function removeElement(elem:IUIElementDescriptor):void{
			ArrayUtils.removeElement(elements,elem);
		}
		
		
		public function init(workbench:Container,elem:IUIElementDescriptor,editor:IElementEditor):void{
			this.workbench=workbench;
			this.elem=elem;
			this.editor=editor;
			positionParameter=ParameterIntrospectionUtil.retrieveParameter(new PositionParameterSet(), this.elem ) as PositionParameterSet;
			sizeParameter=ParameterIntrospectionUtil.retrieveParameter(new SizeParameterSet(), this.elem ) as SizeParameterSet;
			rotationParameter=ParameterIntrospectionUtil.retrieveParameter(new RotationParameterSet(), this.elem ) as RotationParameterSet;
			this.startWidth=elem.getFace().width;
			this.startHeight=elem.getFace().height;
			startRotation=MatrixUtils.getAngle(elem.getFace().transform.matrix);
			startPosition= new Point(Math.round(positionParameter.x),Math.round(positionParameter.y));
			registerEditButton(rotateButton);
			registerEditButton(resizeButton);
			registerEditButton(resizeWidthButton);
			registerEditButton(resizeHeightButton);
			registerEditButton(deleteButton);
			  
			  move.styleName="positionEditor";

			
			move.addEventListener( MouseEvent.MOUSE_DOWN , beginDrag ,false,0,true);
			  
			visualEditor.addChild(selection);
			visualEditor.addChild(move);
			wrapper.addChild(deleteButton);
			wrapper.addChild(rotateButton);
			wrapper.addChild(resizeButton);
			wrapper.addChild(resizeWidthButton);
			wrapper.addChild(resizeHeightButton);
			visualEditor.addChild(wrapper);
			workbench.addChild( visualEditor );
			draw();
		}

		public function remove():void{
			workbench.removeChild(visualEditor);
			move.removeEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
		}
		

		public function bind():void{
			positionPanel = editor.retrieveEditor(positionParameter);
			sizePanel = editor.retrieveEditor(sizeParameter);
			rotationPanel=editor.retrieveEditor(rotationParameter);
		}
		private function draw():void{
			var d:FieUIComponent = elem.getFace();
			var p : Point = workbench.globalToLocal(d.localToGlobal(new Point( 0,0)));

			
			visualEditor.width=d.width;
			visualEditor.height=d.height;
			visualEditor.transform.matrix=elem.getFace().transform.concatenatedMatrix;
			visualEditor.x +=workbench.horizontalScrollPosition;
			visualEditor.y +=workbench.verticalScrollPosition;
			
			visualEditorStartPosition= new Point(visualEditor.x,visualEditor.y);
			visualEditorStartRotation = visualEditor.rotation;
			selection.width = d.width;
			selection.height = d.height;
			selection.styleName = "indicator";

			drawMove();
			drawHandlers();

		}

		private function drawMove():void{

			move.x=0;
			move.y=0;
			move.width=selection.width;
			move.height=10;
			
		}

		private function beginDrag(e:MouseEvent):void{

			selectionPosition=new Point(e.stageX,e.stageY);
			startPosition=new Point(positionParameter.x,positionParameter.y);
			visualEditorStartPosition= new Point(visualEditor.x,visualEditor.y);
			clickPosition=new Point(elem.getFace().parent.mouseX,elem.getFace().parent.mouseY);
			FieAdmin.ADMIN_STAGE.addEventListener(MouseEvent.MOUSE_MOVE,DragMove,true);
			FieAdmin.ADMIN_STAGE.addEventListener(MouseEvent.MOUSE_UP,DragEnd,true);
		}

		private function DragMove(e:MouseEvent):void{
			var p:Point=new Point((e.stageX-selectionPosition.x),(e.stageY-selectionPosition.y));
			var p2:Point=new Point(elem.getFace().parent.mouseX-clickPosition.x,elem.getFace().parent.mouseY-clickPosition.y);

			visualEditor.x=visualEditorStartPosition.x+p.x;
			visualEditor.y=visualEditorStartPosition.y+p.y;
			setPosition(p2.x,p2.y);
			(positionPanel as ReflectionEditorPanel).update(positionParameter);
			positionParameter.apply(elem);
			SimpleUIElementDescriptor(elem).initSize();
		}
		private function DragEnd(e:MouseEvent):void{
			FieAdmin.ADMIN_STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,DragMove ,true);
			FieAdmin.ADMIN_STAGE.removeEventListener( MouseEvent.MOUSE_UP, DragEnd , true);
			(positionPanel as ReflectionEditorPanel).update(positionParameter,true);

		}
		
		private function drawHandlers():void{
			
			var btn:EditButton;
			  resizeWidthButton.x=visualEditor.width;
			  resizeWidthButton.y=visualEditor.height/2;
			 
			  
			  resizeHeightButton.x=visualEditor.width/2;
			  resizeHeightButton.y=visualEditor.height;
			  
			  resizeButton.x=visualEditor.width;
			  resizeButton.y=visualEditor.height;
			  
			  rotateButton.x=visualEditor.width;
			  rotateButton.y=0;
			  
		}

		private function registerEditButton(bt : EditButton) : void {
			bt.addEventListener(MouseEvent.MOUSE_DOWN, editButtonMouseHandler,false,0,false);
		}

		private function editButtonMouseHandler(event : MouseEvent) : void {
			
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					var downBt : EditButton = event.target as EditButton;
					if (downBt) {
						switch(downBt.type) {
							case EditType.MOVE:
							case EditType.RESIZE:
							case EditType.RESIZE_HEIGHT:
							case EditType.RESIZE_WIDTH:
							case EditType.ROTATE:
								transformationType = downBt.type;
								startTransformation();
								break;
							case EditType.DELETE:
								
								editor.editIfFace(elem.getFace(),true);
								ApplicationController.getInstance().getTree().destroy(elem);
							default:
								break;
						}
					}
					break;
				case MouseEvent.CLICK:
					var clickBt : EditButton = event.target as EditButton;
					if (clickBt) {
						switch(clickBt.type) {
							case EditType.DELETE:
								elem.destroy();
								break;
							default:
								break;
						}
					}
					break;
				case MouseEvent.MOUSE_MOVE:
					var moveBt : EditButton = event.target as EditButton;

					if (moveBt) {
						switch(moveBt.type) {
							case EditType.MOVE:
							case EditType.RESIZE:
							case EditType.RESIZE_HEIGHT:
							case EditType.RESIZE_WIDTH:
							case EditType.ROTATE:
								
								break;
							default:
								
								break;
						}
					}
					break;
			}
			event.stopImmediatePropagation();
		}

		private function startTransformation( ) : void 
		{
			

			clickMousePoint = new Point(FieAdmin.ADMIN_STAGE.mouseX, FieAdmin.ADMIN_STAGE.mouseY);
			var ob:DisplayObject=elem.getFace();
			previousMouseDiff=new Point();
			var m:Matrix=ob.transform.matrix;
			center = ob.transform.matrix.transformPoint(new Point(m.a* (ob.width/2) + m.tx + m.c * (ob.height/2),m.b * (ob.width/2) + m.d*(ob.height/2) + m.ty));
			FieAdmin.ADMIN_STAGE.addEventListener(MouseEvent.MOUSE_UP, transformMouseUpHandler,true,0,true);
			visualEditorStartRotation=visualEditor.rotation;
			FieAdmin.ADMIN_STAGE.addEventListener(Event.ENTER_FRAME, transformationEnterFrameHandler,false,0,true);
		}

		private function transformMouseUpHandler(event : MouseEvent) : void 
		{
			stopTransformation();
		}

		private function stopTransformation() : void 
		{
			transformationType = null;
			FieAdmin.ADMIN_STAGE.removeEventListener(MouseEvent.MOUSE_UP, transformMouseUpHandler,true);
			FieAdmin.ADMIN_STAGE.removeEventListener(Event.ENTER_FRAME, transformationEnterFrameHandler);
			elem.getFace().transform.matrix=new Matrix();
			
			this.startWidth=elem.getFace().width;
			this.startHeight=elem.getFace().height;
			startRotation=rotationParameter.rotation;
			(positionPanel as ReflectionEditorPanel).update(positionParameter,true);
			(sizePanel as ReflectionEditorPanel).update(sizeParameter,true);
			(rotationPanel as ReflectionEditorPanel).update(rotationParameter,true);
		}

		private function transformationEnterFrameHandler(event : Event) : void 
		{

			var mouseDiff : Point = new Point(FieAdmin.ADMIN_STAGE.mouseX, FieAdmin.ADMIN_STAGE.mouseY).subtract(clickMousePoint);
			if(previousMouseDiff && mouseDiff.equals(previousMouseDiff)) return ;
			previousMouseDiff = mouseDiff.clone();
			
			
			switch(transformationType) {
				case EditType.RESIZE:
					var test:FieUIComponent=elem.getFace();
					var localMouseDiff : Point = GeomUtils.rotatePoint(mouseDiff, -elem.getFace().parent.rotation - elem.getFace().rotation );

					if (KeyboardStatus.shiftDown) {
						var blockRatio : Number = elem.getFace().x / elem.getFace().y;
						if (elem.getFace().x + localMouseDiff.x > elem.getFace().y + localMouseDiff.y) {
							localMouseDiff.x = localMouseDiff.y * blockRatio;
						} else {
							localMouseDiff.y = localMouseDiff.x / blockRatio;
						}
					}
					
					var resizeParentMouseDiff : Point = GeomUtils.rotatePoint(localMouseDiff, elem.getFace().rotation);
					
					var newWidth : Number = elem.getFace().x + localMouseDiff.x < 1 ? 1 : elem.getFace().x + localMouseDiff.x;
					var newHeight : Number = elem.getFace().y + localMouseDiff.y < 1 ? 1 : elem.getFace().y + localMouseDiff.y;
					
					var newX : Number = elem.getFace().x;
					var newY : Number = elem.getFace().y;
					
					if (KeyboardStatus.altDown) {
						(newWidth + localMouseDiff.x < 1) ? 1 : newWidth += localMouseDiff.x;
						(newHeight + localMouseDiff.y < 1) ? 1 : newHeight += localMouseDiff.y;
						newX -= resizeParentMouseDiff.x;
						newY -= resizeParentMouseDiff.y;
					}
					setElementSize(startWidth + localMouseDiff.x , startHeight + localMouseDiff.y);
					
					
					break;
				case EditType.RESIZE_HEIGHT:
					var localMouseDiff_rh : Point = GeomUtils.rotatePoint(mouseDiff, -elem.getFace().parent.rotation - elem.getFace().rotation);
					setElementSize(startWidth , startHeight + localMouseDiff_rh.y); 
					break;
				case EditType.RESIZE_WIDTH:
					
					
					var localMouseDiff_rw : Point = GeomUtils.rotatePoint(mouseDiff, -elem.getFace().parent.rotation - elem.getFace().rotation );
					setElementSize(startWidth + localMouseDiff_rw.x, startHeight); 
					break;
				case EditType.ROTATE:
     				
     				var clonedCenter:Point= center.clone();
     				var currentMouseAngleVector : Point = (new Point(FieAdmin.ADMIN_STAGE.mouseX, FieAdmin.ADMIN_STAGE.mouseY)).subtract(clonedCenter);
     				var currentMouseAngle : Number = Math.atan2(currentMouseAngleVector.y, currentMouseAngleVector.x);
					var clickMouseAngleVector : Point = clickMousePoint.subtract(clonedCenter);
					var clickMouseAngle : Number = Math.atan2(clickMouseAngleVector.y, clickMouseAngleVector.x);
					
					var rotationOffset : Number = (currentMouseAngle - clickMouseAngle) * 180 / Math.PI;
					
					
					var newRotation : Number =  startRotation + rotationOffset;
					
					newRotation = ((newRotation % 360) + 540) % 360 - 180;
      				var center2:Point=new Point(elem.getFace().width/2, elem.getFace().height/2);
      				
					GeomUtils.rotateAroundInternalPoint(elem.getFace(),center2.x,center2.y,newRotation);
					GeomUtils.rotateAroundInternalPoint(visualEditor , visualEditor.width/2, visualEditor.height/2,visualEditorStartRotation + rotationOffset);
					var mat:Matrix = elem.getFace().transform.matrix;
					var x:Number=elem.getFace().x;
					var y:Number=elem.getFace().y;
					positionParameter.x=mat.transformPoint(new Point()).x;
					positionParameter.y=mat.transformPoint(new Point()).y;
					positionParameter.is_percent_x=false;
					positionParameter.is_percent_y=false;
					positionParameter.apply(elem);
					rotationParameter.rotation=Math.round(newRotation);
					
					(positionPanel as ReflectionEditorPanel).update(positionParameter);
					break;

				
			}
		}
		
		private function setPosition( x:Number, y:Number):void{

			if(positionParameter.is_percent_x){
				positionParameter.x=startPosition.x+x/ (elem.getFace().x / positionParameter.x);
			}
			else{
				positionParameter.x=startPosition.x+x;
			}
			if(positionParameter.is_percent_y){


				positionParameter.y=startPosition.y+y / (elem.getFace().y / positionParameter.y);

			}
			else{

				positionParameter.y=startPosition.y+y;
			}
		}
		
		/**
		 * Modifie la taille de l element selectionné
		 */
		 
		private function setElementSize(width:Number,height:Number):void{
			if(sizeParameter.is_percent_h){
				sizeParameter.height=height / (elem.getFace().height / sizeParameter.height);
			}
			else{
				sizeParameter.height=height;
			}
			if(sizeParameter.is_percent_w){
				sizeParameter.width=width /(elem.getFace().width / sizeParameter.width);
			}
			else{
				sizeParameter.width=width;
			}
			sizeParameter.apply(elem);
			(sizePanel as ReflectionEditorPanel).update(sizeParameter);
			SimpleUIElementDescriptor(elem).initSize();
			draw();
		}

	}
	protected function calculateTranslationFromMultiTranslation(overallTranslation:DragGeometry ,  object:Object) : DragGeometry
  {
   var rv:DragGeometry = new DragGeometry();

   
   // This is the rotation, scaling, and translation of the entire selection.
   selectionMatrix.identity();
   selectionMatrix.rotate( toRadians( overallTranslation.rotation ));
   selectionMatrix.scale( (originalGeometry.width + overallTranslation.width) / originalGeometry.width,
    (originalGeometry.height + overallTranslation.height) / originalGeometry.height );
   selectionMatrix.translate( overallTranslation.x + originalGeometry.x, overallTranslation.y + originalGeometry.y);

    // This is the point the object is relative to the selection
   
   relativeGeometry.x = originalModelGeometry[object].x - originalGeometry.x;
   relativeGeometry.y = originalModelGeometry[object].y - originalGeometry.y;   
   
   objectMatrix.identity();
   objectMatrix.rotate( toRadians( overallTranslation.rotation +  originalModelGeometry[object].rotation) );    
   objectMatrix.translate(relativeGeometry.x, relativeGeometry.y);
   

   var translatedZeroPoint:Point = objectMatrix.transformPoint( zero );
   var translatedTopRightCorner:Point = objectMatrix.transformPoint( new Point(originalModelGeometry[object].width,0) );   
   var translatedBottomLeftCorner:Point = objectMatrix.transformPoint( new Point(0,originalModelGeometry[object].height) );   

   translatedZeroPoint = selectionMatrix.transformPoint( translatedZeroPoint );
   translatedTopRightCorner = selectionMatrix.transformPoint( translatedTopRightCorner );
   translatedBottomLeftCorner = selectionMatrix.transformPoint( translatedBottomLeftCorner );

   // uncomment to draw debug graphics.
//   container.graphics.lineStyle(2,0xff0000,0.5);
//   container.graphics.drawCircle(translatedZeroPoint.x, translatedZeroPoint.y , 4);
//   container.graphics.lineStyle(2,0xffff00,0.5);
//   container.graphics.drawCircle(translatedTopRightCorner.x, translatedTopRightCorner.y , 4);
   
   
   
   
   var targetWidth:Number = Point.distance( translatedZeroPoint, translatedTopRightCorner);
   var targetHeight:Number = Point.distance( translatedZeroPoint, translatedBottomLeftCorner ) ;
   
   // remember, rv is the CHANGE in value from the original, not an absolute value.
   rv.x = translatedZeroPoint.x - originalModelGeometry[object].x; 
   rv.y = translatedZeroPoint.y - originalModelGeometry[object].y;
   rv.width = targetWidth - originalModelGeometry[object].width;
   rv.height = targetHeight - originalModelGeometry[object].height;
   
   var targetAngle:Number = toDegrees(Math.atan2( translatedTopRightCorner.y - translatedZeroPoint.y, translatedTopRightCorner.x - translatedZeroPoint.x));
   
   rv.rotation = targetAngle - originalModelGeometry[object].rotation - overallTranslation.rotation;
   return rv;
  }
  
  protected function applyTranslation( translation:DragGeometry) : void
        {
   
            if( selectionManager.currentlySelected.length == 1 )
            {                   
    applyTranslationForSingleObject( selectionManager.currentlySelected[0], translation, originalGeometry );                    
            }
            else if( selectionManager.currentlySelected.length > 1 )
            {    
    applyTranslationForSingleObject(multiSelectModel, translation , originalGeometry);
    for each ( var subObject:Object in selectionManager.currentlySelected )
    {
     
     
     var subTranslation:DragGeometry = calculateTranslationFromMultiTranslation( translation, subObject );
     var originalGeometry:DragGeometry = originalModelGeometry[ subObject ]
     // At this point, constraints to the entire group have already been applied, but we need to apply per component constraints.
     
     applySingleObjectConstraints(subObject, originalGeometry, subTranslation, currentDragRole );

     applyTranslationForSingleObject( subObject, subTranslation , originalModelGeometry[subObject] );
    }
            }

        }
}
