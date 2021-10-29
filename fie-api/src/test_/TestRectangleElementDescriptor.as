package com.flashiteasy.test {

	import flash.display.Sprite;

	import asunit.framework.TestCase;

	import com.flashiteasy.api.controls.RectElementDescriptor;

	/**
	 * @author hanne
	 */
	public class TestRectangleElementDescriptor extends TestCase {
		
		private var rect :RectElementDescriptor;
		
		public function TestRectangleElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		protected override function setUp():void{
			rect = new RectElementDescriptor();
			rect.createControl();
		}
		
		protected override function tearDown():void{
			rect.destroy();
		}
		
		public function testInstantiated():void {
   			assertTrue("rectangle initialisé ", rect.getFace() is Sprite);
   		}
   		
   		public function testSize():void{
   			rect.setActualSize("100", "100");
   			rect.setAlign("top","left");
   			rect.initSize();
   			assertTrue("rectangle width = 100  ", rect.width == 100);
   			assertTrue("rectangle height = 100  ", rect.height == 100);
   			
   			assertTrue("rectangle align left ", rect.getFace().x == 0);
   			assertTrue("rectangle align top ", rect.getFace().y == 0);
   		}
	}
}
