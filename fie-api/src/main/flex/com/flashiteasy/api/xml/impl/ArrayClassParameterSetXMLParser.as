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
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.ITrigger;
	import com.flashiteasy.api.ioc.ClassResolver;
	import com.flashiteasy.api.xml.IParameterSetParser;
	
	import flash.utils.describeType;

	/**
	 * The <code><strong>ArrayClassParameterSetXMLParser</strong></code> class is
	 * a parsing utility class parsing dealing with an array of classes type parameterSets
	 */
	public class ArrayClassParameterSetXMLParser implements IParameterSetParser
	{
		/**
		 * Fills an XML with a ParameterSet and its parent Descriptor.
		 * @param xml
		 * @param instance
		 * @param parent
		 */
		public function fill(xml:XML, instance:IParameterSet, parent:IDescriptor=null):void
		{
			var clazz:Class;
			var trigger:ITrigger;
			if (xml != null)
			{
				for each (var paramNode:XML in xml.children())
				{
					instance[paramNode.name()] = [];
					for each (var node:XML in paramNode.children())
					{
						if (node.name() == "trigger")
						{
							clazz=ClassResolver.resolve(node.@type, ClassResolver.TRIGGERS_PACKAGE);
						}
						trigger=new clazz();
						var accessors:XMLList=describeType(trigger)..accessor;
						for each (var accessor:XML in accessors)
						{
							if ( accessor.@name == "uuid" )
							{
								trigger.uuid = node.@id;
							}
                            else if ( accessor.@type == "Array" )
                            {
                            	trigger[accessor.@name] = [];
                            	trigger[accessor.@name] = node.child(accessor.@name).toString().split(",");
                            }
                            else if (node.children()[0] == "true")
                            {
                                trigger[accessor.@name]=true;
                            }
                            else if (node.children()[0] == "false")
                            {
                                trigger[accessor.@name]=false;
                            }
                            else
                            {
                                trigger[accessor.@name]=node.child(accessor.@name);
                            }
						}
						(instance[paramNode.name()] as Array).push(trigger);
					}
				}
			}
		}

	}
}
