/**
 * FLASHITEASY API 1.0 : Framework for visual interactive developpement <http://www.flashiteasy.com/>
 *
 * FLASHITEASY API 1.0 is (c) 2008-2011 by Robert DEVOS, Didier REYT, Gilles ROQUEFEUIL & Dany SIRIPHOL
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php/>
 * 
 * @private
 *
 */
package com.flashiteasy.api.controls {
	import com.flashiteasy.api.container.MultipleUIElementDescriptor;
	import com.flashiteasy.api.core.IUIElementContainer;
	import com.flashiteasy.api.core.IUIElementDescriptor;
	import com.flashiteasy.api.core.elements.IButtonElementDescriptor;
	import com.flashiteasy.api.selection.ElementList;
	import com.flashiteasy.api.utils.NameUtils;
	import com.flashiteasy.api.utils.XMLParser;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	/**
	 * 
	 * 
	 * @private
	 * 
	 * 
	 * */
	public class ButtonElementDescriptor extends MultipleUIElementDescriptor implements IButtonElementDescriptor
	{
		private var state:Number;
		private var xml_array:Array=new Array();
		private var default_xml:XML=new XML(<container type="com.flashiteasy.api.container::BlockElementDescriptor" >
            <BlockListParameterSet>
              <control type="com.flashiteasy.api.controls::TextElementDescriptor" >
                <PositionParameterSet>
                  <mode>bottom</mode>
                </PositionParameterSet>
                <SizeParameterSet>
                  <is_percent_w>true</is_percent_w>
                  <is_percent_h>true</is_percent_h>
                  <width>100</width>
                  <height>100</height>
                </SizeParameterSet>
                <TextOptionParameterSet>
                  <multiLines>true</multiLines>
                  <wordWrap>true</wordWrap>
                  <autoSize>center</autoSize>
                  <border>true</border>
                </TextOptionParameterSet>
                <TextParameterSet>
                  <text>Entrez votre texte</text>
                </TextParameterSet>
                <RotationParameterSet/>
                <WaitForCompletionParameterSet>
                  <waitComplete>true</waitComplete>
                </WaitForCompletionParameterSet>
              </control>
            </BlockListParameterSet>
            <PositionParameterSet>
              <x>0</x>
              <y>0</y>
              <mode>bottom</mode>
            </PositionParameterSet>
            <AlignParameterSet>
              <v_align>top</v_align>
              <h_align>left</h_align>
            </AlignParameterSet>
            <SizeParameterSet>
                  <is_percent_w>true</is_percent_w>
                  <is_percent_h>true</is_percent_h>
                  <width>100</width>
                  <height>100</height>
                </SizeParameterSet>
            <BackgroundColorParameterSet>
              <backgroundAlpha>1</backgroundAlpha>
              <backgroundColor>10066329</backgroundColor>
            </BackgroundColorParameterSet>
            <WaitForCompletionParameterSet>
              <waitComplete>true</waitComplete>
            </WaitForCompletionParameterSet>
          </container>);
		private var xml1:XML=new XML(<container type="com.flashiteasy.api.container::BlockElementDescriptor" >
            <BlockListParameterSet>
              <control type="com.flashiteasy.api.controls::TextElementDescriptor" >
                <PositionParameterSet>
                  <mode>bottom</mode>
                </PositionParameterSet>
                <AlignParameterSet>
                  <v_align>middle</v_align>
                  <h_align>middle</h_align>
                </AlignParameterSet>
                <SizeParameterSet>
                  <is_percent_w>true</is_percent_w>
                  <is_percent_h>true</is_percent_h>
                  <width>100</width>
                  <height>100</height>
                </SizeParameterSet>
                <TextOptionParameterSet>
                  <multiLines>true</multiLines>
                  <wordWrap>true</wordWrap>
                  <autoSize>center</autoSize>
                  <border>true</border>
                </TextOptionParameterSet>
                <TextParameterSet>
                  <text>Entrez votre texte</text>
                </TextParameterSet>
                <RotationParameterSet/>
                <WaitForCompletionParameterSet>
                  <waitComplete>true</waitComplete>
                </WaitForCompletionParameterSet>
              </control>
            </BlockListParameterSet>
           <PositionParameterSet>
              <x>0</x>
              <y>0</y>
              <mode>bottom</mode>
            </PositionParameterSet>
            <AlignParameterSet>
              <v_align>top</v_align>
              <h_align>left</h_align>
            </AlignParameterSet>
            <SizeParameterSet>
                  <is_percent_w>true</is_percent_w>
                  <is_percent_h>true</is_percent_h>
                  <width>100</width>
                  <height>100</height>
                </SizeParameterSet>
            <BackgroundColorParameterSet>
              <backgroundAlpha>1</backgroundAlpha>
              <backgroundColor>0x00FF00</backgroundColor>
            </BackgroundColorParameterSet>
            <WaitForCompletionParameterSet>
              <waitComplete>true</waitComplete>
            </WaitForCompletionParameterSet>
          </container>);
		private var xml2:XML=new XML(<container type="com.flashiteasy.api.container::BlockElementDescriptor" >
            <BlockListParameterSet>
              <control type="com.flashiteasy.api.controls::TextElementDescriptor" >
                <PositionParameterSet>
                  <mode>bottom</mode>
                </PositionParameterSet>
                <AlignParameterSet>
                  <v_align>middle</v_align>
                  <h_align>middle</h_align>
                </AlignParameterSet>
                <SizeParameterSet>
                  <is_percent_w>true</is_percent_w>
                  <is_percent_h>true</is_percent_h>
                  <width>100</width>
                  <height>100</height>
                </SizeParameterSet>
                <TextOptionParameterSet>
                  <multiLines>true</multiLines>
                  <wordWrap>true</wordWrap>
                  <autoSize>center</autoSize>
                  <border>true</border>
                </TextOptionParameterSet>
                <TextParameterSet>
                  <text>Entrez votre texte</text>
                </TextParameterSet>
                <RotationParameterSet/>
                <WaitForCompletionParameterSet>
                  <waitComplete>true</waitComplete>
                </WaitForCompletionParameterSet>
              </control>
            </BlockListParameterSet>
           <PositionParameterSet>
              <x>0</x>
              <y>0</y>
              <mode>bottom</mode>
            </PositionParameterSet>
            <AlignParameterSet>
              <v_align>top</v_align>
              <h_align>left</h_align>
            </AlignParameterSet>
            <SizeParameterSet>
                  <is_percent_w>true</is_percent_w>
                  <is_percent_h>true</is_percent_h>
                  <width>100</width>
                  <height>100</height>
            </SizeParameterSet>
            <BackgroundColorParameterSet>
              <backgroundAlpha>1</backgroundAlpha>
              <backgroundColor>0xFF0000</backgroundColor>
            </BackgroundColorParameterSet>
            <WaitForCompletionParameterSet>
              <waitComplete>true</waitComplete>
            </WaitForCompletionParameterSet>
          </container>);
		private var component:SimpleUIElementDescriptor;
		private var component2:SimpleUIElementDescriptor;
		private var component3:SimpleUIElementDescriptor;
		
		protected override function initControl():void
		{
			face.addEventListener(MouseEvent.ROLL_OVER , onRollOver ,false,0,true);
			face.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown ,false,0,true);
			face.addEventListener(MouseEvent.MOUSE_UP , onMouseUp ,false,0,true);
			face.addEventListener(MouseEvent.MOUSE_OUT , onMouseOut ,false,0,true);
		}
		
		public override function layoutElement( elementDescriptor:IUIElementDescriptor ):void
		{
			elementDescriptor.setParent(this);
		}
		
		public function setXMLArray(xml_array : Array) : void
		{
			this.xml_array=xml_array;
		}
		
		public function setButtonXml( xml1 : XML , xml2 : XML , xml3 : XML ) : void 
		{
			default_xml=xml1;
			xml1=xml2;
			xml2=xml3;
		}
		
		protected override function drawContent():void{
			
			if(component == null)
			{
				component=XMLParser.createComponent(default_xml);
				component.createControl(getPage(),this);
				component.uuid=this.uuid + "_containerUp";
				XMLParser.unserializeParameters(component , default_xml);
				component2=XMLParser.createComponent(xml1);
				component2.createControl(getPage(),this);
				component2.uuid=this.uuid + "_containerOver";
				XMLParser.unserializeParameters(component2 , xml1);
				component3=XMLParser.createComponent(xml2);
				component3.createControl(getPage(),this);
				component3.uuid=this.uuid + "_containerSelect";
				XMLParser.unserializeParameters(component3 , xml2);
				face.addChild(component.getFace());
				component.applyParameters();
				component2.applyParameters();
				component3.applyParameters();
				changeState(1);
				renameChildren();
				end();
			}/*
			default_xml=xml_array[0];
			this.xml1=xml_array[1];
			this.xml2=xml_array[2];*/
		}
		
		private function renameChildren():void
		{
			renameChildrenInContainer( uuid , IUIElementContainer(component));
			renameChildrenInContainer( uuid , IUIElementContainer(component2));
			renameChildrenInContainer( uuid , IUIElementContainer(component3));
		}
		
		private function renameChildrenInContainer( uuid : String , container  : IUIElementContainer):void
		{
			for each( var child : IUIElementDescriptor in container.getChildren())
			{
				child.uuid = NameUtils.findUniqueName( uuid+"_"+child.uuid , ElementList.getInstance().getElementsAsString(getPage()) );
				if(child is IUIElementContainer)
				{
					renameChildrenInContainer(uuid , IUIElementContainer(child));
				}
			}
		} 
		

		public function changeState( state : Number ) :void {
			this.state=state;
			onStateChanged();
		}
		
		private function onRollOver(e:Event):void
		{
			changeState(2);
			face.removeChildAt(0);
			face.addChild(component2.getFace());
		}
		
		private function onMouseDown(e:Event):void{
			changeState(3);
			face.removeChild(component2.getFace());
			face.addChild(component3.getFace());
		}
		
		private function onMouseUp(e:Event):void
		{
			changeState(2);
			face.removeChildAt(0);
			face.addChild(component2.getFace());
		}
		
		private function onMouseOut(e:Event):void
		{
			changeState(1);	
			face.removeChildAt(0);
			face.addChild(component.getFace());
		}
		
		public function getState():Number 
		{
			return state;
		}
		
		public override function destroy():void{
			/*switch(state){
			
			case 1:
			trace("destroying button");
			component2.destroy();
			component3.destroy();
			break;
			case 2:
			component.destroy();
			component3.destroy();
			break;
			case 3 : 
			component.destroy();
			component2.destroy();
			break;
			 }*/
			component.destroy();
			component2.destroy();
			component3.destroy();
			getFace().removeEventListener(MouseEvent.ROLL_OVER , onRollOver );
			getFace().removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			getFace().removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			getFace().removeEventListener(MouseEvent.MOUSE_OUT , onMouseOut);
			super.destroy();
		}
		
		public function onStateChanged():void
		{
		}
		
		public function getNormalState(): IUIElementDescriptor
		{
			return component;	
		}
		
		public function getRollOverState(): IUIElementDescriptor
		{
			return component2;
		}
		
		public function getClickState(): IUIElementDescriptor
		{
			return component3;
		}
		
		override public function getDescriptorType() : Class
		{
			return ButtonElementDescriptor;
		}
		
	}
}