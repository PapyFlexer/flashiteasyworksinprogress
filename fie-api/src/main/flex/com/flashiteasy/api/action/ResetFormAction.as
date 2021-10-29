/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 * 
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.container.FormElementDescriptor;
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.action.IResetFormAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.utils.PageUtils;
	
	import flash.events.Event;

	public class ResetFormAction extends Action implements IResetFormAction
	{
		
		protected var _form : FormElementDescriptor;
		
		protected var _formName : String;
		//protected var _page : Page;
		
		
		public function ResetFormAction()
		{
			super();
			
		}
		
		public function resetForm(target:String):void
		{
			
			_formName = target;
			//var blocks : Array = page.getPageItems().pageControls;
			/*  */
		}

		public function setFormName( name : String ) : void
		{
			_formName = name;
		}

		override public function apply( event : Event ) : void
		{
			findForm(formName,BrowsingManager.getInstance().getCurrentPage())
			form.resetValues()
		}
		
		public function get form () : FormElementDescriptor
		{
			return _form;
		}
		
		public function set form( value : FormElementDescriptor) : void
		{
			_form = value;
		}
		public function get formName () : String
		{
			return _formName;
		}
		
		public function set formName( value : String) : void
		{
			_formName = value;
		}
		
		private function findForm( formName : String, page : Page) : void
		{
			var blocks : Array = PageUtils.getPageForms(page);
			var item : IDescriptor;
			for each (item in blocks)
			{
				if (item.uuid == formName)
				{
					form = item as FormElementDescriptor;
					break;
				}			
			}
		}

		/**
		 *
		 * @return Class of Action
		 */

		override public function getDescriptorType():Class
		{
				return ResetFormAction;
		}
		
	}
}