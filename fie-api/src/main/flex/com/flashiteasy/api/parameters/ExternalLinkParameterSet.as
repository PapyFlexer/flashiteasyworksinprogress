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
	import com.flashiteasy.api.core.IParameterSetStaticValues;
	import com.flashiteasy.api.core.action.IExternalLinkAction;

    [ParameterSet(description="External_link",type="Reflection", groupname="Link")]
	/**
	 * The <code><strong>ExternalLinkParameterSet</strong></code> is the parameterSet
	 * that handles the External Link Action (non-visual control).Similar to the
	 * getUrl function, it accepts a string to url and a type of window (_self, _blank, _top,...).
	 * Can be used for any URL property.
	 * 
	 */
	public class ExternalLinkParameterSet extends AbstractParameterSet implements IParameterSetStaticValues
	{
		private var _link:String;
		private var _window:String;

        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            //super.apply( target );
            if ( target is IExternalLinkAction )
            {
                IExternalLinkAction( target ).setLinkAndTarget( link, window ); 
            }
        }
        
        [Parameter(type="String", defaultValue="http://", label="Link")]
		/**
		 * The link towards an url 
		 */
		public function get link():String
		{
			return _link;
		}

		/**
		 * 
		 * @private
		 */
		public function set link(value:String):void
		{
			_link=value;
		}
        
        [Parameter(type="Combo", defaultValue="_blank",row="0", sequence="0", label="Target")]
		/**
		 * The window of the url 
		 */
		public function get window():String
		{
			return _window;
		}

		/**
		 * 
		 * @param value
		 */
		public function set window(value:String):void
		{
			_window=value;
		}
		
		/**
		 * List of possible window properties
		 * @param name
		 * @return the window type as a string
		 */
		public function getPossibleValues(name:String):Array
		{
			return ["_blank", "_self", "_parent", "_top"];
		}
	}
}
