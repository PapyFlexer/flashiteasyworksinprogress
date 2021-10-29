package com.flashiteasy.test {
	import com.flashiteasy.api.parameters.ListParameterSet;
	import com.flashiteasy.api.parameters.XmlParameterSet;
	import com.flashiteasy.api.core.CompositeParameterSet;
	import com.flashiteasy.api.parameters.SizeParameterSet;
	import flash.display.Sprite;

	import com.flashiteasy.api.container.ListElementDescriptor;

	import asunit.framework.TestCase;

	/**
	 * @author hanne
	 */
	public class TestListElementDescriptor extends TestCase {
		
		private var l:ListElementDescriptor;
		private var s:SizeParameterSet;
		private var c:CompositeParameterSet;
		private var x:XmlParameterSet;
		private var li:ListParameterSet;
		
		public function TestListElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		
		protected override function setUp():void{
			l=new ListElementDescriptor();
			l.createControl();
			l.uuid="ListTest";
			s=new SizeParameterSet();
			s.height="100";
			s.width="200";
			x=new XmlParameterSet();
			x.xml='<xml><control type="TextElementDescriptor"id="texte4"><SizeParameterSet><width>300</width><height>100</height><is_percent>false</is_percent></SizeParameterSet><PositionParameterSet><x>0</x><y>100</y><is_percent>false</is_percent></PositionParameterSet></control></xml>';
			li=new ListParameterSet();
			li.list=new Array(Array("lol"),Array("aaaa"));
			c=new CompositeParameterSet();
			c.addParameterSet(s);
			c.addParameterSet(x);
			c.addParameterSet(li);
			l.setParameterSet(c);
			l.applyParameters();
		}
		
		public function testInstantiated():void {
   			assertTrue("block initialisée ", l.getFace() is Sprite);
   		}
   		public function testListSize():void{
   			assertTrue("error list width = 200 / " +l.width,l.width == 200);
   			assertTrue("list height",l.height==100);
   		}
   		public function testList():void{
   			assertTrue("length = 2 " , l.length()==2);
   		}
   		
   		override protected function tearDown():void{
			super.tearDown();
			l.destroy();
		}
	}
}
