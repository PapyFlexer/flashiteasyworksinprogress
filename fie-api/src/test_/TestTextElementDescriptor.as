package com.flashiteasy.test {
	import flash.display.Sprite;

	import com.flashiteasy.api.controls.TextElementDescriptor;
	import asunit.framework.TestCase;

	/**
	 * @author hanne
	 */
	public class TestTextElementDescriptor extends TestCase {
		
		private var tf:TextElementDescriptor;
		
		
		public function TestTextElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		
		protected override function setUp():void{
			tf=new TextElementDescriptor();
			tf.createControl();
		}
		protected override function tearDown():void{
			tf.destroy();
		}
		
		public function testInstantiated():void {
   			assertTrue("texte initialisée ", tf.getFace() is Sprite);
   		}
   		
   		public function testSize():void{
   			tf.setActualSize("100", "100");
   			tf.initSize();
   			assertTrue("video width = 100  ", tf.width == 100);
   			assertTrue("video height = 100  ", tf.height == 100);
   		}
   		
   		public function testText():void{
   			tf.setTexte("lol");
   			assertTrue(" set texte ", tf.getContent().pop() == "lol");
   			tf.setTexte("");
   			assertTrue(" set texte vide", tf.getContent().pop() == "");
   			
   		}
   		
	}
}
