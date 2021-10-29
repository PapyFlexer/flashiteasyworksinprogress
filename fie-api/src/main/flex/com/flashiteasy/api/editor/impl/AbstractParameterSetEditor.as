/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.editor.impl
{
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.editor.IParameterSetEditor;
	import com.flashiteasy.api.editor.IParameterSetEditorListener;
	
	import flash.display.Sprite;
	
	/**
	 * The <code><strong>AbstractParameterSetEditor</strong></code> sets the base for the parameterSets contextual editors
	 */
	public class AbstractParameterSetEditor extends Sprite implements IParameterSetEditor
	{
		/**
		 * The listener that registers the 'change' events in ParameterSets
		 * @default null
		 */
		protected var listener : IParameterSetEditorListener;
		
		/**
		 * The parameterSet subject to edition
		 * @default null
		 */
		protected var parameterSet : IParameterSet;
		
		private var bgSprite : Sprite;
		
		/**
		 * Rests the ParameterSet editor
		 * @param listener
		 * @param parameterSet
		 */
		public function reset( listener : IParameterSetEditorListener, parameterSet : IParameterSet  ) : void
		{
			this.listener = listener;
			this.parameterSet = parameterSet;
		}
		
		private var availableWidth : Number;
		
		/**
		 * Displays the editor
		 * @param availableWidth
		 */
		public function layout( availableWidth : Number ) : void
		{
			this.availableWidth = availableWidth;
			drawBackground();
			// Notifying the parent size has changed
			parent.height = height;
		}
		
		private function drawBackground() : void
		{
			bgSprite = new Sprite();
			addChild( bgSprite );
			bgSprite.graphics.beginFill( 0, 0 ); // Transparent background
			bgSprite.graphics.drawRect( 0, 0, getWidth(), getHeight() );
			bgSprite.graphics.endFill();
		}
		
		/**
		 * 
		 */
		protected function update() : void
		{
			listener.update( parameterSet );
		}
		
		
		/**
		 * Records previous values of the ParameterSet, so an UNDO command can be applied in admin module
		 * @param changedParameterList
		 */
		protected function setPreviousValue(changedParameterList:Array = null) : void
		{
			listener.setPreviousValue( changedParameterList);
		}
		
		/**
		 * 
		 * Override when subclassing (component based).
		 */
		protected function getWidth() : Number
		{
			return availableWidth;
		}
		
		/**
		 * Override when subclassing (component based).
		 */
		protected function getHeight() : Number
		{
			return 100;
		}
	}
}