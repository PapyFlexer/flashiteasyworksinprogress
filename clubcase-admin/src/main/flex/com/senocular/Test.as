package com.senocular
{
	public class Test
	{
		/*<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:display="com.senocular.display.*" 
 applicationComplete="applicationCompleteHandler(event)" viewSourceURL="srcview/index.html">
 <mx:Script>
  <![CDATA[
   import mx.controls.Tree;
   import mx.events.ListEvent;
   import com.senocular.events.TransformEvent;
   import com.senocular.display.TransformTool;
   import mx.events.FlexEvent;

   private var _tool: TransformTool;
   private var _selectedItems: Vector.< DisplayObject >; // store selecteditems
   
   [Bindable]
   private var treeDataProvider: XML;
   
   [Bindable]
   private var openedItems: Object;

   // used for manage multiple transformations
   private var anchor_matrix: Matrix;
   private var canvas_matrix: Matrix;
   private var canvas_inverted_matrix: Matrix;   

   protected function applicationCompleteHandler(event:FlexEvent):void
   {
    _tool = new TransformTool();
    _tool.addEventListener( TransformEvent.CONTROL_MOVE, onControlMove );
    _tool.addEventListener( TransformEvent.CONTROL_DOWN, onControlDown );
    _tool.addEventListener( TransformEvent.CONTROL_UP,   onControlUp );
        
    addChild( _tool );
    treeDataProvider = getDataProvider( main_canvas );
    openedItems = treeDataProvider..node.(@open == "1" );
   }
   
   /**
    * build tree dataprovider
    * 
    */
   private function getDataProvider( container: DisplayObjectContainer ): XML
   {
    var res: XML = <node label={container.name} value={UIComponent(container).id} open="1" />;
    var i: int = 0;
    var element: DisplayObject;
    while( i < container.numChildren )
    {
     element = container.getChildAt( i );
     if( element is Image )
      res.node += <node label={element.name} value={UIComponent(element).id} open="0" />;
     else if( element is DisplayObjectContainer )
      res.node += getDataProvider( element as DisplayObjectContainer );
     i++;
    }
    return res;
   }
   
   /**
    * assign selectedItems
    * 
    */
   protected function set selectedItems( value: Vector.< DisplayObject > ): void
   {
    _selectedItems = value;
    
    var bounds: Rectangle;
    var item: DisplayObject;
    var shape: Shape;
    var temp_matrix: Matrix;
    
    _tool.target = null;
    
    // set the container matrix to the main canvas matrix
    // outline_container will contain all the selected items 'bounds'
    outline_container.transform.matrix = main_canvas.transform.matrix.clone();
    
    // remove any old item from the outline_container
    emptyOutline();
    
    if( _selectedItems.length > 0 )
    {
     // update the main_canvas matrix, in case it changed
     updateCanvasMatrix();
     
     // register the outline_container matrix
     anchor_matrix = outline_container.transform.concatenatedMatrix.clone();
     
     for( var i: int = 0; i < _selectedItems.length; i++ )
     {
      item = _selectedItems[i];
      
      // this is the main part of the application.
      // for every selected item I get its bound rectangle
      // then I create a new Shape with the size of that bound
      // and then add the created shape to the outline_container.
      // So for every select elements we will have a 'copy' inside the outline_container
      // The outline_container will be the transformtool target
      bounds = item.getBounds( item );
      shape = new Shape();
      shape.name = item.name;
      shape.graphics.beginFill( 0, 0.1 );
      shape.graphics.drawRect( bounds.x, bounds.y, bounds.width, bounds.height );
      shape.graphics.endFill( );
      
      // get the real selected item matrix
      temp_matrix = item.transform.concatenatedMatrix.clone();
      temp_matrix.concat( canvas_inverted_matrix );

      // assign to the shape 'copy' the same matrix as the selected item
      shape.transform.matrix = temp_matrix;
      outline_container.addChild( shape );
     }
     _tool.target = outline_container;
    }
   }
   
   protected function updateCanvasMatrix( ): void
   {
    canvas_matrix = main_canvas.transform.concatenatedMatrix.clone();
    canvas_inverted_matrix = canvas_matrix.clone();
    canvas_inverted_matrix.invert();
   }
   
   
   /**
    * Remove any child from the outline container
    * 
    */
   private function emptyOutline(): void
   {
    while( outline_container.numChildren > 0 )
     outline_container.removeChildAt( 0 );
   }
   
   // ------------------------------
   // TransformTool event listeners
   // ------------------------------

   protected function onControlDown( event: TransformEvent ): void
   {
    updateCanvasMatrix();
    anchor_matrix = outline_container.transform.concatenatedMatrix.clone( );
    onControlMove( null );
   }
   
   protected function onControlUp( event: TransformEvent ): void
   {
    anchor_matrix = null;
   }
   
   /**
    * Transform tool move handler.
    * 
    */
   protected function onControlMove( event: TransformEvent ): void
   {
    // every time the transform tool is moved
    // we need to update the matrix of every selected item, using
    // the transformed matrix of its 'copy' in the outline_container
     
    var outline_matrix: Matrix = outline_container.transform.concatenatedMatrix.clone();
    var temp: Matrix = outline_matrix.clone();
    outline_matrix.invert( );
    outline_matrix.concat( anchor_matrix );
    outline_matrix.invert( );
    
    anchor_matrix.concat( canvas_inverted_matrix );

    for each( var target_item: DisplayObject in _selectedItems )
    {
     var outline_item: Shape = outline_container.getChildByName( target_item.name ) as Shape;
     var item_c_matrix: Matrix = outline_item.transform.concatenatedMatrix.clone();
     var parent_matrix: Matrix = target_item.parent.transform.concatenatedMatrix.clone();
     parent_matrix.invert();
     item_c_matrix.concat( parent_matrix );
     target_item.transform.matrix = item_c_matrix;
    }
    anchor_matrix = temp.clone();
   }
   

   /**
    * tree selection has changed
    * now update the transform tool selected items
    * 
    */ 
   protected function tree1_changeHandler( event: ListEvent ):void
   {
    var sel: Vector.<DisplayObject> = new Vector.<DisplayObject>();
    for each( var node: XML in ( event.target as Tree ).selectedItems )
    {
     sel.push( this[ node.@value ] );
    }
    selectedItems = sel;
   }

  ]]>
 </mx:Script>
 <mx:Canvas right="5" bottom="5" mouseChildren="false" mouseEnabled="false" id="main_canvas" backgroundAlpha=".05" backgroundColor="#000000" left="210" top="5" visible="true">
  <mx:Canvas id="canvas2" mouseChildren="false">
   <mx:Image name="image1" x="0" y="0" source="@Embed('assets/images/alex.jpg')" id="image_1" /> 
   <mx:Image name="image2" x="105" y="0" source="@Embed('assets/images/img2.jpg')" id="image_2" />
   <mx:Canvas id="canvas1" mouseChildren="false">
    <mx:Image name="image3" source="@Embed('/assets/images/img3.jpg')" id="image_3" y="105" /> 
   </mx:Canvas>
   <mx:Canvas id="canvas3">
    <mx:Image name="image4" source="@Embed('assets/images/img4.jpg')" id="image_4" x="105" y="105" />
   </mx:Canvas>
  </mx:Canvas>
  
 </mx:Canvas>
 <mx:UIComponent id="outline_container" x="0" y="0" />
 <mx:Tree top="5" left="5" bottom="5" 
  dataProvider="{treeDataProvider}" labelField="@label" 
  width="200" enabled="true"
  allowMultipleSelection="true"
  showRoot="false" openItems="{openedItems}"
  change="tree1_changeHandler(event)" fontFamily="Verdana" fontSize="10"></mx:Tree>
</mx:Application>
	}
}