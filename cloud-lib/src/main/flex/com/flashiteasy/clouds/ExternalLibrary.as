/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.clouds
{
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.library.AbstractLibrary;
	import com.flashiteasy.api.library.BuiltInLibrary;
	import com.flashiteasy.api.parameters.ResizableParameterSet;
	import com.flashiteasy.api.xml.impl.StandardParameterSetXMLParser;
	import com.flashiteasy.clouds.lib.CloudsElementDescriptor;
	import com.flashiteasy.clouds.parameters.CloudsLayerParameterSet;
	import com.flashiteasy.clouds.lib.MovingCloud;
	
	public class ExternalLibrary extends AbstractLibrary
	{
		override protected function registerTypes() : void
		{
			trace ("registerType clouds-lib from outer loaded class");
			IocContainer.registerType( CloudsElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(CloudsElementDescriptor, IocContainer.GROUP_PARAMETERS, BuiltInLibrary.dimensionArray.concat(BuiltInLibrary.networkArray.concat(BuiltInLibrary.mediaArray.concat(BuiltInLibrary.decorationArray.concat(CloudsLayerParameterSet)))));
			
			IocContainer.registerType( CloudsLayerParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
		}
	}
}