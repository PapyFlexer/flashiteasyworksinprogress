package com.flashiteasy.admin.uicontrol.story.timelinecontainerclasses
{
	
	import com.flashiteasy.admin.utils.FlexComponentsUtils;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Transition;
	
	import flexlib.controls.HSlider;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.DefaultDataDescriptor;

	public class TimelineHierarchicalDataDescriptor extends DefaultDataDescriptor
	{
	
		public function TimelineHierarchicalDataDescriptor()
		{
			super();	
		}
		
		override public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			return node.Children;
		}
		
		override public function hasChildren(node:Object, model:Object=null):Boolean
		{
			return node != null && node.Children != null && (node.Children as ArrayCollection) != null && (node.Children as ArrayCollection).length > 0;
		}
			
		override public function isBranch(node:Object, model:Object=null):Boolean
		{
			return hasChildren(node, model);
		}
		
		override public function getData(node:Object, model:Object=null):Object
		{
			return node as Story;
		}
	}
}
