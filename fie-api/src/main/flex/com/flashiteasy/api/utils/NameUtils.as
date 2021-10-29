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
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	
	/**
	 * The <code><strong>NameUtils</strong></code> class is
	 * an utility class dealing with control names (uuid) on page
	 */
	public class NameUtils
	{
		
		/**
		 * Returns an array of all controls on page uuids
		 * @param page
		 * @return 
		 */
		public static function getAllNames(page :Page ):Array 
		{
			//trace(ElementList.getInstance().getElements(page ).concat(ActionList.getInstance().getActions(page),InvisibleElementList.getInstance().getElements(page))	);
			return ElementList.getInstance().getElementsId(page ).concat(ActionList.getInstance().getActionsId(page));	
		}
		
		/**
		 * Checks if a name (uuid) is unique in the page list
		 * @param name
		 * @param usedNames
		 * @return 
		 */
		public static function findUniqueName(name:String, usedNames:Array):String
		{
			var found:Boolean=false;
			var newName:String;
			for (var i:int = 0; i < usedNames.length; i++)
			{
				var dupli:String =usedNames[i].toString();
				var j:int=0;
				var tempName:String =name;
				if (name == dupli)
				{
					found=true;
					var tempsubstr:String=tempName.substr(-1, 1);
					var tempsubstr2:String=tempName.substr(-2, 2);
					var howMuch:int = 0;
					var newval:int = 1;
					if (!isNaN(Number(tempsubstr)))
					{
						howMuch=1;
						newval=Number(tempsubstr) + 1;
						if (!isNaN(Number(tempsubstr2)))
						{
							howMuch=2;
							newval=Number(tempsubstr2) + 1;
						}
					}
					var tempstring:String=tempName.substr(0, tempName.length - howMuch);
					newName=tempstring + newval;
					break;
				}
			}
			if (found)
			{
				newName=findUniqueName(newName, usedNames);
			}
			if (!found)
			{
				newName=name;
			}
			
			return newName;
		}

	}
}