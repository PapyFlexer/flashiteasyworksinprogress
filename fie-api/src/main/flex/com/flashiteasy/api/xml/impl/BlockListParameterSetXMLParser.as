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
	import com.flashiteasy.api.container.*;
	import com.flashiteasy.api.controls.*;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.ioc.ClassResolver;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.xml.IParameterSetParser;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	// Parser du parametre BlockListParameter
	// Creer un ensemble de bloc a partir d un xml et l insere dans une Array
	/**
	 * The <code><strong>ArrayParameterSetXMLParser</strong></code> class is
	 * a parsing utility class parsing dealing with BlockList (containers) parameterSets
	 */
	public class BlockListParameterSetXMLParser implements IParameterSetParser
	{
		/**
		 * Fills an XML with a ParameterSet and its parent Descriptor.
		 * @param x
		 * @param instance
		 * @param parent
		 */
		public function fill( x : XML, instance : IParameterSet , parent:IDescriptor = null) : void
		{
			
			var a:Array=new Array();
			var xml:XML;
			var control:IUIElementDescriptor;
			var type : Class ;
    		var params : Array ;
    		var paramSet : CompositeParameterSet ;
    		var p : IParameterSet;
    		var paramSetType:Class;
    		var c:Class;
    		var i : int;
    		var paramSetShortTypeName:String;
    		if(x!=null)
    		{
				for each(  xml in x.*  ){

					if (xml.name() == "container")
					{
        	            c=ClassResolver.resolve(xml.@type, ClassResolver.CONTAINER_PACKAGE);
            	    }
                	else
                	{
                    	c=ClassResolver.resolve(xml.@type, ClassResolver.CONTROLS_PACKAGE);
					}
    				control=new c();
    				control.uuid=xml.@id;
    				type= getDefinitionByName( getQualifiedClassName( control ) ) as Class;
    				params  = IocContainer.getInstances( type, IocContainer.GROUP_PARAMETERS );
    				paramSet = new CompositeParameterSet();
    				control.createControl(IUIElementDescriptor(parent).getPage(),IUIElementContainer(parent));
    				for( i = 0; i < params.length; i++ )
    				{
    					p  = params[ i ];
    					paramSetType = getDefinitionByName( getQualifiedClassName( p ) ) as Class;
    					var parser : IParameterSetParser = IParameterSetParser( IocContainer.getInstance(paramSetType, IocContainer.GROUP_SERIALIZATION ) );
    				
    					paramSetShortTypeName = getQualifiedClassName( p ).split("::")[1];

    					x= new XML(xml.toString());
    					if(xml.name() == "container")
    						parser.fill( x.child(paramSetShortTypeName)[0] , p , control as IUIElementContainer);
    					else
    						parser.fill( x.child(paramSetShortTypeName)[0] , p  );
    					paramSet.addParameterSet( p );
    				}
    				control.setParameterSet( paramSet );

				}
			}
		}
	}
}