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
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.selection.ElementList;

    [ParameterSet(description="Targets",type="Reflection", groupname="Actions")]
	/**
	 * The <code><strong>TargetParameterSet</strong></code> is the parameterSet
	 * that handles the targetting of an array of controls by another one on stage. It is
	 * mostly used in actions.
	 */

	public class TargetsParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		[ArrayElementType("String")]
		private var _targets : Array;
		
		/**
		 * @inheritDoc
		 */
		override public function apply( descriptor: IDescriptor ) : void
		{
			super.apply( descriptor );
			if( descriptor is IAction )
			{
				IAction( descriptor ).targets = targets ;
			}
		}
		
        [Parameter(type="List", labelField = "uuid" ,label="Targets")]
        /**
         * Sets the array of targets using their uuids
         */
        public function get targets() : Array
        {
            return _targets;
        }
        /**
        * 
        * @private
        */
        public function set targets( value : Array ) : void
        {
            _targets = value;
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