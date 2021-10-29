package com.flashiteasy.admin.parameter
{
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.utils.Metadata;
	import com.flashiteasy.admin.utils.MetadataUtil;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.factory.ClassFactory;
	import com.flashiteasy.api.ioc.IocContainer;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ParameterIntrospectionUtil
	{
		/**
		 * Retrieve the parameter sets applicable to a particular element descriptor,
		 * with value for each one if any.
		 */
		public static function retrieveParameterSets(element:IDescriptor):Array
		{
			var elementClass:Class=getDefinitionByName(getQualifiedClassName(element)) as Class;
			var factories:Array=IocContainer.getClassFactories(elementClass, IocContainer.GROUP_PARAMETERS);
			var parameterSets:Array=[];
			var definedParamSets:Array=getDefinedParameterSets(element.getParameterSet());

			// Merging defined parameters with class factories for this descriptor type
			// Notice we use standard for loops instead of for each, due to the
			// "continue label" syntax which raises an error due to a FP bug.
			outer: for (var i:int=0; i < factories.length; i++)
			{
				var clazz:Class=factories[i].generator;

				for (var j:int=0; i < definedParamSets.length; j++)
				{
					if (definedParamSets[j] is clazz)
					{
						parameterSets.push(definedParamSets[j]);
						continue outer;
					}
				}
				parameterSets.push(new clazz());
			}
			return parameterSets;
		}

		public static function getEditableParameters(descriptor:IDescriptor):Array
		{
			var parametersArray:Array=retrieveParameterSets(descriptor);
			var pArray:Array=[];
			for each (var pSet:IParameterSet in parametersArray)
			{
				var editionDescriptor:ParameterSetEditionDescriptor=getParameterSetEditionDescriptor(pSet);
				if (editionDescriptor.isEditable())
				{
					pArray.push(pSet);
				}
			}

			return pArray;
		}

		public static function getParameterList(descriptor:IDescriptor, inClass:Boolean=false):Array
		{
			var elementClass:Class=getDefinitionByName(getQualifiedClassName(descriptor)) as Class;
			var factories:Array=IocContainer.getClassFactories(elementClass, IocContainer.GROUP_PARAMETERS);
			var parameters:Array=[];
			for each (var clazz:ClassFactory in factories)
			{
				if (inClass)
				{
					parameters.push(clazz.generator);
				}
				else
				{
					parameters.push(getQualifiedClassName(clazz.generator).split("::")[1]);
				}

			}
			return parameters;
		}

		public static function getTweenableParameterList(descriptor:IDescriptor):Array
		{
			var elementClass:Class=getDefinitionByName(getQualifiedClassName(descriptor)) as Class;
			var factories:Array=IocContainer.getClassFactories(elementClass, IocContainer.GROUP_PARAMETERS);
			var parameters:Array=[];
			for each (var clazz:ClassFactory in factories)
			{
				var claz:Class=clazz.generator;
				var numericProperty:Array=getNumericPropertyList(new claz);
				if (numericProperty.length > 0)
				{
					parameters.push(getQualifiedClassName(claz).split("::")[1]);
				}
			}
			return parameters;
		}

		public static function getPropertyList(parameter:IParameterSet):Array
		{
			var accessors:XMLList=describeType(parameter)..accessor; // Liste des getter et setter du parametre
			var accessorList:Array=[];
			for each (var accessor:XML in accessors)
			{
				accessorList.push(accessor.@name);
			}
			return accessorList;
		}

		public static function getNumericPropertyList(parameter:IParameterSet):Array
		{
			var accessors:XMLList=describeType(parameter)..accessor; // Liste des getter et setter du parametre
			var accessorList:Array=[];
			for each (var accessor:XML in accessors)
			{
				//trace ("accessor : "+accessor.@name+"  / type : "+accessor.@type);
				if (accessor.@type == "Number" || accessor.@type.indexOf("int") != -1)
				{
					accessorList.push(String(accessor.@name.toString()));
				}
			}
			return accessorList;
		}

		private static function getDefinedParameterSets(rootParameterSet:IParameterSet):Array
		{
			var params:Array=[];
			if (rootParameterSet is CompositeParameterSet)
			{
				params=CompositeParameterSet(rootParameterSet).getParametersSet();
			}
			else
			{
				params=[];
				params.push(rootParameterSet);
			}
			return params;
		}

		/**
		 * extrait un parameterSet d'un descriptor ayant le meme type que le parameterSet passé en argument
		 */
		public static function retrieveParameter(parameterSet:IParameterSet, element:IDescriptor):IParameterSet
		{
			var definedParamSets:Array=getDefinedParameterSets(element.getParameterSet());
			for each (var param:IParameterSet in definedParamSets)
			{
				if (getQualifiedClassName(param) == getQualifiedClassName(parameterSet))
				{
					return param;
				}
			}
			return null;
		}

		/**
		 * Create an edition descriptor for the parameter set provided, using reflection.
		 */
		public static function getParameterSetEditionDescriptor(parameterSet:IParameterSet):ParameterSetEditionDescriptor
		{
			// Getting the type description
			var typeDesc:XML=describeType(parameterSet);
			var descriptor:ParameterSetEditionDescriptor=new ParameterSetEditionDescriptor(parameterSet);
			// Searching for the ParameterSet metadata
			var parameterSetMetadata:Metadata=MetadataUtil.getMetadata(typeDesc, "ParameterSet");
			if (parameterSetMetadata == null)
			{
				return descriptor;
			}
			try
			{
				var customClassName:String=parameterSetMetadata.getArgumentValue("customClass");
				var customClazz:Class=getDefinitionByName(customClassName) as Class
				descriptor.setCustomComponentClass(customClazz);
			}
			catch (e:Error)
			{
				// Swallowing the error, as the custom class may have not been defined (in particular if type argument is "Reflection".
			}
			descriptor.setGroupName(parameterSetMetadata.getArgumentValue("groupname"));
			descriptor.setCustom(parameterSetMetadata.getArgumentValue("type") == "Custom");
			var desc:String=parameterSetMetadata.getArgumentValue("description");
			descriptor.setDescription(desc != null ? desc.toString() : "Edit");
			// Iterating through the accessors, to retrieve the Parameter metadata tags and create corresponding Parameter instances.
			var accessors:XMLList=typeDesc..accessor;
			var parameterMetadata:Metadata;
			for each (var accessor:XML in accessors)
			{
				parameterMetadata=MetadataUtil.getMetadata(accessor, "Parameter");
				if (parameterMetadata != null)
				{
					var min:String=getMetadataValueOrDefault("min", parameterMetadata, "0");
					var max:String=getMetadataValueOrDefault("max", parameterMetadata, "100000");
					var interval:String=getMetadataValueOrDefault("interval", parameterMetadata, "1");
					var value:*=getValueOrDefaultValue(accessor.@name, parameterSet, parameterMetadata);
					// TODO min, max, etc
					var row:Number=new Number(getMetadataValueOrDefault("row", parameterMetadata, "-1"));
					var sequence:Number=new Number(getMetadataValueOrDefault("sequence", parameterMetadata, "-1"));
					var label:String=new String(getMetadataValueOrDefault("label", parameterMetadata, accessor.@name));
					var labelField:String=new String(getMetadataValueOrDefault("labelField", parameterMetadata, accessor.@name));
					descriptor.getParameters().push(new Parameter(row, sequence, parameterMetadata.getArgumentValue("type"), accessor.@name, label, value, min, max, interval, labelField));
					descriptor.setParameters(descriptor.getParameters().sortOn("sequence"));
				}
			}
			return descriptor;
		}

		public static function getParameterSetName(pset:IParameterSet):String
		{
			return getQualifiedClassName(pset).split("::")[1];
		}

		public static function getParameterFromParameterSet(parameterSet:IParameterSet):Array
		{
			var params:Array=[];
			var typeDesc:XML=describeType(parameterSet);
			var accessors:XMLList=typeDesc..accessor;
			var parameterMetadata:Metadata;
			for each (var accessor:XML in accessors)
			{
				parameterMetadata=MetadataUtil.getMetadata(accessor, "Parameter");
				if (parameterMetadata != null)
				{
					var min:String=getMetadataValueOrDefault("min", parameterMetadata, "0");
					var max:String=getMetadataValueOrDefault("max", parameterMetadata, "10000");
					var interval:String=getMetadataValueOrDefault("interval", parameterMetadata, "1");
					var value:*=getValueOrDefaultValue(accessor.@name, parameterSet, parameterMetadata);
					// TODO min, max, etc
					var row:Number=new Number(getMetadataValueOrDefault("row", parameterMetadata, "-1"));
					var sequence:Number=new Number(getMetadataValueOrDefault("sequence", parameterMetadata, "-1"));
					var label:String=new String(getMetadataValueOrDefault("label", parameterMetadata, accessor.@name));
					var labelField:String=new String(getMetadataValueOrDefault("labelField", parameterMetadata, accessor.@name));
					params.push(new Parameter(row, sequence, parameterMetadata.getArgumentValue("type"), accessor.@name, label, value, min, max, interval, labelField));
				}
			}
			params.sortOn("sequence");
			return params;
		}

		public static function getMetadataValueOrDefault(metadataKey:String, parameterMetadata:Metadata, trueDefaultValue:String=null):*
		{
			var value:*=parameterMetadata.getArgumentValue(metadataKey);
			if (value == null)
			{
				value=trueDefaultValue;
			}
			return value;
		}

		private static function getValueOrDefaultValue(accessorName:String, parameterSet:IParameterSet, parameterMetadata:Metadata):*
		{
			var value:*=getMetadataValueOrDefault("defaultValue", parameterMetadata);
			var paramValue:*=parameterSet[accessorName];
			if (!isNaN(Number(value)))
			{
				if (paramValue is Array && paramValue != null)
				{
					value=paramValue;
				}
				else if (paramValue == 0)
				{
					value=paramValue;
				}
				else if (paramValue != null && paramValue != "")
				{
					value=paramValue;
				}
			}
			else
			{
				if ((paramValue != null && paramValue != "") || (paramValue == true) || (paramValue == false))
				{
					value=paramValue;
				}
			}
			return value;
		}
	}
}