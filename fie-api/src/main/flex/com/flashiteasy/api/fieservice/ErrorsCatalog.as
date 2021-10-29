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
	/**
	 * The <code><strong>ErrorsCatalog</strong></code> defines 
	 * the different errors that can occur
	 * while communicating with the distant service
	 * 
	 */
	public class ErrorsCatalog
	{
		
		
		
		public static var errorsList : Array;
		
		
		/**
		 * 
		 * @default 
		 */
		public static const INVALID_TRANSFERT_OBJECT : String = "INVALID_TRANSFERT_OBJECT";
		/**
		 * 
		 * @default 
		 */
		public static const OBJECT_PROXY_MAPPING_PROBLEM : String = "OBJECT_PROXY_MAPPING_PROBLEM";
		/**
		 * 
		 * @default 
		 */
		public static const NO_EVENT_IN_RESPONDER : String = "NO_EVENT_IN_RESPONDER";
		/**
		 * 
		 * @default 
		 */
		public static const INVALID_HEADER_TRANSFERT_OBJECT : String = "INVALID_HEADER_TRANSFERT_OBJECT";
		/**
		 * 
		 * @default 
		 */
		public static const NO_RESULT_IN_RESPONDER : String = "NO_RESULT_IN_RESPONDER";
		/**
		 * 
		 * @default 
		 */
		public static const NO_HEADER_TRANSFERT_OBJECT : String = "NO_HEADER_TRANSFERT_OBJECT";
		
		public static function addError(errorMessage : String, errorCode : String, errorInitiator : String) : void
		{
			
		}
		
		public static function listErrors( ) : Array
		{
			return ErrorsCatalog.errorsList;	
		}
		
		public static function getLastError() : *
		{
			return ErrorsCatalog.errorsList[ErrorsCatalog.errorsList.length-1];
		}
	}
}