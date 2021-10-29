/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.editor
{
	import com.flashiteasy.api.core.IParameterSet;
	
	/**
	 * The <code><strong>IParameterSetEditor</strong></code> interface defines methods shared by ParameterSets editors
	 */
	public interface IParameterSetEditor
	{
		function reset( l : IParameterSetEditorListener, parameterSet : IParameterSet ) : void;
		function layout( availableWidth : Number ) : void;
	}
}