/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.selection
{
	import com.flashiteasy.api.container.DynamicListElementDescriptor;
	import com.flashiteasy.api.container.XmlElementDescriptor;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.ElementDescriptorFinder;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * The <code><strong>ElementList</strong></code> class is the
	 * pseudo-singleton class that manages and keeps track of 
	 * all the controls of a given page.  
	 */
	public class ElementList
	{
		private static var instance : ElementList;
		/**
		 * 
		 * singleton implementation 
		 */
		protected static var allowInstantiation : Boolean = false;
		
		
		/**
		 * Constructor singleton
		 */
		public function ElementList()
		{
			if( !allowInstantiation )
			{
				throw new Error("Instance creation not allowed, please use singleton method.");
			}
		}
		
		/**
		 * Singleton implementation
		 * @return a single ActionList instance
		 */
		public static function getInstance() : ElementList
		{
			if( instance == null )
			{
				allowInstantiation = true;
				instance = new ElementList();
				allowInstantiation = false;
			}
			return instance;
		}
		
		
		/**
		 * A Dictionary holding the page's controls implementing SimpleUIElementDescriptor
		 * @default 
		 */
		protected var elements:Dictionary=new Dictionary(true);
		/**
		 * A Dictionary holding the page's controls implementing MultipleUIElementDescriptor (containers)
		 * @default 
		 */
		protected var containers:Dictionary=new Dictionary(true);

		/**
		 * Adds an element to ElementList
		 * @param element
		 * @param page
		 */
		public function addElement(element:IDescriptor , page : Page ):void
		{
			if( elements [ page ] == null )
			{
				elements [ page ] = new Array();
			}
			elements[page].push(element);
			if(element is IUIElementContainer){
				addContainer(element.uuid,page);
			}
		}
		
		/**
		 * Initializes the dictionaries
		 */
		public function reset() : void
		{
			elements=new Dictionary(true);
			containers=new Dictionary(true);
			instance = null;
			delete this;
		}
		
		private function addContainer(id:String,page:Page):void
		{
			if( containers [ page ] == null )
			{
				containers [ page ] = new Array();
			}
			containers[page].push(id);
		}

		/**
		 * Lists elements
		 * @return the number of actions loaded in page
		 */
		public function length():int
		{
			return elements.length;
		}

		/**
		 * Gets a IUIDescriptor control from the ElementList
		 * @param uuid
		 * @param page
		 * @return IUIElementDescriptor or null
		 */
		public function getElement(uuid:String,page:PageList):IUIElementDescriptor
		{
			if(uuid == null || uuid == "")
			{
				return null;
			}
			var el:IUIElementDescriptor;
			var pageElements : Array = elements[page];
			for each(el in pageElements)
			{
				if (el.uuid == uuid)
				{
					return el;
				}
			}
			return null;
		}
		
		/**
		 * Gets the list of parent elements
		 * @param element
		 * @param page
		 * @param parentList
		 * @return 
		 */
		public function getElementParenList(element:IUIElementDescriptor,page:PageList, parentList:Array = null):Array
		{
			parentList = parentList == null ? [] : parentList;
			if(element == null)
			{
				return null;
			}
			var parent:IUIElementDescriptor = element.getParent();
			if( parent != null)
			{
				parentList.push(parent);
				getElementParenList(parent, page , parentList);
			}
			return parentList;
		}
		
		/**
		 * Send element to back
		 * @param el
		 */
		public function moveElementOnStageToRear(el:IUIElementDescriptor):void
		{
			var elements : Array = elements[el.getPage()];
			var index:int = ArrayUtils.getIndex(elements , el ) ;
			elements.splice(index,1);
			elements.unshift(el);
		}
		
		/**
		 * Bring element to front
		 * @param el
		 */
		public function moveElementOnStageToFront(el:IUIElementDescriptor):void
		{
			var elements : Array = elements[el.getPage()];
			var index:int = ArrayUtils.getIndex(elements , el ) ;
			elements.splice(index,1);
			elements.push(el);
		}
		
		/**
		 * Move element to given index
		 * @param el
		 * @param index
		 */
		public function moveElementOnStageToIndex( el:IUIElementDescriptor , index : int ):void
		{
			var elements : Array = elements[el.getPage()];
			var elementsOnStage : Array = getElementOnStage( el.getPage() ) ;
			
			if(index <= 0 ) 
			{
				moveElementOnStageToRear(el);
			}
			else if( index >= elementsOnStage.length ) 
			{
				moveElementOnStageToFront(el);
			}
			else
			{
				var elementAtIndex : IUIElementDescriptor = elementsOnStage[index];
				var finalIndex : int = ArrayUtils.getIndex(elements , elementAtIndex ) ;
				var startIndex : int = ArrayUtils.getIndex(elements , el ) ;
				elements.splice(startIndex,1);
				elements.splice(finalIndex , 0 , el );
			}
		}
		
		/**
		 * Utility method : returns all the containers in the page
		 * @param page
		 * @return array
		 */
		public function getContainerList(page:PageList) : Array 
		{
			return containers[page];
		}
		
		/**
		 * Return an array of the elements.
		 */
		public function getElements(page:PageList) : Array
		{
			if( elements [ page ] == null )
			{
				elements [ page ] = new Array();
			}
			// Create a copy of the array
			return elements[page].slice(0);
		}
		
		/**
		 * Utility method : returns all the elements uuids
		 */
		public function getElementsAsString( page : PageList) : Array
		{
			var array : Array = []
			var element : IUIElementDescriptor;
			for each ( element in getElements(page) )
			{
				array.push( element.uuid );
			}
			return array;
		}
		
		/**
		 * Empties the ElementList
		 * @param page
		 */
		public function purgeElements(page:PageList):void
		{
			if( elements [ page ] != null )
			{
				delete elements [ page ] ;
				elements [ page ] = new Array();
				delete containers[page];
			}
		}
		
		
		/**
		 * Return an array of the elements uuids.
		 */
		public function getElementsId(page:PageList) : Array
		{
			var i:int;
			var elId:Array = new Array();
			var pageElements : Array = getElements(page);
			for(i=0; i < pageElements.length; i++)
			{

				elId.push(pageElements[i].uuid);
				
			}
			return elId;
		}
		
		/**
		 * Unserializes elements. Used in copy/paste commands
		 * @param page
		 * @return an XML describing the element
		 */
		public function getXML(page:Page): XML
		{

			var pageNode:String="<root>";
			var elem : Array = getTopLevelElements(page);
			/*
			Change the presentation order on the tree
			to have the higher element on top
			*/
			//for (var i : int = 0 ; i < elem.length ; i++ ) //uncoment this ligne and comment the next to get the lower on top
			for (var i : int = elem.length-1 ; i > -1 ; i-- )
			{
				pageNode+=getElementNode(elem[i],page);
			}
			pageNode+="</root>";
			return new XML(pageNode);
			
		}
		
		private function getElementNode( el : * , page:PageList) : String 
		{
			var descriptor:IUIElementDescriptor ;
			if(el is DisplayObject)
			{
				descriptor =  ElementDescriptorFinder.findUIElementDescriptor(el,page);
			}
			else
			{
				descriptor = el as IUIElementDescriptor;
			}
			if(descriptor is IUIElementContainer)
			{
				var children:Array = IUIElementContainer(descriptor).getChildren();
				var pageNode:String="";
				if(children.length > 0  && !(descriptor is XmlElementDescriptor)  && !(descriptor is DynamicListElementDescriptor) )
				{
					var child:IUIElementDescriptor;
					pageNode ="<node isBranch='true' label='"+descriptor.uuid+"' type='"+descriptor.getDescriptorType()+"' >";
					/*
					Change the presentation order on the tree
					to have the higher element on top
					*/
					//for each(child in children) //uncoment this ligne and comment the next to get the lower on top
					for (var i:int= children.length-1; i>-1 ; i--)
					{
						//pageNode+=getElementNode(child , page ); //uncoment and comment the next this ligne to get the lower on top
						pageNode+=getElementNode(children[i] , page );
					}
					pageNode +="</node>";
					return pageNode;
				}
				else
				{
					return "<node isBranch='true' label='"+descriptor.uuid+"' type='"+descriptor.getDescriptorType()+"' />"
				}
				
			}
			else
			{
				if(descriptor is IUIElementDescriptor)
				return "<node label='"+descriptor.uuid+"' type='"+descriptor.getDescriptorType()+"' />";
			}
			return "";
		}
		
		/**
		 * Concatenates a global Array of controls from the cascade of pages' ElementLists on stage
		 * @param page
		 * @return 
		 */
		public function getElementOnStage(page:PageList):Array 
		{
			var i:int;
			var elem:Array= [];
			var pageElements : Array = getElements(page);
			for(i=0; i < pageElements.length; i++)
			{

				if (pageElements[i].getParent() == null)
				{
					elem.push(pageElements[i]);
				}
			}
			return elem;
		}

		/**
		 * Returns the ElementList of highest depth on Stage
		 * @param page
		 * @return 
		 */
		public function getTopLevelElements(page:Page):Array
		{
			if(page.container == "" || page.container=="stage")
			{
				return getElementOnStage(page);
			}
			else
			{
				var i:int;
				var elem:Array= [];
				var pageElements : Array = getElements(page);
				for(i=0; i < pageElements.length; i++)
				{				
					if(!IUIElementDescriptor(pageElements[i]).hasParent())
					{
						elem.push(pageElements[i]);
					}
					else if (IUIElementDescriptor(pageElements[i]).getParent().uuid == page.container)
					{
						elem.push(pageElements[i]);
					}
				}
				return elem;
			}
		}
	
		/**
		 * Removes a control from the ElementList, based on its Descriptor
		 * @param el
		 * @param page
		 */
		public function removeElement(el:IUIElementDescriptor,page:Page):void
		{
			var i:int;
			var pageElements:Array = elements[page]
			label1 : for(i=0; i < pageElements.length; i++)
			{

				if (pageElements[i]== el)
				{
					pageElements.splice(i, 1);
					break label1 ;
				}
			}
			if(el is IUIElementContainer)
			{
				pageElements = containers[page]
				label2: for(i=0; i < pageElements.length; i++)
				{
	
					if (pageElements[i]== el.uuid)
					{
						pageElements.splice(i, 1);
						break label2;
					}
				}
			}
		}
		/**
		 * Removes the control whose uuid is passed from the ElementList
		 * @param uuid
		 * @param page
		 */
		public function removeElementById(uuid:String,page:PageList):void
		{
			var i:int;
			var pageElements:Array = elements[page]
			for(i=0; i < pageElements.length; i++)
			{

				if (pageElements[i].uuid == uuid)
				{
					pageElements.splice(i, 1);
					return ;
				}
			}
			trace("Could not delete element with ID : " + uuid);
		}

		/**
		 * Utility method : express the elementList as a String separated by '+'
		 * @return 
		 */
		public function toString():String
		{
			var s:String="";
			var i:int;
			for(i=0; i < elements.length; i++)
			{
				s+=elements[i].uuid + " + ";
			}
			return s;
		}

	}
}

