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
	 * @private
	 * The <code><strong>IChangeParameterAction</strong></code> interface defines methods shared by all ChangeParameters Actions
	 */
	import com.flashiteasy.api.core.IDescriptor;
	
	public interface IChangeParameterAction
	{
		function initNewParameterValue ( target : String , parameterSet : String , property : String , value : Object ) :void;
	}
}