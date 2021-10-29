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
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.events.MouseEvent;

    [ParameterSet(description="Triggers",type="Reflection", groupname="Actions")]
	/**
	 * The <code><strong>TriggerParameterSet</strong></code> is the parameterSet
	 * that handles Mouse events triggers.
	 */

	public class TriggerParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
        /**
         * 
         * @default 
         */
         
		[ArrayElementType("String")]
        protected var _triggers : Array;
        
        /**
         * 
         * @inheritDoc
         */
        override public function apply( descriptor: IDescriptor ) : void
        {
            //super.apply( descriptor );
            if( descriptor is IAction )
            {
                IAction( descriptor ).triggers = triggers ;
            }
        }
        
        [Parameter(type="Event", label="Events")]
        /**
         * 
         * @return 
         */
        public function get triggers() : Array
        {
            return _triggers;
        }
        
        /**
         * 
         * @private
         */
        public function set triggers( value : Array ) : void
        {
            _triggers = value;
        }
        
        /**
         * Lsts all MouseEvents
         * @param name
         * @return 
         */
        public function getPossibleValues(name:String):Array
        {
            return ArrayUtils.getConstant(flash.events.MouseEvent);
        }
	}
}