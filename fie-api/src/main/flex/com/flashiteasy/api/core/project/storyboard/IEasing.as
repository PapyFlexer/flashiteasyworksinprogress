/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.api.core.project.storyboard
{
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	
	/**
	 * The <code>IEasing<strong></strong></code> interface defines methods shared by transitions
	 */
	public interface IEasing
	{
		function progress( descriptor : IDescriptor, parameterSet : IParameterSet, property : String, t : Transition, currentTime : int ) : void;
		function begin( descriptor : IDescriptor, parameterSet : IParameterSet, property : String, t : Transition ) : void;
		function end( descriptor : IDescriptor, parameterSet : IParameterSet, property : String, t : Transition ) : void;
	}
}