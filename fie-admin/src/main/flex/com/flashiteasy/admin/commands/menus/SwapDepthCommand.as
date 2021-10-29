package com.flashiteasy.admin.commands.menus
{
	import com.flashiteasy.admin.ApplicationController;
	import com.flashiteasy.admin.commands.AbstractCommand;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class SwapDepthCommand extends AbstractCommand
	{
		private var object:DisplayObject;
		private var depth:String;
		private var oldIndex:int;
		private var oldParent:IUIElementContainer;
		private var descriptor:IUIElementDescriptor;
		private var uuid:String;
		private var page:Page;
		private var parent:IUIElementContainer;

		public function SwapDepthCommand(descriptor:IUIElementDescriptor, depth:String, parent:IUIElementContainer=null)
		{
			this.descriptor=descriptor;
			this.page=descriptor.getPage();
			this.object=descriptor.getFace();
			this.depth=depth;
			//this.parent=parent;
		}

		public override function execute():void
		{
			this.uuid=descriptor.uuid;
			var elem:IUIElementDescriptor=ElementList.getInstance().getElement(uuid, page);
			object=elem.getFace();
			if (parent == null)
			{
				if (elem.hasParent())
				{
					parent=elem.getParent();
				}
			}
			oldIndex=object.parent.getChildIndex(object);
			oldParent=elem.getParent();
			var backwardIndex:int=oldIndex > 0 ? oldIndex - 1 : 0;
			var forwardIndex:int=oldIndex < (object.parent.numChildren - 1) ? oldIndex + 1 : (object.parent.numChildren - 1);
			if (depth == "rear")
			{
				if (parent == null || parent.getPage() != page)
				{
					//ElementList.getInstance().moveElementOnStageToRear(descriptor);
					ElementList.getInstance().moveElementOnStageToRear(elem);
					object.parent.addChildAt(object, 0);
				}
				else
				{
					//parent.swapChildAt(descriptor, 0);
					parent.swapChildAt(elem, 0);
				}
			}
			else if (depth == "front")
			{
				if (parent == null || parent.getPage() != page)
				{
					ElementList.getInstance().moveElementOnStageToFront(elem);
					object.parent.addChild(object);
				}
				else
				{
					//parent.removeChild(elem);
					//parent.layoutElement(elem);
					parent.swapChildAt(elem, object.parent.numChildren-1);
					
				}
			}
			else if (depth == "backward")
			{
				if (parent == null || parent.getPage() != page)
				{
					ElementList.getInstance().moveElementOnStageToIndex(elem, backwardIndex);
					object.parent.addChildAt(object, backwardIndex);
				}
				else
				{
					parent.swapChildAt(elem, backwardIndex);
				}
			}
			else if (depth == "forward")
			{
				if (parent == null || parent.getPage() != page)
				{
					ElementList.getInstance().moveElementOnStageToIndex(elem, forwardIndex);
					object.parent.addChildAt(object, forwardIndex);
				}
				else
				{
					parent.swapChildAt(elem, forwardIndex);
				}
			}
			else if( !isNaN(int(depth)))
			{
				var index : int = int(depth);
				if (parent == null || parent.getPage() != page)
				{
					// prevent out of bound error
					if(index > object.parent.numChildren +1 )
					{
						index = object.parent.numChildren;
					}
					ElementList.getInstance().moveElementOnStageToIndex(elem, index);
					object.parent.addChildAt(object, index);
				}
				else
				{
					//index = parent.uuid != oldParent.uuid ? index + 1 : index;
					parent.swapChildAt(elem, index);
				}
			}
			parent=null;
			dispatchEvent(new Event(Event.COMPLETE));
			
			ApplicationController.getInstance().getBlockList().update();

		}

		public override function redo():void
		{
			execute();
		}

		public override function undo():void
		{
			var elem:IUIElementDescriptor=ElementList.getInstance().getElement(uuid, page);
			object=elem.getFace();
			if (parent == null)
			{
				if (elem.hasParent())
				{
					parent=elem.getParent();
				}
			}
			if (parent == null)
			{
				ElementList.getInstance().moveElementOnStageToIndex(elem, oldIndex);
				object.parent.addChildAt(object, oldIndex);
			}
			else
			{
				parent.swapChildAt(elem, oldIndex);
			}
			parent=null;
			ApplicationController.getInstance().getBlockList().update();
			
		}

	}
}