/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 *
 */

package com.flashiteasy.sample
{
	import com.flashiteasy.api.core.AbstractParameterSet;
	import com.flashiteasy.api.core.FieUIComponent;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.library.AbstractLibrary;
	import com.flashiteasy.api.library.BuiltInLibrary;
	import com.flashiteasy.api.xml.impl.StandardParameterSetXMLParser;
	import com.flashiteasy.sample.editor.impl.SimpleBackgroundColorEditorImpl;
	import com.flashiteasy.sample.lib.CircleElementDescriptor;
	import com.flashiteasy.sample.parameters.CircleBackgroundColorParameterSet;
	
	/**
	 * The <code><strong>ExternalLibrary</strong></code> class takes charge of the
	 * element loading at runtime as well as the registering of classes.
	 * It is the most important class to write in any API project, as long
	 * as no objet would show in the ControlList of the admin. Moreover,
	 * the object would not serialize unserialize itself.
	 * Last, no dependancies would link the ParameterSet to the descriptor.
	 * <p>
	 * The registerTypes methods does the following things
	 * <ul>
	 * <li>step 1 : <code><strong>IocContainer.registerType( CircleElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent)</strong></code> register the CircleElementDescriptor</li>
	 * <li>step 2 : <code><strong>IocContainer.registerSimpleType(SimpleBackgroundColorEditorImpl)</strong></code> register the custom editor</li>
	 * <li>step 3 : <code><strong>IocContainer.registerTypeList( CircleElementDescriptor, IocContainer.GROUP_PARAMETERS, BuiltInLibrary.dimensionArray.concat(BuiltInLibrary.decorationArray.concat(CircleBackgroundColorParameterSet)))</strong></code> build your element by linking your Descriptor with available ParameterSets : concatenating dimensionArray, decorationArray and the custom pSet : CircleBackgroundColorParameterSet</li>
	 * <li>step 4 : <code><strong>IocContainer.registerType(CircleBackgroundColorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);</strong></code>  register the way the component will be parsed</li>
 	 * </ul>
	 * </p>
	 */
	public class ExternalLibrary extends AbstractLibrary
	{
		/**
		 * @inheritDoc
		 */
		override protected function registerTypes() : void
		{
			/** registers the CircleElement **/
			IocContainer.registerType( CircleElementDescriptor, IocContainer.GROUP_FACES, FieUIComponent);
			/** register the custom editor **/
			IocContainer.registerSimpleType(SimpleBackgroundColorEditorImpl);
			/** build your element by linking your Descriptor with available ParameterSets :
			 * concatenating dimensionArray, decorationArray and the custom pSet : CircleBackgroundColorParameterSet
			/*/
			IocContainer.registerTypeList( CircleElementDescriptor, IocContainer.GROUP_PARAMETERS, BuiltInLibrary.dimensionArray.concat(BuiltInLibrary.decorationArray.concat(CircleBackgroundColorParameterSet)));
			/** register the way the component will be parsed  **/
			IocContainer.registerType(CircleBackgroundColorParameterSet, IocContainer.GROUP_SERIALIZATION, StandardParameterSetXMLParser);
		}
	}
}