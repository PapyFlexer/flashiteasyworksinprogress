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
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.action.IInternalLinkAction;
	import com.flashiteasy.api.core.project.Page;

    [ParameterSet(description="Internal_link",type="Reflection", groupname="Link")]
	/**
	 * The <code><strong>InternalLinkParameterSet</strong></code> is the parameterSet
	 * that handles as an Action (non-visual control) the navigation between the different project pages.
  	 * It lists the available pages as a tree.
	 */
	public class InternalLinkParameterSet extends AbstractParameterSet
	{
		private var _page:String;

        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            //super.apply( target );
            if ( target is IInternalLinkAction )
            {
                IInternalLinkAction( target ).setTargetPage( _page ); 
            }
        }
        
        [Parameter(type="PageCombo", label="Page")]
		/**
		 * 
		 * @the project page to link to 
		 */
		public function get page():String
		{
			return _page;
		}

		/**
		 * 
		 * @private
		 */
		public function set page(value:String):void
		{
			_page=value;
		}
	}
}