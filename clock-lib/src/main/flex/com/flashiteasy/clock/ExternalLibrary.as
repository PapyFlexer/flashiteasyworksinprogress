/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */
package com.flashiteasy.clock
{
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.library.AbstractLibrary;
	import com.flashiteasy.api.library.BuiltInLibrary;
	import com.flashiteasy.api.xml.impl.ArrayParameterSetXMLParser;
	import com.flashiteasy.clock.lib.ClockElementDescriptor;
	import com.flashiteasy.clock.parameters.ClockParameterSet;
	 
	public class ExternalLibrary extends AbstractLibrary
	{
		override protected function registerTypes() : void
		{
			trace ("registerType clock-lib from outer loaded class");
			IocContainer.registerType( ClockElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			IocContainer.registerTypeList(ClockElementDescriptor, IocContainer.GROUP_PARAMETERS, BuiltInLibrary.dimensionArray.concat(BuiltInLibrary.networkArray.concat(BuiltInLibrary.mediaArray.concat(BuiltInLibrary.decorationArray.concat(ClockParameterSet)))));
			IocContainer.registerType( ClockParameterSet, IocContainer.GROUP_SERIALIZATION, ArrayParameterSetXMLParser);
		}
	}
}