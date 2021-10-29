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
	import com.flashiteasy.api.container.MultipleUIElementDescriptor;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code><strong>ElementDescriptorUtils</strong></code> class is
	 * an utility class dealing with Controls
	 */
	public class ElementDescriptorUtils
	{
		/**
		 * Returns the depth of a Descriptor
		 * @param descriptor
		 * @return 
		 */
		public static function getDescriptorDepth( descriptor : IUIElementDescriptor ) : int 
		{
			return descriptor.getFace().parent.getChildIndex(descriptor.getFace());
		}
		
		/**
		 * Find a ParameterSet given its name and the control's descriptor
		 * @param descriptor
		 * @param parameterSetName
		 * @return 
		 */
		public static function findParameterSet(descriptor : IDescriptor, parameterSetName:String):IParameterSet
		{
			if(descriptor != null)
			{
			var descriptorParameters : CompositeParameterSet = descriptor.getParameterSet() as CompositeParameterSet;
			if (descriptorParameters != null )
			{
				var parameters : Array = descriptorParameters.getParametersSet();
				for each (var pSet:IParameterSet in parameters)
				{
					if (getQualifiedClassName(pSet).split("::")[1] == parameterSetName)
					{
						return pSet;
					}
				}

			}
			}
			return null;
		}
				
		public static function deepList( descriptorsArray : Array, descriptorsOrIds : Boolean, arr:Array ) : Array
		{
			//var arr : Array = [] ;
			for each (var descr : IUIElementDescriptor in descriptorsArray)
			{
				descriptorsOrIds ? arr.push(descr)	: arr.push(descr.uuid);
				if (descr is MultipleUIElementDescriptor)
				{
					arr.concat(deepList(MultipleUIElementDescriptor(descr).getChildren(), descriptorsOrIds, arr));
				}
				else
				{
					//descriptorsOrIds ? arr.push(descr)	: arr.push(descr.uuid);
				}
			}
			return arr;
		}

	}
}