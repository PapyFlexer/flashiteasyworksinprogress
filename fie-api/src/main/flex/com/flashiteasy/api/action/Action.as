/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 *
 */
package com.flashiteasy.api.action
{
	import com.flashiteasy.api.core.BrowsingManager;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.ITrigger;
	import com.flashiteasy.api.core.action.ITargetsAction;
	import com.flashiteasy.api.core.action.ITriggerAction;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.utils.ArrayUtils;
	import com.flashiteasy.api.utils.NameUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * 
	 * The <code><strong>Action</strong></code> class is a pseudo-abstract class that is extended by all actions. 
	 * It extends the EventDispatcher Class from Flash so listeners can be applied to it. 
	 * The Action class implements the IDescriptor interface so it can be registered
	 * as a non-visual FIE component that can receive ParameterSets.
	 * 
	 */
	/**
	 * 
	 * @author gillesroquefeuil
	 */
	public class Action extends EventDispatcher implements IDescriptor, IAction, IEventDispatcher, ITriggerAction, ITargetsAction
	{
		/**
		 * 
		 * @default : Array of triggers (mouse, time, keyboard or story-related)
		 */
		protected var _triggers:Array;
		/**
		 * 
		 * @default : Array of targets (visual components) on stage, subject to triggers
		 */
		protected var _targets:Array;
		/**
		 * 
		 * @default : Page, the page where the action takes place
		 */
		protected var _page:Page;
		
		private var _params:IParameterSet;
		private var _uuid:String;
		private var _isWaiting:Boolean=false;

		/**
		 * Apply parameters, must be overridden
		 * @param event
		 */
		public function apply(event:Event):void
		{
			throw new Error("Abstract Classes must be overridden");
		}

		/**
		 * 
		 * Creates the action by adding its instance to the Action List Actions Dictionary
		 * and calls the applyParameters method shared by all FIE controls
		 * 
		 * @param page : Page
		 */
		public function createAction(page:Page):void
		{
			this._page=page;
			ActionList.getInstance().addAction(this, page);
			applyParameters();
		}

		/**
		 * Applies the events (triggers set on visual controls)
		 */
		public function applyEvents():void
		{
			for each (var trigger:ITrigger in triggers)
			{
				trigger.prepare(_targets, this);
			}
		}

		/**
		 *  Method shared by all controls, basic for IoC pattern
		 */
		public function applyParameters():void
		{
			if (_params != null)
			{
				_params.apply(this);
			}
			dispatchEvent(new Event(FieEvent.COMPLETE));
		}

		/**
		 * Method to destroy the Action. Calls the ActionList removeAction method 
		 * that assures the GarbageCollector will correctly trash it.
		 * 
		 */
		public function destroy():void
		{
			removeEvents();
			ActionList.getInstance().removeAction(this, _page);
		}

		/**
		 * Method to destroy the events that assures the GarbageCollector will correctly trash them.
		 * 
		 */
		public function removeEvents():void
		{
			for each (var trigger:ITrigger in triggers)
			{
				trigger.unload(_targets, this);
			}
		}

		/**
		 * Returns the page instance whom the action belongs to.
		 * @return  the page instance where the action has been created
		 */
		public function getPage():Page
		{
			return _page;
		}

		/**
		 * Sets the page instance where the action is created
		 * @param page the page instance where the action must be created
		 */
		public function setPage(page:Page):void
		{
			_page=page;
			dispatchEvent(new Event(FieEvent.PAGE_CHANGE));
		}

		/**
		 * Affects the action to an array of controls
		 * @param value
		 */
		public function setTargets(value:Array):void
		{
			targets=value;
		}

		/**
		 * Sets the action triggers.
		 * @param value the Array of targets (controls) that are the action subjects
		 */
		public function setTriggers(value:Array):void
		{
			triggers=value;
		}

		/**
		 * 
		 * Sets the Array of triggers (events) that  fire the action 
		 */

		public function get triggers():Array
		{
			return _triggers;
		}
		/**  @private  **/
		public function set triggers(value:Array):void
		{
			_triggers=value;
		}


		/**
		 * 
		 * Sets the Array of targets (controls) subjects to the action 
		 */
		public function get targets():Array
		{
			return _targets;
		}

		/**  @private  **/
		public function set targets(value:Array):void
		{
			_targets=value;
		}

		/**
		 * Returns the array of ParameterSets defining the action
		 * @return  IParameterSet, cf. IoC package
		 */
		public function getParameterSet():IParameterSet
		{
			return _params;
		}

		/**
		 * Sets the array of ParameterSets defining the action
		 * @param value IParameterSet, cf. IoC package
		 */
		public function setParameterSet(value:IParameterSet):void
		{
			_params=value;

		}
		
		/**
		 * Cloning method used when copy/paste or duplicate actions are perfomed. takes chareg of the descriptor and its parameters (simple and/or composite).
		 * @param sameId Boolean that states if the copied element must keep its uuid or generate a new one. The clone is not added in the ElementList until its page is set
		 * (see next method)
		 * @return the IUIElementDescriptorof the element to be copied, cut and/or duplicated.
		 */
		public function clone(sameId:Boolean=false):IAction
		{
			var c:Class=getDescriptorType();
			var control:IAction=new c();
			//control.uuid=sameId ? control.uuid : "";
			control.uuid="";
			control.createAction(_page);
			ITriggerAction(control).setTriggers(cloneTriggers());
			control.setParameterSet(cloneParameters());
			ActionList.getInstance().removeAction(control, _page);
			control.addEventListener(FieEvent.PAGE_CHANGE, pageSet);
			//control.addEventListener(FieEvent.COMPLETE, cloneComplete);
			return control;
		}
		
		// The clone is not added in the ElementList until its page is set

		private function pageSet(e:Event):void
		{
			var el:IAction=e.target as IAction;
			el.removeEventListener(FieEvent.PAGE_CHANGE, pageSet);

			// Give an unique uuid to the clone if it doesn t have any
			if (el.uuid == "")
			{
				el.uuid=NameUtils.findUniqueName(this.uuid, ActionList.getInstance().getActionsId(BrowsingManager.getInstance().getCurrentPage()));
			}
			// add the clone to the elementList
			ActionList.getInstance().addAction(el, BrowsingManager.getInstance().getCurrentPage());
		}

		private function cloneParameters():IParameterSet
		{
			var pSet:CompositeParameterSet=getParameterSet() as CompositeParameterSet;
			var clonedPset:CompositeParameterSet=new CompositeParameterSet;
			var params:Array=ArrayUtils.clone(pSet.getParametersSet());
			clonedPset.setParameterSet(params);
			return clonedPset;

		}
		
		private function cloneTriggers():Array
		{
			var triggers:Array=this.triggers;
			var clonedTriggers:Array=new Array;
			var params:Array=ArrayUtils.clone(triggers);
			clonedTriggers=params;
			return clonedTriggers;

		}
		
		// Renvoi la classe

		/**
		 *
		 * @return
		 */
		public function getDescriptorType():Class
		{
			throw new Error("getDescriptorType Must be overridden");
			return Action;
		}

		/**
		 * Sets an unique id on page
		 */
		public function get uuid():String
		{
			return _uuid;
		}

		/**  @private  **/
		public function set uuid(value:String):void
		{
			_uuid=value;
		}

		/**
		 * Sets a Boolean that states if the control is ready to be rendered (when false)
		 */
		public function get isWaiting():Boolean
		{
			return _isWaiting;
		}

		/** @private  **/
		public function set isWaiting(value:Boolean):void
		{
			_isWaiting=value;
		}

	}
}
