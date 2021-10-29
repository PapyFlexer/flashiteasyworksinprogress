/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.xml.impl
{
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.ioc.ClassResolver;
	import com.flashiteasy.api.xml.IParameterSetParser;
	
	/**
	 * The <code><strong>CompositeParameterSetXMLParser</strong></code> class is
	 * a parsing utility class parsing dealing with CompositeParameterSets
	 */
	public class CompositeParameterSetXMLParser implements IParameterSetParser
	{
		/**
		 * Fills an XML with a ParameterSet and its parent Descriptor.
		 * @param xml
		 * @param instance
		 * @param parent
		 */
		public function fill(xml:XML, instance:IParameterSet, parent:IDescriptor=null):void
		{
			
			if (xml != null)
			{
				var clazz : Class ;
				var parameters : Array = [];
				
				for each(var node:XML in xml.children())
				{
					if (Object(instance).hasOwnProperty(node.name()))
					{

						if (instance[node.name()]is Number)
						{
							// Color

							if (node.children()[0] != null && node.children()[0].substring(0, 2) == "0x")
							{
								instance[node.name()]=parseInt(node.children()[0].substring(2), 16);
							}
							// Number / Int
							else
							{
								instance[node.name()]=parseFloat(node.children()[0]);
							}
						}
						else
						{

							if (node.children()[0] == "true")
							{
								instance[node.name()]=true;
							}
							else if (node.children()[0] == "false")
							{
								instance[node.name()]=false;
							}
							else
							{
								instance[node.name()]=node.children()[0];
							}

						}
					}
					else
					{
						clazz = ClassResolver.resolve( node.name() , ClassResolver.PARAMETERS_PACKAGE );
						var param : IParameterSet = new clazz ;
						for each ( 	var subNode : XML in node.children() )
						{
							if (param[subNode.name()]is Number)
							{
								// Color
	
								if (subNode.children()[0] != null && subNode.children()[0].substring(0, 2) == "0x")
								{
									param[subNode.name()]=parseInt(subNode.children()[0].substring(2), 16);
								}
								// Number / Int
								else
								{
									param[subNode.name()]=parseFloat(subNode.children()[0]);
								}
							}
							else
							{
	
								if (subNode.children()[0] == "true")
								{
									param[subNode.name()]=true;
								}
								else if (subNode.children()[0] == "false")
								{
									param[subNode.name()]=false;
								}
								else
								{
									param[subNode.name()]=subNode.children()[0];
								}
	
							}
						}
						parameters.push(param );
					}
				}
				
				CompositeParameterSet( instance ).setParameterSet( parameters );
			}
		}

	}
}