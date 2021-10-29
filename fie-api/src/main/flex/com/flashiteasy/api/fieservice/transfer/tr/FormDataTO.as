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
	import flash.net.URLVariables;

	/**
	 * The <code><strong>FormDataTO</strong></code> class extends the base TO
	 * and is specifically charged of form elements sending
	 */
	public class FormDataTO extends TransferObject
	{
		/**
		 * Constructor
		 */
		public function FormDataTO()
		{
			super();
		}
		
		/**
		 * The path to the php page that will treat the form content
		 * @default 
		 */
		public var phpFilePath:String;
		
		/**
		 * The form data
		 * @default 
		 */
		public var formData:Object;
		/**
		 * A boolean that states id the form has been correctly sent.
		 * @default 
		 */
		public var success:Boolean
		
	}
}