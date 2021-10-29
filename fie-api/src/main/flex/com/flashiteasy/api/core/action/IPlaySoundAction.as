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
	 * The <code><strong>IPlaySoundAction</strong></code> interface defines methods shared by play sound actions
	 */
	public interface IPlaySoundAction
	{
		function setSoundToPlayURL ( str : String , loop : Boolean, time : Number, volume:Number ) : void;
	}
}