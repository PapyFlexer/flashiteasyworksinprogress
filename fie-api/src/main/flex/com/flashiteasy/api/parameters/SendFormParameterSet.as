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
	import com.flashiteasy.api.action.ResetFormAction;
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.action.IResetFormAction;
	import com.flashiteasy.api.core.action.ISendFormAction;
	import com.flashiteasy.api.core.project.Page;

	/**
	 * The <code><strong>SendFormParameterSet</strong></code> is the parameterSet
	 * that handles the sending of a tragetted form container in the page.
	 */

	// metadata
    [ParameterSet(description="Send_Form",type="Reflection", groupname="Form")]
	public class SendFormParameterSet extends AbstractParameterSet
	{
		private var _formToSendName : String
		private var _page : Page;
        /**
         * 
         * @inheritDoc
         */
        override public function apply(target:IDescriptor):void
        {
            //super.apply( target );
            if ( target is ISendFormAction )
            {
               ISendFormAction( target ).setFormName( formToSendName );
               ISendFormAction( target ).verifyAndSendForm( _formToSendName ); 
            }
            else if (target is ResetFormAction)
            {
            	IResetFormAction( target ).setFormName(formToSendName);
            	IResetFormAction( target ).resetForm( formToSendName );
            }
        }
        
        [Parameter(type="FormComboBox", label="Form")]
		/**
		 * 
		 * @the form page to send
		 */
		public function get formToSendName():String
		{
			return _formToSendName;
		}

		/**
		 * 
		 * @private
		 */
		public function set formToSendName(value:String):void
		{
			_formToSendName=value;
		}

		public function get page() : Page
		{
			return _page;
		}
		public function set page( value : Page ) : void
		{
			_page = value;
		}
	}
}