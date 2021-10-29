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
	 * The <code><strong>AbstractParameterSet</strong></code> is the abstract class representing parameterSets that will be applied to descriptor in order to form the visual control.
	 * A parameterSet is a logical collection of parameters : size, position, color, and so on. These parameters can be added to descriptors
	 * whether they build visual or non)-visual components.
	 * They are specifically adaptated to run with InjectionOfContext pattern(IoC).
	 * Note the cardinality of the descriptor-parameterSet i 1 to 1.
	 * If and when the developper needs to melt several parameterSets, he should use the <code><strong>CompositeParameterSet</strong></code>.
	 * <p>
	 * ParameterSet comes with meta-data, so editors can be dynamically and contectually loaded into the admin module :
	 * <ul>
	 * <li>Meta must come first over the class declaration, so the parameterSet editor displays itself correctly. Example, for the AlignParameterSet class : <code>[ParameterSet(description="Align_type", type="Reflection", groupname="Dimension")]</code></li>
	 * <li>Meta must come after that for each of the properties they own, so the corrects components can be called in the editor. example : <code>[Parameter(type="Combo",defaultValue="top", row="0", sequence="1", label="VerticalShort")]</code>. This calls a ComboBox </li>
 * 	 * </ul>
	 * </p>
	 */
	public class AbstractParameterSet implements IParameterSet
	{

		/**
		 * Constructor. As this is an abstract class it throws an error if instanciated.
		 */
		public function AbstractParameterSet()
		{
			if (this["constructor"] == AbstractParameterSet)
			{
				throw new Error( "AbstractParameterSet is a pseudo-abstract type, and should be overriden." );
			}
		}

		private var target : IDescriptor;

		/**
		 * By applying the parameterSet properties to the targetted Descriptor
		 * this method triggers the control refresh on stage.
		 * @param target IDescriptor to which the parameterSet is applied
		 */
		public function apply( target: IDescriptor ) : void
		{
			//this.target = target; 
		}
		
		/**
		 * Returns the IDescriptor implementation to wich the parmeterSet is applied
		 * @return IDescriptor
		 */
		protected function getTarget() : IDescriptor
		{
			return target;
		}


	}
}