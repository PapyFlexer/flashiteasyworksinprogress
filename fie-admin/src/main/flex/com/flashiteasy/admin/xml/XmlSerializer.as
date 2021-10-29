package com.flashiteasy.admin.xml
{
	import com.flashiteasy.admin.conf.Conf;
	import com.flashiteasy.admin.converter.RteHtmlParser;
	import com.flashiteasy.admin.edition.ParameterSetEditionDescriptor;
	import com.flashiteasy.admin.fieservice.FileManagerService;
	import com.flashiteasy.admin.parameter.ParameterIntrospectionUtil;
	import com.flashiteasy.admin.utils.BitmapUtils;
	import com.flashiteasy.admin.utils.Metadata;
	import com.flashiteasy.admin.utils.MetadataUtil;
	import com.flashiteasy.api.container.DynamicListElementDescriptor;
	import com.flashiteasy.api.container.ListElementDescriptor;
	import com.flashiteasy.api.container.XmlElementDescriptor;
	import com.flashiteasy.api.controls.SimpleUIElementDescriptor;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IAction;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.ITrigger;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.project.Page;
	import com.flashiteasy.api.core.project.storyboard.Story;
	import com.flashiteasy.api.indexation.IndexationManager;
	import com.flashiteasy.api.indexation.PageInformation;
	import com.flashiteasy.api.parameters.TriggerParameterSet;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.selection.StoryList;
	import com.flashiteasy.api.utils.NumberUtils;
	import com.flashiteasy.api.utils.PageUtils;
	import com.flashiteasy.api.utils.StringUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;

	public class XmlSerializer
	{
		
		
		private static var xmlActions : Array = [];
		public static function serializePage(page:Page, mode:String="normal", pageToIndex : Page=null, pageLevel:int=1):XML
		{
			
			var elements:Array=ElementList.getInstance().getTopLevelElements(page);
			var pageXML:XML;
			if (mode == "html")
			{
				pageXML=new XML("<page link='" + PageUtils.getLinkToHome(pageLevel) + "' url='" + pageToIndex.getPageUrl() + "'></page>");
			}
			else
			{
				pageXML=new XML("<page></page>");
			}
			
			
			for each (var element:IUIElementDescriptor in elements)
			{
				
				pageXML.*+=serializeControl(element, mode);
			}

			var actions:Array=mode == "html" ? ActionList.getInstance().getActions(page).concat(xmlActions) : ActionList.getInstance().getActions(page);
			for each (var action:IAction in actions)
			{
				
				var actionNode:XML = serializeAction(action, mode);
				if(actionNode.valueOf() != null)
					pageXML.*+=actionNode;
			}
			var storyboardNode:XML=new XML("<storyboard></storyboard>");
			var stories:Array=StoryList.getInstance().getStories(page);
			for each (var s:Story in stories)
			{
				storyboardNode.*+=serializeStory(s);
			}
			// if html mode, insert all stories and actions
			if (mode == "html" && pageLevel!=1)
			{
				var pageTemp:Page = pageToIndex;
				var actionsToAdd : Array = [];
				var storiesToAdd : Array = [];
				while (pageTemp.parentIsPage)
				{
					actionsToAdd=ActionList.getInstance().getActions(pageTemp);
					storiesToAdd=StoryList.getInstance().getStories(pageTemp);
					for each (var actionToAdd:IAction in actionsToAdd)
					{
						pageXML.*+=serializeAction(actionToAdd, mode);
					}
					for each (var storyToAdd:Story in storiesToAdd)
					{
						storyboardNode.*+=serializeStory(storyToAdd);
					}
					pageTemp = Page(pageTemp.getParent());
				}
			}
			
			pageXML.*+=storyboardNode;
			
			// if html mode, insert metadata into XML
			if (mode == "html")
			{
				var metadataNode:XML = new XML("<metas></metas>");
 				
 				metadataNode.*+=new XML("<gc>"+IndexationManager.getInstance().googlecode+"</gc>");
				metadataNode.*+=new XML("<href>#/"+pageToIndex.getPageUrl()+"</href>");
				
 				var pi : PageInformation  = IndexationManager.getInstance().getPageInformation(pageToIndex);
				if(pi != null ) 
				{
					metadataNode.* += new XML( pi.serializePageMetaData(pi) );
				}
				pageXML.* += metadataNode;
			}
			pageXML.normalize();
			xmlActions = [];
			return pageXML;

		}

		
		/**
		 * Serializes a control
		 */
		public static function serializeControl(control:IUIElementDescriptor, mode:String="normal"):XML
		{

			var nodeXml:XML=XMLUtils.createControlXML(control, mode);
			var clazz:String;
			var accessors:XMLList;
			var parameters:Array=CompositeParameterSet(control.getParameterSet()).getParametersSet();
			var htmlConverter:RteHtmlParser;
			if (mode == "html")
			{
				htmlConverter=new RteHtmlParser;
			}

			// Transform each parameter into an XML

			for each (var param:IParameterSet in parameters)
			{
				var node:XML = serializeParameter(control, param, mode);
				if(node.valueOf() != null)
					nodeXml.*+=node;
			}
			return nodeXml;
		}



		private static function serializeParameter(control:IUIElementDescriptor, param:IParameterSet, mode:String="normal", composite:Boolean=false):XML
		{
			var clazz:String;
			var nodeXml:XML;

			// Get parameterSet class name
			clazz=getQualifiedClassName(param).split("::")[1];
			nodeXml=new XML("<" + clazz + "></" + clazz + ">");

			// If the parameter is a blockListParameterset , it means the control is a container 
			// serialize it s children 
			if (clazz == "BlockListParameterSet" && (!(control is XmlElementDescriptor) || mode == "html") && !(control is DynamicListElementDescriptor))
			{
				var children:Array=IUIElementContainer(control).getChildren();
				if(control is XmlElementDescriptor)
				{
					var actions : Array = ActionList.getInstance().getActions(XmlElementDescriptor(control).getXml())
					xmlActions = xmlActions.concat(actions);
					
				}
				for each (var child:IUIElementDescriptor in children)
				{
					var x:XML=serializeControl(child, mode);
					nodeXml.*+=x; //serializeControl(child);
				}
			}
			else
			{

				var descriptor:ParameterSetEditionDescriptor=ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param);
				var isValidator : Boolean = false;
				//trace ("serializing pSet :: "+getQualifiedClassName(param).split("::")[1]);
				//We just serialise parameterSet that have Metadata
				if (descriptor.getDescription() != null || composite)
				{
					// list of parameterSet's accessor
					var accessors:XMLList=describeType(param)..accessor;

					for each (var accessor:XML in accessors)
					{

						nodeXml=saveField(control, nodeXml, accessor, clazz, param, mode, composite);
					}

					//create an empty node if no accessors have been set
					if (nodeXml.children().length() == 0)
					{
						nodeXml=new XML();
					}
				}
			}
			return nodeXml;
		}

		private static function saveField(control:IUIElementDescriptor, nodeXml:XML, accessor:XML, clazz:String, param:IParameterSet, mode:String, composite:Boolean=false):XML
		{

			try
			{
				var save:Boolean=false;

				// ignore field with no set values
				if ((param[accessor.@name] == null || param[accessor.@name] == ""))
				{
					// to avoid a nasty bug because "" == false ...
					if (param[accessor.@name] is Boolean)
					{
						save=true;
					}
					// to avoid a nasty bug because 0 == null ... 
					if (param[accessor.@name] is Number && param[accessor.@name] == 0)
					{
						save=true;
					}
				}
				else
				{
					save=true;
				}

				if (save)
				{

					var stringValue:String;
					var booleanValue:Boolean;
					var numberValue:Number;

					var parameterValue:String;



					var accessorMetadata:Metadata=MetadataUtil.getMetadata(accessor, "Parameter");

					//Getting defaultValue if some properties don't have metadata we still serialise them
					var defaultValue:*=accessorMetadata != null ? ParameterIntrospectionUtil.getMetadataValueOrDefault("defaultValue", accessorMetadata) : null;
					//first make Position for html
					if (clazz == "PositionParameterSet" && mode == "html" && (accessor.@name == "x" || accessor.@name == "y"))
					{
						parameterValue=String(getAbsolutePosition(accessor.@name, param[accessor.@name], control));
					}
					if (clazz == "SizeParameterSet" && mode == "html" && (accessor.@name == "width" || accessor.@name == "height"))
					{
						parameterValue=String(getAbsoluteSize(accessor.@name, param[accessor.@name], control));
					}


					//if parameter value is default it's not neccessary to write it
					//compare as String because defaultValue is always a String
					if (String(param[accessor.@name]) != defaultValue)
					{
						if (accessor.@name.indexOf("color") != -1 || accessor.@name.indexOf("Color") != -1)
						{
							var value:Number=Number(param[accessor.@name]);
							if (!isNaN(value))
							{
								if (mode == "html" && clazz == "BackgroundColorParameterSet")
								{

									trace("RGB String: " + NumberUtils.hexadecimalToRgbString(value));

									parameterValue=NumberUtils.hexadecimalToRgbString(value);
								}
								else
								{
									parameterValue="0x" + NumberUtils.numberToHexadecimalString(value);
								}
							}
							else
							{
								parameterValue=param[accessor.@name];
							}
						}
						else if (clazz == "TextParameterSet" && accessor.@name == "text")
						{
							if (mode == "html")
							{
								var htmlConverter:RteHtmlParser=new RteHtmlParser;
								htmlConverter.ParseToHTML(String(param[accessor.@name]));
								parameterValue=htmlConverter.StringFormat;
							}
							else
							{
								parameterValue=param[accessor.@name];
							}
						}
						else if (clazz == "PositionParameterSet")
						{
							if (mode != "html" || (accessor.@name != "x" && accessor.@name != "y"))
							{

								parameterValue=param[accessor.@name];
							}

						}
						else if (clazz == "SizeParameterSet")
						{
							if (mode != "html" || (accessor.@name != "width" && accessor.@name != "height"))
							{

								parameterValue=param[accessor.@name];
							}

						}
						else if ((clazz == "ImgParameterSet" || clazz == "BackgroundImageParameterSet") && mode == "html" && accessor.@name == "source")
						{
							if(param[accessor.@name].split(".")[1] == "swf")
							{
								//if (clazz == "ImgParameterSet")
								//{
									doExportBitmap(control,param[accessor.@name],clazz);
								/*}
								else
								{
									var back : Loader = SimpleUIElementDescriptor(control).getBackgroundImage();
									doExportBitmapLoader(back,param[accessor.@name]);
								}*/
								parameterValue=param[accessor.@name].split(".")[0]+".png";
							}
							else
							{
								parameterValue=param[accessor.@name];
							}

						}
						else
						{
							//if parameter value is default it's not neccessary to write it
							//compare as String because defaultValue is always a String
							if (String(param[accessor.@name]) != defaultValue)
							{
								parameterValue=param[accessor.@name];
							}
						}
					}

					if (parameterValue != null && parameterValue != "")
					{
						if (composite)
						{
							nodeXml[accessor.@name]=parameterValue;

						}
						else
						{

							nodeXml[accessor.@name]=parameterValue;
						}
					}
					if (param is CompositeParameterSet)
					{
						var compositeParameters:Array=CompositeParameterSet(param).getParametersSet();
						for each (var compositeParam:IParameterSet in compositeParameters)
						{
							nodeXml.*+=serializeParameter(control, compositeParam, mode, true);
						}
					}
				}
			}
			// Swallowing access error for writeonly accessors
			catch (e:Error)
			{
			}

			return nodeXml;
		}


		/**
		 * Serializes an action
		 */
		public static function serializeAction(action:IAction, mode:String="normal"):XML
		{
			var nodeXml:XML=XMLUtils.createActionXML(action, mode);
			var clazz:String;
			var accessors:XMLList;
			var parameters:Array=CompositeParameterSet(action.getParameterSet()).getParametersSet();
			var paramValue:*;

			for each (var param:IParameterSet in parameters)
			{
				clazz=getQualifiedClassName(param).split("::")[1];
				nodeXml.*+=new XML("<" + clazz + "></" + clazz + ">");
				accessors=describeType(param)..accessor;

				for each (var accessor:XML in accessors)
				{
					try
					{
						paramValue=param[accessor.@name];
						if (paramValue == null)
						{
							//nodeXml.child(clazz)[accessor.@name]="";
						}
						else
						{
							if (accessor.@type == "com.flashiteasy.api.core.project::Page")
							{
								nodeXml.child(clazz)[accessor.@name]=Page(paramValue).link;
							}
							else if (accessor.@type == "Array" && param is TriggerParameterSet)
							{
								writeXMLArray(paramValue, nodeXml, clazz, accessor.@name);
							}
							else
							{
								nodeXml.child(clazz)[accessor.@name]=paramValue;
							}
						}
					}
					// Swallowing access error for writeonly accessors
					catch (e:Error)
					{
					}
				}
			}

			return nodeXml;
		}

		/**
		 * Serializes an animation
		 */
		public static function serializeStory(s:Story):XML
		{
			var nodeXml:XML=XMLUtils.createStoryXML(s);
			return nodeXml;
		}

		/*public static function getAbsolutePosition(propertyName:String, parameterValue:String, control:IUIElementDescriptor):Number
		{
			var value:Number=Number(parameterValue);
			var parent:IUIElementContainer=control.getParent();
			var element:SimpleUIElementDescriptor=SimpleUIElementDescriptor(control);
			var angleRadians : Number = (element.getFace().rotation * (Math.PI / 180));
			var realValue:Number = value;
			var realX:Number=element.realX;
			var realY:Number=element.realY;
			if (propertyName == "x")
			{
				
				if (element.h_align != "left" || element.getParent() is ListElementDescriptor || angleRadians != 0)
				{
					if( angleRadians != 0 )
					{
						realX = -((element.width/2)*Math.cos(angleRadians)-(element.height/2)*Math.sin(angleRadians)) + (realX*Math.cos(angleRadians) - realY*Math.sin(angleRadians));
					}
				
					if (element._isPercentX)
					{
						realX=Math.round((100 * realX) / parent.width);
					}
					return realX;
					//realValue = realX;
				}
				
			}
			else if (propertyName == "y")
			{
				if (element.v_align != "top" || element.getParent() is ListElementDescriptor || angleRadians != 0)
				{	
					if( angleRadians != 0 )
					{
						realY =  -element.height/2 + (realX*Math.sin(angleRadians) + realY*Math.cos(angleRadians))
					}
					if (element._isPercentY)
					{
						realY=Math.round((100 * realY) / parent.height);
					}
					return realY;
				}
			}
			//return value;
			return realValue;

		}*/ 
		
		public static function getAbsolutePosition(propertyName:String, parameterValue:String, control:IUIElementDescriptor):Number
		{
			var value:Number=Number(parameterValue);
			var parent:IUIElementContainer=control.getParent();
			var element:SimpleUIElementDescriptor=SimpleUIElementDescriptor(control);
			var angleRadians : Number = (element.getFace().rotation * (Math.PI / 180));
			var realX:Number=element.realX;
			var realY:Number=element.realY;
			var p_orig : Point = new Point(realX,realY);
			var p_center : Point = new Point( element.width/2, element.height/2);
			var m:Matrix = new Matrix();
			m.rotate(angleRadians);
			m.translate(p_orig.x-p_center.x, p_orig.y-p_center.y);
			if (propertyName == "x")
			{
				if (element.h_align != "left" || element.getParent() is ListElementDescriptor || angleRadians != 0)
				{
					if( angleRadians != 0 )
					{
						realX =  m.transformPoint(p_center).x;
						//realX =  -p_orig.x-element.width/2 + (realX*Math.cos(angleRadians) - realY*Math.sin(angleRadians))
					}
					if (element._isPercentX)
					{
						realX=Math.round((100 * realX) / parent.width);
					}
					return realX;
				}
			}
			else if (propertyName == "y")
			{
				if (element.v_align != "top" || element.getParent() is ListElementDescriptor || angleRadians != 0)
				{    
					if( angleRadians != 0 )
					{
						realY =  m.transformPoint(p_center).y;
						//realY =  p_orig.y+element.height/2 + (realY*Math.sin(angleRadians) + realX*Math.cos(angleRadians))
					}
					if (element._isPercentY)
					{
						realY=Math.round((100 * realY) / parent.height);
					}
					return realY;
				}
			}
			return value;
		}
 
		public static function getAbsoluteSize(propertyName:String, parameterValue:String, control:IUIElementDescriptor):Number
		{
			var value:Number=Number(parameterValue);
			var parent:IUIElementContainer=control.getParent();
			var element:SimpleUIElementDescriptor=SimpleUIElementDescriptor(control);
			if (propertyName == "width")
			{
				if (!element._isPercentW)
				{
					
					return element.width;
				}
			}
			else if (propertyName == "height")
			{
				if (!element._isPercentH)
				{
					return element.height;
				}
			}
			return value;

		}
		
		public static  function doExportBitmap(descriptor:IUIElementDescriptor, url:String, clazz:String) : void
		{
			var fms:FileManagerService = new FileManagerService();
			var type : String = "png";
			var directory : String = url.substr(0, url.lastIndexOf("/")+1);
			var fileName : String = url.substr(url.lastIndexOf("/")+1 ).split(".")[0] + "." + type;
			var bytes : String = clazz == "ImgParameterSet" ? BitmapUtils.generateBitmap( Sprite(descriptor.getFace()), type ) : BitmapUtils.generateBitmapFromLoader(SimpleUIElementDescriptor(descriptor).getBackgroundImage(), type);
			fms.addEventListener(FileManagerService.EXPORT_BITMAP, onExportComplete);
			fms.addEventListener(FileManagerService.ERROR, onExportComplete);
			fms.exportBitmap( fileName, directory, bytes );
		}
			
		public static function onExportComplete( e : Event ) : void
		{
			e.target.removeEventListener(FileManagerService.EXPORT_BITMAP, onExportComplete);
			e.target.removeEventListener(FileManagerService.ERROR, onExportComplete);
			switch (e.type)
			{

				//export ok
				case "filemanager_export_bitmap":
					//Alert.show(Conf.languageManager.getLanguage("Export_created"), Conf.languageManager.getLanguage("Export"));
					break;
	
				//error
				case "filemanager_error":
					Alert.show(Conf.languageManager.getLanguage("Error"), Conf.languageManager.getLanguage("Export"));
	
					break;
			}
		}
		/**
		 * Writes XML tags for an array of typed objects
		 */
		public static function writeXMLArray(array:Array, xml:XML, parameterName:String, propertyName:String):void
		{
			var clazz:String;
			var propXML:XML;
			var tagName:String;

			for each (var trigger:*in array)
			{
				clazz=getQualifiedClassName(trigger).split("::")[1]; // Nom du parametre
				tagName=StringUtils.getTagNameFromParameterSet(parameterName);

				if (xml.child(parameterName).child(clazz).length() == 0)
				{
					propXML=new XML("<" + tagName + " type='" + getQualifiedClassName(trigger) + "' id='" + ITrigger(trigger).uuid + "' ></" + tagName + ">");
				}

				var accessors:XMLList=describeType(trigger)..accessor; // Liste des getter et setter du parametre

				for each (var accessor:XML in accessors)
				{
					if (trigger[accessor.@name] == null || trigger[accessor.@name] == undefined)
					{
						propXML[accessor.@name]="";
					}
					else if (accessor.@name != "uuid")
					{
						propXML[accessor.@name]=trigger[accessor.@name];
					}
				}
				xml[parameterName][propertyName].*+=propXML;
			}

		}
	}
}


