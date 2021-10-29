/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.container
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IAlignElementDescriptor;
	import com.flashiteasy.api.core.elements.IResizeFromChildrenElementDescriptor;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.DisplayListUtils;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	// 

	/**
	 * The <code><strong>MultipleUIElementDescriptor</strong></code>is the base (abstract-like) Container control. It defines all containers - controls that include a list of other controls - default methods ( child layout , loading, etc.).
	 * <p>It extends the <code>SimpleUIElementDescriptor</code> class, which is the abtract-like class describing all visual controls.</p>
	 * 
	 */
	public class MultipleUIElementDescriptor extends SimpleUIElementDescriptor implements  IUIElementContainer, IResizeFromChildrenElementDescriptor
	{
		/**
		 * 
		 * @default String
		 */
		protected var overflow:String;
		/**
		 * This variable contains the list of non-loaded yet Container's children.
		 * @default  
		 */
		protected var waiting_child:Array=[]; // liste des enfants non chargé

		/**
		 * contains the list of all Container's children
		 * @default 
		 */
		protected var child_list:Array=[]; // liste de tout les enfants
		protected var count_load:int=0; // Compte le nombre de control pret a etre affiché dans le container

		

		/**
		 * The Container can have a padding. This var manages the Container's top-padding
		 * @default : 0;
		 */
		protected var paddingTop:Number;

		/**
		 * The Container can have a padding. This var manages the Container's right-padding
		 * @default : 0;
		 */
		protected var paddingRight:Number;

		/**
		 * The Container can have a padding. This var manages the Container's left-padding
		 * @default : 0;
		 */
		protected var paddingLeft:Number;

		/**
		 * The Container can have a padding. This var manages the Container's bottom-padding
		 * @default : 0;
		 */
		protected var paddingBottom:Number;

		// resize 
		
		private var originalWidth : Number ;
		private var originalHeight : Number ;
		/**
		 * 
		 * @default 
		 */
		public var resizable : Boolean = false ;
		

		// =============== CREATION =======================

		override protected function initControl():void
		{
			if (super.parentBlock == null)
			{
				parentContainer=AbstractBootstrap.getInstance();
				if (!face.hasEventListener(Event.RESIZE))
				//if ( !hasEventListener(FieEvent.CONTAINER_INCREASE) )
				{
					
					//addEventListener(FieEvent.CONTAINER_INCREASE, resizeBrowser);
					face.addEventListener(Event.RESIZE, resizeBrowser);
				}
			}
		}



		// =========== AJOUT D ELEMENT DANS LE BLOC ================

		/**
		 * The <code>layoutElement</code> method manages the adjunction of a new child in the container.
		 * @param elementDescriptor, the control (represented by its descriptor class, cf. IoC pattern)
		 */
		public function layoutElement(elementDescriptor:IUIElementDescriptor):void
		{
			elementDescriptor.setParent(this);
			child_list.push(elementDescriptor);

			if (this.isLoaded())
			{
				displayElement(elementDescriptor);
			}
			else
			{
				if (!elementDescriptor.isLoaded())
					waiting_child.push(elementDescriptor);
			}
		}

		/**
		 * The <code>swapChildAt</code> method manages the swapping of a child, at a given index
		 * @param elementDescriptor
		 * @param index
		 */
		public function swapChildAt(elementDescriptor:IUIElementDescriptor, index:int):void
		{
			var startIndex:int=ArrayUtils.getIndex(child_list, elementDescriptor);
			if (startIndex != -1)
			{
				child_list.splice(startIndex, 1);
				child_list.splice(index, 0, elementDescriptor);
			}
			if (index < child_list.length - 1)
			{
				getFace().addChildAt(elementDescriptor.getFace(), index);
			}
			else
			{
				getFace().addChild(elementDescriptor.getFace());
			}
			// Put backgroundImage always behind
			if (index == 0)
			{
				if (this.BackgroundImageLoader != null)
				{
					face.addChildAt(BackgroundImageLoader, 0);
				}
			}
		}

		/**
		 * Returns the child index of a control, based on its descriptor class interface (IUIElementDescriptor)
		 * @param el
		 * @return 
		 */
		public function getChildIndex(el:IUIElementDescriptor):int
		{
			var i:int=0;
			for (i=0; i < child_list.length; i++)
			{
				if (child_list[i] == el)
				{
					return i;
				}
			}
			return -1;
		}

		// for each children of the container , list the increase in width due to overflow

		private var widthIncreaseList:Dictionary=new Dictionary(true);
		private var heightIncreaseList:Dictionary=new Dictionary(true);

		public function checkOverflow(element:IUIElementDescriptor):void
		{
			var increaseWidth : Number  =  calculateWidthOverflow(element);
			var increaseHeight : Number =  calculateHeightOverflow(element);
			widthIncreaseList[element] = increaseWidth;
			heightIncreaseList[element] = increaseHeight;
			resizeFromOverflow();
		}

		private function childResized(e:Event):void
		{
			var element:IUIElementDescriptor=e.target as IUIElementDescriptor;
			checkOverflow(element);
			onChildResized(element);
		}

		private var overflowHeight:Number=0;
		private var overflowWidth:Number=0;

		private function resizeFromOverflow():void
		{
			var maxWidthIncrease : Number = 0 ;
			var maxHeightIncrease : Number = 0 ;
			var length : int = 0;
			for each( var value : Number in widthIncreaseList )
			{
				length ++;
				if( value > maxWidthIncrease )
				{
					maxWidthIncrease = value ;
				}
			}
			for each ( var value2 : Number in heightIncreaseList )
			{
				if( value2 > maxHeightIncrease )
				{
					maxHeightIncrease = value2 ;
				}
			}
			var actualH:Number = h;
			var actualW:Number = w;
			w = originalWidth + maxWidthIncrease;
			h = originalHeight + maxHeightIncrease;
			overflowHeight = maxHeightIncrease;
			overflowWidth = maxWidthIncrease;
			if(actualW != w || actualH != h)
			{
				sizeChanged=true;
				initSize(true);
			}
		}

		// Function called when one child change its size
		
		/**
		 * Not used yet.
		 * @param el
		 */
		protected function onChildResized( el : IUIElementDescriptor ):void
		{

		}

		private function calculateWidthOverflow(element:IUIElementDescriptor):Number
		{
			var bounds:Rectangle=DisplayListUtils.getRealBounds(element.getFace(), face);
			var rightPoint:Number=Math.round(bounds.right);
			var widthIncrease:Number=0;
			var alignRight:Boolean = false;
			if ( element is IAlignElementDescriptor )
			{
				alignRight = IAlignElementDescriptor(element).h_align == "right";
			}

			if (!element.percentWidth && !element.percentX && !alignRight)
			{
				// Check if element is overflowing right

				if (rightPoint > originalWidth)
				{
					// Increase the width of the container
					if (_isPercentW)
					{
						widthIncrease=(rightPoint - width) * w / width;
					}
					else
					{
						widthIncrease=rightPoint - originalWidth;
					}
				}
			}

			return widthIncrease;// > 0 ? widthIncrease : 0;
		}

		private function calculateHeightOverflow(element:IUIElementDescriptor):Number
		{
			var bounds:Rectangle=DisplayListUtils.getRealBounds(element.getFace(), face);
			var bottomPoint:Number=Math.round(bounds.bottom);
			var heightIncrease:Number=0;
			var alignBottom:Boolean = false;
			if ( element is IAlignElementDescriptor )
			{
				alignBottom = IAlignElementDescriptor(element).v_align == "bottom" ? true : false;
			}
			if (!element.percentHeight && !element.percentY && !alignBottom)
			{

				// overflow bottom 

				if (bottomPoint > originalHeight)
				{
					if (_isPercentH)
					{
						heightIncrease=(bottomPoint - height) * h / height;
					}
					else
					{
						heightIncrease=(bottomPoint - originalHeight);
					}
				}
			}

			return heightIncrease;// > 0 ? heightIncrease : 0;;
		}

		// Resize the container to prevent children overflow

		private var resizingChildren:Array=[];


		// ================== PARAMETRES ====================================
		
		/**
		 * The <code>resizeFromChildren</code> represents the Container's ability to be resized by one or more of its children
		 * getting over the container limits (overflow). When this method is applied with a <code>true</code> argument, the container gets automatically 
		 * resized should one of its children overflows the container bounding box.
		 * @param enable
		 */
		public function resizeFromChildren( enable : Boolean ) : void 
		{
			if (enable != resizable)
			{
				this.resizable=enable;
				var block:IUIElementDescriptor;
				for each (block in child_list)
				{
					block.removeEventListener(FieEvent.RESIZE, childResized);
					block.removeEventListener(FieEvent.MOVED, childResized);
				}
				if (enable)
				{
					for each (block in child_list)
					{
						if (!block.hasEventListener(FieEvent.MOVED))
							block.addEventListener(FieEvent.MOVED, childResized, false, 0, true);
						if (!block.hasEventListener(FieEvent.RESIZE))
							block.addEventListener(FieEvent.RESIZE, childResized, false, 0, true);
						if (isLoaded())
						{
							checkOverflow(block);
						}
					}
				}
				else
				{
					applyParameters();
				}

			}
		}

		override protected function drawContent():void
		{
			if (!isLoaded())
			{
				loadChildren(); // Commence le chargement des child
			}
		}


		// ============= FONCTIONS SPECIFIQUES AU CONTAINER ======


		/**
		 * Gets the container depth in its parent displaylist.
		 * @return 
		 */
		public function getContainerDepth():int
		{
			var depth:int;
			if (getParent() == null)
			{
				return 0;
			}
			else
			{
				return getParent().getContainerDepth() + 1;
			}
		}


		/**
		 * Lists all the container's children
		 * @return 
		 */
		public function getChildren(recursive:Boolean = false):Array
		{
			var children:Array = child_list.slice(0);
			if(recursive)
			{
				for each (var element:IUIElementDescriptor in children)
				{
					if(element is IUIElementContainer)
					{
						children = children.concat(IUIElementContainer(element).getChildren(recursive));
					}
				}
			}
			return children;
		}

		// Retire un child du block

		/**
		 * removes a given child from the container based on its descriptor
		 * @param el : the child to be removed element descriptor
		 * @param destroy : True, a boolean value that states if the child must me made GC-ready. It is by default set to <code>true</code>, except for copy/paste operations where the instance must be recorded in a virtual clipboard. 
		 */
		public function removeChild(el:IUIElementDescriptor, destroy:Boolean=false):void
		{
			arrayRemove(el, destroy);
			el.setParent(null);
			onChildRemoved(el);
		}

		// Function called when one child is removed from the container 
		
		/**
		 * 
		 * @param el
		 */
		protected function onChildRemoved( el : IUIElementDescriptor ):void
		{

		}

		// retire le child des arrays

		private function arrayRemove(el:IUIElementDescriptor, destroy:Boolean=false):void
		{
			var i:int;
			for (i=0; i < child_list.length; i++)
			{

				if (child_list[i] == el)
				{
					if (destroy)
						child_list[i].destroy();
					child_list.splice(i, 1);
					break;
				}
			}
			for (i=0; i < waiting_child.length; i++)
			{

				if (waiting_child[i] == el)
				{
					waiting_child.splice(i, 1);
					return;
				}
			}
		}

		/**
		 * Empties the container of its children.
		 */
		public function deleteChildren():void
		{
			while (child_list.length != 0)
			{
				var element:IUIElementDescriptor = child_list.pop();
				
				delete widthIncreaseList[element];
				delete heightIncreaseList[element];
				element.destroy();
			}
		}

		/**
		 * Returns the container's number of children
		 * @return 
		 */
		public function length():int
		{
			return child_list.length;
		}

		// Proprietés en lecture

		/**
		 * 
		 * @return 
		 */
		public function get padding_top():int
		{
			return paddingTop;
		}

		/**
		 * 
		 * @return 
		 */
		public function get padding_bottom():int
		{
			return paddingBottom;
		}

		/**
		 * 
		 * @return 
		 */
		public function get padding_left():int
		{
			return paddingLeft;
		}

		/**
		 * 
		 * @return 
		 */
		public function get padding_right():int
		{
			return paddingRight;
		}

		// ============ GESTION DE L AFFICHAGE ======================

		// Compte le nombre de blocs charges

		/**
		 * The <code>blockLoaded</code> method is fired when all the container's children have been loaded.
		 * @param e
		 */
		protected function blockLoaded(e:Event):void
		{
			count_load++;
			if (count_load == waiting_child.length)
			{
				layoutElements();
			}
		}

		// function loading all children : apply all childrens parameters 
		// and wait for their complete before displaying the container

		private function loadChildren():void
		{
			var block:IUIElementDescriptor;
			// if the container has children to load , add listeners
			if (waiting_child.length > 0)
			{
				// if we are not waiting for children to complete , display them even if they are not ready
				if (waitComplete == false)
				{
					layoutElements();
				}
				else
				{
					for each (block in waiting_child)
					{
						// ADD a listener to count loaded children
						block.addEventListener(FieEvent.COMPLETE, blockLoaded, false, 0, true);

						// usually not needed , trick to display cloned containers  .see clone method in simpleUI 
						block.setPage(getPage());

					}
				}

			}
			// if the container has no child to load or no children at all , then it is ready
			else
			{
				layoutElements();
				end(); // container is ready
			}
			refreshChildren();
		}

		private var avoidInfiniteLoop:Boolean=false;

		protected override function onSizeChanged():void
		{
			originalWidth=getSizeParameter()[0];
			originalHeight=getSizeParameter()[1];
			
			if (isLoaded())
			{
				if (!avoidInfiniteLoop)
				{
					refreshChildren(true);
				}
			}
			//dispatchEvent(new Event(FieEvent.CONTAINER_RESIZE));
		}

		private function getSizeParameter():Array
		{

			var realW:Number;
			var realH:Number;
			var params:Array=CompositeParameterSet(this.getParameterSet()).getParametersSet();
			for each (var p:IParameterSet in params)
			{
				if (p is SizeParameterSet)
				{
					realW=SizeParameterSet(p).width;
					realH=SizeParameterSet(p).height;
					break;
				}
			}
			return [realW, realH];
		}

		// Apply children parameters

		
		/**
		 *The <code>refreshChildren</code> method is used to refresh the container content, cycling through its children.
		 */
		protected function refreshChildren( justInvalidate : Boolean = false ):void
		{
			avoidInfiniteLoop = true ;
			var block : IUIElementDescriptor;
			for each (block in child_list)
			{
				if( justInvalidate )
				{
					block.invalidate();
				}
				else
				{
					block.applyParameters();
				}
				if(resizable)
				{
					// Children don t overflow the container in that case . The function is called to update 
					// the widthIncreaseList and HeightIncreaseList
					checkOverflow(block);
				}
			}
			avoidInfiniteLoop = false ;
		}

		// function called when all children of a container are ready 
		// display children in the container

		/**
		 * The <code>layoutElements</code> method is called when all the container's children are ready to be rendered
		 */
		protected function layoutElements():void
		{
			var block:IUIElementDescriptor;

			for each (block in child_list)
			{
				block.removeEventListener(FieEvent.COMPLETE, blockLoaded);
				displayElement(block);
			}
			waiting_child=[];
			end();
		}

		protected override function drawBorder():void
		{
			super.drawBorder();
			face.addChildAt(borderComponent,0);
		}
		protected override function end():void
		{
			if(!isLoaded())
			{
				refreshChildren(true);
			}
			super.end();
		}
		// Function used to display a visual element 

		private function displayElement(el:IUIElementDescriptor):void
		{

			// remove a child from child_list when a child is destroyed
			el.addEventListener(FieEvent.REMOVED, deleteBlock, false, 0, true);
			// Display the control 
			layoutControl(el);

			widthIncreaseList[el]=0;
			heightIncreaseList[el]=0;
			if (resizable)
			{
				if (!el.hasEventListener(FieEvent.RESIZE))
					el.addEventListener(FieEvent.RESIZE, childResized, false, 0, true);

				if (!el.hasEventListener(FieEvent.MOVED))
					el.addEventListener(FieEvent.MOVED, childResized, false, 0, true);
				if (isLoaded())
				{
					checkOverflow(el);
					if(!el.hasEventListener(FieEvent.RESIZE))
						el.addEventListener(FieEvent.RESIZE, childResized ,false , 0 , true );
					
					if(!el.hasEventListener(FieEvent.MOVED))
						el.addEventListener(FieEvent.MOVED , childResized , false , 0 , true );
					if(isLoaded() || el.isLoaded())
					{
						checkOverflow(el);
					}
				}
			}
		}

		// container with special layout must override this function
		
		/**
		 * The <code>layoutControl</code> method manages a container's given child placement. As this class is mostly an abstract, all containers with automatic placement are overriding this method.
		 * @param el
		 */
		protected function layoutControl( el : IUIElementDescriptor ) : void 
		{
			face.addChild(el.getFace());
		}

		public override function getDescriptorType():Class
		{
			return MultipleUIElementDescriptor;
		}

		private var isBeeingDestroyed:Boolean=false;

		public override function destroy():void
		{
			isBeeingDestroyed=true;
			deleteChildren();
			if (face != null)
			{
				face.removeEventListener(Event.RESIZE, resizeBrowser);
			}
			removeEventListener(FieEvent.CONTAINER_INCREASE, resizeBrowser);
			super.destroy();
		}

		/**
		 * Deletes a block and premares it to be garbage-collected.
		 * @param e : the Event fired when desctuction is called.
		 */
		protected function deleteBlock(e:Event):void
		{
			removeChild(e.target as IUIElementDescriptor, false);
			if (resizable)
			{
				delete widthIncreaseList[e.target];
				delete heightIncreaseList[e.target];
				if (!isBeeingDestroyed)
				{
					resizeFromOverflow();
				}
			}
			e.target.removeEventListener(FieEvent.REMOVED, deleteBlock);
			e.target.removeEventListener(FieEvent.RESIZE, childResized);
			e.target.removeEventListener(FieEvent.MOVED, childResized);

		}


		override public function clone(sameId:Boolean=false):IUIElementDescriptor
		{
			var control:IUIElementContainer=super.clone(sameId) as IUIElementContainer;
			if(!(this is XmlElementDescriptor) && !(this is DynamicListElementDescriptor))
			{
				for each (var child:IUIElementDescriptor in child_list)
				{
					control.layoutElement(child.clone(sameId));
				}
			}
			return control;

		}

	}
}
