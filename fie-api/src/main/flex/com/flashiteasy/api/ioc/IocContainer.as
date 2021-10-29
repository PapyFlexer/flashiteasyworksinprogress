/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.api.ioc
{
	import com.flashiteasy.api.factory.ClassFactory;
	import com.flashiteasy.api.utils.ArrayUtils;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The <code><strong>IocConatiner</strong></code> class is an implementation
	 * of the Injection of control / dependancy inversion design pattern
	 */
	public class IocContainer
	{
		/**
		 * Visual controls
		 * @default 
		 */
		public static const GROUP_FACES : String = "Faces";
		
		/**
		 * Interaction controls
		 * @default 
		 */
		public static const GROUP_ACTIONS : String = "Actions";
		
		/**
		 * Animations
		 * @default 
		 */
		public static const GROUP_ANIMATIONS : String = "Animations";
		
		/**
		 * ParameterSets
		 * @default 
		 */
		public static const GROUP_PARAMETERS : String = "Parameters";
		
		/**
		 * Serialization methods
		 * @default 
		 */
		public static const GROUP_SERIALIZATION : String = "Serialization";
		
		/**
		 * Serialization methods
		 * @default 
		 */
		public static const GROUP_EXTERNAL : String = "External";
		
		// Dictionary is an "ugly" type.
		// Should use an appropriate Map type, but it's simpler for the sample 
		private static var singleTypes : Dictionary = new Dictionary();
		private static var multipleTypes : Dictionary = new Dictionary();
		
		public static var externalDescriptors : Array = new Array();
		/**
		 * Do-nothing method.
		 * Here to force the developer to register its classes
		 * so the compiler adds them to the compilation unit.
		 * @param type
		 */
		public static function registerSimpleType( type: Class ) : void
		{
			// 
		}
		
		/**
		 * Registers Classes in a group. 
		 * @param type
		 * @param group
		 * @param clazz
		 */
		public static function registerType( type: Class, group : String, clazz : Class ) : void
		{
			// TODO Should check whether interfaz is actually an interface.
			if( singleTypes[ group ] == null )
			{
				singleTypes[ group ] = new Dictionary();
			}
			singleTypes[ group ][ getQualifiedClassName( type ) ] = new ClassFactory( clazz );
		}
		
		/**
		 * Finds the correct ClassFactory for each type of element
		 * @param type
		 * @param group
		 * @return 
		 */
		public static function getClassFactory( type: Class, group : String ) : ClassFactory
		{
			return singleTypes[group][ getQualifiedClassName( type ) ];
		}
		
		/**
		 * Dynamic instanciation.
		 * @param type
		 * @param group
		 * @return 
		 */
		public static function getInstance( type: Class, group : String ) : Object
		{
			return getClassFactory( type, group ).newInstance();
		}
		
		/**
		 * Registers element types in correct groups, with added ParameterSets
		 * @param type
		 * @param group
		 * @param types
		 */
		public static function registerTypeList( type: Class, group : String, types : Array ) : void
		{
			// TODO Should check whether interfaz is actually an interface.
			if( multipleTypes[ group ] == null )
			{
				multipleTypes[ group ] = new Dictionary();
			}
			multipleTypes[ group ][ getQualifiedClassName( type ) ] = [];
			for each( var typeItem : Class in types )
			{ 
				multipleTypes[ group ][ getQualifiedClassName( type ) ].push( new ClassFactory( typeItem ) );
			}
		}
		
		/**
		 * Array implementation of the getClassFactory method (see higher)
		 * @param type
		 * @param group
		 * @return 
		 */
		public static function getClassFactories( type: Class, group : String ) : Array
		{
			return multipleTypes[group][ getQualifiedClassName( type ) ];
		}
		
		/**
		 * Array implementation of the getInstance method (see higher)
		 * @param type
		 * @param group
		 * @return 
		 */
		public static function getInstances( type: Class, group : String ) : Array
		{
			var instances : Array = [];
			var factories : Array = getClassFactories( type, group );
			for each( var factory : ClassFactory in factories )
			{
				instances.push( factory.newInstance() );
			}
			return instances;
		}
		
		/**
		 * 
		 * @return 
		 */
		public static function getControls():Array 
		{
			var controls : Array = [] ;
			//var test : * = IocContainer.singleTypes[ IocContainer.GROUP_FACES ];
			for (var control:String in IocContainer.singleTypes[ IocContainer.GROUP_FACES ])
			{
				controls.push(control);
				if (control.indexOf("api") == -1 && !ArrayUtils.containsString(control, IocContainer.externalDescriptors)) IocContainer.externalDescriptors.push(control);
			}
			controls.sort(Array.CASEINSENSITIVE);
			return controls ;
		}
		
		/**
		 * Returns action list
		 */
		public static function getActions() : Array
		{
			var actions : Array = [];
            for (var action:String in IocContainer.singleTypes[ IocContainer.GROUP_ACTIONS ])
            {
                actions.push(action);
            }
            actions.sort(Array.CASEINSENSITIVE);
           //trace("tracing " + actions);
            return actions ;
		} 

	}
}