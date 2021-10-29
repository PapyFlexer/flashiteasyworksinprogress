/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.fieservice.transfer.tr
{
	import flash.net.registerClassAlias;
	
	/**
	 * 
	 * The <code><strong>TransferObject</strong></code> class is the base Object 
	 * that works with amfphp for business logic.
	 * It contains 2 properties :
	 * <ul>
	 * <li><code><strong>code</strong></code> the request sent to amfphp (a protocol string using a <code>fie://...</code> syntax</li>
	 * <li><code><strong>message</strong></code> an optional message</li>
 	 * </ul>
	 */
	public class TransferObject
	{
		/**
		 * 
		 */
		public function TransferObject()
		{
			registerClassAlias("TransferObject", TransferObject) ;
		}
		
		private var _code : int;
		private var _message : String;
		
		/**
		 * The request
		 */
		public function get code() : int
		{
			return _code;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set code( value : int ) : void
		{
			_code = value;
		}

		/**
		 * The message sent by the transfer object
		 */
		public function get message() : String
		{
			return _message;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set message( value : String ) : void
		{
			_message = value;
		}

	}
}