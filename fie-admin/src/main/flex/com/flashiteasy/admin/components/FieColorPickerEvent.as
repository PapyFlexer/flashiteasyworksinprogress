/**
this file is part of FLASHITEASY
FLASHITEASY FlashContentManagement - see http://code.google.com/p/flashiteasy/
FLASHITEASY is (c) 2004-2008 Didier Reyt / Gilles Roquefeuil and is released under the GPL License:
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License (GPL)
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
To read the license please visit http://www.gnu.org/copyleft/gpl.html
 */
	
/**
 * Name : FieColorPickerEvent
 * Package : fie.admin.components
 * Version : 1.0
 * Date :  19 sept. 08
 * Author : Gilles Roquefeuil / Didier Reyt
 * URL : http://www.flashiteasy.com/
 * Mail : gr@flashiteasy.com
 * Mail : dr@flashiteasy.com
 */

package fie.admin.components {
	import flash.events.Event;
	
	/**
	 * @author didierreyt
	 */
	public class FieColorPickerEvent extends Event {
		public static const NOCOLOR:String = "noColor";
		public function FieColorPickerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
