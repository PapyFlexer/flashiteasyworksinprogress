/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.core
{
	/**
	 * 
	 * The <code><strong>CompositeParameterSet</strong></code> is the abstract class to use when several parameterSets must be aggregated.
	 * Although this is a pseudo-abstract class, a meta is added to enforce an array of IParameterSets structure.
	 */
	public class CompositeParameterSet extends AbstractParameterSet
	{
		[ArrayElementType("com.flashiteasy.api.core.IParameterSet")]
		/**
		 * The Array of ParameterSets to be aggregated
		 * @default empty Array
		 */
		protected var _params : Array = [];
		
		/**
		 * Adds a ParameteerSet to the present CompositeParameterSet.
		 * @param s IParameterSet
		 */
		public function addParameterSet( s : IParameterSet ) : void
		{
			_params.push( s );
		}
		
		/**
		 * Lits the individual ParameterSets aggregated in the present CompositeParameterSet.
		 * @return 
		 */
		public function getParametersSet() : Array
		{
			return _params;
		}
		
		/**
		 * Sets the array of ParameterSets
		 * @param value
		 */
		public function setParameterSet( value : Array ) : void
		{
			_params=value;
		}
		/**
		 * Returns the number of ParameterSets aggregated
		 * @return 
		 */
		public function length():int{
			return _params.length;
		}
		
		/**
		 * 
		 * @inheritDoc
		 */
		override public function apply( target: IDescriptor ) : void
		{
			super.apply( target );
			for each( var p : IParameterSet in _params )
			{
				p.apply( target );
			}
			//trace("apply");
		}
	}
}