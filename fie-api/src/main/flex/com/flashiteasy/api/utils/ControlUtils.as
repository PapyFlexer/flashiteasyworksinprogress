/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.utils
{
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.parameters.PositionParameterSet;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code><strong>ControlUtils</strong></code> class is
	 * an utility class dealing with Controls
	 */
	public class ControlUtils
	{
		/**
		 * Extracts a ParameterSet from a descriptor having the same type than the ParameterSet passed as argument
		 * @param parameterSet the parameterset
		 * @param element the descriptor
		 * @return a ParameterSet if possible, null otherwise
		 */
		public static function retrieveParameter ( parameterSet : IParameterSet , element : IDescriptor ) : IParameterSet
		{
			var definedParamSets : Array = getDefinedParameterSets( element.getParameterSet() );
			for each( var param:IParameterSet in definedParamSets )
			{
				if( getQualifiedClassName(param) == getQualifiedClassName(parameterSet))
				{
					return param;
				}
			}
			return null;
		}
		/**
		 * Extracts a ParameterSet from a descriptor having the same type than the ParameterSet passed as argument
		 * @param parameterSet the parameterset
		 * @param element the descriptor
		 * @return a ParameterSet if possible, null otherwise
		 */
		public static function retrieveClonedParameter ( parameterSet : IParameterSet , element : IDescriptor ) : IParameterSet
		{
			var definedParamSets : Array = getDefinedParameterSets( element.getParameterSet() );
			for each( var param:IParameterSet in definedParamSets )
			{
				if( getQualifiedClassName(param) == getQualifiedClassName(parameterSet))
				{
					return CloneUtils.clone(param);
				}
			}
			return null;
		}
		/**
		 * Returns the PositionParameterSet of an element on stage, based on its Descriptor
		 * @param element Descriptor of the control
		 * @return The PositionParameterSet, where we can extract x and y values
		 */
		public static function getPositionParameter( element : IDescriptor ) : PositionParameterSet
		{
			var definedParamSets : Array = getDefinedParameterSets( element.getParameterSet() );
			for each( var param:IParameterSet in definedParamSets )
			{
				if( getQualifiedClassName(param) == getQualifiedClassName(PositionParameterSet) )
				{
					return param as PositionParameterSet;
				}
			}
			return null;
		}
		
		/**
		 * Returns the SizeParameterSet of an element on stage, based on its Descriptor
		 * @param element Descriptor of the control
		 * @return The SizeParameterSet, where we can extract width and height values
		 */
		public static function getSizeParameter( element : IDescriptor ) : SizeParameterSet
		{
			var definedParamSets : Array = getDefinedParameterSets( element.getParameterSet() );
			for each( var param:IParameterSet in definedParamSets )
			{
				if( getQualifiedClassName(param) == getQualifiedClassName(SizeParameterSet) )
				{
					return param as SizeParameterSet;
				}
			}
			return null;
		}

		
		/**
		 * @private
		 * @param rootParameterSet
		 * @return 
		 */
		private static function getDefinedParameterSets( rootParameterSet : IParameterSet ) : Array
		{
			var params : Array = [];
			if ( rootParameterSet is CompositeParameterSet )
			{
				params = CompositeParameterSet( rootParameterSet ).getParametersSet(); 
			}
			else
			{
				params = [];
				params.push( rootParameterSet );
			}
			return params;
		}
	}
}