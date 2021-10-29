/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.triggers
{
	import com.flashiteasy.api.container.MultipleUIElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.ITrigger;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.errors.ApiErrorManager;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ElementList;
	/**
	 * The <code><strong>AbstractTrigger</strong></code> class is
	 * a pseudo-abstract class that defines what kind
	 * of triggers will fire the FIE Actions.
	 * All classes extending this abstract must implement ITrigger.
	 * 
	 * @see com.flashiteasy.api.core.ITrigger 
	 */
	public class AbstractTrigger implements ITrigger
	{

		/**
		 * Empty constructor
		 */
		public function AbstractTrigger()
		{
			
		}
		[ArrayElementType("String")]
		private var _events : Array;
		private var _type : String;
		private var _uuid : String;
		
		/**
		 * Sets events 
		 */
		public function get events():Array
		{
			return _events;
		}

		/**
		 * 
		 * @private
		 */
		public function set events(value:Array):void
		{
			_events = value;
		}

        /**
         * Method that adds the correct listener so the correct originator fires the correct action on the correct traget
         * @param targets an array of Controls uuids
         * @param action the Action to fire
         */
        public function prepare( targets : Array, action : IAction ):void
        {
            var page : Page = action.getPage();//BrowsingManager.getInstance().getCurrentPage();
            var target : String;
            var uiTarget : FieUIComponent;
            var event : String;
            var elTarget : IUIElementDescriptor;
            
            for each ( target in targets )
            {
                for each ( event in events )
                {
                	/*if(page is XMLFile)
                	{
                		uiTarget = XMLFileList.getInstance().
                	}
                	else
                	{*/
                	elTarget = ElementList.getInstance().getElement( target, page );
                	if(elTarget != null)
                	{
	                	uiTarget = elTarget.getFace();
	                	//}
	                    // TODO : en fn du type d'event, affecter le listener à la scene ou à la face
	                    uiTarget.addEventListener( event, action.apply, false, 0, true );
	                    uiTarget.buttonMode = true;
	                    if(!(elTarget is MultipleUIElementDescriptor))
	                    {
	  						uiTarget.mouseChildren = false;
	                    }
                 	}
                 	else
                 	{
                 		ApiErrorManager.getInstance().dispatchEvent(new FieEvent(FieEvent.ERROR_ACTION_NO_TARGET,{uuid : uuid}));
                 	}
                }
            }           
        }

		/**
		 * Sets the trigger type
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * 
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
		}
        
        /**
         * This method removes the listeners set by the <code>prepare</code> method.
         * @param targets
         * @param action
         */
        public function unload(targets:Array, action:IAction):void
        {
            var page : Page = BrowsingManager.getInstance().getCurrentPage();
            var target : String;
            var uiTarget : FieUIComponent;
            var event : String;
            
            for each ( target in targets )
            {
                for each ( event in events )
                {
                	var control : IUIElementDescriptor = ElementList.getInstance().getElement( target, page );
                	if(control != null ) 
                	{
	                    uiTarget = control.getFace();
	                    uiTarget.removeEventListener( event, action.apply );
                    	uiTarget.buttonMode = false; 
  						uiTarget.mouseChildren = true;
               		}
                }
            }
        }

		/**
		 * Sets the trigger uuid
		 */
		public function get uuid():String
		{
			return _uuid;
		}

		/**
		 * 
		 * @private
		 */
		public function set uuid(value:String):void
		{
			_uuid = value;
		}
	}
}
