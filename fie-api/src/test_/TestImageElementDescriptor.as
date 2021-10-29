package com.flashiteasy.test {
	import flash.events.Event;
	import flash.display.Sprite;

	import com.flashiteasy.api.controls.ImgElementDescriptor;
	import asunit.framework.TestCase;

	/**
	 * @author hanne
	 */
	public class TestImageElementDescriptor extends TestCase {
		
		private var img:ImgElementDescriptor;
		private var img2:ImgElementDescriptor;
		
		public function TestImageElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		
		protected override function setUp():void{
			img = new ImgElementDescriptor();
			img.createControl();
			//img.addEventListener("loaded",loadedTest);
			img2 = new ImgElementDescriptor();
			img2.createControl();
			//img2.addEventListener("load_fail",loadedTest2);
		}
		

		protected override function tearDown():void{
			img.destroy();
		}
		
		public function testInstantiated():void {
   			assertTrue("image initialisée ", img.getFace() is Sprite);
   		}
   		
   		public function testSize():void{
   			img.setActualSize("100", "100");
   			img.initSize();
   			assertTrue("image width = 100  ", img.width == 100);
   			assertTrue("image height = 100  ", img.height == 100);
   		}
   		
   		public function testImage():void{
   			img.setImage("media/suiko.jpg");
   			assertTrue("initialisation image valide " , img.hasImage());
   			//img.changeImage("lolololol");
   			//assertTrue("initialisation url image non valide  ", img.hasImage());
   			img.removeImage();
   			assertFalse("image vide apres suppression  ", img.hasImage());
   			assertFalse("image non valide apres suppression", img.isValid());
   		}
	}
}
