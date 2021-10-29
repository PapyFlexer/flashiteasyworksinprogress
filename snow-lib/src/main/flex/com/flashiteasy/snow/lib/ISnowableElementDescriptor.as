/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.snow.lib
{

	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	public interface ISnowableElementDescriptor extends IUIElementDescriptor
	{
		function setSnowStorm( quantity : Number, color : uint, useMouseForWind : Boolean ) : void; 
	}
}
