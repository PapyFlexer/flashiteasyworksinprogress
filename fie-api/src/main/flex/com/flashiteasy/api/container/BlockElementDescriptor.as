/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.container
{
	import com.flashiteasy.api.core.IUIElementContainer;


	// basic container

	/**
	 * The <code><strong>BlockElementDescriptor</strong></code> is the descriptor (see IoC) of the base container.
	 * It mostly takes the role of a group-like control, allowing brother-elements to me moved and/or modified all together.
	 * 
	 */
	public class BlockElementDescriptor extends MultipleUIElementDescriptor implements  IUIElementContainer
	{
		/**  @inheritDoc  **/
		override public function getDescriptorType():Class
		{
			return BlockElementDescriptor;
		}

	}
}
