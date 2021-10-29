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
	public class AbstractApiError extends Error implements IApiError
	{
        internal static const WARNING:int = 0;
        internal static const FATAL:int = 1;
        public var id:int;
        public var severity:int;
        private static var messages:XML;
        
		public function AbstractApiError()
		{
			messages = 	<errors>
							<error code="1000"><![CDATA[Animations must have valid targets. Please select one or more in Target List.)+]]></error>
							<error code="1001"><![CDATA[Actions must have valid targets. Please select one or more in Target List.]]></error>
							<error code="1002"><![CDATA[Actions must have valid trigger. Please select one in Trigger List.]]></error>
						</errors>;
        }
        
        public function getApiErrorMessages(id:int):String {
            var message:XMLList = messages.error.(@code == id);
            return message[0].text();
        }
        
        public function getTitle():String {
            return "API Error #" + id;
        }
           
        public function toString():String {
            return "[API ERROR #" + id + "] " + message;
        }
        
    }
}
