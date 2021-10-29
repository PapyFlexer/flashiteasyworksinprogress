package com.flashiteasy.admin.components
{
	import com.flashiteasy.admin.components.componentsClasses.EventItemRenderer;
	import com.flashiteasy.admin.components.filterComponents.FilterPopUp;
	import com.flashiteasy.admin.event.TriggerEvent;
	import com.flashiteasy.admin.popUp.PopUp;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.editor.IParameterSetEditor;
	import com.flashiteasy.api.editor.IParameterSetEditorListener;
	import com.flashiteasy.api.editor.impl.AbstractParameterSetEditor;
	import com.flashiteasy.api.parameters.FilterParameterSet;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.core.ClassFactory;
	import mx.events.DragEvent;

	public class FilterEditorImpl extends AbstractParameterSetEditor implements IParameterSetEditor
	{
		
		private var filterList:List;
		private var popUpButton:Button;
		private var box:HBox;
		
		override public function reset( listener : IParameterSetEditorListener, parameterSet : IParameterSet  ) : void
		{
			this.listener = listener;
			this.parameterSet = parameterSet;
			setFilters(FilterParameterSet(parameterSet));
		}
		
		override public function layout(availableWidth:Number):void
		{
			super.layout( availableWidth );
			box = new HBox;
			box.percentWidth = 100;
			filterList= new List();
			filterList.percentWidth = 100;
			box.addChild(filterList);
			filterList.dragEnabled=true;
			filterList.dragMoveEnabled=true;
    		filterList.dropEnabled=true;
    		filterList.addEventListener(DragEvent.DRAG_COMPLETE,moveSelectedFilter ,false , 0 , true  );
    		filterList.addEventListener(DragEvent.DRAG_Start,startMoveSelectedFilter ,false , 0 , true  );
    		
			popUpButton= new Button();
			box.addChild(popUpButton);
			popUpButton.addEventListener(MouseEvent.CLICK , openWorkbench ,false , 0 , true  );
			addChild(box);
		}
		
			

			private var workbench : FilterPopUp ;
			private var param : FilterParameterSet;
			
			public function setFilters( param : FilterParameterSet ) : void
			{
				this.param=param;
				box.callLater(initList,[param.filters]);
			}
			private function initList( data : Array ) :void
			{
				filterList.itemRenderer=new ClassFactory(EventItemRenderer);
				filterList.dataProvider= data;
				filterList.dragEnabled=true;
				filterList.dragMoveEnabled=true;
    			filterList.dropEnabled=true;
				filterList.percentWidth = 100;
				box.addEventListener(TriggerEvent.REMOVE_EVENT , removeSelectedFilter) ;
			}
			
			private function removeSelectedFilter(e:Event) :void
			{
				param.removeFilter(filterList.selectedIndex);
				dispatchEvent(new Event(Event.CHANGE));
				box.callLater(initList,[param.filters]);
			}
			
			private function startMoveSelectedFilter(e:DragEvent) :void
			{
				//param.moveFilter(filterList.selectedIndex);
				//dispatchEvent(new Event(Event.CHANGE));
				//box.callLater(initList,[param.filters]);
				trace("startMoveSelectedFilter"+e.target.selectedIndex);
			}
			
			private function moveSelectedFilter(e:DragEvent) :void
			{
				trace(""+e.target.selectedIndex+" dropIndex "+e.target.calculateDropIndex);
				/*param.moveFilter(filterList.selectedIndex);
				dispatchEvent(new Event(Event.CHANGE));
				box.callLater(initList,[param.filters]);*/
			}
			private function openWorkbench():void
			{
				if(filterList.selectedIndex == -1)
				{
					workbench = new FilterPopUp(param);
				}
				else
				{
					workbench = new FilterPopUp(param,filterList.selectedItem);
				}
				workbench.addEventListener(Event.CHANGE , change ,false , 0 , true  );
				workbench.addEventListener(PopUp.CLOSED , workbenchClose , false , 0 , true );
				filterList.enabled=false;
			}
			
			private function workbenchClose(e:Event):void
			{
				filterList.enabled=true;
			}
			private function change(e:Event):void
			{
				//dispatchEvent(new Event(Event.CHANGE));
				setPreviousValue();
				update();
				box.callLater(initList,[param.filters]);
			}
	}
}