package com.flashiteasy.api.editor
{
	import com.flashiteasy.api.core.IParameterSet;
	
	/**
	 * The <code><strong>IParameterSetEditorListener</strong></code> interface defines methods shared by all ParameterSets editors listeners
	 */
	public interface IParameterSetEditorListener
	{
		function update( parameterSet : IParameterSet ) : void;
		function setPreviousValue( changedParameterList:Array = null) : void;
	}
}