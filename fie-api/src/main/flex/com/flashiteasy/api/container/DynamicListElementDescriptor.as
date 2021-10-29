package com.flashiteasy.api.container
{
	import com.flashiteasy.api.action.ExternalBrowsingAction;
	import com.flashiteasy.api.action.InternalBrowsingAction;
	import com.flashiteasy.api.controls.DailyMotionElementDescriptor;
	import com.flashiteasy.api.controls.ImgElementDescriptor;
	import com.flashiteasy.api.controls.TextElementDescriptor;
	import com.flashiteasy.api.controls.VideoElementDescriptor;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.core.IDescriptor;
	import com.flashiteasy.api.core.IParameterSet;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IXmlElementDescriptor;
	import com.flashiteasy.api.events.FieEvent;
	import com.flashiteasy.api.parameters.DailyMotionParameterSet;
	import com.flashiteasy.api.parameters.ExternalLinkParameterSet;
	import com.flashiteasy.api.parameters.ImgParameterSet;
	import com.flashiteasy.api.parameters.InternalLinkParameterSet;
	import com.flashiteasy.api.parameters.TextParameterSet;
	import com.flashiteasy.api.parameters.VideoParameterSet;
	import com.flashiteasy.api.parameters.XmlParameterSet;
	import com.flashiteasy.api.selection.ActionList;
	import com.flashiteasy.api.utils.ElementDescriptorUtils;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class DynamicListElementDescriptor extends ListElementDescriptor implements IXmlElementDescriptor
	{
		public function DynamicListElementDescriptor()
		{
			super();
		}

		private var itemDictionary:Dictionary=new Dictionary;
		private var _xmlProvider:XMLList=null;
		private var _xmlRendererName:String;
		
		public function init(xmlProvider:XMLList, request:String):void
		{
			if(xmlProvider != _xmlProvider)
			{
				_xmlProvider = xmlProvider;
				this.destroyChildren();
				this.waiting_child=[];
				this.count_load = 0;
				this.setIsLoaded(false);
				var xmlParam:XmlParameterSet = XmlParameterSet(ElementDescriptorUtils.findParameterSet(this,"XmlParameterSet"));
				_xmlRendererName = xmlParam.xml;
				drawItems();
			}
		}
		
		
		public function drawItems():void
		{
			var idx:int=-1;
			itemDictionary=new Dictionary;
			// on cycle a travers les articles
			for each (var item:XML in XMLList(_xmlProvider))//[node]))
			{
				idx++;
				var uuid:String=this.uuid + "_" + Math.random();
				var xmlElementDescriptor:XmlElementDescriptor=new XmlElementDescriptor();
				xmlElementDescriptor.width=100;
				xmlElementDescriptor.height=100;
				xmlElementDescriptor.uuid=uuid;
				xmlElementDescriptor.isWaiting = true;
				xmlElementDescriptor.setXml(_xmlRendererName);
				xmlElementDescriptor.createControl(getPage(), this, false);
				itemDictionary[xmlElementDescriptor]=item;
				
				xmlElementDescriptor.addEventListener(FieEvent.COMPLETE, handler);
				face.addChild(xmlElementDescriptor.getFace());

			}
			
		}
		
	
		
		private function handler(event:Event):void
		{
			
			event.target.removeEventListener(FieEvent.COMPLETE, handler);
			update(IUIElementContainer(event.target));
		}
		
		private function update(target:IUIElementContainer):void
		{
			// on genere le mapping en fonction l'id,avec la possibilite da'ttaquer les attributes
			// on cycle a travers les blocs du template, et on reagit en fonction de leur typoe :
			// - TextElementDescriptor => TextParamteerSet content
			
			var child_list : Array = IUIElementContainer(target).getChildren(true);
			//findTemplateActions(XmlElementDescriptor(target).getXml());
			var action_list : Array = ActionList.getInstance().getActions(XmlElementDescriptor(target).getXml());
			child_list = child_list.concat(action_list);
			for each (var elem:IDescriptor in child_list)
			{
				var params:Array=CompositeParameterSet(elem.getParameterSet()).getParametersSet();
				var p:IParameterSet;
				var propertyList: Array = elem.uuid.split("@");
				var id:String=String(propertyList.shift());
				var ns:Namespace = null;
				var value: String = null;
				var isProperty : Boolean = propertyList.length > 0;
				
				if( id.indexOf(":") != -1)
				{
					var nsArray : Array = id.split("::");
					var i : int = 0;
					var xmlValue : XMLList = XMLList(itemDictionary[target]); 
					for each( var nsString:String in nsArray)
					{
						i++;
						ns = xmlValue.namespace(nsString.split(":")[0]);
						if(ns != null)
						{
							if(i<nsArray.length)
							{
								xmlValue = xmlValue.ns::[nsString.split(":")[1]];

							}
							else
							{
								value = isProperty ? xmlValue.ns::[nsString.split(":")[1]].@[String(propertyList)] : xmlValue.ns::[nsString.split(":")[1]];
							}
						}
					}
				}
				else if (itemDictionary[target][id] != null)
				{
					value = isProperty ? itemDictionary[target][id].@[String(propertyList)] : itemDictionary[target][id];
				}
				if(value != null && String(value) != "")
				{
					// TODO : implementation des types par interface
					if (elem is TextElementDescriptor)
					{
						// cycler à travers les pSets et récupérer celui qui nous intéresse
						for each (p in params)
						{
							if (p is TextParameterSet)
							{
								TextParameterSet(p).text= value ;
								p.apply(elem);
								break;
							}
						}
					}
					else if (elem is ImgElementDescriptor)
					{
						for each (p in params)
						{
							// TODO : implementation des types par interface
							if (p is ImgParameterSet)
							{
								ImgParameterSet(p).source=value;
								p.apply(elem);
								break;
							}
						}
					}
					else if (elem is VideoElementDescriptor)
					{
						for each (p in params)
						{
							// TODO : implementation des types par interface
							if (p is VideoParameterSet)
							{
								VideoParameterSet(p).source=value;
								p.apply(elem);
								break;
							}
						}
					}
					else if (elem is DailyMotionElementDescriptor)
					{
						for each ( p in params )
						{
							if (p is DailyMotionParameterSet)
							{
								DailyMotionParameterSet(p).source = value;
								p.apply( elem );
								break;
							}
						}
					}
					else if (elem is ExternalBrowsingAction)
					{
						//trace("i found an action to replace : link="+value);
						for each (p in params)
						{
							// TODO : implementation des types par interface
							if (p is ExternalLinkParameterSet)
							{
								ExternalLinkParameterSet(p).link = value;
								p.apply(elem);
								break;
							}
						}
					}
					else if (elem is InternalBrowsingAction)
					{
						//trace("i found an action to replace : link="+value);
						for each (p in params)
						{
							// TODO : implementation des types par interface
							if (p is InternalLinkParameterSet)
							{
								InternalLinkParameterSet(p).page = value;
								p.apply(elem);
								break;
							}
						}
					}
					
					
					if (elem is IUIElementDescriptor)
					{
						IUIElementDescriptor(elem).isWaiting=false;
						IUIElementDescriptor(elem).invalidate();
					}
				}

			}
		}
		
		public function setXml( xml : String ) : void 
		{
			if( _xmlRendererName != xml )
			{
				_xmlRendererName = xml;
				if(this.getChildren().length>0)
				{
					this.destroyChildren();
					this.waiting_child=[];
					this.count_load = 0;
					this.setIsLoaded(false);
					this.drawItems();
				}
			}
		}
		
		private function destroyChildren():void
		{
			if(this.getChildren().length>0)
			{
				for each (var child:IDescriptor in this.getChildren())
				{
					child.destroy();
				}
			}
			
		}
		
		public override function getDescriptorType() : Class
		{
			return DynamicListElementDescriptor;
		}
	}
}