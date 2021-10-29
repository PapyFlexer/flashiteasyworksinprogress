/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.errors
{
	public class WarningApiError extends AbstractApiError
	{
		public function WarningApiError( errorID : int )
		{
			id = errorID;
			severity = AbstractApiError.FATAL
			message = getApiErrorMessages( errorID );
		}

		public override function getTitle():String {
			return "Error #" + id + " -- Warning";
		}
		
		public override function toString():String {
			return "[WARNING ERROR #" + id + "] " + message;
		}
		
	}
}