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
	/**
	* The <code><strong>FormDataTO</strong></code> class extends the base TO
	* to get the distant parameterList
	*/
	public class RemoteParameterListTO extends TransferObject
	{
		/**
		 * Constructor
		 */
		public function RemoteParameterListTO()
		{
			super();
		}

		private var _remoteParameterList : Array;
		
		/**
		 * An array of distant parameters
		 */
		public function get remoteParameterList() : Array
		{
			return _remoteParameterList;
		}
		
		/**
		 * 
		 * @private
		 */
		public function set remoteParameterList( value : Array ) : void
		{
			_remoteParameterList = value;
		}
		
	}
}