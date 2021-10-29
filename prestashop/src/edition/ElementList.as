/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package edition
{

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
		
		private var elements:Dictionary=new Dictionary();


		/**
		 * Adds an element to ElementList
		 * @param element
		 * @param page
		 */
		public function addElement(element:DisplayObject, name:String ):void
		{
			elements[name] = element;
		}
		
		/**
		 * Initializes the dictionaries
		 */
		public function reset() : void
		{
			elements=new Dictionary(true);
			instance = null;
			delete this;
		}
		
		public function length():int
		{
			return elements.length;
		}
		
		public function contains( d : DisplayObject ) : Boolean
		{

			for each(var k in elements)
			{
				if (k == d)
				{
					trace("found");
					return true;
				}
			}
			return false;
		}

		public function getElement(name : String):DisplayObject
		{
			if(name == null || name  == "")
			{
				return null;
			}

			for (var k:* in elements)
			{
				if (k == name)
				{
					return elements[k];
				}
			}
			return null;
		}
		

	
		
		/**
		 * Return an array of the elements uuids.
		 */
		public function getElementList() : Array
		{
			var i:int;
			var names:Array = new Array();
			for (var key:* in elements) names.push(key);
			return names;
		}

		public function removeElementById(name:String):void
		{
			var i:int;
			for (var k:* in elements)
			{
				if(k == name)
				{
					delete elements[k];
					return;
				}
			}
		}
	}
}

