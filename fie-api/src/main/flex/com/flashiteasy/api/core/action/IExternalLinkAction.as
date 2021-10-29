/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.action
{
	/**
	 * The <code><strong>IExternalLinkAction</strong></code> interface defines external link actions
	 */
	public interface IExternalLinkAction
	{
		function setLinkAndTarget( link : String, target : String ) : void;
	}
}