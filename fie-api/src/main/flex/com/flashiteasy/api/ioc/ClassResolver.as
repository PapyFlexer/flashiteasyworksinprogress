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
	
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author gillesroquefeuil
	 */
	public class ClassResolver
	{
		/**
		 * 
		 * @default 
		 */
		public static const ACTION_PACKAGE			: String = "com.flashiteasy.api.action";
		/**
		 * 
		 * @default 
		 */
		public static const ANIMATION_PACKAGE		: String = "com.flashiteasy.api.animation";
		/**
		 * 
		 * @default 
		 */
		public static const CONTAINER_PACKAGE		: String = "com.flashiteasy.api.container";
		/**
		 * 
		 * @default 
		 */
		public static const CONTROLS_PACKAGE		: String = "com.flashiteasy.api.controls" ;
		/**
		 * 
		 * @default 
		 */
		public static const PARAMETERS_PACKAGE		: String = "com.flashiteasy.api.parameters" ;
		/**
		 * 
		 * @default 
		 */
		public static const TRIGGERS_PACKAGE		: String = "com.flashiteasy.api.triggers" ;
		/**
		 * 
		 * @default 
		 */
		public static const EASING_PACKAGE			: String = "com.flashiteasy.api.easing" ;
		/**
		 * 
		 * @default 
		 */
		public static const GSKINNER_EASING         : String = "com.gskinner.motion.easing";
		/**
		 * 
		 * @default 
		 */
		public static const VALIDATOR_PACKAGE		: String = "com.flashiteasy.api.controls.Validator";
		
		/**
		 * 
		 * @param name
		 * @param defaultPackage
		 * @return 
		 */
		public static function resolve( name : String, defaultPackage : String ) : Class
		{
			var c : Class;
			try
			{
    			c=getDefinitionByName(defaultPackage + "." + name) as Class;
   			}
   			catch( e : Error )
   			{
   				//trace("Could not find component " + name + " into the default package, trying to retrieve class using FQCN.");
   				c = getDefinitionByName( name ) as Class;
   			}
   			return c;
		}

	}
}