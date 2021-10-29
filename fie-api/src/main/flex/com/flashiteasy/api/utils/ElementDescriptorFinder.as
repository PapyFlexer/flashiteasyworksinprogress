/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import com.flashiteasy.api.bootstrap.AbstractBootstrap;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.PageList;
	import com.flashiteasy.api.selection.ElementList;
	
	import flash.display.DisplayObject;
	
	/**
	 * The <code><strong>ElementDescriptorFinder</strong></code> class is
	 * an utility class dealing with Descriptors. It's an Utility 
	 * used to browse a display object hierarchy in order 
	 * to find the corresponding element descriptor.
	 */
	public class ElementDescriptorFinder
	{
		/**
		 * Finds a Descriptor in a DO on stage
		 * @param item
		 * @param page
		 * @return 
		 */
		public static function findUIElementDescriptor( item : DisplayObject , page : PageList) : IUIElementDescriptor
		{
			var descriptor : IUIElementDescriptor;
			
			if( item == null )
			{
				//trace("Face is not a display object, returning a null value.");
				return null;
			}
			if( item is FieUIComponent ) 
			{
				for each(  descriptor in ElementList.getInstance().getElements( page ) )
				{
					if( descriptor.getFace() == item )
					{
						return descriptor;
					}
				}
				//trace("parentFace :: "+findUIElementDescriptor( item.parent ,page ));
				return null;
			}
			else
			{
				// Level-up into the hierarchy, the item may be a child of the element
				// descriptor
				if( item.parent is AbstractBootstrap )
				{
					return null;
				}
				return findUIElementDescriptor( item.parent ,page );
			}
			
		}
	}
}