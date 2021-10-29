/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.motion
{
	import com.flashiteasy.api.core.project.storyboard.Storyboard;
	
	public interface IStoryboardPlayer
	{
		function start( s : Storyboard, time : int =0 ) : void;
		function startOnUnload( s : Storyboard, time : int =0 ) : void;
		function stop( s : Storyboard ) : void;
		function goToTimeAndStop( s : Storyboard, time : int =0 ) : void ;
		function getStoryboard( ) : Storyboard;
		function getMaxTime() : Number;
		function getDelayBeforeDestroy():Number;
	}
}