/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.fieservice
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * The <code><strong>FieError</strong></code> defines 
	 * how errors are treated and managed. It takes a string
	 * and can hold an Object for 
	 * convenient behaviours.
	 */
	public class FieError extends EventDispatcher
	{
		
		private var _errorString:String;
		private var _errorData:Object;
		
		
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		 public override function toString():String
		{
			return "";
			//return formatToString("FieErrorEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		} 
		
		// getters & setters
		/**
		 * 
		 * @return 
		 */
		public function get errorData() : Object
		{
			return _errorData;
		}

		/**
		 * 
		 * @param value
		 */
		public function set errorData( value : Object) : void
		{
			_errorData = value;
		}

		/**
		 * 
		 * @return 
		 */
		public function get errorString() : String
		{
			return _errorString;
		}

		/**
		 * 
		 * @param value
		 */
		public function set errorString( value : String) : void
		{
			_errorString = value;
		}
		
		

	}
}