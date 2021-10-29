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
	import com.flashiteasy.api.core.action.IDestroyElementAction;
	import com.flashiteasy.api.selection.ElementList;

    [ParameterSet(description="Targets",type="Reflection", groupname="Actions")]
	/**
	 * The <code><strong>TargetParameterSet</strong></code> is the parameterSet
	 * that handles the targetting of an array of controls by another one on stage. It is
	 * mostly used in actions.
	 */

	public class DestroyElementsParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{

		[ArrayElementType("String")]
		private var _elementsToDestroy : Array;
		

		override public function apply(target:IDescriptor):void
		{
			super.apply( target );
			if( target is IDestroyElementAction )
			{
				IDestroyElementAction( target ).setElementsToDestroy(elementsToDestroy, BrowsingManager.getInstance().getCurrentPage());
			}

		}
		
        [Parameter(type="List", labelField = "uuid" ,label="Targets")]
        /**
         * Sets the array of targets using their uuids
         */
        public function get elementsToDestroy() : Array
        {
            return _elementsToDestroy;
        }
        /**
        * 
        * @private
        */
        public function set elementsToDestroy( value : Array ) : void
        {
            _elementsToDestroy = value;
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