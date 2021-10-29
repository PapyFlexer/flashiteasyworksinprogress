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
	import com.flashiteasy.api.container.*;
	import com.flashiteasy.api.controls.*;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.PageItems;
	import com.flashiteasy.api.core.project.storyboard.IStory;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.core.project.storyboard.Storyboard;
	import com.flashiteasy.api.core.project.storyboard.Transition;
	import com.flashiteasy.api.core.project.storyboard.Update;
	import com.flashiteasy.api.ioc.ClassResolver;
	import com.flashiteasy.api.ioc.IocContainer;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.xml.IParameterSetParser;
	import com.gskinner.motion.easing.Linear;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	// Classe contenant les parsers XML de fichiers
	/**
	 * The <code><strong>XMLParser</strong></code> class is
	 * an utility class parsing the XMLs that describe project pages
	 */
	public class XMLParser
	{

		private static var numXML:int=0;
		
		/**
		 * Transforms an XML into a Descriptor
		 * @param xml
		 * @return a SimpleUIElementDescriptor instance
		 */
		public static function createComponent(xml:XML):SimpleUIElementDescriptor
		{
			var control:SimpleUIElementDescriptor;
			var c:Class;
			//trace("create component " + xml.toString());
			if (xml.name() == "container")
			{
				c=ClassResolver.resolve(xml.@type, ClassResolver.CONTAINER_PACKAGE);
			}
			else
			{
				c=ClassResolver.resolve(xml.@type, ClassResolver.CONTROLS_PACKAGE);
			}

			control=new c();
			(control as IUIElementDescriptor).uuid=xml.@id;
			return control;
		}

		/**
		 * Inits a Descriptor
		 * @param xml
		 * @return 
		 */
		public static function initComponent(xml:XML):SimpleUIElementDescriptor
		{
			var control:SimpleUIElementDescriptor=XMLParser.createComponent(xml);

			return control;
		}

		// Parser d un bloc XML 
		// Parse le parametre XML du bloc XMLELEMENTDESCRIPTOR
		// Creer un container general pour contenir l ensemble des control decrit dans le XML 
		// puis le retourne

		/**
		 * Parses the XML from the 'XMLElementDescriptor' block, creates a container with all children described and returns it.
		 * @param x
		 * @param parent
		 * @return 
		 */
		public static function parseXmlBlock(x:XML, parent:IUIElementContainer=null):BlockElementDescriptor
		{

			var xml:XML;
			//var re:RegExp;
			var paramSetType:Class;
			var p:IParameterSet;
			var general_container:BlockElementDescriptor;
			var paramSetShortTypeName:String;
			var parser:IParameterSetParser;
			var x:XML;
			var c:Class;
			var type:Class;
			var params:Array;
			var Arrayblocks:Array;
			var paramSet:CompositeParameterSet;
			var control:IUIElementDescriptor;

			// Creation d un bloc general  contenir l ensemble des elements du bloc XML

			general_container=new BlockElementDescriptor();
			(general_container as BlockElementDescriptor).createControl(parent.getPage(),parent);
			// ajout du container au parent 
			Arrayblocks = [];
			// liste des blocs 
			//==========================

			numXML++;
			// DEBUT DU PARSE XML

			for each(xml in x.*)
				// Pour chaque noeud du xml ( qui decrit un control ou container )
			{
				// Recuperation du nom de la classe de l element et initialisation
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

				// Ajout du bloc dans le bloc general

				control.createControl(general_container.getPage(),general_container);

				// Initialisation des variables pour traiter les parameterSet 

				// Recuperation de la liste des parametres du bloc
				type=getDefinitionByName(getQualifiedClassName(control))as Class;
				params=IocContainer.getInstances(type, IocContainer.GROUP_PARAMETERS);
				paramSet=new CompositeParameterSet();
				// Liste des parametres a injecter dans le bloc

				for(var i:int=0; i < params.length; i++)
					// Pour chaque parametre du bloc 
				{
					p=params[i];
					paramSetType=getDefinitionByName(getQualifiedClassName(p))as Class;

					// Parser utilisé pour le parametre
					parser=IParameterSetParser(IocContainer.getInstance(paramSetType, IocContainer.GROUP_SERIALIZATION));

					/*re= new RegExp("(<(control|container).+id=\""+control.uuid+".*>.+)","si");
					   var result:Array=re.exec(xml.toString());


					 x= new XML(result[1]);*/
					paramSetShortTypeName=getQualifiedClassName(p).split("::")[1];
					x=new XML(xml.toString());
					// XML du bloc
					// Parse du xml 
					if (control is IUIElementContainer)
						parser.fill(x.child(paramSetShortTypeName)[0], p, IUIElementContainer(control));
					else
						parser.fill(x.child(paramSetShortTypeName)[0], p);
					// Ajout du parametre dans la liste des parametre du control
					paramSet.addParameterSet(p);
				}

				// Ajout des parametres dans le control 

				control.setParameterSet(paramSet);

			}

			// Container general envoyer au xmlelementdescriptor
			general_container.uuid="XMLContainer " + numXML;
			return general_container;
		}

		// Fonction chargeant une page a partir de son XML 

		/**
		 * Parses a project page using its XML.
		 * @param page
		 * @param x
		 * @param parent
		 * @return 
		 */
		public static function parseXML(page : Page, x:XML, parent:IUIElementContainer=null):PageItems
		{

			var xml:XML;
			var paramSetType:Class;
			var p:IParameterSet;
			var paramSetShortTypeName:String;
			var parser:IParameterSetParser;
			var tmp_xml:XML;
			var c:Class;
			var type:Class;
			var params:Array;
			var paramSet:CompositeParameterSet;
			var control:IUIElementDescriptor;
			var controls : Array = [];
			var action : IAction;
			var actions : Array = [];
			var story : IStory;
			var stories : Array = [];
			var pageItems:PageItems = new PageItems();
			var isInApp : Boolean = LoaderUtil.isInApplication();

			// DEBUT DU PARSE XML
			
			// Pour chaque noeud du xml ( qui decrit un control ou container )
			
			// Trying to find Application class, if not found the application is ran outside editor
			
			for each(xml in x.*)
			{

				if (xml.name() == "storyboard" || xml.name() == "animation" ) 
				{ 
					// swallowing error for storyboard Node
				}
				else if ( xml.name() == "action")
				{
					c=ClassResolver.resolve(xml.@type, ClassResolver.ACTION_PACKAGE);
					action = new c();
					action.uuid = xml.@id;
					actions.push(action);
					
					type=getDefinitionByName(getQualifiedClassName(action))as Class;
					params=IocContainer.getInstances(type, IocContainer.GROUP_PARAMETERS);
					paramSet=new CompositeParameterSet();
					
                    for(var j:int=0; j < params.length; j++)
                    {
                        p=params[j];
                        paramSetType=getDefinitionByName(getQualifiedClassName(p))as Class;
    
                        parser=IParameterSetParser(IocContainer.getInstance(paramSetType, IocContainer.GROUP_SERIALIZATION));
    
                        paramSetShortTypeName=getQualifiedClassName(p).split("::")[1];
                        tmp_xml=new XML(xml.toString());
                        parser.fill(tmp_xml.child(paramSetShortTypeName)[0], p, action as IAction);
                        
                        paramSet.addParameterSet(p);
                    }
					
					action.setParameterSet(paramSet);
					action.createAction(page);
					//if ( !isInApp )
					//{
						//action.applyEvents();
					//}
				}
				else
				{
					// Recuperation du nom de la classe de l element et l initialise
					if (xml.name() == "container")
					{
	                    c=ClassResolver.resolve(xml.@type, ClassResolver.CONTAINER_PACKAGE);
					}
					else if ( xml.name() == "control" )
					{
                        c=ClassResolver.resolve(xml.@type, ClassResolver.CONTROLS_PACKAGE);
					}
	
					control=new c();
					control.uuid=xml.@id;
					controls.push(control);
					// Ajout du control a son parent
	
					if (parent == null)
						control.createControl(page , null, true);
					else
						control.createControl(page , parent, true);
	
					// Initialisation des variables pour traiter les parameterSet 
					unserializeParameters( control , xml ) ;
				}
			}
            
            pageItems.pageControls = controls;
            pageItems.pageActions = actions;
			return pageItems;

		}
		
		/**
		 * Parses a page storyboard, using the 'storyboard' node in page's XML.
		 * @param page
		 * @param x
		 * @param pageItems
		 * @return 
		 */
		public static function parseStoryboard( page : Page, x : XML, pageItems : PageItems ) : Storyboard
		{
			var xStoryboard : XML = x.child("storyboard")[0];
			var storyboard : Storyboard = new Storyboard();
			
			if( xStoryboard != null )
			{
				var stories : XMLList = xStoryboard.story;
				for each( var xStory : XML in stories )
				{
					var s : Story = new Story();
					s.createStory(page);
					s.init( xStory.@uuid, getDescriptor( xStory.@target, pageItems ), xStory.@loop=="true", xStory.@autoPlay=="true" , xStory.@autoPlayOnUnload=="true" );
					// Parsing the internal updates...
					var updates : XMLList = xStory.update;
					var param : CompositeParameterSet = new CompositeParameterSet
					var updateId : int = -1;
					for each( var xUpdate : XML in updates )
					{
						var update : Update = new Update();
						update.init( xUpdate.@target, xUpdate.@targetProperty, s.uuid+String(updateId++), s );
						update.setTransitions( buildTransitions( xUpdate.keyframe ) );
						s.addUpdate( update );
					}
					storyboard.addStory( s );
				}
			}
			pageItems.pageStories = storyboard.getStories();
			return storyboard;
		}
		
		/**
		 * When parsing storyboards, transitions are defined by keyframes. This method instanciates correctly the transitions with their begin and end properties.
		 * @param xKeyframes
		 * @return 
		 */
		private static function buildTransitions( xKeyframes : XMLList ) : Array
		{
			var keyframes : Array = [];
			var transitions : Array = [];
			// First pass, we order the keyframes
			for each( var xKeyframe : XML in xKeyframes )
			{
				keyframes.push( xKeyframe );
			}
			keyframes.sortOn( "@time", Array.NUMERIC );
			// Second pass, we create a transition for each step
			for( var i : int = 1; i < keyframes.length; i++ )
			{
				var t : Transition = new Transition();
				//
				t.begin = new int( keyframes[ i-1].@time );
				t.end = new int( keyframes[ i ].@time );
				if(keyframes[ i-1 ].child("value")[0] != null )
				{
					t.beginValue=keyframes[ i-1 ].child("value")[0].text();
				}
				if(keyframes[ i ].child("value")[0] != null )
				{
					t.endValue=keyframes[ i ].child("value")[0].text();
				}
				if( keyframes[ i ].child("easing") != null && keyframes[ i ].child("easing").@type != null )
				{
					// TODO The easing classes should be parameterized using a specific parser based on reflection
					t.easingClass = ClassResolver.resolve(keyframes[ i ].child("easing").@type, ClassResolver.GSKINNER_EASING);
					t.easingType = keyframes[ i ].child("easing").@easingType;
				}
				else
				{
					// if no easing is registered then we set it to default
					t.easingClass = Linear; 
					t.easingType = "easeNone";
				}
				transitions.push( t );
			}
			return transitions;
		}
		
		/**
		 * Returns a given descriptor from the ElementList using its uuid 
		 * @param id
		 * @param a
		 * @return 
		 */
		private static function getDescriptorFromArray( id : String, a : Array ) : IDescriptor
		{
			var desc : IDescriptor;
			for each( desc in a )
			{
				if( desc.uuid == id )
				{
					return desc;
				}
				else if( desc is MultipleUIElementDescriptor )
				{
					var o : IDescriptor = getDescriptorFromArray( id, MultipleUIElementDescriptor( desc ).getChildren() );
					if( o != null )
					{
						return o;
					}
				}
			}
			return null;
		}
		
		/**
		 * Returns a given descriptor from the PageItems object using its uuid 
		 * @param id
		 * @param pageItems
		 * @return 
		 */
		private static function getDescriptor( id :String, pageItems : PageItems  ) : IDescriptor
		{
			var o : IDescriptor = getDescriptorFromArray( id, pageItems.pageControls );
			if( o != null )
			{
				return o;
			}
			// FIXME Should actions be incorporated ? I guess so...
			o = getDescriptorFromArray( id, pageItems.pageActions );
			if( o != null )
			{
				return o;
			}
			// ANIMATIONS too ?
			o = getDescriptorFromArray( id, pageItems.pageStories );
			if( o != null )
			{
				return o;
			}
			return null;
			//throw new Error("Unable to find descriptor with uuid : " + id);
		}

		// create parameters from an xml and set them to a descriptor

		/**
		 * Unserializes a control parameters
		 * @param control
		 * @return 
		 */
		public static function unserializeParameters(control:IUIElementDescriptor , xml : XML ):void
		{
			var type:Class=getDefinitionByName(getQualifiedClassName(control))as Class;
			var params:Array=IocContainer.getInstances(type, IocContainer.GROUP_PARAMETERS);
			var paramSet:CompositeParameterSet=new CompositeParameterSet();
			var p:IParameterSet;
			for(var i:int=0; i < params.length; i++)
			{
				p=params[i];
				var paramSetType:Class=getDefinitionByName(getQualifiedClassName(p))as Class;
				var parser:IParameterSetParser=IParameterSetParser(IocContainer.getInstance(paramSetType, IocContainer.GROUP_SERIALIZATION));
				// spaghetti part ... Just for the sample, XML controls should be parsed into a dedicated class
				var paramSetShortTypeName:String=getQualifiedClassName(p).split("::")[1];
				var tmp_xml : XML =new XML(xml.toString());

				parser.fill(tmp_xml.child(paramSetShortTypeName)[0], p, control as IUIElementContainer);

				paramSet.addParameterSet(p);
			}
			control.setParameterSet(paramSet);
		}
	}
}

