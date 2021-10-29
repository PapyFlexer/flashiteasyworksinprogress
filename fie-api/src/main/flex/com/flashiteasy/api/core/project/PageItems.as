/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core.project
{
	/**
	 * The <code><strong>PageItems</strong></code> class represents a single element of a Story, concerning a single target.
	 */
	public class PageItems
	{
        /**
         * 
         * @default Contains all page blocks, visual & non-visual
         */
        public var pageControls : Array ;
        /**
         * 
         * @default Contains all page actions
         */
        public var pageActions : Array;
        /**
         * 
         * @default Contains all page timer-based animations
         */
        public var pageStories : Array;
        /**
         * 
         * @default Contains all trigger-based animations
         */
        public var pageTriggerStories : Array;
        /**
         * 
         * @default Contains all pageIn animations (transition page load)
         */
        public var pageInStories : Array;
        /**
         * 
         * @default  Contains all pageOut animations (transition page unload)
         */
        public var pageOutStories : Array;
	}
}