/*
   // Get parameterSet class name
   clazz=getQualifiedClassName(param).split("::")[1];

   // If the parameter is a blockListParameterset , it means the control is a container
   // serialize it s children
   if (clazz == "BlockListParameterSet" && !(control is XmlElementDescriptor))
   {
   var children:Array=IUIElementContainer(control).getChildren();
   for each (var child:IUIElementDescriptor in children)
   {
   var x:XML=serializeControl(child,mode);
   nodeXml.BlockListParameterSet.*+=x;//serializeControl(child);
   }
   }
   else
   {

   var descriptor:ParameterSetEditionDescriptor=ParameterIntrospectionUtil.getParameterSetEditionDescriptor(param);
   //We just serialise parameterSet that have Metadata
   if (descriptor.getDescription() != null)
   {

   // Serialize regular parameterSet into the format <param> value </param>
   trace("class " + clazz );
   nodeXml.*+=new XML("<" + clazz + "></" + clazz + ">");

   // list of parameterSet's accessor

   accessors=describeType(param)..accessor;

   for each (var accessor:XML in accessors)
   {
   try
   {
   var accessorMetadata:Metadata=MetadataUtil.getMetadata(accessor, "Parameter");

   //Getting defaultValue if some properties don't have matadata we still serialise them
   var defaultValue:*=accessorMetadata != null ? ParameterIntrospectionUtil.getMetadataValueOrDefault("defaultValue", accessorMetadata) : null;

   // Don t serialize fields with empty values
   if ((param[accessor.@name] == null || param[accessor.@name] == ""))
   {
   // to avoid a nasty bug because "" == false ...
   if (param[accessor.@name] is Boolean)
   {
   //if parameter value is default it's not neccessary to write it
   //compare as String because defaultValue is always a String
   if (String(param[accessor.@name]) != defaultValue)
   nodeXml.child(clazz)[accessor.@name]=param[accessor.@name];
   }
   // to avoid a nasty bug because 0 == null ...
   if (param[accessor.@name] is Number && param[accessor.@name] == 0)
   {
   //if parameter value is default it's not neccessary to write it
   //compare as String because defaultValue is always a String
   if (String(param[accessor.@name]) != defaultValue)
   {
   if(accessor.@name.indexOf("color") != -1 || accessor.@name.indexOf("Color") != -1)
   {
   var value : Number = Number(param[accessor.@name]);
   trace("value " + value );
   if(!isNaN(value))
   {
   nodeXml.child(clazz)[accessor.@name]=="0x"+NumberUtils.numberToHexadecimalString(value);
   }
   }
   else
   {
   nodeXml.child(clazz)[accessor.@name]=param[accessor.@name];
   }
   }
   }
   }

   // Serialize everything else
   else
   {
   //if parameter value is default it's not neccessary to write it
   //compare as String because defaultValue is always a String
   if (String(param[accessor.@name]) != defaultValue)
   {
   if(accessor.@name.indexOf("color") != -1 || accessor.@name.indexOf("Color") != -1)
   {
   var value : Number = Number(param[accessor.@name]);
   if(!isNaN(value))
   {
   nodeXml.child(clazz)[accessor.@name]="0x"+NumberUtils.numberToHexadecimalString(value);
   }
   else
   {
   nodeXml.child(clazz)[accessor.@name]=param[accessor.@name];
   }

   }
   else if(clazz == "TextParameterSet" && accessor.@name == "text" )
   {
   if(mode =="html")
   {

   htmlConverter.ParseToHTML(String(param[accessor.@name]));
   nodeXml.child(clazz)[accessor.@name]=htmlConverter.StringFormat;
   }
   else
   {
   nodeXml.child(clazz)[accessor.@name]=param[accessor.@name];
   }
   }
   else
   {
   nodeXml.child(clazz)[accessor.@name]=param[accessor.@name];
   }
   }
   }

   }
   // Swallowing access error for writeonly accessors
   catch (e:Error)
   {
   }

   }
   //if node is empty it's not neccessary to write it
   if (nodeXml.child(clazz).children().length() == 0)
   delete nodeXml.children()[nodeXml.child(clazz).childIndex()];

   if( param is CompositeParameterSet )
   {
   var compositeParameters : Array = CompositeParameterSet(param).getParametersSet();
   for each ( var compositeParam : IParameterSet in compositeParameters )
   {
   nodeXml.child(clazz).* += serializeParameter( compositeParam );
   }
   }
   }
   }
   }
 */
