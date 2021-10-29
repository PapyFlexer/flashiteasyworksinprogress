package com.kingnare.skins.dropIndicator
{
	import mx.skins.ProgrammaticSkin;
	import flash.display.Graphics

	public class ListDropIndicator extends ProgrammaticSkin
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 */
		public function ListDropIndicator()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  direction
		//----------------------------------

		/**
		 *  Should the skin draw a horizontal line or vertical line.
		 *  Default is horizontal.
		 */
		public var direction:String="horizontal";

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);

			var g:Graphics=graphics;

			g.clear();
			g.lineStyle(2, 0xCCCCCC);

			// Line
			if (direction == "horizontal")
			{
				g.moveTo(0, 0);
				g.lineTo(w, 0);
			}
			else
			{
				g.moveTo(0, 0);
				g.lineTo(0, h);
			}
		}

	}
}