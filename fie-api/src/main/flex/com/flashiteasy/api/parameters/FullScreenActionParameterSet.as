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
	import com.flashiteasy.api.core.action.IFullScreenAction;
	import com.flashiteasy.api.selection.ElementList;
	

	[ParameterSet(description="FullScreen",type="Reflection", groupname="FullScreen")]
	/**
	 * 
	 * @private
	 */
	public class FullScreenActionParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{



		private var _elementName : String;

		override public function apply(target:IDescriptor):void
		{
			super.apply(target);

			if ( target is IFullScreenAction )
			{
				IFullScreenAction( target ).setElementToFullScreen( elementName );
			}

		}

      [Parameter(type="List", defaultValue="",row="0", sequence="0", label="Elements")]
		public function get elementName() : String
		{
			return _elementName;
		}


		public function set elementName( value : String ) : void
		{
			_elementName = value;
		}
        /**
         * Lists availables targets on stage using their uuids
         * @param name
         * @return 
         */
        public function getPossibleValues(name:String):Array
        {
            return ElementList.getInstance().getElementsAsString( BrowsingManager.getInstance().getCurrentPage() );
        }		
	}
}