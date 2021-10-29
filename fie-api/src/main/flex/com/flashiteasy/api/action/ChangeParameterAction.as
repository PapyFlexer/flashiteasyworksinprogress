/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.action
{
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.action.IChangeParameterAction;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.ElementDescriptorUtils;
	
	import flash.events.Event;
	
	/**   @private **/

	public class ChangeParameterAction extends Action implements IChangeParameterAction
	{	
		private var pset : IParameterSet;
		private var property : String ;
		private var value : Object ;
		private var target : IDescriptor;
		private var triggerControl : IDescriptor;
		
		/**
		 * 
		 * @param target
		 * @param parameterSet
		 * @param property
		 * @param value
		 */
		public function initNewParameterValue ( target : String , parameterSet : String , property : String , value : Object ) :void
		{
			this.target = ElementList.getInstance().getElement( target , _page);
			//_targets=[target];
			pset = ElementDescriptorUtils.findParameterSet( this.target , parameterSet ) ;
			this.property = property ;
			this.value = value ;
		}
		
		override public function apply( event : Event ):void
		{
			pset[property]=value ;
			pset.apply(target);
			if( target is SimpleUIElementDescriptor )
			{
				SimpleUIElementDescriptor( target ).invalidate();
			}
		}
		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return ChangeParameterAction;
		}
	}
}