/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.sample.editor.impl
{
	import com.flashiteasy.api.editor.IParameterSetEditor;
	import com.flashiteasy.api.editor.impl.AbstractParameterSetEditor;
	import com.flashiteasy.sample.ExternalLibrary
	import com.flashiteasy.sample.parameters.CircleBackgroundColorParameterSet;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * A simple editor for the CircleElement background color editor.
	 * All custom editors must extend com.flashiteasy.api.editor.impl.AbstractParameterSetEditor
	 * as well as they must implement com.flashiteasy.api.editor.IParameterSetEditor
	 * <p>
	 * The custom editor will be automatically loaded in the administration module when
	 * the custom object is selected on stage. As a virtual component, the editor implementation must
	 * override this method :
	 * <code>override public function layout( availableWidth : Number ):void</code></li>
	 * If the editor needs a special height to be displayed in the editor column of admin mode,
	 * the following method can also override the component :
	 * <listing>override protected function getHeight():Number
	 * 		override protected function getHeight():Number
	 * 		{
	 * 			return 50; // the editor height needed
	 * 		}
	 * </listing>
	 * </p>
	 * The Flash'Iteasy API is pure AS3, so if components are needed for
	 * the custom editor, two options are available :
	 * - use in-built admin components. This option should cover most of needs, see the help document.
	 * - write your own editor and eventually reference CS3+ components in Flex project properties so they are available for the editor
	 * 
	 */
	public class SimpleBackgroundColorEditorImpl extends AbstractParameterSetEditor implements IParameterSetEditor
	{
		// the colors that will be applied to the circle element 
		private var colors : Array = [ 0xff9900, 0x009900, 0x0000FF ];
		
		/**
		 * Overrides the component layout.
		 * @param availableWidth
		 */
		override public function layout( availableWidth : Number ):void
		{
			// invoke the layout method of the AbstractParameterSetEditor
			super.layout( availableWidth );
			// invoke your component rendering method
			drawThreeSquares();
		}
		
		/**
		 * Takes charge of the editor rendering : 
		 * draw 3 colored square and add a listener to each so the color of the square in the component
		 * is dispatched to the selected CircleElement on stage.
		 */
		private function drawThreeSquares() : void
		{
			// draw the 3 squares
			for( var i : int = 0; i < colors.length ; i++ )
			{
				var colorSprite : Sprite = new Sprite();
				addChild( colorSprite );
				colorSprite.graphics.beginFill( colors[i], 1 );
				colorSprite.graphics.drawRect( 0, 0, 50, 50 );
				colorSprite.graphics.endFill();
				// squares are placed with a 10 px gap
				colorSprite.x = i * 60 + 10;
				// sets the name of the sprite to the colors array index so it can be easily called in the callback function.
				colorSprite.name = i.toString();
				// add an event listener on the individual square
				// Anonymous function is most handy here
				colorSprite.addEventListener( MouseEvent.CLICK, itemClicked );
			}
		}
		
		// callback for the component squares
		private function itemClicked( e : Event ) : void
		{
			// Invoke this method inherited from AbstractParameterSetEditor so the edition is cancelable
			setPreviousValue();
			// Sets the color and alpha of the selected CircleElement on stage.
			CircleBackgroundColorParameterSet( parameterSet ).backgroundColor = colors[ new Number( e.target.name ) ];
			CircleBackgroundColorParameterSet( parameterSet ).backgroundAlpha= 1;
			update();
		}
		
		override protected function getHeight():Number
		{
			return 50;
		}
	}
}