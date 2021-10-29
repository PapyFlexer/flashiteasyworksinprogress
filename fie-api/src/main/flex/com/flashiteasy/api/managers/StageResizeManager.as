/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.managers
{

	/**
	* Dispatched when the resize of the stage starts.
	*/
	[Event(name="stageResizeStart", type="com.flashiteasy.api.events.FieStageResizeEvent")]

	/**
	* Dispatched when the stage is being resized.
	*/
	[Event(name="stageResizeProgress", type="com.flashiteasy.api.events.FieStageResizeEvent")]

	/**
	* Dispatched when the resize of the stage is finished.
	*/
	[Event(name="stageResizeEnd", type="com.flashiteasy.api.events.FieStageResizeEvent")]



	import com.flashiteasy.api.events.FieStageResizeEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * The <code><strong>StageResizeManager</strong></code> handles
	 * the Stage Reize events and works (loosely, no hard dependencies)
	 * with the SWFFit classes and js so browsers scrollers behave
	 * coherently.
	 * <p>
	 * As a pseudo-singleton class, it must be called using
	 * the <code><strong>StageResizeManager.getInstance()</strong></code> syntax.
	 * </p>
	 */
	public class StageResizeManager extends EventDispatcher
	{
		private static var _instance:StageResizeManager;
		private var _stage:Stage;
		private var _t1:Timer;
		private var _resizeEndDelay:int;
		
		/**
		 * Singleton implementation
		 * @default false
		 */
		protected static var allowInstantiation : Boolean = false;

		/**
		 * 
		 * @param pStage a reference to the stage of the project
		 * @param pResizeEndDelay the delay between 2 tests of stageResizing Events.
		 * @return StageResizeManager instance.
		 */
		public static function getInstance(pStage:Stage, pResizeEndDelay:int=200) : StageResizeManager
		{
			if( _instance == null )
			{
				allowInstantiation = true;
				_instance = new StageResizeManager(pStage, pResizeEndDelay);
				trace ("creating StageResizeMngr with "+pStage.toString());
				allowInstantiation = false;
			} 
			return _instance;
		}
		
		/**
		 * 
		 * constructor
		 * 
		 * */
		
		public function StageResizeManager(pStage:Stage, pResizeEndDelay:int=200 )
		{
			if (allowInstantiation == true)
			{
			_stage = pStage;
			_resizeEndDelay = pResizeEndDelay;
			
			_stage.addEventListener( Event.RESIZE, onStageResize );
			
			_t1 = new Timer( 50, 0 );
			_t1.addEventListener( TimerEvent.TIMER, onTimer );
			} else {
				throw( new Error( "operator 'new' is not not allowed with singleton classes. Use StageResizeManager.getInstance() instead !" ) );
			}
			
		}

		/**
		 * Fired when the user resizes the stage
		 * 
		 * @param e Event
		 */	
		private function onStageResize( e:Event ):void
		{
			
			if( !_t1.running )
			{
				
				dispatchEvent( new FieStageResizeEvent( FieStageResizeEvent.STAGE_RESIZE_START, false, false ) );
				_t1.start();
				
			}
			else
			{
				
				dispatchEvent( new FieStageResizeEvent( FieStageResizeEvent.STAGE_RESIZE_PROGRESS, false, false ) );
				_t1.reset();
				_t1.start();
				
			}
			
		}
		
		/**
		 * Fired each pResizeEndDelay ms ( eg 250 ) when the timer is running. 
		 * 
		 * @param e Event
		 * 
		 */	
		private function onTimer( e:TimerEvent ):void
		{
			
			var t:Timer = e.currentTarget as Timer
			var count:int = t.currentCount * t.delay;
			
			if( count > _resizeEndDelay )
			{
				
				_t1.reset();
				dispatchEvent( new FieStageResizeEvent( FieStageResizeEvent.STAGE_RESIZE_END, false, false ) );
				
			}
			
		}
		
	}
}

