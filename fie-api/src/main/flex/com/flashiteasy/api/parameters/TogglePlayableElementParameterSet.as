/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.parameters
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.action.IElementAction;
	import com.flashiteasy.api.core.elements.IPlayableElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.selection.ElementList;

	// metadata
    [ParameterSet(description="Toggle_Element",type="Reflection", groupname="Control")]
	/**
	 * The <code><strong>PlayStoryParameterSet</strong></code> is the parameterSet
	 * that handles the action of triggering an animation (Story).
	 * The metadata generates a combobox listing the possible targets (stories)
	 * on stage.
	 */
	public class TogglePlayableElementParameterSet extends AbstractParameterSet  implements IParameterSetStaticValues
	{
		
		private var _elementList:Array;
		private var _time : uint;
		
        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            //super.apply( target );
            if ( target is IElementAction )
            {
                IElementAction( target ).setElementsToTrigger(_elementList , target.getPage() ); 
            }
        }
 
       [Parameter(type="List", defaultValue="",row="0", sequence="0", label="Elements")]
		/**
		 * the Array of stories to play
		 */
		public function get elementList():Array
		{
			return _elementList;
		}

		/**
		 * 
		 * @private
		 */
		public function set elementList(value:Array):void
		{
			_elementList=value;
		}
		

		/**
		 * Returns the array of 
		 * @param name
		 * @return 
		 */
		public function getPossibleValues(name:String):Array
		{
			var page : Page = new Page;
			page = BrowsingManager.getInstance().getCurrentPage();
			var elems:Array = ElementList.getInstance().getElements(page);
			var playableElementUuids : Array = [];
			for each (var el : IDescriptor in elems)
			{
				// lists only the playable controls
				if ( el is IPlayableElementDescriptor) playableElementUuids.push(el.uuid);
			}
			return playableElementUuids;
		}
		
	}
}