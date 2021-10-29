package com.flashiteasy.admin.components
{
	import mx.core.mx_internal;
	use namespace mx_internal;
	import flash.events.Event;
	
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import com.flashiteasy.api.utils.ArrayUtils;

	public class CustomTree extends Tree
	{
		
		private var openedItems : Array = [];
		/**
        * Tree with additionnal functionnality 
        * keep it s state when dataprovider is changed 
        * and have a slightly modified drag functionnalities
        **/
        private var openedFolderHierarchy:Object;
        private var allowDrag : Boolean = false;
        
		public function CustomTree()
		{
			
		}
		
		
		// Setter enabling drag functionnalities
		
		public function set allowDragFunctions( value : Boolean ) : void 
		{
			allowDrag = value;
			if(allowDrag)
			{
				dragEnabled=true;
				dropEnabled=true;
				addEventListener(DragEvent.DRAG_OVER,handleDragOver);
				addEventListener(DragEvent.DRAG_START , handleDragStart);
				addEventListener(DragEvent.DRAG_COMPLETE , dragComplete ) ;
			}
			else
			{
				removeEventListener(DragEvent.DRAG_START , handleDragStart);
				removeEventListener(DragEvent.DRAG_OVER,handleDragOver);
				removeEventListener(DragEvent.DRAG_COMPLETE , dragComplete ) ;
			}
		}

		private var openBeforeDrag : Array = [];
		
		private function handleDragStart(e:DragEvent):void
		{
			// Close dragged folder so it cannot be dropped on its children
			
			openBeforeDrag =[]; // store opened folder before drag operation to reopen them on drop
			var item : Object ;
			for each( item in selectedItems )
			{
				if( isItemOpen(item))
				{
					openBeforeDrag.push(item.@label); // store label because the XML is recreated on update
					expandItem(item , false);
				}
				
				
			}
		}
		
		private function dragComplete(e:DragEvent ) : void 
		{
			
			// Reopen dragged folder if they were open
			
			var item : String ;
			for each(item in openBeforeDrag )
			{
				// find items from their label
				if(dataProvider.source.(@label == item ).toXMLString().length > 1)
				{

					expandItem(dataProvider.source.(@label==item)[0], true ) ;
				}
				else
				{
					expandItem(dataProvider.source..*.(@label==item)[0], true ) ;
				}
				
			}
		}
		
		
		private function handleDragOver(e:DragEvent) : void
		{
			// Open folders when dragging over
			try{
			var currNodeOver:TreeItemRenderer = TreeItemRenderer(indexToItemRenderer(calculateDropIndex(e)));
			if ( currNodeOver == null  || !dataDescriptor.isBranch(currNodeOver.data) || draggingOverSelf(e) )
			{
				return 
			}
			expandItem(currNodeOver.data,true);	
			}
			catch(e:Error)
			{
			}
		}
		
		private function draggingOverSelf(event:DragEvent):Boolean{
        
            //Get the node currently dragging over.
            var currNodeOver:TreeItemRenderer = TreeItemRenderer(indexToItemRenderer(calculateDropIndex(event)));
            if (currNodeOver==null){
                return false;
            }
            
            //get the node we are currently dragging
            var draggingNode:TreeItemRenderer = TreeItemRenderer(itemToItemRenderer(event.dragSource.dataForFormat("treeItems")[0]));
            if(currNodeOver != draggingNode){
                return false;
            }
            return true;
        }

		private var expanded:Boolean=false;
		private var lastIndex : int ; // Last selectedIndex
		
		// Listener function called when dataprovider is changed
		// Keep tree state
		
		private function expand(e:Event) : void 
		{			
			// storing opened nodes
			
			openedItems=[];
			for each(var item:XML in openItems )
			{
				openedItems.push(item.@label);
			}
			openItems=[];
			
			// Storing last index
			
			lastIndex = selectedIndices[0];
			
			// Expand all nodes at start 
			if(!expanded)
				callLater(expandAll);
			
			// Restore previous state once render is finished 
			
			if(dataProvider.source.toString() != "" && dataProvider.source != null) 
			{
				callLater(restoreState);
			}
		}
			
		override public function set dataProvider(value:Object):void
		{
			if(super.dataProvider != null)
			{
				super.dataProvider.removeEventListener("listChanged",expand);
			}
			super.dataProvider=value;	
			super.dataProvider.addEventListener("listChanged",expand , false , 0 , true);

		}
		
		// Expand all folders
		
		public function expandAll():void
		{
			if(dataProvider!=null && dataProvider.source.toString().length>1)
			{
				expanded=true;
				for each (var item:XML in dataProvider.source) {
	                if( item.children() != null ) {
	                	expandChildrenOf(item , true);
	                }
	            } 
   			}	
		}
		
		public function expandParents(node:XML):void {
                if (node && !isItemOpen(node)) {
                   	expandItem(node, true);
                    expandParents(node.parent());
                }
            }
            
        // Restore previous state
        
		private function restoreState() : void 
		{
			var itemToOpen : XML ;
			
			// Restore opened nodes 
			
			for each(var item:* in openedItems)
			{
				if(dataProvider.source.(@label == item ).toXMLString().length > 1)
					itemToOpen = dataProvider.source.(@label == item )[0];
				else
					itemToOpen = dataProvider.source..*.(@label == item )[0];
				expandItem(itemToOpen, true );
			}
			
			// restore index
			
			scrollToIndex(lastIndex);
		}
		
		public function getDropParent(e:DragEvent):Object
		{
			var dropData : Object = getDropData();
			var parent : Object  = dropData.parent;
			if( getItemIndex(parent) > calculateDropIndex(e) || dropData.parent == null ) 
			{
				return null;
			}
			else
			{
				return parent;
			}
		}
		/*===========================
		!!!! use MX_INTERNAL !!!!!
		============================*/ 
	
		// Return the target of a drag and drop operation
		
		public function getObjectTarget() : Object {
		   var dropData : Object = mx_internal::_dropData as Object;
		   if (dropData.parent != null) {
		      return dropData.parent;
		   } else {
		          // if there is not parent (root of the tree), return the root directly
		      var renderer : IListItemRenderer = indexToItemRenderer(0);
		      return renderer.data;
		}
		}
		
		/*===========================
		!!!! use MX_INTERNAL !!!!!
		============================*/ 
		
		// return drop data 
		
		public function getDropData() : Object 
		{
			return mx_internal::_dropData as Object;
		}
	}
}