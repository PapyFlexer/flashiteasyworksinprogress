package com.flashiteasy.test {
	import flash.display.Sprite;

	import com.flashiteasy.api.controls.VideoElementDescriptor;
	import asunit.framework.TestCase;
	
	/**
	 * @author hanne
	 */
	public class TestVideoElementDescriptor extends TestCase {
		
		private var video:VideoElementDescriptor;
		public function TestVideoElementDescriptor(testMethod : String = null) {
			super(testMethod);
		}
		
		protected override function setUp():void{
			video=new VideoElementDescriptor();
			video.createControl();
		}
		
		public function testInstantiated():void {
   			assertTrue("video initialisée ", video.getFace() is Sprite);
   		}
   		
   		public function testSize():void{
   			video.setActualSize("100", "100");
   			video.initSize();
   			assertTrue("video width = 100  ", video.width == 100);
   			assertTrue("video height = 100  ", video.height == 100);
   		}
   		
   		public function testVideo():void{
   			video.setVideo("video/hancock-tsr2_h480p.flv");
   			assertTrue("initialisation video valide " , video.hasVideo());
   			video.changeVideo("lolololol");
   			assertTrue("initialisation url video non valide  ", video.hasVideo());
   			video.removeVideo();
   			assertFalse("video vide apres suppression  ", video.hasVideo());
   			video.changeVideo("");
   			assertFalse("changement de video vide", video.hasVideo());
   			video.changeVideo("video/phone.flv");
   			assertTrue("changement de video correct", video.hasVideo());
   		}
   		
   		 override protected function tearDown():void {
            super.tearDown();
           	video.destroy();
        }
   		
	}
}
