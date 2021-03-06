package com.flashiteasy.admin.uicontrol
{
	import mx.controls.Tree;

	/**
	 * Flash'Iteasy
	 * Fie team is
	 * dany, didier, gilles
	 * & many thanks to alexis, ghazi, jean-françois
	 */
	public class PageTree extends Tree
	{
		private var _dp:Array;

		/**
		 *
		 */
		public function PageTree()
		{
			super();
			this.minWidth=200;
			labelField="@label";
		}


		override public function set dataProvider(value:Object):void
		{
			super.dataProvider=value;
		}

		/**
		 *
		 * @return
		 */
		public function getSelectedLink():String
		{
			//return selectedItem as Page;
			var url:String=createUrlFromItem();
			return url;
		}

		private var selectedPageIndex:int=-1;

		private function getNodeByLabel(label:String, data:XMLList):XML
		{
			for each (var parentNode:XML in data)
			{
				selectedPageIndex+=1;
				if (parentNode.@label == label)
				{
					return parentNode;
				}
			}
			return null;
		}

		/**
		 * Select a page on the tree
		 * @param p is the path to the page
		 */
		public function setSelectedPage(p:String):void
		{
			if (p != null)
			{
				var items:Array=p.split("/");
				var l:int=items.length;
				var data:XMLList=dataProvider.source;
				var index:int=-1;
				var expandList:Array=[];
				var itemList:XMLList=dataProvider.source;
				var item:XML;
				while (++index < l)
				{
					item=getNodeByLabel(items[index], itemList);
					expandList.push(item);
					itemList=item.children();
				}
				callLater(expandAndSelect, [expandList]);
			}
			else
			{
				selectedIndex=-1
			}

		}

		private function expandAndSelect(expandList:Array):void
		{
			//Where it's length -1 because we don't want to open the selectedPage
			for (var i:int=0; i < expandList.length - 1; i++)
			{
				expandItem(expandList[i], true);
			}
			//due to a bug where multiple Items can be selected if they share the same name
			//we use selectedIndex instead
			//selectedItem = expandList[expandList.length-1];
			selectedIndex=selectedPageIndex;
			selectedPageIndex=-1;
		}

		//Return real URL from a selectedItem
		private function createUrlFromItem():String
		{
			var item:Object=selectedItem;
			var Ar:Array=[selectedItem.@label];
			var parent:Object=getParentItem(selectedItem);
			while (parent != null)
			{
				Ar.unshift(parent.@label);
				item=parent;
				parent=getParentItem(item);
			}
			return Ar.join("/");
		}
	}
}